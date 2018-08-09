require 'rails_helper'

describe Category, type: :model do

  context 'association' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:items) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).scoped_to(:user_id).case_insensitive }
  end

  describe 'check_for_items' do
    it 'should check if there is any item' do
      user = create(:user)
      list = create(:list, user: user)
      category = user.categories[0]
      item = create(:item, list: list, category: category)
      category.destroy
      expect(category.errors).not_to be_empty
      expect(category.destroyed?).to be_falsy
    end
  end

end