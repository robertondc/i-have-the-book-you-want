class ApplicationController < ActionController::Base
  protect_from_forgery

  def owner?(object)
    (object.instance_of?(User) && current_user == object) || (object.respond_to?(:user) && object.user == current_user)
  end
  
end
