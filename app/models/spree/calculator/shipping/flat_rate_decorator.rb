require_dependency 'spree/shipping_calculator'

Spree::Calculator::Shipping::FlatRate.class_eval do

  def compute_package_with_free_promotion_action(package)
    apply_free_charge?(package) ? 0.0 : compute_package_without_free_promotion_action(package)
  end
  alias_method_chain :compute_package, :free_promotion_action

protected

  def apply_free_charge?(package)
    # Check if an eligible promotion exists, and that it has the "MakeShippingMethodFree" action.
    # If so, check that the shipping method for the package in in the list of the ones
    # targeted by the promotion action.
    package.order.promotions.any? do |p|
      p.eligible?(package.order) &&
      p.promotion_actions.any? do |action|
        action.is_a?(Spree::Promotion::Actions::MakeShippingMethodFree) &&
        action.calculator.selected_shipping_methods.include?(calculable)
      end
    end
  end

end
