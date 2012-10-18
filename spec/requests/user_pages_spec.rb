require 'spec_helper'

describe "UserPages" do
	subject { page }

	describe "Index" do
		let(:admin) { FactoryGirl.create(:admin) }
		before do
			sign_in admin
			visit users_path
		end

		it { should have_selector('title', :text => "All Users") }
		it { should have_selector('h1', :text => "All Users") }
		describe "Pagination" do
			it { should have_selector('div.pagination') }
			it "should list each user" do
				User.paginate(:page => 1).each do |user|
					page.should have_selector('li', :text => user.name)
				end
			end
		end

		describe "Delete Links" do
			it { should_not have_link('delete') }
			describe "as an Admin User" do
				let(:admin) { FactoryGirl.create(:admin) }
				before do
					sign_in admin
					visit users_path
				end

				it { should have_link('delete', :href => user_path(User.first)) }
				it "should be able to delete another User" do
					expect { click_link('delete') }.to change(User, :count).by(-1)
				end
				it { should_not have_link('delete', :href => user_path(admin)) }
			end
		end
	end

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
			describe "after submission" do
				before { click_button submit }
				it { should have_selector('title', :text => "Sign Up") }
				it { should have_content('error') }
			end
		end
		describe "with valid information" do
			before { fill_f(false) }
			it "should create a user" do
				expect { click_button submit }.to change(User, :count).by(1)
			end
			describe "after saving the user" do
				before { click_button submit }
				let(:user) { User.find_by_email("user@example.com") }

				it { should have_selector('title', :text => user.name) }
				it { should have_selector('div.alert.alert-success', :text => 'Welcome') }
				it { should have_link('Sign Out') }
			end
		end
	end

	describe "ProfilePage" do
		let(:user) { FactoryGirl.create(:user) }
		let!(:m1) { FactoryGirl.create(:micropost, :user => user, :content => "s1") }
		let!(:m2) { FactoryGirl.create(:micropost, :user => user, :content => "s2") }
		before { visit user_path(user) }

		it { should have_selector('title', :text => user.name) }
		it { should have_selector('h1', :text => user.name) }

		describe "microposts" do
			it { should have_content(m1.content) }
			it { should have_content(m2.content) }
			it { should have_content(user.microposts.count) }
		end
	end

	describe "Edit" do
		let(:user) { FactoryGirl.create(:user) }
		before do
			sign_in user
			visit edit_user_path(user)
		end

		describe "Page" do
			it { should have_selector('title', :text => "Edit User") }
			it { should have_selector('h1', :text => "Update Profile") }
			it { should have_link('change', :href => 'http://gravatar.com/emails') }
		end
		describe "with invalid information" do
			before { click_button "Save Changes" }
			it { should have_content('error') }
		end
		describe "with valid information" do
			let(:new_name) { "New Name" }
			let(:new_email) { "new@example.com" }
			before do
				fill_f(true)
				click_button "Save Changes"
			end

			it { should have_selector('title', :text => new_name) }
			it { should have_selector('div.alert.alert-success') }
			it { should have_link('Sign Out', :href => signout_path) }
			specify { user.reload.name.should == new_name }
			specify { user.reload.email.should == new_email }
		end
	end
end
