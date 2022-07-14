json.stay do
  json.baseAmount @nightly_rate
  json.totalAmount @total_amount
  json.fees do 
    json.array! @fees do |fee|
      json.name fee.name
      json.amount fee.amount
    end
  end
  json.taxes @tax_amount
end
