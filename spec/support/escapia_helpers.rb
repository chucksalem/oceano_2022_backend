# frozen_string_literal: true

module EscapiaHelpers
  def stub_escapia(*args)
    stub_request(:post, 'https://api.escapia.com/EVRNService.svc').to_return(*args)
  end
end
