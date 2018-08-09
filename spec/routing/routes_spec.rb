require "rails_helper"

RSpec.describe "routes", type: :routing do
  it "routes /login to the sessions controller" do
    expect(post("/api/v1/auth/login")).
      to route_to("api/v1/auth/sessions#create")
  end

  it "routes /logout to the sessions controller" do
    expect(delete("/api/v1/auth/logout")).
      to route_to("api/v1/auth/sessions#destroy")
  end

  it "routes /forgot to the passwords controller" do
    expect(post("/api/v1/auth/forgot")).
      to route_to("api/v1/auth/passwords#create")
  end

  it "routes /register to the registrations controller" do
    expect(post("/api/v1/auth/register")).
      to route_to("api/v1/auth/registrations#create")
  end

  it "routes /update-profile to the registrations controller" do
    expect(put("/api/v1/auth/update-profile")).
      to route_to("api/v1/auth/registrations#update")
  end

  it "routes /delete-account to the registrations controller" do
    expect(delete("/api/v1/auth/delete-account")).
      to route_to("api/v1/auth/registrations#destroy")
  end

  it "routes /index to the lists controller" do
    expect(get("/api/v1/lists")).
      to route_to("api/v1/lists#index")
  end

  it "routes /create to the lists controller" do
    expect(post("/api/v1/lists")).
      to route_to("api/v1/lists#create")
  end

  it "routes /update to the lists controller" do
    expect(put("/api/v1/lists/1")).
      to route_to("api/v1/lists#update", id: "1")
  end

  it "routes /update to the lists controller" do
    expect(patch("/api/v1/lists/1")).
      to route_to("api/v1/lists#update", id: "1")
  end

  it "routes /delete to the lists controller" do
    expect(delete("/api/v1/lists/1")).
      to route_to("api/v1/lists#destroy", id: "1")
  end

  it "routes /index to the items controller" do
    expect(get("/api/v1/lists/1/items")).
      to route_to("api/v1/items#index", list_id: "1")
  end

  it "routes /create to the items controller" do
    expect(post("/api/v1/lists/1/items")).
      to route_to("api/v1/items#create", list_id: "1")
  end

  it "routes /update to the items controller" do
    expect(put("/api/v1/lists/1/items/2")).
      to route_to("api/v1/items#update", list_id: "1", id: "2")
  end

  it "routes /update to the items controller" do
    expect(patch("/api/v1/lists/1/items/2")).
      to route_to("api/v1/items#update", list_id: "1", id: "2")
  end

  it "routes /delete to the items controller" do
    expect(delete("/api/v1/lists/1/items/2")).
      to route_to("api/v1/items#destroy", list_id: "1", id: "2")
  end

  it "routes /toggle_done to the items controller" do
    expect(post("/api/v1/lists/1/items/2/toggle-done")).
      to route_to("api/v1/items#toggle_done", list_id: "1", id: "2")
  end

  it "routes /index to the categories controller" do
    expect(get("/api/v1/categories")).
      to route_to("api/v1/categories#index")
  end

  it "routes /create to the categories controller" do
    expect(post("/api/v1/categories")).
      to route_to("api/v1/categories#create")
  end

  it "routes /update to the categories controller" do
    expect(put("/api/v1/categories/1")).
      to route_to("api/v1/categories#update", id: "1")
  end

  it "routes /update to the categories controller" do
    expect(patch("/api/v1/categories/1")).
      to route_to("api/v1/categories#update", id: "1")
  end

  it "routes /delete to the categories controller" do
    expect(delete("/api/v1/categories/1")).
      to route_to("api/v1/categories#destroy", id: "1")
  end

  it "routes /profile to the users controller" do
    expect(get("/api/v1/profile")).
      to route_to("api/v1/users#profile")
  end
end