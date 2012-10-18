namespace :db do
	desc "Fille database with sample data"
	task :populate => :environment do
		admin = User.create!(:name => "Bobby", :email => "kolbobby@gmail.com", :password => "rusty23", :password_confirmation => "rusty23")
		admin.toggle!(:admin)
		30.times do |n|
			name = Faker::Name.name
			email = "user-#{n+1}@example.com"
			password = "password"
			User.create!(:name => name, :email => email, :password => password, :password_confirmation => password)
		end

		users = User.all(:limit => 5)
		25.times do
			content = Faker::Lorem.sentence(5)
			users.each { |user| user.microposts.create!(:content => content) }
		end
	end
end
