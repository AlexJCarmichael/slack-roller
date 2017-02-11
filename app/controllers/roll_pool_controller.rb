class RollPoolController < ApplicationController
  def roll_pool
    body = roll_pool_params[:text]
    actor = Actor.find_by(name: roll_pool_params[:user_name])
    if body_nil_or_empty?(body)
      text = nil_or_empty_response(actor)
      return render json: {
        response_type: "in_channel",
        text: text
      }
    end
    message = Message.new(body: body.downcase, user_name: roll_pool_params[:user_name])
    message.roll_dice
    pool = message.rough_rolls.join(", ")
    roll_pool = RollPool.new(actor: actor, pool: pool)

    if roll_pool.save == false
      RollPool.find_by(actor: actor).destroy
      roll_pool.save
    end
    render json: {
      response_type: "in_channel",
      text: roll_pool.pool
    }
  end

  def body_nil_or_empty?(body)
    (body.nil? || body.present?) ? true : false
  end

  def nil_or_empty_response(actor)
    if RollPool.find_by(actor: actor)
      RollPool.find_by(actor: actor).pool
    else
      "No Roll Pool for actor"
    end
  end

  private

  def roll_pool_params
   params.permit(:text, :user_name)
  end
end
