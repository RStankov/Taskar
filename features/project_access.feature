Feature: Project access
  In to have better control who is contributing to a project
  As account owner
  I want to be able to give and revoke access to projects

  Background:
    Given I logged in as an account owner
      And a project named "Todo App" exists in my account

  Scenario: Giving access to a user
    Given a user named "John Doe" exists in my account
     When I give access to "Todo App" to "John Doe"
     Then "John Doe" should have access to "Todo App" project

  Scenario: Revoking access to a user
    Given a user named "John Doe" exists in my account
      And "John Doe" has access to "Todo App" project
     When I revoke the access to "Todo App" to "John Doe"
     Then "John Doe" should not have access to "Todo App" project

  Scenario: Giving access to a user from his account profile page
    Given a user named "John Doe" exists in my account
     When I give access to "Todo App" to "John Doe" from his account profile page
     Then "John Doe" should have access to "Todo App" project

  Scenario: Deny access to project (even for the account owner)
     When I open "Todo App" project
     Then I should see that I don't have access to the project
