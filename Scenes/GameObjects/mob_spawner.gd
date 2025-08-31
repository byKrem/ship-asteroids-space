extends Node

@export var mobs : Array[PackedScene]
@export var base_coins : int = 3
@export var maximum_objects : int = 6

@onready var player: CharacterBody2D = $"../Player"
@onready var coins : int = base_coins
@onready var camera = get_viewport().get_camera_2d()
@onready var camera_rect = camera.get_viewport_rect()
@onready var spawn_area = Rect2(camera.global_position - camera_rect.size/2, camera_rect.size)

var timer : SceneTreeTimer
var lastPlayerPos : Vector2
var waveCount : int = 1

func _ready() -> void:
	timer = get_tree().create_timer(0.3)
	timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
	if player != null:
		lastPlayerPos = player.global_position

func rnd_spawn() -> void:
	var spawn_count : int = clamp(coins,0,maximum_objects-get_child_count())
	coins -= spawn_count
	var difficulty = 1
	if waveCount>5:
		difficulty = difficulty - 1
	
	for n in range(spawn_count):
		var index = randi_range(0, mobs.size() - 1 - difficulty)
		var mob : CharacterBody2D = mobs[index].instantiate()
		
		var angle = randf_range(0, TAU)
		var distance = randi_range(200,1000) # MinDistance and MaxDistance
		
		mob.global_position = lastPlayerPos + Vector2(cos(angle), sin(angle)) * distance
		
		mob.velocity = Vector2(cos(angle),sin(angle)) * 50
		 
		add_child.call_deferred(mob)

# If there is NO any child nodes then we need to spawn new mobs
func _on_child_exiting_tree(node: Node) -> void:
	if coins != 0 and get_child_count() < maximum_objects:
		rnd_spawn()
	
	if get_child_count() - 1 == 0:
		base_coins = base_coins * 1.5
		coins = base_coins
		waveCount = waveCount + 1
		rnd_spawn()
