# == Schema Information
#
# Table name: clients
#
#  id                        :integer          not null, primary key
#  harvest_id                :integer
#  name                      :string(255)
#  highrise_id               :integer
#  cache_version             :integer
#  currency                  :string(255)
#  active                    :boolean
#  details                   :text
#  default_invoice_timeframe :string(255)
#  last_invoice_kind         :string(255)
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#

class Client < ActiveRecord::Base
  extend HarvestModel

  has_many :invoices,
    :dependent => :destroy,
    :primary_key => :harvest_id

end
