class Gear< ApplicationRecord
  belongs_to :head, :class_name => "RsItem", optional: true
  belongs_to :cape, :class_name => "RsItem", optional: true
  belongs_to :neck, :class_name => "RsItem", optional: true
  belongs_to :ammunition, :class_name => "RsItem", optional: true
  belongs_to :weapon, :class_name => "RsItem", optional: true
  belongs_to :shield, :class_name => "RsItem", optional: true
  belongs_to :legs, :class_name => "RsItem", optional: true
  belongs_to :hands, :class_name => "RsItem", optional: true
  belongs_to :feet, :class_name => "RsItem", optional: true
  belongs_to :ring, :class_name => "RsItem", optional: true
  belongs_to :chest, :class_name => "RsItem", optional: true
  has_many :tasks

  
  def get_formated_gear
    if head != nil then head1 = head.formated_name else head1 = "none" end
    if cape != nil then cape1 = cape.formated_name else cape1 = "none" end
    if neck != nil then neck1 = neck.formated_name else neck1 = "none" end
    if weapon != nil then weapon1 = weapon.formated_name else weapon1 = "none" end
    if chest != nil then chest1 = chest.formated_name else chest1 = "none" end
    if shield != nil then shield1 = shield.formated_name else shield1 = "none" end
    if legs != nil then legs1 = legs.formated_name else legs1 = "none" end
    if hands != nil then hands1 = hands.formated_name else hands1 = "none" end
    if feet != nil then feet1 = feet.formated_name else feet1 = "none" end
    if ring != nil then ring1 = ring.formated_name else ring1= "none" end
    if ammunition != nil then ammunition1 = ammunition.formated_name else ammunition1 = "none" end
    if ammunition_amount != nil then ammunition_amount1= ammunition_amount else ammunition_amount1="none" end
    return "Head:#{head1}\n
            Cape:#{cape1}\n
            Neck:#{neck1}\n
            Weapon:#{weapon1}\n
            Chest:#{chest1}\n
            Shield:#{shield1}\n
            Legs:#{legs1}\n
            Hands:#{hands1}\n
            Feet:#{feet1}\n
            Ring:#{ring1}\n
            Ammunition:#{ammunition1}\n
            Ammunition Amount:#{ammunition_amount1}"
  end
  
  
  def to_json
    if head != nil then json_head = head.to_json else json_head = "none" end
    if cape != nil then json_cape = cape.to_json else json_cape = "none" end
    if neck != nil then json_neck = neck.to_json else json_neck = "none" end
    if weapon != nil then json_weapon = weapon.to_json else json_weapon = "none" end
    if chest != nil then json_chest = chest.to_json else json_chest = "none" end
    if shield != nil then json_shield = shield.to_json else json_shield = "none" end
    if legs != nil then json_legs = legs.to_json else json_legs = "none" end
    if hands != nil then json_hands = hands.to_json else json_hands = "none" end
    if feet != nil then json_feet = feet.to_json else json_feet = "none" end
    if ring != nil then json_ring = ring.to_json else json_ring = "none" end
    if ammunition != nil then json_ammunition = ammunition.to_json else json_json_ammunition = "none" end
        if ammunition_amount != nil then json_ammunition_amount= ammunition_amount else json_ammunition_amount="none" end

      json_gear = {
          'head' => json_head,
          'cape' => json_cape,
          'neck' => json_neck,
          'weapon' => json_weapon,
          'chest' => json_chest,
          'shield' => json_shield,
          'legs' => json_legs,
          'hands' => json_hands,
          'feet' => json_feet,
          'ring' => json_ring,
          'ammunition' => json_ammunition,
          'ammunition_amount' => json_ammunition_amount
      }
      return json_gear
  end

end
