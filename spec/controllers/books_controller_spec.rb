require 'spec_helper'

describe BooksController do
  render_views
  
  before(:all) do
     @user = User.new
     @user.username = 'roberto'
     @user.email = 'roberto@roberto.com'
     @user.password = 'roberto@roberto.com'
     @user.save
     
     @book = Book.new
     @book.author = 'Paulo Coelho'
     @book.title = 'Diario de um Mago'
     @book.language = Book::LANGUAGES.first
     @book.user = @user
     @book.save
     
     @another_user = User.new
     @another_user.username = 'paulo'
     @another_user.email = 'paulo@paulo.com'
     @another_user.password = 'paulo@paulo.com'
     @another_user.save
  end

  describe "GET index" do
    it "redirects the user to login for unlogged users" do
      sign_out @user
      get :index
      expect(response).to redirect_to(new_user_session_path)
    end

    it "shows the own books page for logged users" do
      sign_in @user
      get :index
      expect(response).to render_template('index')
    end
  end

  describe "GET edit" do
    
    it "redirects the user to login for unlogged users" do
      sign_out @user
      get :edit, id: @book
      expect(response).to redirect_to(new_user_session_path)
    end

    it "shows the edit books page the for logged users owning the books" do
      sign_in @user
      get :edit, id: @book
      expect(response).to render_template('edit')
    end

    it "redirects to the root page when the current user is not the owner of book" do      
      sign_out @user
      sign_in @another_user
      
      get :edit, id: @book
      expect(response).to redirect_to(root_path)
    end
        
  end
  
  describe "GET show_user" do
    it "show the books only from specified username" do
      sign_in @user
      get :show_user, username: @user.username  
      expect(response).to render_template('index')
    end

    it "show a error message for invalid usernames without change the url" do
      sign_in @user
      get :show_user, username: 'invalid_username_'  
      expect(response).to render_template('index')
      expect(response.body).to match /#{I18n.t('users.not_found')}/m
    end

  end
  
end