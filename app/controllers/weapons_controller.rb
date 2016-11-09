class WeaponsController < ApplicationController
  def new_weapon
    actor_name = params[:user_name]
    weapon = Weapon.new
    weapon.new_weapon(params[:text])
    if weapon.save
      render json: { response_type: "in_channel",
                     text: weapon.new_weapon_message(actor_name)
                   }
    else
      render json: { response_type: "in_channel",
                     text: error_message(weapon)
                   }
    end
  end

  def weapons
    output = Weapon.all.map { |weap| "#{weap.name}" }
    render json: { response_type: "in_channel",
                   text: output.join("\n")
                 }
  end

  def weapon
    weapon_name = Weapon.new
    name_parse = weapon_name.find_weapon(params[:text])
    weapon = Weapon.find_by(name: name_parse)
    # wealpon = Weapon.find_by(name: "name")
    render json: { response_type: "in_channel",
                   text: weapon.weapon_message
                 }

  end

  def equip
  end

  private
  def error_message(obj)
    "#{obj.errors.first[0].capitalize} #{obj.errors.first[1]}."
  end
end
