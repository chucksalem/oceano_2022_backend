class HomeController < ApplicationController
  def index
    @random_units = UnitRepository.random_units(limit: 4, except: [@id])
  end
end
