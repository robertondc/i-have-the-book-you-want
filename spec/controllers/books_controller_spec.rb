require 'spec_helper'

describe BooksController do

  before(:all) do
     @user = User.new
     @user.username = 'roberto'
     @user.email = 'roberto@roberto.com'
     @user.password = 'roberto@roberto.com'
     @user.save
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

end