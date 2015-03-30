describe LineItem do

  subject { FactoryGirl.create :line_item }

  describe '#invoice' do

    let(:invoice) { FactoryGirl.create :invoice }

    before :each do
      subject.invoice = invoice
      subject.save!
    end

    it 'should return the invoice to which the line item belongs' do
      subject.invoice.should == invoice
    end

  end

end
