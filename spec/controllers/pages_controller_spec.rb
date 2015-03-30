require 'spec_helper'

describe PagesController do

  describe "GET 'index'" do
    context "not logged in" do
      it "returns http success" do
        get 'index'
        response.should be_success
      end
    end

    context "logged in" do
      before do
        session[:user_email] = "test@testing.com"
      end

      it "redirects to /invoices" do
        get 'index'
        response.should be_redirect
      end
    end
  end

  describe "GET 'invoices'" do
    it "redirects when not logged in" do
      get 'invoices'
      response.should be_redirect
    end
  end

  describe "POST export" do
    before do
      controller.stub(:render) # So the send_data expectation works.
      controller.stub(:current_user).and_return( User.create! )
      User.stub(:outstanding_invoices).and_return( Invoice.create!(:state => :draft) )
    end

    it "creates the report" do
      Invoicing::CreatesIIFReportFromInvoices.should_receive(:create)
      post 'export', :export => {'1' => '1'}
    end

    it "responds with send_data" do
      controller.should_receive(:send_data)
      post 'export', :export => {'1' => '1'}
    end
  end

  describe "POST login" do
    it "redirects to harvest" do
      post 'login'
      response.should be_redirect
    end
  end

  describe "POST logout" do
    it "redirects" do
      post 'logout'
      response.should be_redirect
    end
  end

end