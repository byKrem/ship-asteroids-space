extends Container

@export var bus_name : String = "Master"

@onready var _bus_index := AudioServer.get_bus_index(bus_name)

func _ready() -> void:
	$ValueSlider.value = AudioServer.get_bus_volume_linear(_bus_index)
	$Name.text = bus_name
	$Value.text = str(AudioServer.get_bus_volume_linear(_bus_index) * 100) + "%"

func _on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(_bus_index, value)
	$Value.text = str(value*100) + "%"
