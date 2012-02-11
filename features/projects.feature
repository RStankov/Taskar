Feature: Projects
  In order to better organize my team's tasks
  As account owner
  I want to be able to create and manage projects

  Background:
    Given I am logged in as an account owner

  Scenario: Create new project
     When I create new project "Taskar"
     Then I should see "Create task list"
      And there should be a project named "Taskar"

  Scenario: Renaming project
    Given a project named "Todo App" exists in my account
     When I rename the project to "Taskar"
     Then there should be a project named "Taskar"
      But there should not be a project named "Todo App"

  Scenario: Completing a project
    Given a project named "Taskar" exists in my account
     When I complete the project
     Then the project should be completed

  Scenario: Reseting completed project
    Given a completed project named "Taskar" exists in my account
     When I reset the project
     Then the project should not be completed

  Scenario: Deleting a project
    Given a project named "Taskar" exists in my account
     When I delete the project
     Then there should not be a project named "Todo App"
