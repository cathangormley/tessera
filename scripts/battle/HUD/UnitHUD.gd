extends Control
class_name UnitHUD

signal action_button_hovered(action: Action)
signal action_button_pressed(action: Action)

# UI elements
@onready var stats_vbox = %StatsVBox
@onready var inventory_vbox = %InventoryVBox
@onready var skills_vbox = %SkillsVBox

## Core Stats
@onready var vig_label = %StatsVBox/VIGLabel
@onready var str_label = %StatsVBox/STRLabel
@onready var dex_label = %StatsVBox/DEXLabel
@onready var agi_label = %StatsVBox/AGILabel
@onready var int_label = %StatsVBox/INTLabel
@onready var fai_label = %StatsVBox/FAILabel

## HP / SP
@onready var hp_label = %StatsVBox/HPLabel
@onready var sp_label = %StatsVBox/SPLabel

@onready var cooldown_label = %StatsVBox/CooldownLabel
@onready var hit_label = %StatsVBox/HitLabel
@onready var dodge_label = %StatsVBox/DodgeLabel

@onready var encumbrance_label = %StatsVBox/EncumbranceLabel

@onready var name_label = %StatsVBox/NameLabel
## Label for e.g. "Lvl. 5 Human Warrior"
@onready var desc_label = %StatsVBox/DescLabel


func highlight_unit_hud(unit: Unit) -> void:
	display_unit_stats(unit)
	display_unit_inventory(unit)
	display_unit_skills(unit)


func display_unit_stats(unit: Unit) -> void:
	for label: Label in stats_vbox.get_children():
		label.text = ""
	
	if unit == null: return
	
	name_label.text = unit.unit_name
	desc_label.text = "LV %d %s %s" % [unit.stats.job_level, unit.stats.race.name, unit.stats.job.name]
	
	hp_label.text = "HP: %d/%d" % [unit.stats.current_hp, unit.stats.max_hp]
	sp_label.text = "SP: %d/%d" % [unit.stats.current_sp, unit.stats.max_sp]
	
	vig_label.text = "VIG: %d" % unit.stats.vigor
	str_label.text = "STR: %d" % unit.stats.strength
	dex_label.text = "DEX: %d" % unit.stats.dexterity
	agi_label.text = "AGI: %d" % unit.stats.agility
	int_label.text = "INT: %d" % unit.stats.intellect
	fai_label.text = "FAI: %d" % unit.stats.faith
	
	cooldown_label.text = "Cooldown: %0.2f" % unit.stats.cooldown
	hit_label.text = "Hit: %+d%%" % unit.stats.hit
	dodge_label.text = "Dodge: %+d%%" % unit.stats.dodge
	encumbrance_label.text = "Carry: %d/%d (%s)" % [unit.stats.carry, unit.stats.carry_capacity, encumbrance_text[unit.stats.encumbrance]]


func display_unit_inventory(unit: Unit) -> void:
	for child in inventory_vbox.get_children():
		child.queue_free()
	
	if unit == null: return
	
	var header_label = Label.new()
	header_label.text = "Inventory:"
	inventory_vbox.add_child(header_label)
	
	for item in unit.inventory.items:
		var label = Label.new()
		label.text = item.item_name
		label.tooltip_text = item.description
		label.mouse_filter = Control.MOUSE_FILTER_STOP
		inventory_vbox.add_child(label)


func display_unit_skills(unit: Unit) -> void:
	for child in skills_vbox.get_children():
		child.queue_free()
	
	if unit == null: return
	
	var header_label = Label.new()
	header_label.text = "Skills:"
	skills_vbox.add_child(header_label)
	
	for skill in unit.stats.skills:
		var label = Label.new()
		label.text = skill.name
		label.tooltip_text = skill.description
		label.mouse_filter = Control.MOUSE_FILTER_STOP
		skills_vbox.add_child(label)


static var encumbrance_text: Dictionary[Stats.Encumbrance, String] = {
	Stats.Encumbrance.LIGHT: "Light",
	Stats.Encumbrance.MEDIUM: "Medium",
	Stats.Encumbrance.HEAVY: "Heavy",
} 
