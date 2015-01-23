#class RegistrationsController < Devise::RegistrationsController
class Users::RegistrationsController < Devise::RegistrationsController

  # POST /resource
  ### CUSTOM ###
  def create

    build_resource(sign_up_params)

    # The last role should be the one created in the form
    # We set the values here so they get saved and they aren't passed in the form
    
    resource.roles.last.assign_attributes(role: "owner", active: 1, default_role: 1)

    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  protected

  ### CUSTOM ###

  def sign_up_params
    
    #devise_parameter_sanitizer.sanitize(:sign_up)
    params.require(:user).permit(:email, :password, :password_confirmation, :name_first, :name_last, :phone, roles_attributes: [ company_attributes: [ :id, :name, :address1, :address2, :city, :province, :postal ] ] )
    
  end
  
  def set_minimum_password_length
    if devise_mapping.validatable?
      @minimum_password_length = resource_class.password_length.min
    end
  end
  
end