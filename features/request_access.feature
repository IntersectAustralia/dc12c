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
    And I have countries
      | name   |
      | Greece |
      | Egypt  |
      | Cyprus |
      | Turkey |
    And I have papyri
      | inventory_id | languages       | width | height | date   | general_note  | note           | paleographic_description | recto_note | verso_note | country_of_origin | origin_details | source_of_acquisition | preservation_note | genre | language_note | summary             | original_text | translated_text | visibility |
      | v.macq2      | Coptic, Greek   | 30    | 77     | 88 CE  | General Blah  | Specific blah  | Paleo Diet               | Rectangle  | Verses     | Greece            | It's Greek.    | Got it from Greece    | poorly preserved  | Book  | Fancy Greek   | don't understand it | περιοχής      | area            | VISIBLE    |
      | hidden.macq  | Coptic, Demotic | 60    | 177    | 488 CE | General stuff | Specific stuff |                          |            |            | Turkey            |                |                       |                   |       |               |                     |               |                 | HIDDEN     |
      | visible.macq | Coptic, Demotic | 60    | 177    | 488 CE | General stuff | Specific stuff |                          |            |            | Turkey            |                |                       |                   |       |               |                     |               |                 | VISIBLE    |

  Scenario: researchers should have a request access button on view papyrus pages
    Given I am logged in as "researcher@intersect.org.au"
    And I am on the "v.macq2" papyrus page
    And I should see button "Request Access"
    And I should not see button "Cancel Access"
    When I press "Request Access"
    Then I should see "Your request has been received."
    And I should not see button "Request Access"
    And I should see button "Cancel Access"
    When I press "Cancel Access"
    Then I should see "Your request has been cancelled."
    And I should see button "Request Access"

  Scenario: general public should not see the request link
    Given I am on the "v.macq2" papyrus page
    Then I should not see "Request Access"
    And I should not see "Cancel Access"


#put in spec
#Scenario: researchers should not be able to cancel if the request has already been approved

#Scenario: researchers should not be able to cancel if the request has already been rejected

  @wip
  Scenario: as an administrator I should be able to request access that is granted automatically
  @wip
  Scenario: as a researcher with my request approved I shouldn't see the request or cancel buttons
