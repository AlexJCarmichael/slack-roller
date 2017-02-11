class RollPoolController < ApplicationController
  def roll_pool
    body = roll_pool_params[:text]
    actor = find_actor
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
      find_roll_pool(actor).destroy
      roll_pool.save
    end
    render json: {
      response_type: "in_channel",
      text: roll_pool.pool
    }
  end

  def modify_roll_pool
    actor = find_actor
    roll_pool = find_roll_pool(actor)
    body = roll_pool_params[:text]
    if roll_pool.nil?
      return render json: {
        response_type: "in_channel",
        text: "No roll pool for actor"
      }
    end
    roll_pool.pool = roll_pool.modify(body)
    roll_pool.save
    render json: {
      response_type: "in_channel",
      text: roll_pool.pool
    }
  end

  def find_actor
    Actor.find_by(name: roll_pool_params[:user_name])
  end

  def find_roll_pool(actor)
    RollPool.find_by(actor: actor)
  end

  def body_nil_or_empty?(body)
    (body.nil? || !(body.present?)) ? true : false
  end

  def nil_or_empty_response(actor)
    if find_roll_pool(actor)
      find_roll_pool(actor).pool
    else
      "No Roll Pool for actor"
    end
  end

  private

  def roll_pool_params
   params.permit(:text, :user_name)
  end
end
