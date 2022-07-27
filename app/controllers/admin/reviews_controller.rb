require 'csv'
module Admin
  class ReviewsController < Admin::ApplicationController
    def import_csv
      csv_file = params[:csv_file]
      CSV.foreach(csv_file.path, encoding: "UTF-8") do |row|
        review = Review.where(first_name: row[0]&.strip, last_name: row[1]&.strip, unit_id: row[2]&.strip).first
        if review.present?
          review.update(review_params(row))
        else
          Review.create(review_params(row))
        end
      end
      redirect_to admin_reviews_path, notice: 'CSV file imported successfully!'
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
  end
end
