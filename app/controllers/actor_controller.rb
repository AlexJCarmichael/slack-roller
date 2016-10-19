class ActorController < ApplicationController
  def register
    actor = Actor.new(name: actor_params[:user_name])
    if actor.save
      render json: {
        response_type: "in_channel",
        text: "Registered #{actor.name} as a player."
      }
    else
      render json: {
        response_type: "in_channel",
        text: "#{actor.name} already exists as a player."
      }
    end
  end

  def actor_params
    params.permit(:text, :user_name)
  end
end
