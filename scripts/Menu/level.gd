extends Control

func _ready():
	var level1 = $CenterContainer/Panel/GridContainer/Level1
	level1.pressed.connect(self._on_level1_pressed)
	
	var close_btn = $CenterContainer/Panel/CloseButton
	close_btn.pressed.connect(self._on_close_pressed)

func _on_level1_pressed():
	get_tree().change_scene_to_file("res://scenes/Worlds/dunia_1.tscn")

func _on_close_pressed():
	get_tree().change_scene_to_file("res://scenes/Menu/menu.tscn")
