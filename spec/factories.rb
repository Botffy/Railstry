#encoding: UTF-8
Factory.define :user do |user|
	user.name "S Ármin"
	user.email "scipiades.armin@gmail.com"
	user.password "foobar"
	user.password_confirmation "foobar"
end

Factory.sequence :name do |n|
	"Tester #{n}"
end

Factory.sequence :email do |n|
	"tester-#{n}@example.com"
end
