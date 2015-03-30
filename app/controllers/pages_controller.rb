class PagesController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :export

  before_filter :synchronize, :only => [:invoices]

  def index
    redirect_to '/invoices' if session[:user_email]
  end

  def invoices
    if current_user
      @invoices = current_user.outstanding_invoices
      @subdomain = current_user.subdomain
    else
      logout
    end
  end

  def export
    redirect_to root_url unless params['export'].present?

    format = determine_format(params['export']['format'])
    exported_invoice_ids =
      params["export"].select { |id, export| export == "1" }.keys.map(&:to_i)

    invoices = current_user.outstanding_invoices.select do |invoice|
      exported_invoice_ids.include? invoice.id
    end

    send_data Invoicing::CreatesIIFReportFromInvoices.create(invoices, format), :filename => 'export.iif'

    return invoices
  end

  def login
    session[:user_email] = params[:email]

    redirect_to '/auth/harvest'
  end

  def logout
    session[:user_email] = nil

    redirect_to root_url and return
  end

  def tos
    #Terms of Service page
  end

  def privacy
    #Privacy Policy page
  end

  private
  def synchronize
    return unless current_user

    if !session[:synchronized]
      begin
        Invoicing::SynchronizesInvoices.for_user(current_user)
      rescue Invoicing::ImportError => e
        showstopper "The import failed: #{e.message}"
      rescue => e
        showstopper "An unknown error has occured: #{e.message}"
      else
        session[:synchronized] = true
      end
    end
  end

  def determine_format(format)
    if ['2012', '2013'].include?(format)
      format
    else
      '2012'
    end
  end
end
