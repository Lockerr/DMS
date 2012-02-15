class UploadController < ApplicationController

  def create
    #debugger
    if params[:car]
      if checkin = Checkin.find(params[:car])
        checkin.assets.push Asset.create(:data => params[:Filedata], :attachable_id => checkin.id, :attachable_type => 'Checkin')
      end
      #Checkin.first.assets.push Asset.create(:data => params[:Filedata])
    render :json => 'true'
    end

  end


end
