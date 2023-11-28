class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :property
  validates_presence_of :start_date, :end_date, :amount, :status
  validate :end_date_after_start_date
  validates_numericality_of :amount, greater_than_or_equal_to: 0
  validates_inclusion_of :status, in: %w(pending confirmed cancelled)

  private

  def end_date_after_start_date
      return unless start_date && end_date

      errors.add(:end_date, "must be after start date") if end_date <= start_date
  end
end
