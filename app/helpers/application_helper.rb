module ApplicationHelper
  def back_link_path
    return params[:return_to] if params[:return_to].present?
    return request.referer if request.referer.present? && request.referer.include?(request.host)
    people_path
  end
end
