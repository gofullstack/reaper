module Invoicing
  class ConvertsLineItemsToIIF

    COLUMNS_2012 = %w(SPL SPLID TRNSTYPE DATE AMOUNT MEMO QNTY PRICE INVITEM TAXABLE)
    COLUMNS_2013 = %w(SPL SPLID TRNSTYPE DATE ACCNT AMOUNT MEMO QNTY PRICE INVITEM TAXABLE)

    attr_reader :line_item

    def initialize(line_item, format = '2012')
      @line_item = line_item
      @format = format
      @id = IIFID.next!
    end

    def self.convert(line_item, format = '2012')
      new(line_item, format).to_iif
    end

    def self.headers(format = '2012')
      if format == '2013'
        COLUMNS_2013
      else
        COLUMNS_2012
      end
    end

    def self.headers_2012
      COLUMNS_2012
    end

    def self.headers_2013
      COLUMNS_2013
    end

    def to_iif
      to_row.join("\t")
    end

    def to_row
      self.class.headers(@format).map { |column| self.send(column.downcase) }
    end

    def spl
      'SPL'
    end

    def splid
      @id
    end

    def trnstype
      if has_negative_invoice?
        'CREDIT MEMO'
      else
        'INVOICE'
      end
    end

    def date
      Time.now.strftime('%m/%d/%Y')
    end

    def accnt
      line_item.kind
    end

    def amount
      if line_item.amount == 0
        0.00
      elsif has_negative_invoice?
        "%.2f" % line_item.amount.abs
      else
        "-%.2f" % line_item.amount.abs
      end
    end

    def memo
      line_item.description
    end

    def qnty
      if line_item.quantity == 0
        0.00
      elsif has_negative_invoice?
        "%.2f" % line_item.quantity.abs
      else
        "-%.2f" % line_item.quantity.abs
      end
    end

    def price
      if has_negative_invoice?
        "%.2f" % line_item.unit_price.abs
      else
        "%.2f" % line_item.unit_price
      end
    end

    def invitem
      line_item.kind
    end

    def taxable
      "N"
    end


    private

    def has_negative_invoice?
      line_item.invoice.andand.amount.to_i < 0
    end

  end
end
