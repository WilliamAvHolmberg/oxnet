class Gear < ApplicationRecord
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


end
