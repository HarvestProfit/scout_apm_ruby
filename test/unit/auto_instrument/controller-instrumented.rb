
class ClientsController < ApplicationController
  before_action :check_authorization

  def index
    if ::ScoutApm::AutoInstrument("params[:status] == \"activated\"",["/home/samuel/Documents/scoutapp/scout_apm_ruby/test/unit/auto_instrument/controller.rb:6:in `index'"]){params[:status] == "activated"}
      @clients = ::ScoutApm::AutoInstrument("Client.activated",["/home/samuel/Documents/scoutapp/scout_apm_ruby/test/unit/auto_instrument/controller.rb:7:in `index'"]){Client.activated}
    else
      @clients = ::ScoutApm::AutoInstrument("Client.inactivated",["/home/samuel/Documents/scoutapp/scout_apm_ruby/test/unit/auto_instrument/controller.rb:9:in `index'"]){Client.inactivated}
    end
  end

  def create
    @client = ::ScoutApm::AutoInstrument("Client.new(params[:client])",["/home/samuel/Documents/scoutapp/scout_apm_ruby/test/unit/auto_instrument/controller.rb:14:in `create'"]){Client.new(params[:client])}
    if ::ScoutApm::AutoInstrument("@client.save",["/home/samuel/Documents/scoutapp/scout_apm_ruby/test/unit/auto_instrument/controller.rb:15:in `create'"]){@client.save}
      ::ScoutApm::AutoInstrument("redirect_to @client",["/home/samuel/Documents/scoutapp/scout_apm_ruby/test/unit/auto_instrument/controller.rb:16:in `create'"]){redirect_to @client}
    else
      # This line overrides the default rendering behavior, which
      # would have been to render the "create" view.
      ::ScoutApm::AutoInstrument("render \"new\"",["/home/samuel/Documents/scoutapp/scout_apm_ruby/test/unit/auto_instrument/controller.rb:20:in `create'"]){render "new"}
    end
  end

  def edit
    @client = ::ScoutApm::AutoInstrument("Client.new(params[:client])",["/home/samuel/Documents/scoutapp/scout_apm_ruby/test/unit/auto_instrument/controller.rb:25:in `edit'"]){Client.new(params[:client])}

    if ::ScoutApm::AutoInstrument("request.post?",["/home/samuel/Documents/scoutapp/scout_apm_ruby/test/unit/auto_instrument/controller.rb:27:in `edit'"]){request.post?}
      ::ScoutApm::AutoInstrument("@client.transaction do...",["/home/samuel/Documents/scoutapp/scout_apm_ruby/test/unit/auto_instrument/controller.rb:28:in `edit'"]){@client.transaction do
        @client.update_attributes(params[:client])
      end}
    end
  end

  def data
    @clients = ::ScoutApm::AutoInstrument("Client.all",["/home/samuel/Documents/scoutapp/scout_apm_ruby/test/unit/auto_instrument/controller.rb:35:in `data'"]){Client.all}

    formatter = ::ScoutApm::AutoInstrument("proc do |row|...",["/home/samuel/Documents/scoutapp/scout_apm_ruby/test/unit/auto_instrument/controller.rb:37:in `data'"]){proc do |row|
      row.to_json
    end}

    ::ScoutApm::AutoInstrument("respond_with @clients.each(&formatter).join(\"\\n\"), :content_type => 'application/json; boundary=NL'",["/home/samuel/Documents/scoutapp/scout_apm_ruby/test/unit/auto_instrument/controller.rb:41:in `data'"]){respond_with @clients.each(&formatter).join("\n"), :content_type => 'application/json; boundary=NL'}
  end
  
  def things
    x = {}
    x[:this] ||= 'foo'
    x[:that] &&= ::ScoutApm::AutoInstrument("'foo'.size",["/home/samuel/Documents/scoutapp/scout_apm_ruby/test/unit/auto_instrument/controller.rb:47:in `things'"]){'foo'.size}
  end
end
