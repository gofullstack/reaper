require 'invoicing/creates_iif_report_from_invoices'

describe Invoicing::CreatesIIFReportFromInvoices do

  subject { double(:creates_iif_report_from_invoices) }

  describe '.create' do

    before :each do
      Invoicing::CreatesIIFReportFromInvoices.stub(:new).and_return(subject)
    end

    it 'should return the iif string' do
      subject.should_receive(:to_iif)

      Invoicing::CreatesIIFReportFromInvoices.create(double(:invoices))
    end

  end

  describe '#to_iif' do

    subject { Invoicing::CreatesIIFReportFromInvoices.new(double(:invoices)) }

    before :each do
      subject.stub(:headers).and_return(['HEADERS'])
      subject.stub(:invoices).and_return(['INVOICES'])
    end

    it 'should insert a line-break between every line' do
      subject.to_iif.should == "HEADERS\nINVOICES"
    end

  end

end
