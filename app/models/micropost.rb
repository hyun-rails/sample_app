class Micropost < ActiveRecord::Base
  belongs_to :user # This line implements the user/micropost association
  # Ordering the microposts with default_scope
  # DESC is SQL for "descending"
  default_scope -> { order('created_at DESC') } 
  # Sets the presence of the user_id attribute to true
  validates :user_id, presence: true 
  # Sets the content attribute
  validates :content, presence: true, length: { maximum: 140 }
end
