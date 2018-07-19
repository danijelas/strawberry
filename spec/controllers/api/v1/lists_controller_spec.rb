require 'rails_helper'
describe Api::V1::ListsController, type: :request do

  let(:user) { create(:user, authentication_token: 'token') }
  let(:headers) { {'Content-Type': 'application/json', 'Accept': 'application/json' } }
  let(:right_auth_headers) { { 'X-User-Email': user.email, 'X-User-Token': user.authentication_token } }

  describe "GET index" do

    let(:endpoint) { api_v1_lists_path }
    
    it "return all lists that belongs to current user" do
      second_user = create(:user)
      list = create(:list, user: user)
      list1 = create(:list, user: user)
      list2 = create(:list, user: second_user)
      list3 = create(:list, user: second_user)
      
      get endpoint, params: nil, headers: headers.merge(right_auth_headers)
      
      expect(response).to be_successful

      expect_json_sizes(2)
      expect_json(
        [
          { id: list.id, name: list.name, currency: list.currency },
          { id: list1.id, name: list1.name, currency: list1.currency }
        ]
      )
      
    end
  end

  describe "POST create" do

    let(:endpoint) { api_v1_lists_path }

    context "with valid params" do
      it "creates a new List" do
        post endpoint, params: JSON.dump(FactoryBot.attributes_for(:list)), headers: headers.merge(right_auth_headers)
        
        expect(response).to be_successful
        expect(List.count).to eq 1
        expect(List.first.user).to eq user
        expect_json_keys([:id, :name, :currency])
        # expect_json_sizes(3)
        # expect_json(id: List.first.id, name: List.first.name, currency: List.first.currency)
      end
    end

    context "with invalid params" do
      it "does not save the new list" do
        post endpoint, params: JSON.dump(FactoryBot.attributes_for(:list, name: nil)), headers: headers.merge(right_auth_headers)
        
        expect(response).to have_http_status(:expectation_failed)
        expect_json_keys(:errors)
        expect(List.count).to eq 0
      end
    end
  end

  describe "PUT update" do

    let(:list) {create (:list), user: user}  
    let(:endpoint) { api_v1_list_path(list) }  

    context "with valid params" do
      it "updates the requested list" do
        put endpoint, params: JSON.dump(id: list.id, list: {name: 'updatedList'}), headers: headers.merge(right_auth_headers)
        
        list.reload
        
        expect(list.name).to eq('updatedList')
      end
    end

    context "with invalid params" do
      it "does not update the requested list" do
        listName = list.name
        
        put endpoint, params: JSON.dump(id: list.id, list: {name: nil}), headers: headers.merge(right_auth_headers)
        
        list.reload

        expect(response).to have_http_status(:expectation_failed)
        expect_json_keys(:errors)
        expect(list.name).to eq(listName)
      end 
    end
  end
  
  describe "DELETE destroy" do

    let!(:list) {create (:list), user: user}
    let(:endpoint) { api_v1_list_path(list) } 

    it "destroys the requested list" do
      delete endpoint, params: nil, headers: headers.merge(right_auth_headers)
      
      expect(response).to be_successful
      expect(List.count).to eq 0
    end

    it "with invalid params, doesn't destroys the requested list" do

      delete api_v1_list_path(5), params: nil, headers: headers.merge(right_auth_headers)
      
      expect(response).to have_http_status(:not_found)
      expect_json_types(error: :string)
      expect(List.count).to eq 1
    end
  end

end
