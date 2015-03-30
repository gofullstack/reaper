require_relative 'basic/iifid'
require_relative 'basic/iif_header'
require_relative 'converters/converts_invoices_to_iif'
require_relative 'converters/converts_line_items_to_iif'

module Invoicing
  class CreatesIIFReportFromInvoices

    def initialize(invoices, format = '2012')
      @invoices = invoices
      @format = format
    end

    def self.create(invoices, format = '2012')
      new(invoices, format).to_iif
    end

    def to_iif
      (headers + invoices).join("\n")
    end

    private

    def headers
      [invoice_headers, line_item_headers, IIFHeader.closing]
    end

    def invoice_headers
      IIFHeader.for(ConvertsInvoicesToIIF.headers)
    end

    def line_item_headers
      IIFHeader.for(ConvertsLineItemsToIIF.headers(@format))
    end

    def invoices
      @invoices.map { |invoice| ConvertsInvoicesToIIF.convert(invoice, @format) }
    end

  end
end
