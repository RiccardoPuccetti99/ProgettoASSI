Feature: Authenticated user can add a comment to a guide

Background:
  Given I am authenticated
  And I have a guide with ID 1
Scenario: Add a comment
  Given I am on the RPP home page
  When I follow "Guides"
  Then I should be on the Index Guides Page
  When I follow "Details" for guide with ID 1
  Then I should be on the Show Guide Page
  And I should see "Aatrox toplane"
  When I follow "Add review" for guide with ID 1
  Then I should be on the Add New Comment Page
  When I fill in "Comment" with "Good guide"
  And I select "8" from "Rating"
  And I press "Add review"
  Then I should be on the Show Guide Page
  And I should see "Good guide"
