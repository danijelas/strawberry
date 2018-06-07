require 'rails_helper'

describe List, type: :model do
    
    context 'association' do
        it { is_expected.to belong_to(:user) }
        it { is_expected.to have_many(:items).order(category_id: :asc).dependent(:destroy) }
    end

    context 'validations' do
        it { is_expected.to validate_presence_of(:name) }
        it { expect(create(:list)).to validate_uniqueness_of(:name).scoped_to(:user_id).case_insensitive }
    end

    # describe 'total_sum' do
    #     it 'returns sum of all items prices if item attribute done is set to true' do
    #       list = create(:list)
    #       create(:item, price: 4, list: list, done: true)
    #       create(:item, price: 3, list: list, done: true)
    #       create(:item, price: 3, list: list, done: false)
    #       create(:item, price: 0, list: list, done: true)
    #       expect(list.total_sum).to eq(7)
    #     end
    # end
    
    describe 'set_currency' do
        
        it 'if there is no self.currency sets it to user.currency' do
            user = create(:user, currency: 'EUR')
            
            list1 = create(:list, user: user)
            expect(list1.currency).to eq('EUR')

            list2 = create(:list, user: user, currency: 'USD')
            expect(list2.currency).to eq('USD')
        end
    
        it 'triggers set_currency on save' do
            user = create(:user, currency: 'EUR')
            
            list1 = user.lists.build(name: 'list', currency: 'USD')
            expect(list1).to receive(:set_currency)
            list1.save

            list2 = user.lists.build(name: 'list2')
            expect(list2).to receive(:set_currency)
            list2.save
        end
    end
end