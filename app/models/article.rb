class Article < ActiveRecord::Base
  validates :title, presence: true, length: { minimum: 3, maximum: 80 }
  validates :description, presence: true, length: { minimum: 10, maximum: 400 }
end