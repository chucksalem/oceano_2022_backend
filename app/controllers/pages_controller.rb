class PagesController < ApplicationController
  def resources
    render
  end

  def contact
    render
  end

  def testimonials
    @reviews = UnitRepository.random_units(limit: 10).map(&:reviews).flatten
    render
  end

  def faq
    render
  end

  def maps
    render
  end

  def owners
    render
  end

  def trip_cancellation_insurance
    render
  end

end
