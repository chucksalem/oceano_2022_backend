# frozen_string_literal: true

module PropertiesHelper
  def fetch_image(unit)
    image = unit.descriptions.images.select { |img| img[:default] == true }.first
    image[:formats].select { |img| img[:category] == 'Standard' }.first[:url]
  end

  def fetch_name(unit)
    unit.name.split('-').first
  end
end
