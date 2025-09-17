## Skills are special modifiers or abilities
## A unit may have many skills; they help make every unit feel unique
extends Resource
class_name Skill

@export var name: String
@export var description: String
@export var icon: Texture2D

## The list of actions this skill grants
@export var action_templates: Array[ActionTemplate]

enum Rarity { COMMON, RARE, LEGENDARY, }
@export var rarity: Rarity

enum Tag { HUMANOID, DAMAGE, } # etc.
@export var tags: Array[Tag]

# The behaviour resource
@export var behavior: SkillBehavior
