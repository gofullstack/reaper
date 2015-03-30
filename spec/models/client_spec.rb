describe Client do

  subject { FactoryGirl.create :client }

  describe '#invoices' do

    let(:invoice) { FactoryGirl.create(:invoice) }

    before :each do
      subject.invoices << invoice
      subject.save!
    end

    it "should return the client's invoices" do
      subject.invoices.should == [invoice]
    end

  end

end
