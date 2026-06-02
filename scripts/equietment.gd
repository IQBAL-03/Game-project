extends Control

var is_visible_equipment = false

func _ready() -> void:
	add_to_group("equipment")
	visible = false

func _input(event):
	if event is InputEventKey and event.pressed and (event.keycode == KEY_E or event.keycode == KEY_B):
		toggle_equipment()

func toggle_equipment():
	is_visible_equipment = !is_visible_equipment
	visible = is_visible_equipment
	get_tree().paused = is_visible_equipment
