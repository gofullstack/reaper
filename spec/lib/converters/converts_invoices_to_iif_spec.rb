require 'invoicing/converters/converts_invoices_to_iif'

describe Invoicing::ConvertsInvoicesToIIF do
  include FakesInvoices

  subject { Invoicing::ConvertsInvoicesToIIF.new(invoice) }

  describe '.convert' do

    context 'given an invoice in 2012 format' do

      subject { Invoicing::ConvertsInvoicesToIIF }

      let(:converted_invoice) { double(:invoice, :to_iif => 'INVOICE') }

      before :each do
        subject.stub(:new).with(invoice, '2012').and_return(converted_invoice)
      end

      it 'should return the invoice in 2012 IIF format' do
        subject.convert(invoice).should == 'INVOICE'
      end

    end

    context 'given an invoice in 2013 format' do

      subject { Invoicing::ConvertsInvoicesToIIF }

      let(:converted_invoice) { double(:invoice, :to_iif => 'INVOICE2013') }

      before :each do
        subject.stub(:new).with(invoice, '2013').and_return(converted_invoice)
      end

      it 'should return the invoice in 2013 IIF format' do
        subject.convert(invoice, '2013').should == 'INVOICE2013'
      end

    end

  end

  describe '.headers' do

    it 'should return the IIF Invoice columns' do
      Invoicing::ConvertsInvoicesToIIF.headers.should ==
        Invoicing::ConvertsInvoicesToIIF::COLUMNS
    end

  end

  describe 'naive IIF columns' do

    let!(:today) { Time.now }
    let(:fifteen_days) { Invoicing::ConvertsInvoicesToIIF::FIFTEEN_DAYS }

    before :each do
      Time.stub(:now).and_return(today)
    end

    specify 'its transid' do
      Invoicing::IIFID.stub(:next!) { 100 }
      subject.trnsid.should eql 100
    end

    describe '.nameistaxable' do
      context 'it is taxable' do
        subject { Invoicing::ConvertsInvoicesToIIF.new(taxable_invoice) }

        it 'has a tax value' do
          subject.nameistaxable.should eql 'Y'
        end
      end

      context 'it is not taxable' do
        subject { Invoicing::ConvertsInvoicesToIIF.new(not_taxable_invoice) }

        it 'has no tax values' do
          subject.nameistaxable.should eql 'N'
        end
      end
    end

    its(:trnstype) { should eql 'INVOICE' }
    its(:trns) { should eql 'TRNS' }
    its(:endtrns) { should eql 'ENDTRNS' }
    its(:date) { should eql today.strftime('%m/%d/%Y') }
    its(:accnt) { should eql 'ACCOUNTS RECEIVABLE' }
    its(:name) { should eql invoice.client.name }
    its(:amount) { should eql '1.00' }
    its(:docnum) { should eql invoice.number }
    its(:toprint) { should eql 'Y' }
    its(:terms) { should eql invoice.due_at_human_format }
    its(:invmemo) { should eql invoice.notes.squish }
    its(:duedate) { should eql (today + fifteen_days).strftime('%m/%e/%Y') }

    context 'it has empty notes' do
      subject { Invoicing::ConvertsInvoicesToIIF.new(empty_notes_invoice) }

      its(:invmemo) { should eql '' }
    end

  end

  describe 'negative-value invoice' do
    context 'it has a negative amount' do
      subject { Invoicing::ConvertsInvoicesToIIF.new(negative_invoice) }

      its(:trnstype) { should eql 'CREDIT MEMO' }
    end
  end

  describe '#line_items' do

    let(:converted_line_item) { 'LINE ITEM' }

    before :each do
      Invoicing::ConvertsLineItemsToIIF.stub(:convert).
        and_return(converted_line_item)
      subject.stub_chain(:invoice, :line_items).and_return(Array.new(5) { '' })
    end

    it "should return the invoice's line items in IIF format" do
      subject.line_items.should == Array.new(5) { converted_line_item }
    end

  end

  describe 'addresses' do

    context 'when the address has four lines' do

      before do
        details = %{
        Address 1
        Address 2
        Address 3
        Address 4
        }
        invoice.stub_chain(:client, :details).and_return(details)
      end

      it 'should fill out all address fields' do
        subject.addr1.should eql 'Address 1'
        subject.addr2.should eql 'Address 2'
        subject.addr3.should eql 'Address 3'
        subject.addr4.should eql 'Address 4'
      end

    end

    context 'when the address has one line' do

      before do
        details = %{
        Address 1
        }
        invoice.stub_chain(:client, :details).and_return(details)
      end

      it 'should fill out all but addr4' do
        subject.addr1.should eql 'Address 1'
        subject.addr2.should be_empty
        subject.addr3.should be_empty
        subject.addr4.should be_empty
      end

    end

  end

end
