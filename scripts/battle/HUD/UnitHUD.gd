extends Control
class_name UnitHUD

signal action_button_hovered(action: Action)
signal action_button_pressed(action: Action)

# UI elements
@onready var stats_vbox = %StatsVBox
@onready var inventory_vbox = %InventoryVBox
@onready var skills_vbox = %SkillsVBox

## Core Attributes
@onready var vig_label: Label = %VIGLabel
@onready var str_label: Label = %STRLabel
@onready var dex_label: Label = %DEXLabel
@onready var agi_label: Label = %AGILabel
@onready var int_label: Label = %INTLabel
@onready var fai_label: Label = %FAILabel

@onready var attribute_labels: Array[Label] = [vig_label, str_label, dex_label, agi_label, int_label, fai_label]

## HP / SP
@onready var hp_label = %StatsVBox/HPLabel
@onready var sp_label = %StatsVBox/SPLabel

@onready var cooldown_label = %StatsVBox/CooldownLabel
@onready var hit_label = %StatsVBox/HitLabel
@onready var dodge_label = %StatsVBox/DodgeLabel

@onready var encumbrance_label = %StatsVBox/EncumbranceLabel

@onready var physical_defense_label = %PhysicalDefenseLabel
@onready var elemental_defense_label = %ElementalDefenseLabel

@onready var name_label = %StatsVBox/NameLabel
## Label for e.g. "Lvl. 5 Human Warrior"
@onready var desc_label = %StatsVBox/DescLabel


func highlight_unit_hud(unit: Unit) -> void:
	display_unit_stats(unit)
	display_unit_attributes(unit)
	display_unit_inventory(unit)
	display_unit_skills(unit)


## Configure text, tooltip, etc. of label
func configure_label(label: Label, text_format: String, stat: StatCalculation) -> void:
	label.text = text_format % stat.result
	label.tooltip_text = stat.get_calculation()


func display_unit_stats(unit: Unit) -> void:
	for label in stats_vbox.get_children():
		if label is Label:
			label.text = ""
	
	if unit == null: return
	
	name_label.text = unit.unit_name
	desc_label.text = "LV %d %s %s" % [unit.stats.job_level, unit.stats.race.name, unit.stats.job.name]
	
	hp_label.text = "HP: %d/%d" % [unit.stats.current_hp, unit.stats.max_hp.result]
	hp_label.tooltip_text = unit.stats.max_hp.get_calculation()
	
	sp_label.text = "SP: %d/%d" % [unit.stats.current_sp, unit.stats.max_sp.result]
	sp_label.tooltip_text = unit.stats.max_sp.get_calculation()

	cooldown_label.text = "Speed: %d (%0.2f)" % [unit.stats.speed.result, unit.stats.cooldown]
	cooldown_label.tooltip_text = unit.stats.speed.get_calculation()

	configure_label(hit_label, "Hit: %+d%%", unit.stats.hit)
	configure_label(dodge_label, "Dodge: %+d%%", unit.stats.dodge)
	
	encumbrance_label.text = "Carry: %d/%d (%s)" % [unit.stats.carry,
			unit.stats.carry_capacity.result, encumbrance_text[unit.stats.encumbrance]]
	encumbrance_label.tooltip_text = unit.stats.carry_capacity.get_calculation()
	
	configure_label(physical_defense_label, "Phys. Def.: %d", unit.stats.physical_defense)
	configure_label(elemental_defense_label, "Elem. Def.: %d", unit.stats.elemental_defense)


func display_unit_attributes(unit: Unit) -> void:
	for label in attribute_labels:
		label.text = ""
	
	if unit == null: return
	
	configure_label(vig_label, "VIG: %d", unit.stats.vigor)
	configure_label(str_label, "STR: %d", unit.stats.strength)
	configure_label(dex_label, "DEX: %d", unit.stats.dexterity)
	configure_label(agi_label, "AGI: %d", unit.stats.agility)
	configure_label(int_label, "INT: %d", unit.stats.intellect)
	configure_label(fai_label, "FAI: %d", unit.stats.faith)


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
