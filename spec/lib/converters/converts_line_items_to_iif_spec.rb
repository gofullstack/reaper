# SPLID  -will always ascend in numerical order, i.e 1,2,3, etc
# TRNSTYPE- Should always say INVOICE
# DATE - Date of transfer
# AMOUNT - Line item total  (if there are two hours at 105 the the AMOUNT would be 210)
# MEMO - this is the line item "Description" In Harvest
# QNTY -  This is "QTY" on the Harvest Invoice
# PRICE- Line item price or "Unit Price" in Harvest
# INVITEM - "Type" on the Harvest invoice
# TAXABLE- Should always say "N"

require 'invoicing/converters/converts_line_items_to_iif'

describe Invoicing::ConvertsLineItemsToIIF do
  include FakesInvoices

  subject { Invoicing::ConvertsLineItemsToIIF.new(line_item) }

  describe '.convert' do

    context 'given a line item' do

      subject { Invoicing::ConvertsLineItemsToIIF }

      let(:converted_line_item) { double(:line_item, :to_iif => 'LINE ITEM') }

      before :each do
        subject.stub(:new).and_return(converted_line_item)
      end

      it 'should return the line item in IIF format' do
        subject.convert(double(:line_item)).should == 'LINE ITEM'
      end

    end

  end

  describe '.headers' do

    it 'should return the 2012 IIF Line Item columns' do
      Invoicing::ConvertsLineItemsToIIF.headers.should ==
        Invoicing::ConvertsLineItemsToIIF::COLUMNS_2012
    end

    it 'should return the 2013 IIF Line Item columns' do
      Invoicing::ConvertsLineItemsToIIF.headers('2013').should ==
        Invoicing::ConvertsLineItemsToIIF::COLUMNS_2013
    end

  end

  describe 'IIF columns' do

    let!(:today) { Time.now }

    before :each do
      Time.stub(:now).and_return(today)
    end

    specify 'its splid' do
      Invoicing::IIFID.stub(:next!) { 100 }
      subject.splid.should eql 100
    end

    its(:spl) { should eql 'SPL' }
    its(:trnstype) { should eql 'INVOICE' }
    its(:date) { should eql today.strftime('%m/%d/%Y') }
    its(:amount) { should eql 0.0 }
    its(:memo) { should eql line_item.description }
    its(:qnty) { should eql "-2.00" }
    its(:price) { should eql "%.2f" % line_item.unit_price }
    its(:invitem) { should eql line_item.kind }
    its(:taxable) { should eql 'N' }

    context 'negative invoice' do
      subject { Invoicing::ConvertsLineItemsToIIF.new(negative_invoice_line_item) }

      specify 'its trnstype' do
        subject.trnstype.should eql 'CREDIT MEMO'
      end

      specify 'its amount should be positive' do
        subject.amount.to_f.should > 0
      end

      specify 'its price should be positive' do
        subject.price.to_f.should > 0
      end

      specify 'its qnty should be positive' do
        subject.qnty.to_f.should > 0
      end
    end

  end

  describe '#to_iif' do

    before :each do
      subject.stub(:to_row).and_return(['LINE', 'ITEM'])
    end

    it 'should join the row representation with tabs' do
      subject.to_iif.should == "LINE\tITEM"
    end

  end

end
