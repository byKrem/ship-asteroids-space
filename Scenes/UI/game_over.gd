extends Control

@onready var main_menu_screen := load("res://Scenes/UI/main_menu.tscn")
var time_played : int = 0

func _on_menu_button_button_up() -> void:
	get_tree().paused = false
	var node = main_menu_screen.instantiate()
	var tree = get_tree()
	var cur_scene = tree.get_current_scene()
	tree.get_root().add_child(node)
	tree.get_root().remove_child(cur_scene)
	tree.set_current_scene(node)

func _on_play_time_timeout() -> void:
	time_played += 1

func _on_visibility_changed() -> void:
	$VBoxContainer/HBoxContainer/Time.text = str(time_played) + " sec"
