class ActorsController < ApplicationController
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

  def register_character
    response = "You are not registered. To register, type `/register`"
    if actor = Actor.find_by(name: actor_params[:user_name])
      response = "#{actor_params[:text]} is not a character for #{actor.name}."
      if character = actor.characters.find_by(name: actor_params[:text])
        actor.actor_character.destroy if actor.actor_character
        ActorCharacter.create(actor: actor, character: character)
        response = "#{actor.name} is now using #{character.name}"
      end
    end
    render json: {
      response_type: "in_channel",
      text: response
    }
  end

  private

  def actor_params
    params.permit(:text, :user_name)
  end
end
