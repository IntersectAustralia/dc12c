Feature: In order to integrate with trismegistos
  As an anonymous user
  I want to download a CSV of papyri

  Background:
    Given I have languages
      | name     |
      | Greek    |
      | Coptic   |
    And I have genres
      | name   |
      | Letter |
      | Book   |

  Scenario: link exists
    When I am on the admin page
    And I follow "Trismegistos CSV"
    Then the downloaded csv should look like
      | Trismegistos nr | Publication | Inventory | Other inventory nrs | Material | Language/script | Provenance | Date         | Note |

  Scenario: basic
    Given I have a papyrus
      | mqt_number | visibility | trismegistos_id | publications | inventory_number | material | languages | origin_details | date_from | date_to | summary |
      | 3          | PUBLIC     | 123             | pubns        | p.macq3/4        | asdf     | Greek     | Greco          | 3 BCE     | 4 CE    | sumo    |
    When I am on the download trismegistos index page
    Then the downloaded csv should look like
      | Trismegistos nr | Publication | Inventory | Other inventory nrs | Material | Language/script | Provenance | Date         | Note |
      | 123             | pubns       | p.macq3/4 | MQT 3               | asdf     | Greek           | Greco      | 3 BCE - 4 CE | sumo |

  Scenario: check visibility
    Given I have papyri
      | mqt_number | visibility |
      | 3          | PUBLIC     |
      | 2          | HIDDEN     |
      | 1          | VISIBLE    |
    When I am on the download trismegistos index page
    Then the downloaded csv should look like
      | Trismegistos nr | Publication | Inventory | Other inventory nrs | Material | Language/script | Provenance | Date | Note |
      |                 |             |           | MQT 1               |          |                 |            |      |      |
      |                 |             |           | MQT 3               |          |                 |            |      |      |
