class Payment < ActiveRecord::Base
  validates :token, uniqueness: true
  validates :amount, presence: true
  store :data, accessors: [:payer_id, :identifier]
  
  def details
    client.details(self.token)
  end

  attr_reader :redirect_uri, :popup_uri
  def setup!(return_url, cancel_url)
    response = client.setup(
      payment_request,
      return_url,
      cancel_url,
      pay_on_paypal: true
      #no_shipping: self.digital?
    )
    self.token = response.token
    self.save!
    @redirect_uri = response.redirect_uri
    @popup_uri = response.popup_uri
    self
  end

  def cancel!
    self.canceled = true
    self.save!
    self
  end

  def complete!(payer_id = nil)
    response = client.checkout!(self.token, payer_id, payment_request)
    self.payer_id = payer_id
    self.identifier = response.payment_info.first.transaction_id

    self.completed = true
    self.save!
    self
  end

  private

  def client
    Paypal::Express::Request.new PAYPAL_CONFIG
  end

  def payment_request
    item = {
      name: "Item name",
      description: "Item description",
      amount: self.amount,
      category: :Digital
    }
    request_attributes = {
      amount: self.amount,
      description: "Payment description",
      items: [item]
    }
    Paypal::Payment::Request.new request_attributes
  end
end
