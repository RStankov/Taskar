Feature: Commenting a task
  In order to better understand tasks
  As a project member
  I want to be able to comment on tasks

  Background:
    Given I am logged in project member
      And a task "Fix registration"

  @javascript
  Scenario: Creating a comment
    When I comment on "Fix registration" with "Done"
    Then there should be a "Done" comment on "Fix registration" task

  @javascript
  Scenario: Updating a comment
    Given I have made a comment "Done" on "Fix registration"
     When I update the "Done" comment on "Fix registration" with "Just done it"
     Then there should be a "Just done it" comment on "Fix registration" task
      But there should not be a "Done" comment on "Fix registration" task

  @javascript
  Scenario: Deleting a comment
    Given I have made a comment "Done" on "Fix registration"
     When I delete the "Done" comment on "Fix registration"
     Then there should not be a "Done" comment on "Fix registration" task

  Scenario: Not be able to edit or delete other users's comment
    Given I a comment "Done" on "Fix registration"
     Then I should not be able to edit or delete the "Done" comment

  Scenario: Not be able to edit or delete comment older than 15 minutes
    Given I have made a comment "Done" on "Fix registration" before 16 minutes ago
     Then I should not be able to edit or delete the "Done" comment
