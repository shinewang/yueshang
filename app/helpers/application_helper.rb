module ApplicationHelper

  FLASH_NOTICE_KEYS = [:error, :notice, :warning]

  # Return a link for use in layout navigation.
  def nav_link(text, path)
    #link_to_unless_current text, :controller => controller, :action => action
    if @current_tab != nil && @current_tab == text
      link_to "<span>#{text}</span>", path, :class => 'selected'
    else
      link_to text, path
    end
  end

  def if_recaptcha?
		yield if @bad_visitor
	end

  def if_admin?
    yield if logged_in? && current_user.has_role?('admin')
	end

	def if_logged_in?
		yield if logged_in?
	end

  def format_time(time)
    time.strftime('%Y-%m-%d %H:%M:%S')
  end

  def format_body(body)
    format_body = body.gsub(%r{(HTTP|http|Http)[sS]*://[\w-]*\.[\w/\.\?&=:\+\-%#]*}) do |url|
      if url =~ /.\.(jpg|jpeg|png|gif|JPG|JPEG|PNG|GIF)/
        "<a href='#{url}' target='_blank'><img src='#{url}' border='0' alt='图' class='image'></a>"
      else
        "<a href='#{url}'>#{url}</a>"
      end
    end
    format_body.gsub(/\r\n/,'<br>')
  end

  def split_title(title)
    if title && title.length > 15 #change to 25*3
      title.split(//)[0,5].to_s + "..."
    else
      title
    end
  end

  def paginate(record_count, page_size, url)
    total_pages = (record_count + page_size - 1) / page_size
    current_page = params[:page] && params[:page].to_i ? params[:page].to_i : 1
    pagination_div = '<div class="pagination">'
    if total_pages > 1
      if current_page <= 1
        pagination_div += '<span class="disabled prev_page">上一页</span>'
      else
        pagination_div += '<a href="' + url + "?page=#{current_page-1}" + '" class="prev_page" rel="prev">上一页</a>'
      end
      
      page = 1
      while page <= total_pages
        if page < current_page
          pagination_div += ' <a href="' + url + "?page=#{page}" + '" rel="prev">' + page.to_s + '</a> '
        elsif page == current_page
          pagination_div += ' <span class="current">' + current_page.to_s + '</span> '
        else
          pagination_div += ' <a href="' + url + "?page=#{page}" + '" rel="next">' + page.to_s + '</a> '
        end
        page += 1
      end

      if current_page >= total_pages
        pagination_div += '<span class="disabled next_page">下一页</span>'
      else
        pagination_div += '<a href="' + url + "?page=#{current_page+1}" + '" class="next_page" rel="next">下一页</a>'
      end
    end
    pagination_div += '</div>'

  end

  def sortable(field, order=nil)
    if params[:sort] == field
      order = 'desc'
    elsif params[:sort_desc] == field
      order = nil
    end
    split_uri = request.request_uri.split('?')
    sort_uri = "#{split_uri.shift}?"
    if split_uri.size == 1
      param_tokens = split_uri.shift.split('&')
      for token in param_tokens
        sort_uri += "#{token}&" unless token =~ /sort=.*/ || token =~ /sort_desc=.*/
      end
    end
    if order == 'desc'
      sort_uri += "sort_desc=#{field}"
    else
      sort_uri += "sort=#{field}"
    end
  end

  def status(status_id)
    case status_id
      when 0 then "请求审核"
      when 1 then "请求隐藏"
      when 2 then "有效"
      when 3 then "隐藏"
    end
  end

  def job_status(status_id)
    case status_id
      when 0 then "申请"
      when 1 then "有效"
      when 2 then "隐藏"
    end
  end

  def able(status)
    case status
      when false then "失效"
      when true then "有效"
    end
  end

  def role_tag(roles)
    if roles && roles.size > 0
      role_string = roles.shift.name
    end
    for role in roles
      role_string += ", #{role.name}"
    end
    return role_string
  end

  def icon_tag(image, name)
    "<dl class=\"icon\"><dt>#{eval(image)}</dt><dd>#{name}</dd></dl>"
  end

end
