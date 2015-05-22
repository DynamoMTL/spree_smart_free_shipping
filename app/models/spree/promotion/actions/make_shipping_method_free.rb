# This promotion action allows the administrator to provide the
# shipping method name(s) - comma separated - that should be made
# free when the promotion is applied to an order.
# See Spree::Calculator::FreeShippingMethod for logic.
module Spree
  class Promotion
    module Actions
      class MakeShippingMethodFree < Spree::PromotionAction
        delegate :eligible?, to: :promotion

        include Spree::CalculatedAdjustments

        has_many :adjustments, as: :source

        before_validation :ensure_action_has_calculator

        def perform(payload = {})
          order = payload[:order]
          return if promotion_adjustment_exists?(order) || !self.eligible?(order)

          result = create_adjustment(order, order)

          return result
        end

        def compute_amount(calculable)
          0.00
        end

        def label
          "#{Spree.t(:promotion)} (#{promotion.name})"
        end

      private

        def create_adjustment(adjustable, order)
          self.adjustments.create!(
            amount: 0.0,
            order: order,
            adjustable: order,
            label: "#{Spree.t(:promotion)} (#{promotion.name})"
          )
         true
        end

        def promotion_adjustment_exists?(adjustable)
          self.adjustments.where(:adjustable_id => adjustable.id).exists?
        end

        def ensure_action_has_calculator
          return if self.calculator
          self.calculator = Calculator::FreeShippingMethod.new
        end
      end
     end
   end
 end

