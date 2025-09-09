extends Unit
class_name AIUnit

var ai: AI

func add_unit_data(_unit_name: String, _ai: AI) -> void:
	super.new_unit(_unit_name)
	is_player_controlled = false
	faction = Unit.Faction.ENEMY
	color = Color("Red")
	ai = _ai


func take_turn(grid: Array) -> void:
	var time0 = Time.get_ticks_msec()
	var coa = ai.choose_course_of_action(grid)
	var time1 = Time.get_ticks_msec()
	print(unit_name + " thought for " + str(time1 - time0) + " ms")
	move_and_execute(coa.move, coa.action, coa.target_area)
