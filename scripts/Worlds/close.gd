extends CollisionShape2D

@export var expected_chests: int = 3
@export var expected_predators: int = 3

func _ready() -> void:
	var area = get_parent() as Area2D
	if area:
		area.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") or body.name == "player" or body.name == "Player":
		call_deferred("_change_to_stars_scene")

func _change_to_stars_scene() -> void:
	var stars = LevelTracker.calculate_stars(expected_chests, expected_predators)
	
	var scene_path = ""
	if stars == 3:
		scene_path = "res://scenes/UI/3_starts.tscn"
	elif stars == 2:
		scene_path = "res://scenes/UI/2_stars.tscn"
	else:
		scene_path = "res://scenes/UI/1_stars.tscn"
	
	get_tree().change_scene_to_file(scene_path)
