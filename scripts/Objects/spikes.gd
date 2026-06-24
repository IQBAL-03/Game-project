extends Area2D

@export var damage_amount: float = 1.0
var triggered: bool = false
var players_inside: Array = []

func _ready() -> void:
	$Spikes.pause()
	$Spikes.frame = 0
	$Spikes.frame_changed.connect(_on_frame_changed)

func _on_frame_changed() -> void:
	if $Spikes.frame >= 4:
		for p in players_inside:
			deal_damage_and_tp(p)
			
	if $Spikes.frame == 8:
		$Spikes.pause()

func play_spike_anim() -> void:
	if not triggered:
		triggered = true
		$Spikes.play("spikes")

func trigger_all_spikes() -> void:
	var container = get_parent().get_parent()
	if container:
		for node in container.get_children():
			if node.name.begins_with("Spikes"):
				var area = node.get_node_or_null("Area2D")
				if area and area.has_method("play_spike_anim"):
					area.play_spike_anim()

func deal_damage_and_tp(player_node: Node2D) -> void:
	if player_node.get("is_teleporting") or player_node.get("is_dead"):
		return
		
	if player_node.has_method("_on_spike_hit"):
		player_node._on_spike_hit()
	else:
		var actual_damage = damage_amount
		if player_node.has_method("is_player_defending") and player_node.is_player_defending():
			actual_damage = 0
		var player_health = player_node.get_node_or_null("HealthComponent")
		if player_health and player_health.has_method("take_damage"):
			player_health.take_damage(actual_damage)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		trigger_all_spikes()
		if not players_inside.has(body):
			players_inside.append(body)
		deal_damage_and_tp(body)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		if players_inside.has(body):
			players_inside.erase(body)

func _on_area_entered(area: Area2D) -> void:
	if area.name == "HurtBox":
		trigger_all_spikes()
		var player_node = area.get_parent()
		if player_node and player_node.is_in_group("player"):
			if not players_inside.has(player_node):
				players_inside.append(player_node)
			deal_damage_and_tp(player_node)

func _on_area_exited(area: Area2D) -> void:
	if area.name == "HurtBox":
		var player_node = area.get_parent()
		if player_node and player_node.is_in_group("player"):
			if players_inside.has(player_node):
				players_inside.erase(player_node)
