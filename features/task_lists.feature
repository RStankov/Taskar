Feature: Task lists
  In order to have a full chaos with project's tasks
  As a project user
  I want to be able to group tasks in lists

  Background:
    Given I am logged in project member
      And there is a task list "Analytics module"
      And I am on the project page

  @javascript
  Scenario: Adding a new task list
     When I add a task list "News module"
     Then there should be a "News module" task list in the project
      And I should be on "News module" task list page


  @javascript
  Scenario: Editing a task list
    When I rename "Analytics module" task list to "Statistics module"
    Then there should be a "Statistics module" task list in the project
     But there should not be a "Analytics module" task list in the project

  @javascript
  Scenario: Deleting a task list
    When I delete "Analytics module" task list
    Then there should not be a "Analytics module" task list in the project