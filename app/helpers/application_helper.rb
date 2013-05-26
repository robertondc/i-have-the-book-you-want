module ApplicationHelper
  def session_link
    if user_signed_in? 
      link_to t('logoff', user:current_user.username), destroy_user_session_path, method:'delete' 
    else
      link_to t('logon'), new_user_session_path
    end
  end
  
  def actions_button(book)
    
  end  
end