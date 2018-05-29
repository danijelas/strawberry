require 'rails_helper'

describe User, type: :model do
    context 'association' do
        it { is_expected.to have_many(:lists).dependent(:destroy) }
        # it { should have_many(:lists) }
        # it { should have_many(:categories) }
    end
end