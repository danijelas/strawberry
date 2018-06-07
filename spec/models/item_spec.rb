require 'rails_helper'

describe Item, type: :model do

  let!(:user) { create(:user, currency: 'EUR') }
  let!(:list) { create(:list, user: user) }

  context 'association' do
    it { is_expected.to belong_to(:list)}
    it { is_expected.to belong_to(:category)}
  end

  context 'validations' do
    it { expect(create(:item, list: list)).to validate_presence_of(:name) }
    it { expect(create(:item, list: list)).to validate_uniqueness_of(:name).scoped_to(:list_id).case_insensitive }
    it { expect(create(:item, list: list)).to validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
  end

  # describe 'price_user_currency' do
  #   it 'converts price to user currency if price is in some other currency' do
      
  #     allow_any_instance_of(Money).to receive(:exchange_to).and_return(9)

  #     list_in_USD = create(:list, currency: 'USD', user: user)
  #     item = create(:item, list: list_in_USD, price: 10)
  #     price_in_EUR = item.price_user_currency
  #     expect(price_in_EUR).to eq(9)

  #     list_in_EUR = create(:list, currency: 'EUR', user: user)
  #     item2 = create(:item, list: list_in_EUR, price: 10)
  #     price_in_EUR = item2.price_user_currency
  #     expect(price_in_EUR).to eq(item2.price)
  #   end
  # end
  
  describe 'set_category' do
    it 'should set category to Miscellaneous if category nil when validated' do
      item = list.items.build(name: 'item')
      expect(item.category).to be_nil
      item.valid?
      expect(item.category.name).to eq("Miscellaneous")

      category2 = user.categories[0]
      item2 = list.items.build(name: 'item2', category: category2)
      expect(item2.category.name).to eq(category2.name)
      item2.valid?
      expect(item2.category.name).to eq(category2.name)
    end
  end

end