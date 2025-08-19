class_name HealthComponent
extends Node

@export var hurtbox : HurtboxComponent
@export var health : int = 1

func _ready() -> void:
	hurtbox.on_damage_taken.connect(hurt)

func hurt(damage: int) -> void:
	health -= damage
	if health <= 0:
		owner.queue_free()
