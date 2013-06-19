class Api::V1::TasksController < ApplicationController
  skip_before_filter :verify_authenticity_token,
                     :if => Proc.new { |c| c.request.format == 'application/json' }

  # Just skip the authentication for now
  before_filter :authenticate_user!

  respond_to :json

  def index
    render :text => '{
  "success":true,
  "info":"ok",
  "data":{
          "tasks":[
                    {"title":"Complete the app"},
                    {"title":"Complete the tutorial"}
                  ]
         }
}'
  end

  def updategeo
    if params["latitude"].blank? || params["longitude"].blank?
      badrequest
      return
    end
    current_user.latitude = params["latitude"].to_f
    current_user.longitude = params["longitude"].to_f
    current_user.geotimestamp = DateTime.now
    if current_user.save
      render :status => 200, :json => {:success => true }
    else
      badrequest
    end
  end

  protected
  def badrequest
    render :status => 400, :json => {:success => false }
  end
end
