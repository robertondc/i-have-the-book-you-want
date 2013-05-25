require 'spec_helper'

describe "routing to books of users" do
  it "routes /user/:username/books to books#show_user for username" do
    expect(:get => "/user/roberto/books").to route_to(
      :controller => "books",
      :action => "show_user",
      :username => "roberto"
    )
  end
end