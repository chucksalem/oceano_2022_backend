EscapiaClient = Savon.client do
  wsdl File.expand_path(Rails.root.join('config', 'escapia.wsdl'))
  convert_request_keys_to :camelcase
  # pretty_print_xml true
  # log true
  env_namespace :s
end
