class Company < ApplicationRecord
    has_many :users
    has_many :invites
    has_many :products
    has_many :chats
end
