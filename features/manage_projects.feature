Feature: Manage projects
  In order to be more organized
  As user
  I want to be able to create and manage projects
  
  Scenario: Create new project
    Given I am "Jack Jones" owner of "15 Lines" account
    And I am logged in
    And I am on the home page
    When I follow "Projects"
    And I follow "Create new project"
    And I fill in "Name" with "Newline"
    And I check "Jack Jones"
    And I press "Create"
    Then should see "Newline"
    And should see "Create task list"

  Scenario: Update existing project
    Given I am "Jack Jones" owner of "15 Lines" account
    And "Newline" project exists for "15 Lines"
    And I am logged in
    And I am on the home page
    When I follow "Projects"
    Then I should see "Newline"
    When I follow "Newline"
    And I follow "Edit"
    And I fill in "Name" with "New-line"
    And press "Save"
    Then I should see "Project updated successfully"
    And I should see "New-line"