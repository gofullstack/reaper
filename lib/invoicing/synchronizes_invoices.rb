require_relative 'connects_to_harvest'

module Invoicing
  class ImportError < StandardError; end

  class SynchronizesInvoices

    include HarvestOperations

    attr_reader :user, :invoices, :clients

    def initialize(user)
      @user = user
      @invoices, @clients = nil, nil
    end

    def self.for_user(user)
      new(user).synchronize!
    end

    def synchronize!
      # Clean up any local invoices, dependent clients should be cleared
      # automagically.
      user.outstanding_invoices.destroy_all

      weak_pull_invoices! && pull_clients!

      update_subdomain

      clients.each do |client|
        unless client.valid?
          problems = client.errors.full_messages.join('; ')

          raise ImportError, %{
            Importing #{client.name} failed! Why, you ask?
            #{problems}
          }
        end

        client.save
      end
      invoices.each do |invoice|
        invoice.user = user

        unless invoice.valid?
          problems = invoice.errors.full_messages.join('; ')

          raise ImportError, %{
            Importing invoice #{invoice.number} failed! Why, you ask?
            #{problems}
          }
        end

        invoice.save
      end
    end

    protected

    # Same as pull_invoices, but with a hard-coded limit. We can worry about
    # automatically backing off the API once these sorts of tasks move to the
    # background.
    def weak_pull_invoices!
      @invoices ||= as_harvest_user do |harvest|
        outstanding = harvest.invoices.all(:status => 'draft', :page => 1)
        outstanding[0, 40].map do |invoice|
          # we grab each invoice individually so that we also get the line
          # items array
          harvest.invoices.find(invoice.id)
        end
      end.map { |invoice| Invoice.new_from_harvested_object(invoice) }
    end

    def pull_invoices!
      @invoices = nil
      return

      @invoices ||= as_harvest_user do |harvest|

        invoices = []
        page = 1

        # we could do this recursively, but ruby doesn't handle that well, hence
        # a +while+ loop
        while true
          outstanding = harvest.invoices.all(:status => 'draft', :page => 1)
          invoices |= outstanding.map do |invoice|
            # we grab each invoice individually so that we also get the line
            # items array
            harvest.invoices.find(invoice.id)
          end

          page += 1

          break if outstanding.empty?
        end

      end.map { |invoice| Invoice.new_from_harvested_object(invoice) }
    end

    def pull_clients!
      @clients ||= invoices.map(&:client_id).map do |client_id|
        as_harvest_user do |harvest|
          harvest.clients.find(client_id)
        end
      end.map { |client| Client.new_from_harvested_object(client) }
    end

    def update_subdomain
      as_harvest_user do |harvest|
        harvest_user = harvest.account.who_am_i
        user.subdomain = Domainatrix.parse(harvest_user.avatar_url).subdomain
      end

      user.save
    end

  end
end
