module ContractsHelper
  def badge_for_status(contract)
    css_classes = ["badge"]
    case contract.status.to_sym
    when :under_analysis
      css_classes << "badge-primary"
    when :waiting_confirmation
      css_classes << "badge-warning"
    when :waiting_payment
      css_classes << "badge-warning"
    when :paid
      css_classes << "badge-primary"
    when :finished
      css_classes << "badge-primary"
    when :rejected
      css_classes << "badge-danger"
    when :canceled
      css_classes << "badge-danger"
    when :expired
      css_classes << "badge-danger"
    end
    content_tag(:span, contract.display_status, class: [css_classes])
  end
end
