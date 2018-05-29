require 'rails_helper'

describe List, type: :model do
    context 'association' do
        it { is_expected.to belong_to(:user) }
        # it { should have_many(:lists) }
        # it { should have_many(:categories) }
    end
end