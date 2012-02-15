class AssetsController < ApplicationController
  def show
    asset = Asset.find(params[:id])
    # do security check here
    send_file asset.data.path, :type => asset.data_content_type
  end
end
