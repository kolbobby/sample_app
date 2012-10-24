namespace :db do
	desc "Fill database with sample data"
	task :populate => :environment do
		make_users
		make_microposts
		make_relationships
	end

	def make_users
		admin = User.create!(:name => "Bobby", :email => "kolbobby@gmail.com", :password => "rusty23", :password_confirmation => "rusty23")
		admin.toggle!(:admin)
		30.times do |n|
			name = Faker::Name.name
			email = "user-#{n+1}@example.com"
			password = "password"
			User.create!(:name => name, :email => email, :password => password, :password_confirmation => password)
		end
	end
	def make_microposts
		users = User.all(:limit => 5)
		25.times do
			content = Faker::Lorem.sentence(5)
			users.each { |user| user.microposts.create!(:content => content) }
		end
	end
	def make_relationships
		users = User.all
		user = users.first
		followed_users = users[2..25]
		followers = users [2..25]
		followed_users.each { |followed| user.follow!(followed) }
		followers.each { |follower| follower.follow!(user) }
	end
end
