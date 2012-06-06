Feature: Administer users
  In order to allow users to access the system
  As an administrator
  I want to administer users

  Background:
    Given I have users
      | email                     | first_name | last_name |
      | raul@intersect.org.au     | Raul       | Carrizo   |
      | georgina@intersect.org.au | Georgina   | Edwards   |
    And I have the usual roles and permissions
    And I am logged in as "georgina@intersect.org.au"
    And "georgina@intersect.org.au" has role "Administrator"

  Scenario: View a list of users
    Given "raul@intersect.org.au" is deactivated
    And I have ldap users
      | dn                                                                                         | one_id    | login_attribute | first_name | last_name | email                   |
      | CN=mqx804005,OU=Affiliated-Staff,OU=Active,OU=MQ-Users,DC=mqauth,DC=uni,DC=mq,DC=edu,DC=au | mqx804005 | mqx804005       | Ryan       | Braganza  | ryan.braganza@mq.edu.au |
    And "ryan.braganza@mq.edu.au" has role "Researcher"
    When I am on the list users page
    Then I should see "users" table with
      | First name | Last name | One ID    | Email                     | Role          | Status      |
      | Georgina   | Edwards   |           | georgina@intersect.org.au | Administrator | Active      |
      | Raul       | Carrizo   |           | raul@intersect.org.au     |               | Deactivated |
      | Ryan       | Braganza  | mqx804005 | ryan.braganza@mq.edu.au   | Researcher    | Active      |

  Scenario: View user details
    Given "raul@intersect.org.au" has role "Researcher"
    And I am on the list users page
    When I follow "View Details" for "raul@intersect.org.au"
    Then I should see field "Email" with value "raul@intersect.org.au"
    And I should see field "First name" with value "Raul"
    And I should see field "Last name" with value "Carrizo"
    And I should see field "Role" with value "Researcher"
    And I should see field "Status" with value "Active"
    And I should see field "One ID" with value ""

  Scenario: View ldap user details
    Given I have ldap users
      | dn                                                                                         | one_id    | login_attribute | first_name | last_name | email                   |
      | CN=mqx804005,OU=Affiliated-Staff,OU=Active,OU=MQ-Users,DC=mqauth,DC=uni,DC=mq,DC=edu,DC=au | mqx804005 | mqx804005       | Ryan       | Braganza  | ryan.braganza@mq.edu.au |
    And "ryan.braganza@mq.edu.au" has role "Researcher"
    And I am on the list users page
    When I follow "View Details" for "ryan.braganza@mq.edu.au"
    Then I should see field "Email" with value "ryan.braganza@mq.edu.au"
    And I should see field "First name" with value "Ryan"
    And I should see field "Last name" with value "Braganza"
    And I should see field "Role" with value "Researcher"
    And I should see field "Status" with value "Active"
    And I should see field "One ID" with value "mqx804005"

  Scenario: Go back from user details
    Given I am on the list users page
    When I follow "View Details" for "georgina@intersect.org.au"
    And I follow "Back"
    Then I should be on the list users page

  Scenario: Edit role
    Given "raul@intersect.org.au" has role "Researcher"
    And I am on the list users page
    When I follow "View Details" for "raul@intersect.org.au"
    And I follow "Edit role"
    And I select "Administrator" from "Role"
    And I press "Save"
    Then I should be on the user details page for raul@intersect.org.au
    And I should see "The role for raul@intersect.org.au was successfully updated."
    And I should see field "Role" with value "Administrator"

  Scenario: Edit role from list page
    Given "raul@intersect.org.au" has role "Researcher"
    And I am on the list users page
    When I follow "Edit role" for "raul@intersect.org.au"
    And I select "Administrator" from "Role"
    And I press "Save"
    Then I should be on the user details page for raul@intersect.org.au
    And I should see "The role for raul@intersect.org.au was successfully updated."
    And I should see field "Role" with value "Administrator"

  Scenario: Cancel out of editing roles
    Given "raul@intersect.org.au" has role "Researcher"
    And I am on the list users page
    When I follow "View Details" for "raul@intersect.org.au"
    And I follow "Edit role"
    And I select "Administrator" from "Role"
    And I follow "Back"
    Then I should be on the user details page for raul@intersect.org.au
    And I should see field "Role" with value "Researcher"

  Scenario: Role should be mandatory when editing Role
    And I am on the list users page
    When I follow "View Details" for "raul@intersect.org.au"
    And I follow "Edit role"
    And I select "" from "Role"
    And I press "Save"
    Then I should see "Please select a role for the user."

  Scenario: Deactivate active user
    Given I am on the list users page
    When I follow "View Details" for "raul@intersect.org.au"
    And I follow "Deactivate"
    Then I should see "The user has been deactivated"
    And I should see "Activate"

  Scenario: Activate deactivated user
    Given "raul@intersect.org.au" is deactivated
    And I am on the list users page
    When I follow "View Details" for "raul@intersect.org.au"
    And I follow "Activate"
    Then I should see "The user has been activated"
    And I should see "Deactivate"

  Scenario: Can't deactivate the last administrator account
    Given I am on the list users page
    When I follow "View Details" for "georgina@intersect.org.au"
    And I follow "Deactivate"
    Then I should see "You cannot deactivate this account as it is the only account with Administrator privileges."
    And I should see field "Status" with value "Active"

  Scenario: Editing own role has alert
    Given I am on the list users page
    When I follow "View Details" for "georgina@intersect.org.au"
    And I follow "Edit role"
    Then I should see "You are changing the role of the user you are logged in as."

  Scenario: Should not be able to edit role of rejected user by direct URL entry
    Given I have a rejected as spam user "spam@intersect.org.au"
    And I go to the edit role page for spam@intersect.org.au
    Then I should be on the list users page
    And I should see "Role can not be set. This user has previously been rejected as a spammer."

