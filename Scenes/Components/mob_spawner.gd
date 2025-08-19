extends Node

@export var mobs : Array[PackedScene]
@export var coins : int = 3

func rnd_spawn() -> void:
	var camera = get_viewport().get_camera_2d()
	var camera_rect = camera.get_viewport_rect()
	var spawn_area = Rect2(camera.global_position - camera_rect.size/2, camera_rect.size)
	
	for n in range(coins):
		var index = randi_range(0, mobs.size() - 1)
		var mob : CharacterBody2D = mobs[index].instantiate()
		
		mob.global_position = Vector2(
			randf_range(spawn_area.position.x,spawn_area.end.x),
			randf_range(spawn_area.position.y,spawn_area.end.y))
		
		mob.rotation = randf_range(0, 2 * PI)
		
		mob.velocity = Vector2(cos(mob.rotation),sin(mob.rotation)) * 50
		
		add_child.call_deferred(mob)
	
	coins = coins * 1.5

# If there is NO any child nodes then we need to spawn new mobs
func _on_child_exiting_tree(node: Node) -> void:
	if get_child_count() - 1 == 0:
		rnd_spawn()
