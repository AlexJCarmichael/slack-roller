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
    actor =  Actor.find_by(name: actor_params[:user_name])
    character = actor.characters.find_by(name: actor_params[:text])
    if character
      actor.actor_character.destroy if actor.actor_character
      ActorCharacter.create(actor: actor, character: character)
      render json: {
        response_type: "in_channel",
        text: "#{actor.name} is now using #{character.name}"
      }
    else
      render json: {
        response_type: "in_channel",
        text: "#{actor_params[:text]} is not a character for #{actor.name}."
      }
    end
  end

  private

  def actor_params
    params.permit(:text, :user_name)
  end
end
