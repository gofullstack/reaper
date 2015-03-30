describe User do
  include Invoicing::Smoke

  subject { FactoryGirl.create :user }

  describe '#invoices' do

    let(:invoice) { FactoryGirl.create :invoice }

    before :each do
      subject.invoices << invoice
    end

    it "should return a user's invoices" do
      subject.invoices.should == [invoice]
    end

  end

  describe '#outstanding_invoices' do

    let(:outstanding_invoice) { FactoryGirl.create(:outstanding_invoice) }
    let(:paid_invoice) { FactoryGirl.create(:paid_invoice) }

    before :each do
      subject.invoices = [outstanding_invoice, paid_invoice]
      subject.save!
    end

    it 'should return a list of outstanding invoices' do
      subject.outstanding_invoices.should == [outstanding_invoice]
    end

  end

end
