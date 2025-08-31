class_name HurtboxComponent
extends Area2D

signal on_damage_taken(damage: int)

func _on_on_damage_taken(damage: int) -> void:
	SfxAudioStreamPlayer.play_polyphonic("res://Assets/hit.mp3")
