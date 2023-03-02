Feature: Users can check guides created by others

Background: 
  Given I have a guide
Scenario: Add a guide
  Given I am on the RPP home page
  When I follow "Guides"
  Then I should be on the Index Guides Page
  When I follow "Details"
  Then I should be on the Show Guide Page
  And I should see "Aatrox toplane"