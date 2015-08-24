module Api
  class UnitsController < Api::Controller
    def index
      codes  = UnitRepository.search(address: { country: 'MX' })
      @units = codes.each_with_object([]) do |code, units|
        units << UnitRepository.find(code)
        units
      end
    rescue Escapia::Request::Error => e
      logger.error e.message
      render_error(500, ['500 internal server error'])
    end

    def show
      @unit = UnitRepository.get(params[:id])
    rescue Escapia::Request::Error => e
      logger.error e.message
      render_error(404, ['404 not found'])
    end
  end
end
