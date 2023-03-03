Feature: Users can check guides created by others

Background: 
  Given I have a guide with ID 1
Scenario: Add a guide
  Given I am on the RPP home page
  When I follow "Guides"
  Then I should be on the Index Guides Page
  When I follow "Details" for guide with ID 1
  Then I should be on the Show Guide Page
  And I should see "Aatrox toplane"