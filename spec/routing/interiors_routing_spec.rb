require "spec_helper"

describe InteriorsController do
  describe "routing" do

    it "routes to #index" do
      get("/interiors").should route_to("interiors#index")
    end

    it "routes to #new" do
      get("/interiors/new").should route_to("interiors#new")
    end

    it "routes to #show" do
      get("/interiors/1").should route_to("interiors#show", :id => "1")
    end

    it "routes to #edit" do
      get("/interiors/1/edit").should route_to("interiors#edit", :id => "1")
    end

    it "routes to #create" do
      post("/interiors").should route_to("interiors#create")
    end

    it "routes to #update" do
      put("/interiors/1").should route_to("interiors#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/interiors/1").should route_to("interiors#destroy", :id => "1")
    end

  end
end
