class ApplicationController < ActionController::API
  def help_message
    """The following options are...
      /roll
      /register
      /new_char <input character name, stats, and modifiers>
      /edit_char <input character name, stats, or modifiers>
      /register_character <character_name>
      /character <character_name>
      /characters <user_name>
      /roster
      /character_roster\n
      /new_weapon
      /edit_weapon
      /weapons
      /weapon
      /equip <weapon>"""
  end
end
