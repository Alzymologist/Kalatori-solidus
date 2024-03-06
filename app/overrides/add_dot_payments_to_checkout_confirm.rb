Deface::Override.new(
  virtual_path: 'checkouts/steps/_confirm_step',
  name: 'add_dot_payments_to_checkout_confirm',
  insert_after: 'section.confirm-step',
  template: 'checkouts/steps/_confirm_step/_solidus_kalatori_payment'
)