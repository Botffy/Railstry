#encoding: UTF-8

namespace :db do
	desc "Fill database with sample data (users)"

	task :populate=>:environment do
		Rake::Task['db:reset'].invoke
		my_first_admin=User.create!(
			:name=>"S Ármin",
			:email=>"scipiades.armin@gmail.com",
			:password=>"reindeerflotilla",
			:password_confirmation=>"reindeerflotilla"
		)
		my_first_admin.toggle!(:admin)

		100.times do |n|
			User.create!(
				:name=>Faker::Name.name,
				:email=>"example-#{n+1}@example.com",
				:password=>"password",
				:password_confirmation=>"password"
			)
		end
	end
end
