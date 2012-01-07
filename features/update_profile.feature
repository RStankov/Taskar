Feature: Update profile
  In order to present present myself better
  As a registered user
  I need to be able to manage my profile

  Background:
    Given I logged in
      And I am on the home page

  Scenario: Update name
    When I change my name to "Radoslav Stankov"
    Then my name should be "Radoslav Stankov"

  Scenario: Update password
    When I change my password to "qwerty"
    Then my password should be "qwerty"
