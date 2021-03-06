class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_devise_permitted_parameters, if: :devise_controller?
  before_filter :get_users

  protected

  def configure_devise_permitted_parameters
    registration_params = [:email, :password, :password_confirmation, :name, :phone]

    if params[:action] == 'update'
      devise_parameter_sanitizer.for(:account_update) { 
        |u| u.permit(registration_params << :current_password)
      }
    elsif params[:action] == 'create'
      devise_parameter_sanitizer.for(:sign_up) { 
        |u| u.permit(registration_params) 
      }
    end
  end

  def require_sign_in
    unless user_signed_in?
      flash[:alert] = "You need to be sign in to access this page"
      redirect_to :root
    end
  end

  def get_users
    @all_users = User.all
  end

  def require_be_owner(owner)
    if user_signed_in?
      unless current_user.owners.include?(owner) | owner.nil?
        flash[:alert] = "You need to be the owner to access this page 1"
        redirect_to :root
      end
    else
      flash[:alert] = "You need to be the owner to access this page"
      redirect_to :root
    end
  end
end
