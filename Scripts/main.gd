extends Node2D

const OBJECT = preload("res://Scenes/Objects/flowers01.tscn")
const OBJECT2 = preload("res://Scenes/Objects/flowers02.tscn")

@export var themes: Array[ThemeConfig] = []

@onready var tilemap_layer = $TileMapLayer
@onready var objects_layer = $ObjectsLayer

#var spawned_objects: Array[Node] = []
var current_theme: ThemeConfig
var last_theme: ThemeConfig = null

var obj_count: int
var placed_objs: Array = []

func _ready() -> void:
	spawn_objects_randomly()

func spawn_objects_randomly():
	var neighbour
	var this_tile
	var count_empty: int = 0
	var tile_data = tilemap_layer.get_used_cells()
	#print(tile_data)
	for item in tile_data:
		#print(item)
		neighbour = tilemap_layer.get_neighbor_cell(item, 12) #CELL_NEIGHBOR_TOP_SIDE = 12
		print("item: " + str(item))
		print("soused: " + str(neighbour))
		this_tile = tilemap_layer.get_cell_tile_data(neighbour)
		var world_pos = tilemap_layer.map_to_local(neighbour)
		if this_tile == null:
			var rand_num = randi_range(0,1)
			if rand_num == 1:
				count_empty += 1
				print("empty")
				spawn_obejct(world_pos)
	print(count_empty)

func spawn_obejct(pos:Vector2):
	var obj = OBJECT.instantiate()
	var obj2 = OBJECT2.instantiate()
	var rand = randi_range(0, 1)
	if rand == 1:
		placed_objs.append(obj)
		obj.position = pos
		get_tree().current_scene.add_child(obj)
	else:
		placed_objs.append(obj2)
		obj2.position = pos
		get_tree().current_scene.add_child(obj2)

func _on_generate_btn_pressed() -> void:
	remove_objs()
	placed_objs.clear()
	pick_theme()
	spawn_objects_randomly()

func remove_objs():
	for item in placed_objs:
		item.queue_free()

func apply_tileset():
	tilemap_layer.tile_set = current_theme.tileset
	#print(current_theme)

func pick_theme():
	#making sure that same tileset is not picked 2 times in a row
	var picked = themes.pick_random()
	#print(picked)
	while picked == current_theme:
		picked = themes.pick_random()
	
	current_theme = picked
	apply_tileset()
	
