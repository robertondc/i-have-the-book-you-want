require 'spec_helper'

describe BooksController do
  render_views
  
  describe "GET index" do
    it "redirects the user to login for unlogged users" do
      user = FactoryGirl.create(:user)
      sign_out user
      get :index
      expect(response).to redirect_to(new_user_session_path)
    end

    it "shows the own books page for logged users" do
      sign_in FactoryGirl.create(:user)
      get :index
      expect(response).to render_template('index')
    end
    
    it "must to sort with 'title asc' by default" do
      user = FactoryGirl.create(:user)
      sign_in user
      book1 = FactoryGirl.create(:book, user:user, title: '2')
      book2 = FactoryGirl.create(:book, user:user, title: '1')
      get :index
      expect(response).to render_template('index')
      assigns(:books).should eq([book2,book1])
    end

    it "must to sort according specified column name with 'asc' direction by default" do
      user = FactoryGirl.create(:user)
      sign_in user
      book1 = FactoryGirl.create(:book, user:user, author: '2')
      book2 = FactoryGirl.create(:book, user:user, author: '1')
      get :index, sort: 'author'
      expect(response).to render_template('index')
      assigns(:books).should eq([book2,book1])
    end

    it "must to sort according specified column name and direction" do
      user = FactoryGirl.create(:user)
      sign_in user
      book1 = FactoryGirl.create(:book, user:user, author: '2')
      book2 = FactoryGirl.create(:book, user:user, author: '1')
      get :index, sort: 'author', direction: 'desc'
      expect(response).to render_template('index')
      assigns(:books).should eq([book1,book2])
    end

    it "must to sort with 'title' when specified a missing column" do
      user = FactoryGirl.create(:user)
      sign_in user
      book1 = FactoryGirl.create(:book, user:user, title: '2')
      book2 = FactoryGirl.create(:book, user:user, title: '1')
      get :index, sort: '_invalid_colum_', direction: 'asc'
      expect(response).to render_template('index')
      assigns(:books).should eq([book2,book1])
    end

    it "must to sort with 'asc' when specified a missing direction" do
      user = FactoryGirl.create(:user)
      sign_in user
      book1 = FactoryGirl.create(:book, user:user, title: '2')
      book2 = FactoryGirl.create(:book, user:user, title: '1')
      get :index, sort: 'title', direction: '_invalid_direction_'
      expect(response).to render_template('index')
      assigns(:books).should eq([book2,book1])
    end

  end

  describe "GET edit" do
    
    it "redirects the user to login page when unlogged users" do
      user = FactoryGirl.create(:user)
      sign_out user
      get :edit, id: FactoryGirl.create(:book)
      expect(response).to redirect_to(new_user_session_path)
    end

    it "shows the edit books page the for logged users owning the books" do
      user = FactoryGirl.create(:user)
      sign_in user
      get :edit, id: FactoryGirl.create(:book, user:user)
      expect(response).to render_template('edit')
    end

    it "redirects to the root page when the current user is not the owner of book" do
      user = FactoryGirl.create(:user)
      sign_in FactoryGirl.create(:another_user)
      get :edit, id: FactoryGirl.create(:book, user:user)
      expect(response).to redirect_to(root_path)
    end
        
  end
  
  describe "GET show_user" do
    
    it "show the books only from specified username for logged users" do
      user = FactoryGirl.create(:user)
      sign_in user
      book = FactoryGirl.create(:book, user:user)
      another_book = FactoryGirl.create(:book)
      get :show_user, username: user.username 
      expect(response).to render_template('index')
      assigns(:books).should eq([book])
    end

    it "show the books only from specified username for unlogged users too" do
      user = FactoryGirl.create(:user)
      sign_out user
      book = FactoryGirl.create(:book, user:user)
      another_book = FactoryGirl.create(:book)
      get :show_user, username: user.username 
      expect(response).to render_template('index')
      assigns(:books).should eq([book])
    end

    it "show a error message for invalid usernames without change the url and with no itens returned" do
      sign_in FactoryGirl.create(:user)
      get :show_user, username: '_invalid_username_'
      expect(response).to render_template('index')
      expect(response.body).to match /#{I18n.t('users.not_found')}/m
      assigns(:books).should eq([])
    end
    
    it "must to sort with 'title asc' by default" do
      user = FactoryGirl.create(:user)
      sign_in user
      book1 = FactoryGirl.create(:book, user:user, title: '2')
      book2 = FactoryGirl.create(:book, user:user, title: '1')
      get :show_user, username: user.username 
      expect(response).to render_template('index')
      assigns(:books).should eq([book2,book1])
    end

    it "must to sort according specified column name with 'asc' direction by default" do
      user = FactoryGirl.create(:user)
      sign_in user
      book1 = FactoryGirl.create(:book, user:user, author: '2')
      book2 = FactoryGirl.create(:book, user:user, author: '1')
      get :show_user, username: user.username , sort: 'author'
      expect(response).to render_template('index')
      assigns(:books).should eq([book2,book1])
    end

    it "must to sort according specified column name and direction" do
      user = FactoryGirl.create(:user)
      sign_in user
      book1 = FactoryGirl.create(:book, user:user, author: '2')
      book2 = FactoryGirl.create(:book, user:user, author: '1')
      get :show_user, username: user.username , sort: 'author', direction: 'desc'
      expect(response).to render_template('index')
      assigns(:books).should eq([book1,book2])
    end

    it "must to sort with 'title' when specified a missing column" do
      user = FactoryGirl.create(:user)
      sign_in user
      book1 = FactoryGirl.create(:book, user:user, title: '2')
      book2 = FactoryGirl.create(:book, user:user, title: '1')
      get :show_user, username: user.username , sort: '_invalid_colum_', direction: 'asc'
      expect(response).to render_template('index')
      assigns(:books).should eq([book2,book1])
    end

    it "must to sort with 'asc' when specified a missing direction" do
      user = FactoryGirl.create(:user)
      sign_in user
      book1 = FactoryGirl.create(:book, user:user, title: '2')
      book2 = FactoryGirl.create(:book, user:user, title: '1')
      get :show_user, username: user.username , sort: 'title', direction: '_invalid_direction_'
      expect(response).to render_template('index')
      assigns(:books).should eq([book2,book1])
    end
    
  end
    
end