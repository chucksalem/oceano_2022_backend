class Api::V1::SessionsController < Devise::SessionsController
  skip_before_action :verify_authenticity_token
  respond_to :json

  # Override the Devise method to allow access to create action for authenticated users
  def require_no_authentication
    assert_is_devise_resource!
  end

  def create
    if user_signed_in?
      return render json: { message: 'Admin already signed in.', user: current_user }
    end

    user = User.find_by(email: params[:email])

    if user && user.valid_password?(params[:password]) && user.admin?
      sign_in(user)
      render json: { message: 'Admin signed in successfully.', user: user }
    else
      render json: { error: 'Invalid email or password.' }, status: :unauthorized
    end
  end

  def destroy
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    render json: { message: 'Admin signed out successfully.' } if signed_out
  end
end
