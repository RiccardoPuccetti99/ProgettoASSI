require "test_helper"

class LolGuidesControllerTest < ActionDispatch::IntegrationTest
  test "should get lolguides" do
    get lol_guides_lolguides_url
    assert_response :success
  end
end
