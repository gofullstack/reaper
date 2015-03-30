require "spec_helper"

describe PagesController do
  describe "routing" do

    it "routes to #index" do
      get("/").should route_to("pages#index")
    end

    it "routes to #invoices" do
      get("/invoices").should route_to("pages#invoices")
    end

  end
end