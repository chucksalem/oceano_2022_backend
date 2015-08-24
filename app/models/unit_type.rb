module UnitType
  CODES = {
    1000 => :cottage,
    1001 => :duplex,
    1002 => :triplex,
    1003 => :fourplex,
    1004 => :house,
    1005 => :townhouse,
    20   => :hotel,
    22   => :lodge,
    3    => :apartment,
    35   => :villa,
    5    => :cabin,
    8    => :condominium
  }.freeze

  def self.from_code(code)
    CODES[code.to_i] || :unknown
  end
end
