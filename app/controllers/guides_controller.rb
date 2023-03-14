class GuidesController < ApplicationController
	require 'google/apis/docs_v1'
	require 'google/apis/drive_v3'


    def index
        #@guides = Guide.all.order('created_at DESC')
		@guides = Guide.order(params[:sort])      
    end    

    def show
        id = params[:id]
		@guide = Guide.find(id)
        authorize! :show, @guide, :message => "BEWARE: You are not authorized to create new guides."
		render 'show'
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
			if (@guide.title.present? && @guide.champ_name.present? && @guide.guida.present?) && @guide.save
			flash[:notice] = "#{@guide.title} was successfully created."
			redirect_to guides_path
		else 
			render :new, status: :unprocessable_entity
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
        if (@guide.title.present? && @guide.champ_name.present? && @guide.guida.present?) && @guide.save
			flash[:notice] = "#{@guide.title} was successfully updated."
			redirect_to guide_path(@guide)
		else 
			render :edit, status: :unprocessable_entity
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
	
	def addToDocs
		@guide = Guide.find(params[:guide_id])

		client = Signet::OAuth2::Client.new(access_token: current_user.token)
		drive_service = Google::Apis::DriveV3::DriveService.new
		drive_service.authorization = client
	  
		doc = Google::Apis::DriveV3::File.new(name: @guide.title, mime_type: 'application/vnd.google-apps.document')
		doc = drive_service.create_file(doc, fields: 'id')
	  
		doc_id = doc.id
	  
		docs_service = Google::Apis::DocsV1::DocsService.new
		docs_service.authorization = client
	  
		# Insert the data from @guide
		requests = [
		  {
			insert_text: {
			  text: "\t\t\t\t\t#{@guide.title}\n\nDetails\n\nChampion: #{@guide.champ_name}\nRole: #{@guide.champ_role}\nCreation date: #{@guide.created_at}\nCreator: #{@guide.user.uid}\n\n\nDescription:\n\n#{@guide.guida}\n\n\nBuilding details\n\nRunes: #{@guide.champ_rune}\nSkill order: #{@guide.skill_order}\nList of items: #{@guide.item}\n\n\nMatchups\n\nIdeal: #{@guide.ideal}\nCounter: #{@guide.counter}",
			  end_of_segment_location: {}
			}
		  }
		]
		batch_update_request = Google::Apis::DocsV1::BatchUpdateDocumentRequest.new(requests: requests)
		docs_service.batch_update_document(doc_id, batch_update_request) 
        flash[:notice] = "<p>Your document has been created. Check it out here:</p><a href='https://docs.google.com/document' target='_blank'>#{@guide.title}</a>".html_safe
		redirect_to @guide
	  end
     
end