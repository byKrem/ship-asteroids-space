class_name HitboxComponent
extends Area2D

@export var damage : int = 1

func _on_area_entered(area: Area2D) -> void:
	if area is HurtboxComponent:
		area.on_damage_taken.emit(damage)
		owner.queue_free()
