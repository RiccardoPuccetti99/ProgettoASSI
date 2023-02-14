Feature: User can log in

Scenario: Log in
  Given I am on the RPP home page
  When I go to the Login Page
  Given a valid user
  And I fill in the following:
    |Email|testStep@case.com|
    |Password|12345678|
  And I press "Sign in"
  Then I should see "Signed in successfully."
  