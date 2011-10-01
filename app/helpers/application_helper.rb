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

end
