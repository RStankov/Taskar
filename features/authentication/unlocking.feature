Feature: Unlocking
  In order to be more protected
  As a registered user
  I want my account to be locked after a certain number of invalid login attempts

  Background:
    Given a user "john.doe@example.org" with password "123456"
      And the user with email "john.doe@example.org" is locked

  Scenario: Not allowing locked user to login(even with correct credentials)
     When I try to login as "john.doe@example.org" with password "123456"
     Then I should see "Your account is locked."

  Scenario: Unlocking from email
     When I unlock my account from the link send to "john.doe@example.org"
     Then I should be signed in

  Scenario: Request unlock email
     When I request an unlock email for "john.doe@example.org"
      And I unlock my account from the link send to "john.doe@example.org"
     Then I should be signed in

