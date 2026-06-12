extends Control

var is_visible_equipment = false
var current_page = 0
var max_page = 3
var items_per_page = 16

# Referensi untuk button navigasi
@onready var btn_kiri = $TextureRect/kiri
@onready var btn_kanan = $TextureRect/kanan

func _ready() -> void:
	add_to_group("equipment")
	visible = false
	# Tunggu satu frame untuk memastikan semua child node sudah siap
	call_deferred("update_pagination")

func _input(event):
	if event is InputEventKey and event.pressed and (event.keycode == KEY_E or event.keycode == KEY_B):
		toggle_equipment()

func toggle_equipment():
	is_visible_equipment = !is_visible_equipment
	visible = is_visible_equipment
	get_tree().paused = is_visible_equipment
	if is_visible_equipment:
		current_page = 0
		update_pagination()

func update_pagination():
	# Update visibility dan state tombol navigasi
	if btn_kiri and btn_kanan:
		# Tombol kiri
		if current_page == 0:
			btn_kiri.disabled = true
			btn_kiri.modulate = Color(0.5, 0.5, 0.5, 0.5)  # Lebih pucat
		else:
			btn_kiri.disabled = false
			btn_kiri.modulate = Color(1, 1, 1, 1)  # Normal
		
		# Tombol kanan
		if current_page >= max_page:
			btn_kanan.disabled = true
			btn_kanan.modulate = Color(0.5, 0.5, 0.5, 0.5)  # Lebih pucat
		else:
			btn_kanan.disabled = false
			btn_kanan.modulate = Color(1, 1, 1, 1)  # Normal
	
	# Update visibility item berdasarkan halaman
	update_items_visibility()

func update_items_visibility():
	# Sembunyikan semua item
	for i in range(1, 17):  # item_1 sampai item_16
		var item = $TextureRect.get_node_or_null("item_" + str(i))
		if item:
			item.visible = false
	
	# Tampilkan item sesuai halaman saat ini
	var start_index = current_page * 4 + 1  # 4 item per halaman
	var end_index = min(start_index + 3, 16)  # Maksimal 16 item
	
	for i in range(start_index, end_index + 1):
		var item = $TextureRect.get_node_or_null("item_" + str(i))
		if item:
			item.visible = true

func next_page():
	if current_page < max_page:
		current_page += 1
		update_pagination()

func prev_page():
	if current_page > 0:
		current_page -= 1
		update_pagination()
