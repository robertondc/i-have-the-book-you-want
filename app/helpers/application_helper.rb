module ApplicationHelper
  def session_link
    if user_signed_in? 
      link_to t('logoff', user: current_user.username), destroy_user_session_path, method:'delete' 
    else
      link_to t('logon'), new_user_session_path
    end
  end
  
  def sortable(column, title=nil)
    title ||= column.titleize 
    direction = column == sort_column && sort_direction == 'asc' ? 'desc' : 'asc'
    arrow_current = sort_direction == 'asc' ? '<i class="icon-chevron-up"></i>' : '<i class="icon-chevron-down"></i>' if column == sort_column
    link_to ("#{title} #{arrow_current}").html_safe, {sort: column, direction: direction}, remote: true
  end  
  
end