require 'rails_helper'

RSpec.describe GuidesController, type: :controller do
    include Devise::Test::ControllerHelpers
    describe "GET #new" do
      before do
        @user = FactoryBot.create(:user)
        sign_in @user
      end
  
      it "assigns a new guide to @guide" do
        guide = Guide.new
        allow(Guide).to receive(:new).and_return(guide)
  
        get :new
  
        expect(assigns(:guide)).to eq(guide)
      end
    end
  end