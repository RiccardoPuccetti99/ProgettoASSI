Feature: Users can review League of Legends matches

Scenario: Check League of Legends matches
  Given I am on the RPP home page
  When I click "Player review"
  Then I should be on the Lol Review Page
  When I select "EUW1" from "region"
  And I fill in "summoner" with "BetweenTheMoon"
  And I press "Search"
  Then I should see the content in the League container
  