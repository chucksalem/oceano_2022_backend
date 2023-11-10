# frozen_string_literal: true

require 'nokogiri'

RSpec::Matchers.define :have_xpath do |xpath:, opts:, value: nil|
  match do |body|
    doc   = Nokogiri::XML::Document.parse(body)
    nodes = doc.xpath(xpath, opts[:namespaces])

    expect(nodes).to_not be_empty
    nodes.each { |n| expect(n.content).to eq(value) } unless value.nil?
    true
  end

  failure_message { |body| "expected to find xpath #{xpath} in:\n#{body}" }
  failure_message_when_negated { |body| "expected not to find xpath #{xpath} in:\n#{body}" }
  description { "have xpath #{xpath}" }
end
