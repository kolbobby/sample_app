require 'spec_helper'

describe "UserPages" do
	subject { page }

	describe "SignUpPage" do
		before { visit signup_path }
		it { should have_selector('title', :text => full_title('Sign Up')) }
		it { should have_selector('h1', :text => 'Sign Up') }
	end
	describe "SignUp" do
		before { visit signup_path }
		let(:submit) { "Create My Account" }

		describe "with invalid information" do
			it "should not create a user" do
				expect { click_button submit }.not_to change(User, :count)
			end
		end
		describe "with valid information" do
			before do
				fill_in "Name", :with => "Example User"
				fill_in "Email", :with => "user@example.com"
				fill_in "Password", :with => "rusty23"
				fill_in "Confirmation", :with => "rusty23"
			end
			it "should create a user" do
				expect { click_button submit }.to change(User, :count).by(1)
			end
		end
	end

	describe "ProfilePage" do
		let(:user) { FactoryGirl.create(:user) }
		before { visit user_path(user) }
		it { should have_selector('title', :text => user.name) }
		it { should have_selector('h1', :text => user.name) }
	end
end
