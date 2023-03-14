require 'rails_helper'

RSpec.describe GuidesController, type: :controller do
  include Devise::Test::ControllerHelpers
  
  describe "PUT #update" do
    before do
      @user = FactoryBot.create(:user)
      sign_in @user
      @guide = FactoryBot.create(:guide, user: @user)
    end

    context "with valid parameters" do
      it "updates the guide" do
        put :update, params: { id: @guide.id, guide: { title: "New Title" } }
        @guide.reload
        expect(@guide.title).to eq("New Title")
      end
    end

    context "with invalid parameters" do
      it "does not update the guide" do
        put :update, params: { id: @guide.id, guide: { title: "" } }
        @guide.reload
        #mettiamo not_to eq("") perchè significa che non ha effettuato correttamente l'update e ritorna il parametro precedente all'update
        expect(@guide.title).not_to eq("")
      end
    end
  end
end