# == Schema Information
#
# Table name: users
#
#  id               :integer          not null, primary key
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  access_token     :string(255)
#  refresh_token    :string(255)
#  email            :string(255)
#  provider         :string(255)
#  token_expires_at :integer
#  token_expires    :boolean
#  subdomain        :string(255)
#

class User < ActiveRecord::Base
  has_many :invoices

  def outstanding_invoices
    invoices.where(:state => :draft)
  end

  def self.find_authenticated(params = {})
    first(params) || new
  end

  def self.connect(params = {})
    new(params).as_harvest_user do |harvest|
      api = Harvest::API::Base.new(harvest.credentials)
      api.send(:request, :get, harvest.credentials, '/account/who_am_i')
    end
  end

  def authenticated_with?(clear_password)
    self.password == clear_password
  end

  def self.create_with_omniauth(auth, email)
    create! do |user|
      user.provider = auth["provider"]
      user.email = email
    end
  end

  def update_auth_token(auth)
    self.access_token = auth["credentials"]["token"]
    self.refresh_token = auth["credentials"]["refresh_token"]
    self.token_expires_at = auth["credentials"]["expires_at"]
    self.token_expires = auth["credentials"]["expires"]
    self.save!
  end
end
