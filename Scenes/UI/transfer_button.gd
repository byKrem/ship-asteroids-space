extends Button

@export var movable_obj : Control
@export var pos : Vector2
@export var new_scene : PackedScene

func _on_button_up() -> void:
	var tween := create_tween()
	tween.tween_property(movable_obj,"position",get_viewport_rect().size * -pos, 0.2)
	if new_scene:
		await tween.finished
		var scene = new_scene.instantiate()
		change_scene_to_node(scene)

func change_scene_to_node(node):
	var tree = get_tree()
	var cur_scene = tree.get_current_scene()
	tree.get_root().add_child(node)
	tree.get_root().remove_child(cur_scene)
	tree.set_current_scene(node)
