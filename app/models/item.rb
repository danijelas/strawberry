class Item < ApplicationRecord

  belongs_to :list
  belongs_to :category

  before_validation :set_category, if: Proc.new { |a| a.category.nil? }
  
  validates :name, presence: true, uniqueness: { scope: :list_id, case_sensitive: false }
  validates :price, numericality: { greater_than_or_equal_to: 0 }

  scope :done, -> { where(done: true) }
  scope :not_done, -> { where(done: false) }

  protected

    def set_category
      self.category = Category.find_or_create_by!(name: 'Miscellaneous', user: self.list.user)
    end

end
