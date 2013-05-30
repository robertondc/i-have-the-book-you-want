require 'spec_helper'

describe RequestsController do
  render_views
  
  describe "POST create" do
    it "create a user request for a existent book" do
      user = FactoryGirl.create(:user)
      book = FactoryGirl.create(:book)
      sign_in user
      post :create, book_id:book.id
      assigns(:request).user eq(user)
      assigns(:request).book eq(book)
    end

    it "block unlogged users" do
      user = FactoryGirl.create(:user)
      book = FactoryGirl.create(:book)
      sign_out user
      post :create, book_id:book.id
      expect(response).to redirect_to(new_user_session_path)
    end

  end

  describe "GET show" do
    it "must to show all requests from the book for logged users" do
      user = FactoryGirl.create(:user)
      another_user = FactoryGirl.create(:another_user)
      book = FactoryGirl.create(:book)
      request1 = FactoryGirl.create(:request, book:book, user:user)
      request2 = FactoryGirl.create(:request, book:book, user:another_user)
      sign_in user
      get :show, book_id:book.id
      assigns(:requests).should eq([request1,request2])
    end

    it "must to ignore requests from another books" do
      user = FactoryGirl.create(:user)
      another_user = FactoryGirl.create(:another_user)
      book1 = FactoryGirl.create(:book)
      book2 = FactoryGirl.create(:book)
      request1 = FactoryGirl.create(:request, book:book1, user:user)
      request2 = FactoryGirl.create(:request, book:book2, user:another_user)
      sign_in user
      get :show, book_id:book1.id
      assigns(:requests).should eq([request1])
    end
    
    it "must to show all requests from the book for unlogged users" do
      user = FactoryGirl.create(:user)
      sign_out user
      book = FactoryGirl.create(:book)
      request1 = FactoryGirl.create(:request, book:book, user:user)
      get :show, book_id:book.id
      assigns(:requests).should eq([request1])
    end

  end
    
end