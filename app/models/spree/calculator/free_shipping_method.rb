module Spree
  class Calculator::FreeShippingMethod < Calculator
    preference :shipping_method_codes, :string

    def self.description
      'Shipping Method Code(s)'
    end

    def compute(line_item = nil)
      0.00
    end

    def selected_shipping_methods
      codes = preferred_shipping_method_codes.split(',').map(&:strip)
      Spree::ShippingMethod.where(admin_name: codes)
    end
  end
end
