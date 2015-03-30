unless ENV['GUARD_NOTIFY'] # Only run simplecov with Rake
  require 'simplecov'
  SimpleCov.start :rails
end

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'capybara/rspec'
require 'turnip/capybara'

Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.infer_base_class_for_anonymous_controllers = true
  config.order = :random
  config.treat_symbols_as_metadata_keys_with_true_values = true

  config.before :suite do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with :truncation
  end

  config.before :each do
    DatabaseCleaner.start
  end

  config.after :each do
    DatabaseCleaner.clean
  end
end

VCR.configure do |c|
  c.allow_http_connections_when_no_cassette = true
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :fakeweb

  if Settings.harvest.access_token
    c.filter_sensitive_data('<ACCESS_TOKEN>') do
      Settings.harvest.access_token
    end
  end
end

module Invoicing

  module Smoke
    include HarvestOperations

    def smoke_user
      {
        'access_token' => Settings.harvest.access_token
      }
    end

    def harvest_invoice
      VCR.use_cassette('harvest_invoice', :record => :once) do
        as_harvest_user(smoke_user) do |harvest|
          harvest.invoices.all.first
        end
      end
    end

  end

end

module FakesInvoices

  def invoice
    @invoice ||= double(
      :amount => "1",
      :client => double(:name => double, :details => double),
      :created_at => double(:created_at),
      :currency => double(:currency),
      :due_amount => double(:due_amount),
      :due_at => double(:due_at),
      :due_at_human_format => double(:due_at_human_format),
      :id => double(:id),
      :issued_at => double(:issued_at),
      :notes => "Notes \r\n\r\n With Newlines!",
      :number => double(:number),
      :period_end => double(:period_end),
      :period_start => double(:period_start),
      :purchase_order => double(:purchase_order),
      :client_key => double(:client_key),
      :state => double(:state),
      :updated_at => double(:updated_at),
      :created_at => double(:created_at),
      :line_items => Array.new(2) {
        double(
          :kind => double(:kind),
          :description => double(:description),
          :quantity => -2,
          :unit_price => "1",
          :amount => 0,
          :taxed => double(:taxed),
          :taxed2 => double(:taxed2),
          :project_id => double(:project_id),
          :invoice => double(:amount => "1")
        )
      },
      :tax => double(:tax),
      :tax2 => double(:tax2),
      :tax_amount => double(:tax_amount),
      :tax2_amount => double(:tax2_amount)
    )
  end

  def taxable_invoice
    @taxable_invoice ||= double(
      :tax => '1',
      :tax2 => nil,
      :tax_amount => '0.0',
      :tax2_amount => '0.0'
    )
  end

  def not_taxable_invoice
    @not_taxable_invoice ||= double(
      :tax => '0',
      :tax2 => nil,
      :tax_amount => '0.0',
      :tax2_amount => '0.0'
    )
  end

  def empty_notes_invoice
    @empty_notes_invoice ||= double(
      :notes => nil
    )
  end

  def negative_invoice
    @negative_invoice ||= double(
      :amount => "-100.14",
      :line_items => Array.new(2) {
        double(
          :kind => double(:kind),
          :description => double(:description),
          :quantity => BigDecimal.new("-2.10"),
          :unit_price => BigDecimal.new("-11"),
          :amount => BigDecimal.new("-9.3"),
          :taxed => double(:taxed),
          :taxed2 => double(:taxed2),
          :project_id => double(:project_id),
          :invoice => double(:amount => "-100.14")
        )
      }
    )
  end

  def line_item
    invoice.line_items.first
  end

  def negative_invoice_line_item
    negative_invoice.line_items.first
  end

end
