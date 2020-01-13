class InvoiceMailer < ApplicationMailer
  def send_to_supplier(supplier)
    emails = []

    @invoices = Invoice.where(supplier_name: supplier)
    @profile = Profile.find_by(company_name: supplier)
    
    return unless @profile
    emails << @profile.email
    sub_emails = JSON.parse @profile.sub_email
    sub_emails.each do |m|  
      emails << m.last
    end

    subject = "#{@profile.name.upcase} - MISSING INVOICE #{Date.current}"

    mail_params = {
      to: emails,
      subject: subject
    }

    mail(mail_params)
  rescue StandardError => e
    Rails.logger.error e.message
    raise StandardError, e
  end
end
