Feature: In order to associate new images with papyri records
  As an Administrator
  I want to upload images to the papyri records

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
    And I have a papyrus
      | inventory_id | languages     | dimensions    | date  | general_note | note          | paleographic_description | recto_note | verso_note | country_of_origin | origin_details | source_of_acquisition | preservation_note | genre | language_note | summary             | original_text | translated_text | visibility |
      | p.macq1      | Coptic, Greek | 5 x 6 cm      |88 CE | General Blah | Specific blah | Paleo Diet               | Rectangle  | Verses     | Greece            | It's Greek.    | Got it from Greece    | poorly preserved  | Book  | Fancy Greek   | don't understand it | περιοχής      | area            | PUBLIC     |
      | hidden       | Coptic, Greek | 5 x 6 cm      |88 CE | General Blah | Specific blah | Paleo Diet               | Rectangle  | Verses     | Greece            | It's Greek.    | Got it from Greece    | poorly preserved  | Book  | Fancy Greek   | don't understand it | περιοχής      | area            | HIDDEN     |
      | public       | Coptic, Greek | 5 x 6 cm      |88 CE | General Blah | Specific blah | Paleo Diet               | Rectangle  | Verses     | Greece            | It's Greek.    | Got it from Greece    | poorly preserved  | Book  | Fancy Greek   | don't understand it | περιοχής      | area            | PUBLIC     |
      | visible      | Coptic, Greek | 5 x 6 cm      |88 CE | General Blah | Specific blah | Paleo Diet               | Rectangle  | Verses     | Greece            | It's Greek.    | Got it from Greece    | poorly preserved  | Book  | Fancy Greek   | don't understand it | περιοχής      | area            | VISIBLE    |
    And "admin@intersect.org.au" uploaded image "test.tiff" to "hidden" with caption "hidden"
    And "admin@intersect.org.au" uploaded image "test2.tiff" to "public" with caption "public"
    And "admin@intersect.org.au" uploaded image "test.tiff" to "visible" with caption "visible"

  Scenario: Clicking cancel
    Given I am logged in as "admin@intersect.org.au"
    And I am on the upload image page for "p.macq1"
    When I follow "Cancel"
    Then I should be on the "p.macq1" papyrus page

  Scenario: Add image without caption
    Given I am logged in as "admin@intersect.org.au"
    And I am on the upload image page for "p.macq1"
    When I attach image "test.tiff"
    And I press "Upload"
    Then I should not see "Your image was successfully uploaded."
    And I should see "Caption can't be blank"

  Scenario: Add image without image
    Given I am logged in as "admin@intersect.org.au"
    And I am on the upload image page for "p.macq1"
    When I fill in "Caption" with "some caption"
    And I press "Upload"
    Then I should not see "Your image was successfully uploaded."
    And I should see "Image can't be blank"

  Scenario: Uploading an image
    Given I am logged in as "admin@intersect.org.au"
    When I am on the "p.macq1" papyrus page
    Then I should see "Upload"
    When I follow "Upload"
    Then I should be on the upload image page for "p.macq1"
    When I attach image "test.tiff"
    And I fill in "Caption" with "This is my fancy picture"
    And I press "Upload"
    Then I should be on the "p.macq1" papyrus page
    Then I should see "Your image was successfully uploaded."
    And "p.macq1" should have 1 image
    And I should see low res image for "test.tiff" of papyrus "p.macq1"
    When I am on the papyrus "p.macq1" image "test.tiff" "low_res" page
    Then I should not see "You are not authorized to access this page."
    When I am on the "p.macq1" papyrus page
    Then I should see "Download in high resolution" for "test.tiff" for "p.macq1"
    And I should see "This is my fancy picture"
    When I follow "Download in high resolution" for "test.tiff" for "p.macq1"
    Then I should not see "You are not authorized to access this page."

  Scenario: researcher can't upload
    Given I am logged in as "researcher@intersect.org.au"
    When I am on the "visible" papyrus page
    Then I should not see "Upload"
    When I am on the upload image page for "visible"
    Then I should be on the home page
    And I should see "You are not authorized to access this page."

  Scenario: anonymous user can't upload
    When I am on the "visible" papyrus page
    Then I should not see "Upload"
    When I am on the upload image page for "visible"
    Then I should be on the home page
    And I should see "You are not authorized to access this page."

  Scenario Outline: Anonymous can't download high res image of HIDDEN or VISIBLE
    When I am on the "<inventory_id>" papyrus page
    Then I should not see "Download in high resolution" for "<filename>" for "<inventory_id>"
    When I am on the papyrus "<inventory_id>" image "<filename>" "original" page
    Then I should see "You are not authorized to access this page."
  Examples:
    | inventory_id | filename  |
    | hidden       | test.tiff |
    | visible      | test.tiff |

  Scenario Outline: researcher can't download high res image of HIDDEN or VISIBLE
    Given I am logged in as "researcher@intersect.org.au"
    When I am on the "<inventory_id>" papyrus page
    Then I should not see "Download in high resolution" for "<filename>" for "<inventory_id>"
    When I am on the papyrus "<inventory_id>" image "<filename>" "original" page
    Then I should see "You are not authorized to access this page."
  Examples:
    | inventory_id | filename  |
    | hidden       | test.tiff |
    | visible      | test.tiff |

  Scenario: Anonymous can download high res image of PUBLIC
    Given I am on the "public" papyrus page
    Then I should see "Download in high resolution" for "test2.tiff" for "public"
    When I follow "Download in high resolution" for "test2.tiff" for "public"
    Then I should not see "You are not authorized to access this page."

  Scenario: Researcher can download high res image of PUBLIC
    Given I am logged in as "researcher@intersect.org.au"
    When I am on the "public" papyrus page
    Then I should see "Download in high resolution" for "test2.tiff" for "public"
    When I follow "Download in high resolution" for "test2.tiff" for "public"
    Then I should not see "You are not authorized to access this page."

  Scenario Outline: Anonymous users can download public & visible low res images
    Given I am on the "<visibility>" papyrus page
    Then I should see "Download in low resolution" for "<image>" for "<visibility>"
    When I follow "Download in low resolution" for "<image>" for "<visibility>"
    Then I should not see "You are not authorized to access this page."
  Examples:
    | visibility | image      |
    | public     | test2.tiff |
    | visible    | test.tiff  |

  Scenario: Anonymous users can't download low res images for hidden papyrus records
    Given I am on the "hidden" papyrus page
    Then I should see "You are not authorized to access this page."

  Scenario Outline: researchers & admin users can download all low res images
    Given I am logged in as "<username>@intersect.org.au"
    Given I am on the "<visibility>" papyrus page
    Then I should see "Download in low resolution" for "<image>" for "<visibility>"
    When I follow "Download in low resolution" for "<image>" for "<visibility>"
    Then I should not see "You are not authorized to access this page."
  Examples:
    | username   | visibility | image      |
    | admin      | public     | test2.tiff |
    | admin      | visible    | test.tiff  |
    | admin      | hidden     | test.tiff  |
    | researcher | public     | test2.tiff |
    | researcher | visible    | test.tiff  |
    | researcher | hidden     | test.tiff  |


