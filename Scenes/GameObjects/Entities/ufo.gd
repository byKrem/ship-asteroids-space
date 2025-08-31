extends CharacterBody2D

const SPEED = 10.0

var viewport_rect
var half_sprite_width
var half_sprite_height

@onready var bullet_scene : PackedScene = preload("res://Scenes/GameObjects/Entities/bullet.tscn")


func _ready() -> void:
	var camere = get_viewport().get_camera_2d()
	var camera_rect = camere.get_viewport_rect()
	viewport_rect = Rect2(camere.global_position - camera_rect.size/2, camera_rect.size)
	
	half_sprite_width = $Sprite2D.texture.get_width() * $Sprite2D.scale.x / 6
	half_sprite_height = $Sprite2D.texture.get_height() * $Sprite2D.scale.y / 6


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
	# TODO: Make WaVe movement. Not in a simple line.
	
	wrap_pos()
	move_and_slide()


func _on_shoot_timer_timeout() -> void:
	var bullet = bullet_scene.instantiate()
	bullet.rotation = randf_range(0,2*PI)
	bullet.global_position = self.global_position + Vector2.from_angle(bullet.rotation) * 100
	bullet.velocity = SPEED * 50 + (velocity.length() / 1.6)
	$"../..".add_child(bullet)
	SfxAudioStreamPlayer.play_polyphonic("res://Assets/shoot.mp3")


func _on_health_component_on_health_run_out() -> void:
	self.queue_free.call_deferred()
