class Book < ActiveRecord::Base
  LANGUAGES = %w{pt_br en}
  attr_accessible :author, :language, :title
  belongs_to :user
end
