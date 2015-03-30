module Invoicing
  class IIFHeader

    def initialize(row)
      @row = row
    end

    def self.for(row)
      new(row).to_iif
    end

    def self.closing
      '!ENDTRNS'
    end

    def to_iif
      '!' + @row.join("\t")
    end

  end
end
