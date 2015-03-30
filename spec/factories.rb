FactoryGirl.define do

  factory :invoice do
    state :open

    factory :outstanding_invoice do
      state :draft
    end

    factory :paid_invoice do
      state :paid
    end
  end

  factory :line_item

  factory :user

  factory :client

end