module ApplicationHelper

# title helper to ensure we have a valid & nicely looking title on all our pages
def title
	base_title="Railstry"
	if @title.nil?
		base title
	else
		"#{base_title}::#{@title}"
	end
end

end
