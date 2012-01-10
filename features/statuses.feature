Feature: Statuses
  In order to collaborate with my coworkers
  As project user
  I want to be able to tell them what I'm currently doing

  Background:
    Given I am logged in project member
      And I am working with another user on this project

  @javascript
  Scenario: Setting my status
     When I update my status to "Going to lunch"
     Then I should have a status "Going to lunch"
      And I see my updated status on the page to "Going to lunch"

  @javascript
  Scenario: Clear status
    Given I have set my status to "Going to lunch"
     When I clear my status
     Then I should have no status
      And I should not see "Going to lunch"

  Scenario: Deleting statues
    Given I have set my status to "Going to lunch"
     When I delete my "Going to lunch" status
     Then there should not be a "Going to lunch" status
