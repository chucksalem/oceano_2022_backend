module UnitRooms
  CODES = {
    40 => :lofts,
    52 => :bathrooms,
    54 => :garage,
    55 => :bedrooms
  }.freeze

  def self.count_for_code(target_type, codes)
    codes.each do |r|
      type = CODES[r[:@code].to_i]
      next unless type.present? && type == target_type
      value = r[:@quantity] || r[:@fixed]
      return value.to_i
    end
    0
  end
end
