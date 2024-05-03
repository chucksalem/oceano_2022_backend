class Review < ApplicationRecord
  require 'csv'
  def self.to_csv
    reviews = all
    CSV.generate do |csv|
      csv << column_names
      reviews.each do |review|
        csv << review.attributes.values_at(*column_names)
      end
    end
  end
end
