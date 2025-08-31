extends Node

@onready var label: Label = $Label
var accelerateTutor: bool = false
var rotateTutor: bool = false
var wrapTutor: bool = false
var shipWrapped: bool = false
var shootTutor: bool = false

func _ready() -> void:
	$"../Player".ship_wrapped.connect(_on_player_ship_wrapped)
	animate_text()

func _shortcut_input(event: InputEvent) -> void:
	var is_rotated := (Input.is_action_pressed("rotate_left") or Input.is_action_pressed("rotate_right"))
	if Input.is_action_pressed("accelerate") and !accelerateTutor:
		label.text = "You can rotate your ship by using [A] or [D]
			Don't forget that accelerating is possible only in forward"
		accelerateTutor = true
		animate_text()
	elif is_rotated and !rotateTutor and accelerateTutor:
		label.text = "Game field is wrapping on each edge.
			So everything can fly through any side and come out of an opposite one.
			Go try it!"
		rotateTutor = true
		animate_text()
	elif shipWrapped and !wrapTutor and accelerateTutor and rotateTutor:
		label.text = "Also getting close to any objects is dangerous!
			Try to shoot by pressing [SPACE]. And be careful...
			You can accidentaly hit yourself"
		wrapTutor = true
		animate_text()

func _on_asteroid_medium_tree_exited() -> void:
	self.queue_free.call_deferred()


func animate_text() -> void:
	label.visible_characters = 0
	var tween := create_tween()
	tween.set_parallel(false)
	
	tween.tween_property(label,"visible_characters",label.get_total_character_count(),1)


func _on_player_ship_wrapped() -> void:
	shipWrapped = true
