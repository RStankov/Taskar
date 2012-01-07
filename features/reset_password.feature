Feature: Reset password
  In order to use Task if I have forgot my password
  As a registered user
  I should be able to reset my password

  Scenario: Reset forgotten password
    Given I an registered user with email "rs@example.org"
      And I have forgotten my password
     When I reset my password of "rs@example.org" email with "123456"
     Then I should be signed in
      And I should be able to login with "rs@exmple.org" and password "123456"

  Scenario: Try to reset password with wrong email
    When I try to reset the password of "not.me@exmaple.org"
    Then I should see "E-mail not found"

  Scenario: Try to reset password with wrong token
    When I try to reset password with wrong token
    Then I should see "Password reset token can't be blank"
