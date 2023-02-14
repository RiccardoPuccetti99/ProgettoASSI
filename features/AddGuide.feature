Feature: User can add manually a guide

Background: 
  Given I am logged in as "test@case.com" with password "ciaociao123"
Scenario: Add a guide
  Given I am on the RPP home page
  When I follow "Guides"
  Then I should be on the Index Guides Page
  When I follow "Add new guide"
  Then I should be on the Create New Guide Page
  When I fill in "Title" with "Aatrox toplane"
  And I fill "Champion name" with "Aatrox"
  And I fill "Guida" with "Play aggressive"
  And I press "Save Changes"
  Then I should be on the RPP home page
  And I should see "Aatrox toplane"