Feature: OneID
  In order to administer less accounts
  As an admin I want to search and create OneID users
  As a user I want to sign in after an account being created for me

  Background:
    Given I have the usual roles and permissions
    And I have a user "admin@intersect.org.au" with role "Administrator"
    And I have a user "researcher@intersect.org.au" with role "Researcher"
# ldap users defined in config/test_ldap_data.ldif

  Scenario: Anonymous can't create OneID user
    When I am on the create One ID user page
    Then I should be on the login page

  Scenario: Researcher can't create OneID user
    Given I am logged in as "researcher@intersect.org.au"
    When I am on the create One ID user page
    Then I should be on the homepage

  @ldap
  Scenario: Admin finds nothing
    Given I am logged in as "admin@intersect.org.au"
    And I am on the admin page
    And I follow "New OneID Account"
    Then I should see "New OneID Account"
    When I fill in "one_id" with "mqx80400"
    And I press "Search"
    Then I should not see the One ID results table

  @ldap
  Scenario Outline: Admin searches by a single parameter
    Given I am logged in as "admin@intersect.org.au"
    And I am on the admin page
    And I follow "New OneID Account"
    Then I should see "New OneID Account"
    When I fill in "<field>" with "<value>"
    And I press "Search"
    Then I should see One ID results table
      | One ID    | First Name | Last Name | Email                |
      | mqx803999 | Carlos     | Aya       | carlos.aya@mq.edu.au |
    Examples:
      | field      | value     |
      | one_id     | mqx803999 |
      | first_name | carlos    |
      | last_name  | aya       |

  @ldap
  Scenario: Creating a user
    Given I am logged in as "admin@intersect.org.au"
    And I am on the new one id users page
    When I fill in "one_id" with "mqx804005"
    And I press "Search"
    And I press "Create" for One ID "mqx804005"
    Then I should be on the user details page for ryan.braganza@mq.edu.au
    And "ryan.braganza@mq.edu.au" should be a "Researcher"

  @ldap
  Scenario: Users that already exist should not show up in search
    Given I have ldap users
      | dn                                                                                         | one_id    | login_attribute | first_name | last_name | email                   |
      | CN=mqx804005,OU=Affiliated-Staff,OU=Active,OU=MQ-Users,DC=mqauth,DC=uni,DC=mq,DC=edu,DC=au | mqx804005 | mqx804005       | Ryan       | Braganza  | ryan.braganza@mq.edu.au |
    Given I am logged in as "admin@intersect.org.au"
    And I am on the new one id users page
    When I fill in "one_id" with "mqx804005"
    And I press "Search"
    Then I should not see the One ID results table

  @wip
  Scenario: Checking pagination

  @ldap
  Scenario: one_id user should be able to login
    Given I have ldap users
      | dn                                                                                         | one_id    | login_attribute | first_name | last_name | email                   |
      | CN=mqx804005,OU=Affiliated-Staff,OU=Active,OU=MQ-Users,DC=mqauth,DC=uni,DC=mq,DC=edu,DC=au | mqx804005 | mqx804005       | Ryan       | Braganza  | ryan.braganza@mq.edu.au |
    When I am on the home page
    And I fill in "Login" with "mqx804005"
    And I fill in "Password" with "mypassword"
    And I press "Log in"
    Then I should see "Logged in successfully."
    And I should be on the home page

  @wip
  @ldap
  Scenario: equivalent ldap tests for database tests in login.feature
