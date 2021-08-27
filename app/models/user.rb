class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :articles

  validates :username, presence: true

  before_validation :set_username
  
  private

  def set_username
    self.username = email.split('@').first
  end
  
end
