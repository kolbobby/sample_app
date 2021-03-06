FactoryGirl.define do
	factory :user do
		sequence(:name) { |n| "Person #{n}" }
		sequence(:email) { |n| "person_#{n}@example.com" }
		password "rusty23"
		password_confirmation "rusty23"
		factory :admin do
			admin true
		end
	end

	factory :micropost do
		content "Sample content"
		user
		factory :p_micropost do
			priv true
		end
	end
end
