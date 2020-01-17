class InvoicesController < ApplicationController
  before_action :authenticate_user!

  def index
    @invoices = Invoice.all
  end

  def import
    CsvMasterDataService.new(Invoice, invoice_file_params).import_csv
    redirect_to invoices_url, notice: 'Data imported'
  end

  def destroy_all
    Invoice.destroy_all
    redirect_to invoices_url, notice: 'All data destroyed'
  end

  def invoice_file_params
    params[:invoice][:file]
  end

  def send_emails
    Invoice.has_supplier.each do |supplier|
      InvoiceMailer.send_to_supplier(supplier).deliver_later
    end
  end
end
