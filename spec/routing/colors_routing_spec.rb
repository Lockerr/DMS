require "spec_helper"

describe ColorsController do
  describe "routing" do

    it "routes to #index" do
      get("/colors").should route_to("colors#index")
    end

    it "routes to #new" do
      get("/colors/new").should route_to("colors#new")
    end

    it "routes to #show" do
      get("/colors/1").should route_to("colors#show", :id => "1")
    end

    it "routes to #edit" do
      get("/colors/1/edit").should route_to("colors#edit", :id => "1")
    end

    it "routes to #create" do
      post("/colors").should route_to("colors#create")
    end

    it "routes to #update" do
      put("/colors/1").should route_to("colors#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/colors/1").should route_to("colors#destroy", :id => "1")
    end

  end
end
