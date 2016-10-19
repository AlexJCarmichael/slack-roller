class CharactersController < ApplicationController
  def new_character
    actor = params[:user_name]
    message_text = params[:text]
    char = Character.new
    char.new_char(actor, message_text)
    if char.save
      char.roll_character(message_text)
      render json: { response_type: "in_channel",
                     text: char.new_char_message
                   }
    else
      render json: { response_type: "in_channel",
                     text: error_message(char)
                   }
    end
  end

  private
  def error_message(obj)
    "#{obj.errors.first[0].capitalize} #{obj.errors.first[1]}."
  end
end
