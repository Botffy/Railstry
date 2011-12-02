module ApplicationHelper

# title helper to ensure we have a valid & nicely looking title on all our pages
def title
	base_title="Railstry"
	if @title.nil?
		base_title
	else
		"#{base_title}::#{@title}"
	end
end


def link_to_and_highlight (name, options = {}, html_options = {}, &block)
	if current_page?(options) then html_options[:class] << " active" end
	
	link_to name, options, html_options, block 
end

end
