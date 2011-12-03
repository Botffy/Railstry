module UsersHelper
	def gravatar_for(user, options={ :size=>50 } )
		options[:default]=:wavatar if options[:default].nil?
		options[:rating]='pg' if options[:rating].nil?
		gravatar_image_tag(user.email.downcase, :alt=>h(user.name), :class=>'gravatar', :gravatar=>options )
	end
end
