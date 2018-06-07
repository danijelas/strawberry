class User < ApplicationRecord
  acts_as_token_authenticatable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :lists, dependent: :destroy
  has_many :categories, -> { order(id: :asc) },  dependent: :destroy

  validates :first_name, :last_name, :currency, presence: true

  after_create :populate_categories

  def name
    "#{first_name} #{last_name}"
  end

  private

  def populate_categories
    self.categories << Category.new(name: 'Dairy')
    self.categories << Category.new(name: 'Bakery')
    self.categories << Category.new(name: 'Fruits & Vegetables')
    self.categories << Category.new(name: 'Meat')
    self.categories << Category.new(name: 'Home Chemistry')
    self.categories << Category.new(name: 'Miscellaneous')
  end
end
