Feature: Account users
  In order to better organize my team
  As account owner
  I want to be able to able to manage the users associated to my account

  Background:
    Given I am logged in as an account owner
      And a user named "Radoslav Stankov" exists in my account

  Scenario: Give admin access to user
     When I toggle the admin access of "Radoslav Stankov" user
     Then "Radoslav Stankov" should be admin in my account

   Scenario: Revoke admin access to user
     Given "Radoslav Stankov" is admin
      When I toggle the admin access of "Radoslav Stankov" user
      Then "Radoslav Stankov" should not be admin in my account

  Scenario: Delete user
     When I delete "Radoslav Stankov" from my account
     Then "Radoslav Stankov" user should still exist
      But "Radoslav Stankov" should not be in my account
