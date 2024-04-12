class Api::V1::SessionsController < Devise::SessionsController
  skip_before_action :verify_authenticity_token
  respond_to :json

  # Override the Devise method to allow access to create action for authenticated users
  def require_no_authentication
    assert_is_devise_resource!
  end

  def create
    logger.debug "Checking if user is already signed in."
    if user_signed_in?
      logger.debug "User is already signed in: #{current_user.inspect}"
      render json: { message: 'Admin already signed in.', user: current_user }
    else
      user = User.find_by(email: params[:email])
      logger.debug "Found user: #{user.inspect}"
      if user && user.valid_password?(params[:password]) && user.admin?
        logger.debug "User is valid and an admin."
        sign_in(user)
        render json: { message: 'Admin signed in successfully.', user: user }
      else
        logger.debug "Invalid credentials or user is not an admin."
        render json: { error: 'Invalid email or password.' }, status: :unauthorized
      end
    end
  end


  def destroy
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    render json: { message: 'Admin signed out successfully.' } if signed_out
  end
end
