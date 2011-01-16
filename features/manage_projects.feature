Feature: Manage projects
  In order to be more organized
  As user
  I want to be able to create and manage projects
  
  Scenario: Create new project
    Given I am "Jack Jones" owner of "Baker shop" account
    And I am logged in
    And I am on the home page
    When I follow "Projects"
    And I follow "Create new project"
    And I fill in "Name" with "Demo project"
    And I check "Jack Jones"
    And I press "Create"
    Then I should see "Demo project"
    And show me the page
    And should see "Create task list"
