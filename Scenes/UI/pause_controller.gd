extends Node


func _input(event: InputEvent) -> void:
	if(event.is_action_released("pause")):
		$"..".visible = !($"..".visible)
		get_tree().paused = !(get_tree().paused)
