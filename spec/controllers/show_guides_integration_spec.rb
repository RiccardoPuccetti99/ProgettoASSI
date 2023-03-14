RSpec.describe GuidesController, type: :controller do
    include Devise::Test::ControllerHelpers
    
    describe "GET #show" do
      before do
        @user = FactoryBot.create(:user)
        @guide = FactoryBot.create(:guide, user: @user)
      end
      
      context "when the guide exists" do
        it "assigns the requested guide to @guide" do
          get :show, params: { id: @guide.id }
          expect(assigns(:guide)).to eq(@guide)
        end
        
        it "renders the :show template" do
          get :show, params: { id: @guide.id }
          expect(response).to render_template(:show)
        end
      end
      
      context "when the guide does not exist" do
        it "raises an ActiveRecord::RecordNotFound error" do
          expect { get :show, params: { id: 999 } }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end