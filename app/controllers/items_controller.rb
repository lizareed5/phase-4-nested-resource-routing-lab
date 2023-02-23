class ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

  def index
    if params[:user_id]
      user = find_user
      items = user.items
    else
      items = Item.all
    end
    render json: items, include: :user, status: :ok
  end

  def show
    item = Item.find(params[:id])
    render json: item, include: :user, status: :ok
  end

  def create
    item = Item.create(item_params)
    render json: item, include: :user, status: :created
  end

  private

  def find_user
    User.find(params[:user_id])
  end

  def render_not_found_response
    render json: {error: "Item not found"}, status: :not_found
  end

  def item_params
    params.permit(:name, :description, :price, :user_id)
  end
end
