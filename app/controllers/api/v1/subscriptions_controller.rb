class Api::V1::SubscriptionsController < BaseController
  def new
    @subscription = Subscription.new
  end

  def create
    @subscription = Subscription.new(subscription_params)
    if @subscription.save
      render json: { message: 'Subscription successful!' }, status: :created
    else
      render json: { error: 'You have already subscribed.' }, status: :unprocessable_entity
    end
  end

  private

  def subscription_params
    params.require(:subscription).permit(:email)
  end
end
