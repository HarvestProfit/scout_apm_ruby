module ScoutApm
  module Instruments
    class Mongoid
      attr_reader :logger

      def initalize(logger=ScoutApm::Agent.instance.logger)
        @logger = logger
        @installed = false
      end

      def installed?
        @installed
      end

      def install
        @installed = true

        # Mongoid versions that use Moped should instrument Moped.
        if defined?(::Mongoid) and !defined?(::Moped)
          ScoutApm::Agent.instance.logger.info "Instrumenting Mongoid 2.x"

          ### OLD (2.x) mongoids
          if defined?(::Mongoid::Collection)
            ::Mongoid::Collection.class_eval do
              include ScoutApm::Tracer
              (::Mongoid::Collections::Operations::ALL - [:<<, :[]]).each do |method|
                instrument_method method, :type => "MongoDB", :name => '#{@klass}/' + method.to_s
              end
            end
          end

          ### See moped instrument for Moped driven deploys

          ### 5.x Mongoid
          if mongoid_v5? && defined?(::Mongoid::Contextual::Mongo)
            STDOUT.puts "Instrumenting Mongoid 5.x"
            # All the public methods from Mongoid::Contextual::Mongo.
            # TODO: Geo and MapReduce support (?). They are in other Contextual::* classes
            methods = [
              :count, :delete, :destroy, :distinct, :each,
              :explain, :find_first, :find_one_and_delete, :find_one_and_replace,
              :find_one_and_update, :first, :geo_near, :initialize, :last,
              :length, :limit, :map, :map_reduce, :pluck,
              :skip, :sort, :update, :update_all,
            ]
            # :exists?,

            methods.each do |method|
              if ::Mongoid::Contextual::Mongo.method_defined?(method)
                with_scout_instruments = %Q[
                def #{method}_with_scout_instruments(*args, &block)

                  req = ScoutApm::RequestManager.lookup
                  *db, collection = view.collection.namespace.split(".")

                  name = collection + "/#{method}"
                  filter = ScoutApm::Instruments::Mongoid.anonymize_filter(view.filter)

                  layer = ScoutApm::Layer.new("MongoDB", name)
                  layer.desc = filter.inspect

                  req.start_layer( layer )
                  begin
                    #{method}_without_scout_instruments(*args, &block)
                  ensure
                    req.stop_layer
                  end
                end

                alias_method :#{method}_without_scout_instruments, :#{method}
                alias_method :#{method}, :#{method}_with_scout_instruments
                ]

                ::Mongoid::Contextual::Mongo.class_eval(with_scout_instruments)
              end
            end
          end
        end
      end

      def mongoid_v5?
        if defined?(::Mongoid::VERSION)
          ::Mongoid::VERSION =~ /\A5/
        else
          false
        end
      end


      # Example of what a filter looks like: => {"founded"=>{"$gte"=>"1980-1-1"}, "name"=>{"$in"=>["Tool", "Deftones", "Melvins"]}}
      # Approach: find every leaf-node, clear it. inspect the whole thing when done.
      def self.anonymize_filter(filter)
        Hash[
          filter.map do |k,v|
            if v.is_a? Hash
              [k, anonymize_filter(v)]
            else
              [k, "?"]
            end
          end
        ]
      end
    end
  end
end

