module UnitReviews
  def self.from_response(reviews)
    return [] if reviews[:unit_review].nil?
    reviews[:unit_review].map do |review|
      next if review.is_a?(Array)
      {
        title:   review[:@title],
        city:    review[:@reviewer_city],
        state:   review[:@reviewer_state],
        comment: review[:review_comment][:@comment]
      }
    end
  end
end
