Feature: Requesting access
  to a papyrus record

  Background:
    Given I have a user "admin@intersect.org.au" with role "Administrator"
    And I have a user "researcher@intersect.org.au" with role "Researcher"
    And I have languages
      | name     |
      | Greek    |
      | Coptic   |
      | Egyptian |
      | Demotic  |
      | Latin    |
    And I have genres
      | name          |
      | Letter        |
      | Book          |
      | Book Fragment |
    And I have papyri
      | mqt_number | inventory_id | languages       | dimensions   | date_from   | general_note  | lines_of_text  | paleographic_description | recto_verso_note | origin_details | source_of_acquisition | preservation_note | genre | language_note | summary             | original_text | translated_text | visibility |
      | 2          | v.macq2      | Coptic, Greek   | 5 x 6 cm     | 88 CE       | General Blah  | Specific blah  | Paleo Diet               | Rectangle        | It's Greek.    | Got it from Greece    | poorly preserved  | Book  | Fancy Greek   | don't understand it | περιοχής      | area            | VISIBLE    |
      | 3          | hidden.macq  | Coptic, Demotic | 5 x 6 cm     | 488 CE      | General stuff | Specific stuff |                          |                  |                |                       |                   |       |               |                     |               |                 | HIDDEN     |
      | 5          | visible.macq | Coptic, Demotic | 5 x 6 cm     | 488 CE      | General stuff | Specific stuff |                          |                  |                |                       |                   |       |               |                     |               |                 | VISIBLE    |

  Scenario: researchers should have a request access button on view papyrus pages
    Given I am logged in as "researcher@intersect.org.au"
    And I am on the "MQT 2" papyrus page
    Then I should see button "Request Access"
    And I should not see button "Cancel Access"

    When I press "Request Access"
    Then I should see "Your request has been received."
    And I should not see button "Request Access"
    And I should see button "Cancel Access"

    When I press "Cancel Access"
    Then I should see "Your request has been cancelled."
    And I should see button "Request Access"

  Scenario: check email
    Given I am logged in as "researcher@intersect.org.au"
    And I am on the "MQT 2" papyrus page
    When I press "Request Access"
    Then "admin@intersect.org.au" should receive an email with subject "Papyri Data Capture - Papyrus access request"

    Given I follow "Logout"
    And I am logged in as "admin@intersect.org.au"
    When I open the email
    And I click the first link in the email
    Then I should be on the papyrus access request page for "researcher@intersect.org.au" and papyrus "MQT 2"

  Scenario: general public should not see the request link
    Given I am on the "MQT 2" papyrus page
    Then I should not see "Request Access"
    And I should not see "Cancel Access"


#put in spec
#Scenario: researchers should not be able to cancel if the request has already been approved

#Scenario: researchers should not be able to cancel if the request has already been rejected

  @wip
  Scenario: as an administrator I should be able to request access that is granted automatically
  @wip
  Scenario: as a researcher with my request approved I shouldn't see the request or cancel buttons

