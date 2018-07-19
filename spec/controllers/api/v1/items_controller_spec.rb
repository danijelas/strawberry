require 'rails_helper'
describe Api::V1::ListsController, type: :request do

  let(:user) { create(:user, authentication_token: 'token') }
  let(:headers) { {'Content-Type': 'application/json', 'Accept': 'application/json' } }
  let(:right_auth_headers) { { 'X-User-Email': user.email, 'X-User-Token': user.authentication_token } }

  describe "GET index" do

    let(:list) {create(:list, user: user)}
    let(:endpoint) { api_v1_list_items_path(list) }
    
    it "return all items that belongs to current list" do
      item1 = create(:item, list: list)
      item2 = create(:item, list: list)
      second_list = create(:list, user: user)
      item3 = create(:item, list: second_list)
      item4 = create(:item, list: second_list)
      
      get endpoint, params: nil, headers: headers.merge(right_auth_headers)
      
      expect(response).to be_successful
      expect_json_sizes(2)
      expect_json(
        [
          { id: item1.id, name: item1.name, price: item1.price.to_s, description: item1.description, done: item1.done},
          { id: item2.id, name: item2.name, price: item2.price.to_s, description: item2.description, done: item2.done}
        ]
      )
    end
  end

  describe "POST create" do
    
    let(:list) {create (:list), user: user}
    let(:endpoint) { api_v1_list_items_path(list) }
    
    context "with valid params" do
      it "creates a new Item" do

        post endpoint, params: JSON.dump(FactoryBot.attributes_for(:item, list: list)), headers: headers.merge(right_auth_headers)

        expect(response).to be_successful
        expect(Item.count).to eq 1
        expect(Item.first.list).to eq list
        expect_json_keys([:id, :name, :price, :description, :done])
        # expect_json_sizes(5)
        # expect_json(description: Item.first.description, done: Item.first.done, id: Item.first.id, name: Item.first.name, price: Item.first.price.to_s)
      end
    end

    context "with invalid params" do
      it "does not save the new item" do

        post endpoint, params: JSON.dump(FactoryBot.attributes_for(:item, name: nil, list: list)), headers: headers.merge(right_auth_headers)
        
        expect(response).to have_http_status(:expectation_failed)
        expect_json_keys(:errors)
        expect(Item.count).to eq 0
      end
    end
  end

  describe "PUT update" do

    let(:list) {create (:list), user: user}
    let(:item) {create (:item), list: list, done: true}
    let(:endpoint) { api_v1_list_item_path(list, item) }

    context "with valid params" do
      it "updates the requested item" do
        category1 = user.categories[0]

        expect(item.name).not_to eq('updatedItemName')
        # expect(item.category_id).not_to eq(category1.id)
        expect(item.description).not_to eq('updatedDescription')
        expect(item.price).not_to eq(10)
        
        put endpoint, params: JSON.dump(FactoryBot.attributes_for(:item, name: 'updatedItemName', 
        category_id: category1.id, description: 'updatedDescription', 
        price: 10, list: list)), headers: headers.merge(right_auth_headers)
        
        item.reload
        list.reload
        
        expect(item.name).to eq('updatedItemName')
        expect(item.category_id).to eq(category1.id)
        expect(item.description).to eq('updatedDescription')
        expect(item.price).to eq(10)
      end
    end

    context "with invalid params" do
      it "does not update the requested item" do
        itemName = item.name

        put endpoint, params: JSON.dump(FactoryBot.attributes_for(:item, name: nil)), headers: headers.merge(right_auth_headers)
        
        item.reload
        list.reload
        
        expect(response).to have_http_status(:expectation_failed)
        expect_json_keys(:errors)
        expect(item.name).to eq(itemName)
      end 
    end
  end

  describe "DELETE destroy" do

    let!(:list) {create (:list), user: user}
    let!(:item) {create (:item), list: list}
    let(:endpoint) { api_v1_list_item_path(list, item) } 

    it "destroys the requested list" do
      
      delete endpoint, params: nil, headers: headers.merge(right_auth_headers)
      
      expect(response).to be_successful
      expect(Item.count).to eq 0
    end

    it "with invalid params, doesn't destroys the requested item" do

      delete api_v1_list_item_path(list, 5), params: nil, headers: headers.merge(right_auth_headers)
      
      expect(response).to have_http_status(:not_found)
      expect_json_types(error: :string)
      expect(Item.count).to eq 1
    end
  end

  describe "POST toggle_done" do

    let(:list) {create (:list), user: user}
    let(:item) {create (:item), list: list, done: true}
    let(:endpoint) { toggle_done_api_v1_list_item_path(list, item) }

    context "with valid params" do
      it "updates the requested item" do
        done = item.done

        post endpoint, params: nil, headers: headers.merge(right_auth_headers)
        
        item.reload
        list.reload
        
        expect(response).to be_successful
        expect(item.done).to eq(!done)
      end
    end

    context "with invalid params" do
      it "does not update the requested item" do
        # ???
      end 
    end
  end

end