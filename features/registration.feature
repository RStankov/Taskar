Feature: Registration
  In order to be able to use Taskar
  As user
  I want to register and login

  Scenario: Registering user and account
    When I register as "John Doe" with account "Taskar"
    Then I should see "You have signed up successfully."
     And there should be a user "John Doe" owning the account "Taskar"

  Scenario: Logging in
    Given a user "john.doe@example.org" with password "123456"
     When I login as "john.doe@example.org" with password "123456"
     Then I should be logged in

  Scenario: Try to login with wrong password
    When I login as "not.existing.user@example.org" with password "wrong-password"
    Then I should not be logged in