class HomeController < ApplicationController
  def index
    @random_units = UnitRepository.random_units(limit: 5, except: [@id])
  end
end
