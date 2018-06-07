class List < ApplicationRecord
    
    belongs_to :user
    has_many :items, -> { order(category_id: :asc) },  dependent: :destroy

    validates :name, presence: true, uniqueness: { scope: :user_id, case_sensitive: false }

    before_save :set_currency
    
    # def total_sum
    #   items.select { |item| item.done == true }.map(&:price).sum
    # end
    
    def set_currency
      self.currency = user.currency unless self.currency?
    end    
    
end
