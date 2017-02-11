class RollPool < ApplicationRecord
  belongs_to :actor
  validates :actor, uniqueness: true

  def modify(body)
    new_die = determine_new_die(body)
    if body.include?("add")
      arr_pool = pool_to_array
      pool = arr_pool + new_die
      pool.join(", ")
    elsif body.include?("subtract")
      arr_pool = pool_to_array
      pool = remove_die(new_die, arr_pool)
      pool.join(", ")
    else
      self.pool
    end
  end

  def determine_new_die(body)
    body.split("").map {|x| x[/\d+/]}.compact
  end

  def pool_to_array
    self.pool.split(", ")
  end

  def remove_die(new_die, arr_pool)
    valid_die = validate_die_in_pool(new_die, arr_pool).compact
    valid_die.each do |str|
      arr_pool.slice!(arr_pool.index(str))
    end
    arr_pool
  end

  def validate_die_in_pool(new_die, arr_pool)
    new_die.map do |die|
      if arr_pool.include?(die)
        die
      else
        nil
      end
    end
  end
end
