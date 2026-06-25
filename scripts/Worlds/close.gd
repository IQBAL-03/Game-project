extends CollisionShape2D

func _ready() -> void:
	var area = get_parent() as Area2D
	if area:
		area.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") or body.name == "player" or body.name == "Player":
		get_tree().quit()
