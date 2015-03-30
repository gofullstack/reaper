# == Schema Information
#
# Table name: line_items
#
#  id          :integer          not null, primary key
#  kind        :string(255)
#  description :text
#  quantity    :decimal(10, 2)
#  unit_price  :decimal(10, 2)
#  amount      :decimal(10, 2)
#  taxed       :boolean
#  taxed2      :boolean
#  project_id  :integer
#  invoice_id  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class LineItem < ActiveRecord::Base
  belongs_to :invoice
end
