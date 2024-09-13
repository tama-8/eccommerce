class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  with_options presence: true do
    validates :name
    validates :status
  end
  enum status: {
    # 通常
    normal: 0,
    # 退会済み
    withdrawn: 1,
    # 停止
    banned: 2
  }

  has_many :cart_items, dependent: :destroy
end
