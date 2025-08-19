extends CharacterBody2D

var viewport_rect
var half_sprite_width
var half_sprite_height

func _ready() -> void:
	var camere = get_viewport().get_camera_2d()
	var camera_rect = camere.get_viewport_rect()
	viewport_rect = Rect2(camere.global_position - camera_rect.size/2, camera_rect.size)
	
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
	
	wrap_pos()
	move_and_slide()

# TODO: On collide change move direction
