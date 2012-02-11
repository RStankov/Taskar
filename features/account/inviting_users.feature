Feature: Inviting users
  In order to collaborate with multiple people
  As account owner
  I want to be able to invite people

  Background:
    Given I am logged in as an account owner

  Scenario: Inviting user
    When I invite "rs@example.org" to my account
     And "rs@example.org" accepts my invitation
    Then the user with "rs@example.org" should be in my account

  Scenario: Inviting existing user(not in my account)
    Given a user "rs@example.org" with password "123456"
     When I invite "rs@example.org" to my account
      And "rs@example.org" accepts my invitation confirming with "123456" password
     Then the user with "rs@example.org" should be in my account

  Scenario: Send second invitation email
    Given I have invited "rs@example.org" to my account
     When I resent my invitation
      And "rs@example.org" accepts my invitation
     Then the user with "rs@example.org" should be in my account

  Scenario: Delete invitation
    Given I have invited "rs@example.org" to my account
     When I delete my invitation
     Then there should not be an invitation for "rs@example.org"