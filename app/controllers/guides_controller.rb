class GuidesController < ApplicationController

    def index
        @guides = Guide.all      
    end    

    def show
        id = params[:id]
		@guide = Guide.find(id)
        authorize! :show, @guide, :message => "BEWARE: You are not authorized to create new guides."
    end 

    def new
        authorize! :create, Guide, :message => "BEWARE: You are not authorized to create new guides."
		@guide = Guide.new
    end 

    def create
        authorize! :create, Guide, :message => "BEWARE: You are not authorized to create new guides."
        user_id = current_user.id
        @user = User.find(user_id)
		@guide = @user.guide.create(params[:guide].permit(:title, :champ_name, :champ_role, :champ_rune, :skill_order, :path_jungle, :item, :guida, :counter, :ideal))
			if @guide.save
			flash[:notice] = "#{@guide.title} was successfully created."
			redirect_to guides_path
		else 
			#flash[:danger] = @guide.errors.full_messages
			#redirect_back(fallback_location: new_guide_path)
			render template: 'guides/new'
		end	
		
	end

    def edit
        id = params[:id]
		@guide = Guide.find(id)
		authorize! :update, @guide, :message => "BEWARE: You are not authorized to edit new guides."       
    end  

	def update
		id = params[:id]
		@guide = Guide.find(id)
		authorize! :update, @guide, :message => "BEWARE: You are not authorized to update a movies."
		@guide.update(params[:guide].permit(:title, :champ_name, :champ_role, :champ_rune, :skill_order, :path_jungle, :item, :guida, :counter, :ideal))
        if @guide.save
			flash[:notice] = "#{@guide.title} was successfully updated."
			redirect_to guide_path(@guide)
		else 
			#flash[:danger] = @guide.errors.full_messages
			#redirect_back(fallback_location: new_guide_path)
			render template: 'guides/new'
		end
		
	end
	
	def destroy
		id = params[:id]
		@guide = Guide.find(id)
		authorize! :destroy, @guide, :message => "BEWARE: You are not authorized to delete movies."
		@guide.destroy
		flash[:notice] = "#{@guide.title} has been deleted."
		redirect_to guides_path
	end    
     
end