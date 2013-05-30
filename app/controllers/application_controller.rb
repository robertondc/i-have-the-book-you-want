class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :owner?, :request_available?

  def request_available?(object)
    user_signed_in? && !owner?(object) && !current_user.requests.map{|r| r.book }.include?(object)
  end

  def owner?(object)
    (object.instance_of?(User) && current_user == object) || (object.respond_to?(:user) && object.user == current_user)
  end
  
end
