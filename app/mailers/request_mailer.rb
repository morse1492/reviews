class RequestMailer < ApplicationMailer
  def send_request_email(customer)
    @customer = customer
    mail(to: @customer.email, subject: 'Please respond to our request')
  end
end
