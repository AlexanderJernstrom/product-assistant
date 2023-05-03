class Product < ActiveRecord::Base
  belongs_to :company
  has_neighbors :embedding
end
