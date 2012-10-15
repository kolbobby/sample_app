Feature: Signing In
	Scenario: Unsuccessful SignIn
		Given a user visits the SignInPage
		When he submits invalid SignIn information
		Then he should see an error message
	Scenario: Successful SignIn
		Given a user visits the SignInPage
		And the user has an account
		And the user submits valid SignIn information
		Then he should see his profile page
		And he should see a SignOut link