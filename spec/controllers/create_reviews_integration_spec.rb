require 'rails_helper'

RSpec.describe ReviewsController, type: :controller do
    include Devise::Test::ControllerHelpers

    describe "POST #create" do
        before do
            @user1 = FactoryBot.create(:user)
            @user2 = FactoryBot.create(:user)
            sign_in @user2
            @guide = FactoryBot.create(:guide, user: @user1)
        end
    
    context "with valid parameters" do
        let(:valid_params) do
          {
            rating: 7,
            comment: "Good guide!"
          }
        end
  
        it "creates a new review" do
          expect {
            post :create, params: { guide_id: @guide.id, review: valid_params }
          }.to change(Review, :count).by(1)
  
          expect(response).to redirect_to guide_path(@guide)
        end
      end

      context "with invalid parameters" do
        let(:invalid_params) do
          {
            rating: nil,
            comment: "Good guide!"
          }
        end
  
        it "does not create a new review" do
            expect {
                post :create, params: { guide_id: @guide.id, review: invalid_params }
          }.not_to change(Review, :count)
  
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end  
    end      
end    