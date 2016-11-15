class WeaponsController < ApplicationController
  def new_weapon
    actor_name = params[:user_name]
    message = params[:text]
    weapon = Weapon.new
    weapon.random_weapon(message) if message.blank?
    begin
      weapon.new_weapon(message) if message.present?
      if weapon.save
        output = weapon.new_weapon_message(actor_name)
      else
        output = error_message(weapon)
      end
    rescue
      output = "Invalid Input. Type `/new_weapon name: <weapon_name>, quality: <quality>`"
    end
    render json: { response_type: "in_channel",
                   text: output
                 }
  end

  def edit_weapon
    actor_name = params[:user_name]
    if weapon = find_weapon
      weapon.edit_weapon(params[:text])
      weapon.save
      output = weapon.edit_weapon_message(actor_name)
    else
      output = "This weapon does not exist yet. Try creating it with `/new_weapon name: <weapon_name>`"
    end
    render json: { response_type: "in_channel",
                   text: output
                 }
  end

  def weapons
    output = Weapon.all.map { |weap| "#{weap.name}" }
    render json: { response_type: "in_channel",
                   text: output.join("\n")
                 }
  end

  def weapon
    if weapon = find_weapon
      output = weapon.weapon_message
    else
      output = "This weapon does not exist yet. Try creating it with `/new_weapon name: <weapon_name>`"
    end
    render json: { response_type: "in_channel",
                   text: output
                 }
  end

  private
  def find_weapon
    name_parse = Weapon.new.weapon_name(params[:text])
    weapon = Weapon.find_by(name: name_parse)
    weapon
  end

  def error_message(obj)
    "#{obj.errors.first[0].capitalize} #{obj.errors.first[1]}."
  end
end
