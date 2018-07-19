require 'rails_helper'
describe Api::V1::CategoriesController, type: :request do

  let(:user) { create(:user, authentication_token: 'token') }
  let(:headers) { {'Content-Type': 'application/json', 'Accept': 'application/json' } }
  let(:right_auth_headers) { { 'X-User-Email': user.email, 'X-User-Token': user.authentication_token } }

  describe "GET index" do

    let(:endpoint) { api_v1_categories_path }
    
    it "return all categories that belongs to current user" do
      second_user = create(:user)
      category = create(:category, user: user)
      category1 = create(:category, user: user)
      category2 = create(:category, user: second_user)
      category3 = create(:category, user: second_user)
      
      get endpoint, params: nil, headers: headers.merge(right_auth_headers)
      
      expect(response).to be_successful

      expect_json_sizes(8)
      expect_json(
        [
          { id: user.categories[0].id, name: 'Dairy' },
          { id: user.categories[1].id, name: 'Bakery' },
          { id: user.categories[2].id, name: 'Fruits & Vegetables' },
          { id: user.categories[3].id, name: 'Meat' },
          { id: user.categories[4].id, name: 'Home Chemistry' },
          { id: user.categories[5].id, name: 'Miscellaneous' },
          { id: category.id, name: category.name },
          { id: category1.id, name: category1.name }
        ]
      )
    end
  end

  describe "POST create" do

    let(:endpoint) { api_v1_categories_path }

    context "with valid params" do
      it "creates a new Category" do
        post endpoint, params: JSON.dump(FactoryBot.attributes_for(:category)), headers: headers.merge(right_auth_headers)
        
        expect(response).to be_successful
        expect(Category.count).to eq 7
        expect(Category.last.user).to eq user
        expect_json_keys([:id, :name])
      end
    end

    context "with invalid params" do
      it "does not save the new category" do
        post endpoint, params: JSON.dump(FactoryBot.attributes_for(:category, name: nil)), headers: headers.merge(right_auth_headers)
        
        expect(response).to have_http_status(:expectation_failed)
        expect_json_keys(:errors)
      end
    end
  end

  describe "PUT update" do

    let(:category) {create (:category), user: user}  
    let(:endpoint) { api_v1_category_path(category) }  

    context "with valid params" do
      it "updates the requested category" do
        put endpoint, params: JSON.dump(id: category.id, category: {name: 'updatedCategory'}), headers: headers.merge(right_auth_headers)
        category.reload
        expect(category.name).to eq('updatedCategory')
      end
    end

    context "with invalid params" do
      it "does not update the requested category" do
        categoryName = category.name
        put endpoint, params: JSON.dump(id: category.id, category: {name: nil}), headers: headers.merge(right_auth_headers)
        category.reload

        expect(response).to have_http_status(:expectation_failed)
        expect_json_keys(:errors)
        expect(category.name).to eq(categoryName)
      end 
    end
  end

  describe "DELETE destroy" do

    let!(:category) {create (:category), user: user}
    let(:endpoint) { api_v1_category_path(category) } 

    it "destroys the requested category" do
      delete endpoint, params: nil, headers: headers.merge(right_auth_headers)
      
      expect(response).to be_successful
      expect(Category.count).to eq 6
    end

    it "with invalid params, doesn't destroys the requested category" do

      delete api_v1_category_path(5), params: nil, headers: headers.merge(right_auth_headers)
      
      expect(response).to have_http_status(:not_found)
      expect_json_types(error: :string)
      expect(Category.count).to eq 7
    end
  end

end