require 'invoicing/basic/iif_header'

describe Invoicing::IIFHeader do

  describe '.for' do

    subject { Invoicing::IIFHeader }

    context 'given a row' do

      let(:row) { double(:row) }
      let(:header) { double(:header, :to_iif => 'IIF') }

      before :each do
        subject.stub(:new).with(row).and_return(header)
      end

      it 'should return the IIF row string for the row' do
        subject.for(row).should == 'IIF'
      end

    end

  end

  describe '.closing' do

    subject { Invoicing::IIFHeader.closing }

    it { should eql '!ENDTRNS' }

  end

  describe '#to_iif' do

    let(:row) { ['IIF', 'HEADER'] }

    subject { Invoicing::IIFHeader.new(row).to_iif }

    it { should eql "!IIF\tHEADER" }

  end

end
