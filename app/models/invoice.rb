# == Schema Information
#
# Table name: invoices
#
#  id                   :integer          not null, primary key
#  subject              :text
#  number               :string(255)
#  issued_at            :date
#  due_at               :date
#  due_at_human_format  :string(255)
#  due_amount           :decimal(10, 2)
#  notes                :text
#  recurring_invoice_id :integer
#  period_start         :date
#  period_end           :date
#  discount             :decimal(10, 2)
#  discount_amount      :decimal(10, 2)
#  client_key           :string(255)
#  amount               :decimal(10, 2)
#  tax                  :decimal(10, 2)
#  tax2                 :decimal(10, 2)
#  tax_amount           :decimal(10, 2)
#  tax2_amount          :decimal(10, 2)
#  estimate_id          :integer
#  purchase_order       :string(255)
#  retainer_id          :integer
#  currency             :string(255)
#  state                :string(255)
#  harvest_id           :integer
#  user_id              :integer
#  client_id            :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class Invoice < ActiveRecord::Base
  extend HarvestModel

  belongs_to :user
  belongs_to :client,
    :dependent => :destroy,
    :primary_key => :harvest_id
  has_many :line_items, :dependent => :destroy

  before_validation :coerce_state

  validates_inclusion_of :state, :in => [ :open, :partial, :draft, :paid, :unpaid, :pastdue ]

  def self.outstanding(conditions = {})
    conditions.merge!(:state => :draft)

    where(conditions)
  end

  private
  def coerce_state
    self.state = self.state.to_sym if self.state
  end
end
