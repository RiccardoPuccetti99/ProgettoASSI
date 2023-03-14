require 'rails_helper'

RSpec.describe GuidesController, type: :controller do
  include Devise::Test::ControllerHelpers
  
  describe "DELETE #destroy" do
    before do
      @user = FactoryBot.create(:user)
      sign_in @user
      @guide = FactoryBot.create(:guide, user: @user)
    end

    it "deletes the guide" do
      expect {
        delete :destroy, params: { id: @guide.id }
      }.to change(Guide, :count).by(-1)
    end

    it "redirects to the guides index page" do
      delete :destroy, params: { id: @guide.id }
      expect(response).to redirect_to(guides_path)
    end
  end
end