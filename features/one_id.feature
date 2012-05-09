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

  @wip
  Scenario: Admin searches for One ID by oneid
    Given I am logged in as "admin@intersect.org.au"
    And I am on the admin page
    And I follow "New OneID Account"
    Then I should see "New OneID Account"
    When I fill in "One ID" with "mqx804005"
    And I press "Search"
    Then I should see One ID results table
      | Ryan | Braganza | mqx804005 |
