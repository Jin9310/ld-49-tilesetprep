extends Node2D

@export var themes: Array[ThemeConfig] = []
#blacklist for edges of the tileset
@export var blacklist: Array[Vector2i] = []

@onready var tilemap_layer = $TileMapLayer
@onready var objects_layer = $ObjectsLayer

var current_theme: ThemeConfig
var last_theme: ThemeConfig = null

var obj_count: int
var placed_objs: Array = []

func _ready() -> void:
	#print(blacklist)
	pick_theme()
	spawn_objects_randomly()

func spawn_objects_randomly():
	var neighbour
	var this_tile
	var count_objects: int = 0
	#get used tiles
	var tile_data = tilemap_layer.get_used_cells()
	for item in tile_data:
		#check if there is a free space above the placed tile
		neighbour = tilemap_layer.get_neighbor_cell(item, 12) #CELL_NEIGHBOR_TOP_SIDE = 12
		this_tile = tilemap_layer.get_cell_tile_data(neighbour)
		#convert vector2i to vector2
		var world_pos = tilemap_layer.map_to_local(neighbour)
		#now on the free top neighbours spawn an object
		if this_tile == null:
			var rand_num = randi_range(0,1)
			#randomly decide if spawn or not
			if rand_num == 1:
				if count_objects < current_theme.max_objects:
					if neighbour not in blacklist:
						#print("spawning at: " + str(neighbour))
						count_objects += 1
						spawn_obejct(world_pos)
	print("number of objs: " + str(count_objects))

func spawn_obejct(pos:Vector2):
	var select_item = current_theme.decor.pick_random().instantiate()
	placed_objs.append(select_item)
	select_item.position = pos
	get_tree().current_scene.add_child(select_item)

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
	
