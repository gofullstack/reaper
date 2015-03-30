require 'invoicing/synchronizes_invoices'
require 'invoicing/connects_to_harvest'

describe Invoicing::SynchronizesInvoices do
  include Invoicing::Smoke

  let(:user) { FactoryGirl.create(:user, smoke_user) }

  let(:harvest_line_item) { harvest_invoice.line_items.first }
  let(:harvest_client_id) { harvest_invoice.client_id }

  subject { Invoicing::SynchronizesInvoices.new(user) }

  describe '#synchronize!' do

    let(:client) { FactoryGirl.create(:client) }
    let(:line_item) { FactoryGirl.create(:line_item) }
    let(:invoice) {
      FactoryGirl.create(:outstanding_invoice,
                     :client => client,
                     :line_items => [line_item]
                    )
    }

    before :each do
      user.invoices = [invoice]
      user.save!

      VCR.use_cassette('sync', :record => :once) do
        subject.synchronize!
      end
    end

    it "should delete all of the user's existing invoices" do
      Invoice.outstanding({:id => invoice.id}).should be_empty
    end

    it "should delete the user's invoice's clients" do
      Client.where(:id => harvest_client_id).count.should be_zero
    end

    it "should delete the user's invoice's line items" do
      LineItem.where(:invoice_id => invoice.id).count.should be_zero
    end

    it "should save invoices from Harvest" do
      Invoice.where(:harvest_id => harvest_invoice.id).should_not be_empty
    end

    it "should save clients from Harvest" do
      Client.where(:harvest_id => harvest_client_id).should_not be_empty
    end

    it "should save line items from Harvest" do
      invoices = Invoice.where(:harvest_id => harvest_invoice.id)
      invoices.map(&:line_items).flatten.should_not be_empty
    end

  end

end
