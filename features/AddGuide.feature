Feature: Authenticated user can manually add a guide

Background: 
  Given I am authenticated
Scenario: Add a guide
  Given I am on the RPP home page
  When I follow "Guides"
  Then I should be on the Index Guides Page
  When I follow "Add new guide"
  Then I should be on the Create New Guide Page
  When I fill in "Title" with "Aatrox toplane"
  And I fill in "Champion name" with "Aatrox"
  And I fill in "Guide" with "Play aggressive"
  And I press "Save Changes"
  Then I should be on the Index Guides Page
  And I should see "Aatrox toplane"

  