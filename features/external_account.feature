Feature: In order to grant access to the system
  As an administrator
  I want to create an external account

  Background:
    Given I have a user "admin@intersect.org.au" with role "Administrator"
    And I have a user "resesarcher@intersect.org.au" with role "Researcher"

  Scenario: Create a user
    Given I am logged in as "admin@intersect.org.au"
    When I am on the admin page
    And I follow "New External Account"
    And I fill in external user info
      | first_name | last_name | email        | role       |
      | Bob        | Bobo      | bob@bobo.com | Researcher |
    And I press "Save"
    Then I should see "The user was successfully created."
    And I should be on the user details page for bob@bobo.com
    But FYI the user will be assigned a random password by the system
    And I should see fields displayed
      | field        | value        |
      | Email        | bob@bobo.com |
      | First name   | Bob          |
      | Last name    | Bobo         |
      | Role         | Researcher   |
      | Status       | Active       |
      | One ID       |              |
    Then I logout

    And "bob@bobo.com" should receive an email
    When I open the email
    Then I should see "An account has been created for you with the following details" in the email body
    Given I am on the list papyri page # so we are not on the front page with a sign-in form
    When I follow "Login to Macquarie Papyri" in the email
    And I sign in with the credentials in the email
    Then I should see "Logged in successfully."

  Scenario: Create a user fail
    Given I am logged in as "admin@intersect.org.au"
    When I am on the admin page
    And I follow "New External Account"
    But FYI I didn't fill anything in
    And I press "Save"
    Then I should see "The record could not be saved"

  Scenario: not seeing warnings about is_ldap nor login_attribute
    Given I am logged in as "admin@intersect.org.au"
    When I am on the admin page
    And I follow "New External Account"
    And I fill in external user info
      | first_name | last_name |
      | dupe       | dupe      |
    And I press "Save"
    Then I should see "The record could not be saved"
    And I should not see "Login can't be blank"
    And I should not see "should eq"
    And I should not see "Is ldap is not included in the list"

  Scenario: researcher can't create
    Given I am logged in as "researcher@intersect.org.au"
    When I am on the new external users page
    Then I should be on the new user session page

  Scenario: anonymous can't create
    When I am on the new external users page
    Then I should be on the new user session page
