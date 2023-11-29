module Api
    module V1
        class BookingsController < BaseController
            def create
              # current_user will handeled letter with authentication to associate the booking  
              @booking = Booking.new(booking_params)
          
              if @booking.save
                # Trigger email after successful booking
                BookingMailer.booking_confirmation(current_user, @booking).deliver_now

                render json: { message: 'Booking created successfully' }, status: :created
              else
                render json: { errors: @booking.errors.full_messages }, status: :unprocessable_entity
              end
            end
          
            private
          
            def booking_params
              params.permit(:property_id, :user_id, :start_date, :end_date, :amount)
            end
        end
    end
end
