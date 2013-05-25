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
    it "show the books only from specified username" do
      user = FactoryGirl.create(:user)
      sign_in user
      get :show_user, username: user.username  
      expect(response).to render_template('index')
    end

    it "show a error message for invalid usernames without change the url" do
      sign_in FactoryGirl.create(:user)
      get :show_user, username: '_invalid_username_'  
      expect(response).to render_template('index')
      expect(response.body).to match /#{I18n.t('users.not_found')}/m
    end

  end
  
end