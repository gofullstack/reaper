describe Invoice do

  subject { FactoryGirl.create :invoice }

  describe '#client' do

    let(:client) { FactoryGirl.create(:client) }

    before :each do
      subject.client = client
      subject.save!
    end

    it "should return the invoice's client" do
      subject.client.should == client
    end

  end

  describe '#line_items' do

    let(:line_item) { FactoryGirl.create(:line_item) }

    before :each do
      subject.line_items << line_item
      subject.save!
    end

    it "should return the invoice's line items" do
      subject.line_items.should == [line_item]
    end

  end

end
