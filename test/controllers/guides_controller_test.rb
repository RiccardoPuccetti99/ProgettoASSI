require "test_helper"

class GuidesControllerTest < ActionDispatch::IntegrationTest
  test "should get lolguides" do
    get guides_lolguides_url
    assert_response :success
  end
end
