module PaymentsHelper
  def payment_types_for_select
    Payment.payment_types.map do |k, v|
      [ I18n.t("activerecord.attributes.payment.payment_types.#{k}"), k ]
    end
  end
end
