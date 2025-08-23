extends Control

@onready var main_menu_screen := load("res://Scenes/UI/main_menu.tscn")


func _on_resume_button_up() -> void:
	self.visible = false
	get_tree().paused = false


func _on_options_button_up() -> void:
	pass # Replace with function body.


func _on_menu_button_up() -> void:
	get_tree().paused = false
	var node = main_menu_screen.instantiate()
	var tree = get_tree()
	var cur_scene = tree.get_current_scene()
	tree.get_root().add_child(node)
	tree.get_root().remove_child(cur_scene)
	tree.set_current_scene(node)
