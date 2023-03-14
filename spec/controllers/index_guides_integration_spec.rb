require 'rails_helper'

RSpec.describe GuidesController, type: :controller do
  describe "GET #index" do
    it "returns a successful response" do
      get :index
      expect(response).to be_successful
    end
    
    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
    
    it "assigns @guides" do
      guide1 = FactoryBot.create(:guide)
      guide2 = FactoryBot.create(:guide)
      get :index
      expect(assigns(:guides)).to match_array([guide1, guide2])
    end
  end
end