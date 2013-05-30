class Request < ActiveRecord::Base
  belongs_to :user
  belongs_to :book
  
  validate :user, uniqueness: {scope: :book}
   
end