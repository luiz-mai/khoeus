module ApplicationHelper
  # Returns the full title on a per-page basis.
  def full_title(page_title = '')
    base_title = "Khoeus"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def body_class
    [controller_name, action_name].join('-')
  end

  def input_group(title, icon, required, *fields)
    content_tag(:div, class: 'form-group') do
      label_tag(title.parameterize.underscore.to_sym, title) + ('*' if required) +
          content_tag(:div, class: "form-fields #{'multiple' if fields.size > 1}") do
            content_tag(:i, nil, class: "fa fa-#{icon}") +
                content_tag(:div, class: 'row') do
                  fields.each do |field|
                    concat(content_tag(:div, class: "col-xs-12 col-md-#{field[:col]}") do
                      concat(send(field[:type] + '_tag', field[:name].parameterize.underscore.to_sym, '', class: field[:classes], placeholder: field[:placeholder]))
                    end)
                  end
                end
          end
    end
  end
end
