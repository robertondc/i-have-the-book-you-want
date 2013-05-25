class Book < ActiveRecord::Base
  attr_accessible :author, :language, :title
  belongs_to :user
end
