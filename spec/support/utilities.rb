include ApplicationHelper

def valid_signin(user)
	fill_in "Email", :with => user.email
	fill_in "Password", :with => user.password
	click_button "Sign In"
end

def fill_f(n)
	if n
		fill_in "Name", :with => "New Name"
		fill_in "Email", :with => "new@example.com"
	else
		fill_in "Name", :with => "Example User"
		fill_in "Email", :with => "user@example.com"
	end
	fill_in "Password", :with => "rusty23"
	fill_in "Confirmation", :with => "rusty23"
end

def sign_in(user)
	visit signin_path
	fill_in "Email", :with => user.email
	fill_in "Password", :with => user.password
	click_button "Sign In"
	cookies[:remember_token] = user.remember_token
end

RSpec::Matchers.define :have_error_message do |message|
	match do |page|
		page.should have_selector('div.alert.alert-error', :text => message)
	end
end