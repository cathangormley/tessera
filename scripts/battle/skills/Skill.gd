## Skills are special modifiers or abilities
## A unit may have many skills; they help make every unit feel unique
extends Node
class_name Skill

# The template that was used to generate this skill
var skill_template: SkillTemplate

var skill_name: String
var description: String
var icon: Texture2D

var actions: Array[Action]

var tags: Array[SkillTemplate.Tag]

var behavior: SkillBehavior

## Use input skill template to generate skill
func use_skill_template(_skill_template: SkillTemplate) -> Skill:
	skill_template = _skill_template
	
	skill_name = skill_template.name
	description = skill_template.description
	icon = skill_template.icon
	
	for action_template in skill_template.action_templates:
		actions.append(action_template.to_action())
	
	tags = skill_template.tags
	behavior = skill_template.behavior
	
	return self
