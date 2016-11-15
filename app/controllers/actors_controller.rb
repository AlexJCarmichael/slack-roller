class ActorsController < ApplicationController
  def register
    actor = Actor.new(name: actor_params[:user_name])
    if actor.save
      output = "Registered #{actor.name} as a player."
    else
      output = "#{actor.name} already exists as a player."
    end
    render json: {
      response_type: "in_channel",
      text: output
    }
  end

  def register_character
    response = "You are not registered. To register, type `/register`."
    if actor = Actor.find_by(name: actor_params[:user_name])
      response = "#{actor_params[:text]} is not a character for #{actor.name}."
      char = Actor.find_char(actor_params[:text])
      if character = actor.characters.find_by(name: char)
        actor.actor_character.destroy if actor.actor_character
        ActorCharacter.create(actor: actor, character: character)
        response = "#{actor.name} is now using #{character.name}."
      end
    end
    render json: {
      response_type: "in_channel",
      text: response
    }
  end

  def roster
    response = Actor.all.map { |actor| "#{actor.name}" }
    render json: {
      response_type: "in_channel",
      text: response.join("\n")
    }
  end

  private

  def actor_params
    params.permit(:text, :user_name)
  end
end
