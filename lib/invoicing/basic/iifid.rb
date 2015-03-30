module Invoicing
  class IIFID

    @@iifid = 0

    def self.next!
      @@iifid += 1
    end

    def self.reset!
      @@iifid = 0
    end

  end
end
