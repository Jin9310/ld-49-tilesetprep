extends Node2D

@export var themes: Array[ThemeConfig] = []

@onready var tilemap_layer = $TileMapLayer
@onready var objects_layer = $ObjectsLayer

#var spawned_objects: Array[Node] = []
var current_theme: ThemeConfig
var last_theme: ThemeConfig = null

func _on_generate_btn_pressed() -> void:
	pick_theme()

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
	
