extends Node

@export var mobs : Array[PackedScene]
@export var coins : int = 3


func rnd_spawn() -> void:
	for n in range(coins):
		var index = randi_range(0, mobs.size()-1)
		var mob = mobs[index].instantiate()
		
		
	
	coins = coins * 1.5

# If there is NO any child nodes then we need to spawn new mobs
func _on_child_exiting_tree(node: Node) -> void:
	if get_child_count() - 1 == 0:
		rnd_spawn()
