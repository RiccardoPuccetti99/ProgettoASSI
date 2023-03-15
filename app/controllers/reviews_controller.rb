class ReviewsController < ApplicationController
    def new
        id_guide = params[:guide_id]
        @guide = Guide.find(id_guide)
    end
    
    def create
        id_guide = params[:guide_id]
		@guide = Guide.find(id_guide)
		@user = current_user
        authorize! :create, Review, :message => "BEWARE: You are not authorized to create new reviews."
		if params[:review][:rating].present?
			@review = @guide.review.create!(params[:review].permit(:rating, :comment, :user))	
			@review.user_id = @user.id
			@review.save!
			flash[:notice] = "Your review has been successfully added to #{@guide.title}."
			redirect_to guide_path(@guide)
		else
			flash[:notice] = "One or more parameters are missing. Error" 
			render :new, status: :unprocessable_entity
		end		
    end 
    
    def destroy
		id = params[:id]
		id_guide = params[:guide_id]
		@guide = Guide.find(id_guide)
		@review = Review.find(id)
        authorize! :destroy, @review, :message => "BEWARE: You are not authorized to delete reviews."
		@review.destroy
		flash[:notice] = "Your review has been deleted."
		redirect_to guide_path(@guide)
	end
end