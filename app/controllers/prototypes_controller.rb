class PrototypesController < ApplicationController
  before_action :move_to_index, except: [:index, :show, :new, :create, :destroy, :update]
  before_action :authenticate_user!, except: [:index, :show]
 

def index
  @prototypes = Prototype.all
end

def new
  @prototype = Prototype.new
end

def create
  @prototype = Prototype.create(prototype_params)
  if @prototype.save
    redirect_to root_path
  else 
    render new_prototype_path
  end
end

def show
  @prototype = Prototype.find(params[:id])
  @comment = Comment.new
  @comments = @prototype.comments.includes(:user)
end

def edit
  @prototype = Prototype.find(params[:id])
end

def update
  @prototype = Prototype.find(params[:id])
  if @prototype.update(prototype_params)
    redirect_to prototype_path(@prototype)
  else
    render :edit, status: :unprocessable_entity
  end
end

def destroy
  prototype = Prototype.find(params[:id])
  prototype.destroy
  redirect_to root_path
end

private

def prototype_params
  params.require(:prototype).permit(:title, :image, :catch_copy, :concept).merge(user_id: current_user.id)
end

def move_to_index
  @prototype = Prototype.find(params[:id])
  unless user_signed_in? && current_user.id == @prototype.user_id
    redirect_to new_user_session_path
  end
end

end