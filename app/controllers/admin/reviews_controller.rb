module Admin
  class ReviewsController < Admin::ApplicationController
    def import_csv
      created = 0
      updated = 0
      csv_file = params[:csv_file]
      CSV.foreach(csv_file.path, encoding: "UTF-8") do |row|
        review = Review.where(first_name: row[0]&.strip, last_name: row[1]&.strip, unit_id: row[2]&.strip).first
        if review.present?
          review.update(review_params(row))
          updated += 1
        else
          Review.create(review_params(row))
          created += 1
        end
      end
      redirect_to admin_reviews_path, notice: "CSV file imported successfully! Created: #{created} Updated: #{updated}"
    end

    def delete_all
      Review.destroy_all
      redirect_to admin_reviews_path, notice: "All reviews have been removed"
    end

    private

    def review_params(row)
      {
        first_name: row[0]&.strip,
        last_name: row[1]&.strip,
        unit_id: row[2]&.strip,
        comment: row[3]&.strip,
        stars: row[4]&.strip
      }
    end

    # Overwrite any of the RESTful controller actions to implement custom behavior
    # For example, you may want to send an email after a foo is updated.
    #
    # def update
    #   super
    #   send_foo_updated_email(requested_resource)
    # end

    # Override this method to specify custom lookup behavior.
    # This will be used to set the resource for the `show`, `edit`, and `update`
    # actions.
    #
    # def find_resource(param)
    #   Foo.find_by!(slug: param)
    # end

    # The result of this lookup will be available as `requested_resource`

    # Override this if you have certain roles that require a subset
    # this will be used to set the records shown on the `index` action.
    #
    # def scoped_resource
    #   if current_user.super_admin?
    #     resource_class
    #   else
    #     resource_class.with_less_stuff
    #   end
    # end

    # Override `resource_params` if you want to transform the submitted
    # data before it's persisted. For example, the following would turn all
    # empty values into nil values. It uses other APIs such as `resource_class`
    # and `dashboard`:
    #
    # def resource_params
    #   params.require(resource_class.model_name.param_key).
    #     permit(dashboard.permitted_attributes(action_name)).
    #     transform_values { |value| value == "" ? nil : value }
    # end

    # See https://administrate-demo.herokuapp.com/customizing_controller_actions
    # for more information
  end
end
