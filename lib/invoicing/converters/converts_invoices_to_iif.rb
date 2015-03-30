module Invoicing
  class ConvertsInvoicesToIIF

    FIFTEEN_DAYS = (60 * 60 * 24 * 15)
    COLUMNS = %w(TRNS TRNSID TRNSTYPE DATE ACCNT NAME AMOUNT DOCNUM TOPRINT ADDR1
                ADDR2 ADDR3 ADDR4 TERMS NAMEISTAXABLE INVMEMO DUEDATE)

    attr_reader :invoice

    def initialize(invoice, format = '2012')
      @invoice = invoice
      @format = format
      @id = IIFID.next!
    end

    def self.convert(invoice, format = '2012')
      new(invoice, format).to_iif
    end

    def self.headers
      COLUMNS
    end

    def to_iif
      [to_row.join("\t"), line_items(@format), endtrns].join("\n")
    end

    def line_items(format = '2012')
      invoice.line_items.map do |line_item|
        ConvertsLineItemsToIIF.convert(line_item, format)
      end
    end

    def trns
      "TRNS"
    end

    def endtrns
      'ENDTRNS'
    end

    def trnsid
      @id
    end

    def trnstype
      if is_negative?(invoice)
        'CREDIT MEMO'
      else
        'INVOICE'
      end
    end

    def date
      Time.now.strftime('%m/%d/%Y')
    end

    def accnt
      'ACCOUNTS RECEIVABLE'
    end

    def name
      invoice.client.name
    end

    def amount
      "%.2f" % invoice.amount
    end

    def docnum
      invoice.number
    end

    def toprint
      'Y'
    end

    def terms
      invoice.due_at_human_format
    end

    def nameistaxable
      if is_taxable?(invoice)
        'Y'
      else
        'N'
      end
    end

    def invmemo
      if invoice.notes.present?
        invoice.notes.squish
      else
        ''
      end
    end

    # TODO: Pull out formatting into IIFDate or something
    def duedate
      (Time.now + FIFTEEN_DAYS).strftime('%m/%e/%Y')
    end

    (0..3).each do |i|
      number = i + 1
      define_method "addr#{number}" do
        address[i]
      end
    end


    def to_row
      self.class.headers.map { |column| self.send(column.downcase) }
    end


    private

    def address
      details = invoice.client.details.strip.split(/\n+/).map(&:strip)
      Array.new(4) { |index| details[index].to_s }
    end

    def is_taxable?(invoice)
      (invoice.tax.present? && invoice.tax.to_i > 0)                ||
      (invoice.tax2.present? && invoice.tax2.to_i > 0)              ||
      (invoice.tax_amount.present? && invoice.tax_amount.to_i > 0)  ||
      (invoice.tax2_amount.present? && invoice.tax2_amount.to_i > 0)
    end

    def is_negative?(invoice)
      invoice.amount.to_i < 0
    end
  end
end
