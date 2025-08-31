extends CharacterBody2D

const SPEED = 10.0

signal ship_wrapped()
@export var BULLET : PackedScene
@onready var life_counter: HBoxContainer = $"../CanvasLayer/LifeCounter"

var viewport_rect: Rect2
var half_sprite_width: float
var half_sprite_height: float
var fire_in_cooldown: bool = false
var extra_life_count: int = 3
@onready var angle: float = ProjectSettings.get_setting("gameplay/angle_sensitivity")

func wrap_pos() -> void:
	if global_position.x < viewport_rect.position.x - half_sprite_width:
		global_position.x = viewport_rect.end.x + half_sprite_width
		ship_wrapped.emit()
	elif global_position.x > viewport_rect.end.x + half_sprite_width:
		global_position.x = viewport_rect.position.x - half_sprite_width
		ship_wrapped.emit()
		
	if global_position.y < viewport_rect.position.y - half_sprite_height:
		global_position.y = viewport_rect.end.y + half_sprite_height
		ship_wrapped.emit()
	elif global_position.y > viewport_rect.end.y + half_sprite_height:
		global_position.y = viewport_rect.position.y - half_sprite_height
		ship_wrapped.emit()

func fire() -> void:
	var bullet = BULLET.instantiate()
	bullet.rotation = rotation
	bullet.global_position = $Marker2D.global_position
	bullet.velocity = SPEED * 50 + (velocity.length() / 1.6)
	owner.add_child(bullet)

func _ready() -> void:
	var camere = get_viewport().get_camera_2d()
	var camera_rect = camere.get_viewport_rect()
	viewport_rect = Rect2(camere.global_position - camera_rect.size/2, camera_rect.size)
	
	half_sprite_width = $Sprite2D.texture.get_width() * $Sprite2D.scale.x / 6
	half_sprite_height = $Sprite2D.texture.get_height() * $Sprite2D.scale.y / 6
	
	ProjectSettings.settings_changed.connect(_on_settings_changed)

func _on_settings_changed() -> void:
	angle = ProjectSettings.get_setting("gameplay/angle_sensitivity")

func _process(_delta: float) -> void:
	if Input.is_action_pressed("shoot") and !fire_in_cooldown:
		fire()
		fire_in_cooldown = true
		$ShootCooldown.start()

func _physics_process(_delta: float) -> void:
	var direction := Input.get_axis("rotate_left", "rotate_right")
	
	if Input.is_action_pressed("accelerate"):
		velocity += Vector2(cos(rotation),sin(rotation)) * SPEED
		velocity = velocity.limit_length(SPEED * 100)
		$Sprite2D.frame = 1
	else:
		velocity = velocity.move_toward(Vector2.ZERO, SPEED/5)
		$Sprite2D.frame = 0
	
	if direction:
		rotation += angle * direction
	
	wrap_pos()
	move_and_slide()

func _on_shoot_cooldown_timeout() -> void:
	fire_in_cooldown = false


func _on_health_component_on_health_run_out() -> void:
	extra_life_count -= 1
	var life_to_remove = life_counter.get_child(0)
	life_counter.remove_child(life_to_remove)
	
	if extra_life_count <= 0:
		self.call_deferred("queue_free")
	else:
		$HealthComponent.health = 1
		immune_toggle()
		$ImmuneTimer.start()

func immune_toggle() -> void:
	$HurtboxComponent.set_deferred("monitorable", !$HurtboxComponent.monitorable)
	$HurtboxComponent.set_deferred("monitoring", !$HurtboxComponent.monitoring)
	if $AnimationPlayer.is_playing():
		$AnimationPlayer.stop()
	else:
		$AnimationPlayer.play("immuneAnim")

func _on_immune_timer_timeout() -> void:
	immune_toggle()
