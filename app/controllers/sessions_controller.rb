class SessionsController < Devise::SessionsController
  # To change this template use File | Settings | File Templates.
  def create
    resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#new")
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    sign_in(resource_name, resource)
    respond_with resource, :location => redirect_location(resource_name, resource)
    #User.current_user = resource
  end


end