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

end
