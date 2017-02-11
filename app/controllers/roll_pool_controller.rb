class RollPoolController < ApplicationController
  def roll_pool
    body = roll_pool_params[:text].downcase
    message = Message.new(body: body, user_name: roll_pool_params[:user_name])
    message.roll_dice
    pool = message.rough_rolls.join(", ")
    actor = Actor.find_by(name: roll_pool_params[:user_name])
    roll_pool = RollPool.new(actor: actor, pool: pool)
    render json: {
      response_type: "in_channel",
      text: roll_pool.pool
    }
  end

  private

  def roll_pool_params
   params.permit(:text, :user_name)
  end
end
