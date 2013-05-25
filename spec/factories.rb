FactoryGirl.define do
  factory :user do
    username 'roberto'
    email 'roberto@roberto.com'
    password 'roberto@roberto.com'
  end

  factory :another_user, class: User do
    username 'paulo'
    email 'paulo@paulo.com'
    password 'paulo@paulo.com'
  end
  
  factory :book do
    author 'Paulo Coelho'
    title 'Diario de um Mago'
    language Book::LANGUAGES.first
    user = :user
  end

end