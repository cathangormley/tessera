## Represents a template for a skill
extends Resource
class_name SkillTemplate

@export var name: String
@export var description: String
@export var icon: Texture2D

## The list of actions this skill grants
@export var action_templates: Array[ActionTemplate]

enum Rarity { COMMON, RARE, LEGENDARY, }
@export var rarity: Rarity

# TODO! Move this into SkillDB?
enum Tag { HUMANOID, DAMAGE, } # etc.
@export var tags: Array[Tag]

# The behaviour resource
@export var behavior: SkillBehavior


func to_skill() -> Skill:
	return Skill.new().use_skill_template(self)
