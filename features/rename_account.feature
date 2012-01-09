Feature: Rename account

  Scenario: Rename account
    Given I am logged in as an account owner
     When I rename my account name to "Taskar"
     Then I should be owner of the "Taskar" account


