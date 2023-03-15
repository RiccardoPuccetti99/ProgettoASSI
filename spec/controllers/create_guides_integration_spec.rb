require 'rails_helper'

RSpec.describe GuidesController, type: :controller do
    include Devise::Test::ControllerHelpers
  
    describe "POST #create" do
      before do
        @user = FactoryBot.create(:user)
        sign_in @user
      end
  
      context "with valid parameters" do
        let(:valid_params) do
          {
            title: "My Guide",
            champ_name: "My Champion",
            champ_role: "My Role",
            champ_rune: "My Rune",
            skill_order: "My Skill Order",
            path_jungle: "My Path Jungle",
            item: "My Item",
            guida: "My Guide Description",
            counter: "My Counter",
            ideal: "My Ideal"
          }
        end
  
        it "creates a new guide" do
          expect {
            post :create, params: { guide: valid_params }
          }.to change(Guide, :count).by(1)
  
          expect(response).to redirect_to(guides_path)
        end
      end
  
      context "with invalid parameters" do
        let(:invalid_params) do
          {
            title: "",
            champ_name: "My Champion",
            champ_role: "My Role",
            champ_rune: "My Rune",
            skill_order: "My Skill Order",
            path_jungle: "My Path Jungle",
            item: "My Item",
            guida: "My Guide Description",
            counter: "My Counter",
            ideal: "My Ideal"
          }
        end
  
        it "does not create a new guide" do
          expect {
            post :create, params: { guide: invalid_params }
          }.not_to change(Guide, :count)
  
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end