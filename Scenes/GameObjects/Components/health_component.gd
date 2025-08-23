class_name HealthComponent
extends Node

@export var hurtbox : HurtboxComponent
@export var health : int = 1

signal on_health_run_out

func _ready() -> void:
	hurtbox.on_damage_taken.connect(hurt)

func hurt(damage: int) -> void:
	health -= damage
	if health <= 0:
		on_health_run_out.emit()
