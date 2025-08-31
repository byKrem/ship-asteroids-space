extends HBoxContainer

@export var setting_category : String = "gameplay"
@export var setting_name : String

var setting_total : String

func _ready() -> void:
	setting_total = "{setting_category}/{setting_name}".format(
		{"setting_category": setting_category, "setting_name": setting_name})
	
	if !ProjectSettings.has_setting(setting_total):
		ProjectSettings.set_setting(setting_total, 0.05)
		$ValueSlider.value = 0.05
		$Value.text = str(0.05 * 1000) + "%"
	else:
		$ValueSlider.value = ProjectSettings.get_setting(setting_total)
		$Value.text = str($ValueSlider.value * 1000) + "%"


func _on_value_slider_value_changed(value: float) -> void:
	$Value.text = str(value * 1000) + "%"
	if ProjectSettings.has_setting(setting_total):
		ProjectSettings.set_setting(setting_total, value)
		ProjectSettings.settings_changed.emit()
