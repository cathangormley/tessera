extends Node

var skills: Array[SkillTemplate] = []


func _ready() -> void:
	load_skills("res://scripts/battle/skills/skills/")
	print("SkillDB ready")


func load_skills(path: String) -> void:
	skills.clear()

	var dir := DirAccess.open(path)
	if dir == null:
		push_error("SkillDB: Could not open directory: " + path)
		return

	dir.list_dir_begin()
	var filename = dir.get_next()
	while filename != "":
		if not dir.current_is_dir():
			skills.append(load(path + filename))
		filename = dir.get_next()
	dir.list_dir_end()

	print("SkillDB loaded " + str(skills.size()) + " skills")


func get_skills_with_tag(tag: SkillTemplate.Tag) -> Array[SkillTemplate]:
	var skills_with_tag: Array[SkillTemplate]
	for skill in skills:
		if tag in skill.tags: skills_with_tag.append(skill)
	return skills_with_tag


func get_skills_with_tags(tags: Array[SkillTemplate.Tag]) -> Array[SkillTemplate]:
	var skills_with_tags = skills
	for tag in tags:
		skills_with_tags = get_skills_with_tag(skills_with_tags)
	return skills_with_tags


func get_random_skills_with_tags(tags: Array[SkillTemplate.Tag], count: int) -> Array[SkillTemplate]:
	var skills_with_tags := get_skills_with_tags(tags)
	skills_with_tags.shuffle()
	return skills_with_tags.slice(0, count)
