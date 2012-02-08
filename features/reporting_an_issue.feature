Feature: Reporting an issue
  In order to improve the application
  As a registered user
  I want to be able to report an issues with the application

  @pending @javascript
  Scenario: Reporting an issue
    Given I am logged in
      And I am on the home page
     When I report issue about "Slow page loading"
     Then there should be an issue about "Slow page loading" on the home page


