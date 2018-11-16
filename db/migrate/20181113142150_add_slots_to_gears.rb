class AddSlotsToGears < ActiveRecord::Migration[5.2]
  def change
    add_reference :gears, :head, :class => "RSItem"
    add_reference :gears, :cape, :class => "RSItem"
    add_reference :gears, :neck, :class => "RSItem"
    add_reference :gears, :ammunition, :class => "RSItem"
    add_reference :gears, :weapon, :class => "RSItem"
    add_reference :gears, :shield, :class => "RSItem"
    add_reference :gears, :legs, :class => "RSItem"
    add_reference :gears, :hands, :class => "RSItem"
    add_reference :gears, :feet, :class => "RSItem"
    add_reference :gears, :ring, :class => "RSItem"
  end
end
