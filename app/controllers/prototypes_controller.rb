class PrototypesController < ApplicationController
  before_action :move_to_index, except: [:index, :show]
  before_action :authenticate_user!, only: [:edit, :new, :create]
 

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
  if user_signed_in?
    redirect_to action: :index
  end
end

end