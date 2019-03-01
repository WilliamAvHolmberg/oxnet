require 'socket'
require 'active_record'
require 'httparty'
require 'nokogiri'
require 'acts_as_list'
require 'json'
require 'open-uri'
require_relative 'generate_items'
require_relative 'generate_worlds'
#require_relative 'generate_slots'






#generate account types
AccountType.create(name: "SLAVE").save
AccountType.create(name: "MULE").save

#TaskTypes
TaskType.create(name: "MULE_DEPOSIT").save
TaskType.create(name: "MULE_WITHDRAW").save
TaskType.create(name: "MULE_DEPOSIT").save
TaskType.create(name: "WOODCUTTING").save
TaskType.create(name: "COMBAT").save
TaskType.create(name: "AGILITY").save
TaskType.create(name: "QUEST").save


#break condition
BreakCondition.create(name: "TIME").save
BreakCondition.create(name: "LEVEL").save
BreakCondition.create(name: "TIME_OR_LEVEL").save

#instructions
InstructionType.create(name: "NEW_CLIENT").save
InstructionType.create(name: "MULE_WITHDRAW").save
InstructionType.create(name: "CREATE_ACCOUNT").save

#gen items
#GenerateItems.new
#gen worlds
GenerateWorlds.new
#gen slots
#GenerateSlots.new