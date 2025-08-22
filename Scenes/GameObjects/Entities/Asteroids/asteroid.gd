class_name Asteroid
extends CharacterBody2D

@export var smaller_asteroid : PackedScene

const MAX_SPEED = 100
var viewport_rect
var half_sprite_width
var half_sprite_height

func _ready() -> void:
	var camere = get_viewport().get_camera_2d()
	var camera_rect = camere.get_viewport_rect()
	viewport_rect = Rect2(camere.global_position - camera_rect.size/2, camera_rect.size)
	rotation = randf_range(0,TAU)
	
	half_sprite_width = $Sprite2D.texture.get_width() * $Sprite2D.scale.x / 2
	half_sprite_height = $Sprite2D.texture.get_height() * $Sprite2D.scale.y / 2

func wrap_pos() -> void:
	if global_position.x < viewport_rect.position.x - half_sprite_width:
		global_position.x = viewport_rect.end.x + half_sprite_width
	elif global_position.x > viewport_rect.end.x + half_sprite_width:
		global_position.x = viewport_rect.position.x - half_sprite_width
		
	if global_position.y < viewport_rect.position.y - half_sprite_height:
		global_position.y = viewport_rect.end.y + half_sprite_height
	elif global_position.y > viewport_rect.end.y + half_sprite_height:
		global_position.y = viewport_rect.position.y - half_sprite_height

func _physics_process(delta: float) -> void:
	rotation += velocity.length() * delta / 40
	velocity = velocity.limit_length(MAX_SPEED)

	wrap_pos()
	move_and_slide()

func _on_health_component_on_health_run_out() -> void:
	if smaller_asteroid != null:
		var angle : float = randf_range(0, 2*PI)
		var vector = Vector2(cos(angle),sin(angle)) * 50
		
		var first : Asteroid = smaller_asteroid.instantiate()
		first.global_position = self.global_position
		first.velocity = vector
		first.rotation = angle + randf_range(-PI/2, PI/2)
		
		$"..".call_deferred("add_child", first)
		
		var second : Asteroid = smaller_asteroid.instantiate()
		second.global_position = self.global_position
		second.velocity = -vector
		second.rotation = -angle + randf_range(-PI/2, PI/2)
		
		$"..".call_deferred("add_child", second)
	
	self.call_deferred("queue_free")
