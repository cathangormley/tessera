extends Node

func get_timestamp() -> String:
	var unix_time: float = Time.get_unix_time_from_system()
	var ms = str(unix_time - floor(unix_time)).substr(1, 6)
	return Time.get_datetime_string_from_unix_time(int(unix_time)) + ms

func print_timestamp() -> void:
	print(get_timestamp())
