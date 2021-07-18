extends Control
signal back
signal export_tileset(path)
signal set_tile_name(idx, name)
signal set_tile_shape(idx, shape)

var tile_shapes = [
    "square", 
    "slope-L", 
    "slope-R",
    "gentle-slope1-L",
    "gentle-slope2-L",
    "gentle-slope1-R",
    "gentle-slope2-R"
]


func _ready():
	#Populate tile shapes
	for shape in tile_shapes:
		get_node("TileShapes").add_item(shape)
		
	#Set export dialog path to the user's documents dir
	var dir = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS)
	get_node("ExportDialog").set_current_dir(dir)


func _on_BackButton_pressed():
	#Emit "back" signal
	emit_signal("back")


func _on_ExportButton_pressed():
	#Show export dialog
	get_node("ExportDialog").popup()
	
	
func _on_TileList_item_selected(index):
	#Update tile name and shape
	var text = get_node("TileList").get_item_text(index)
	var parts = text.split(" ")
	var name = parts[0]
	var shape = parts[1].substr(1, parts[1].length() - 2)
	get_node("TileName").set_text(name)
	get_node("TileShapes").select(tile_shapes.find(shape))
	
func _on_RenameButton_pressed():
	#Set new tile name
	var tile_id = get_node("TileList").get_selected_items()[0]
	var text = get_node("TileList").get_item_text(tile_id)
	var parts = text.split(" ")
	var name = get_node("TileName").get_text()
	var shape = parts[1].substr(1, parts[1].length() - 2)
	get_node("TileList").set_item_text(tile_id, name + " (" + shape + ")")
	emit_signal("set_tile_name", tile_id, name)
	
	
func _on_TileShapes_item_selected(ID):
	#Set new tile shape
	var tile_id = get_node("TileList").get_selected_items()[0]
	var shape_id = get_node("TileShapes").get_selected()
	var text = get_node("TileList").get_item_text(tile_id)
	var parts = text.split(" ")
	var name = parts[0]
	var shape = tile_shapes[shape_id]
	get_node("TileList").set_item_text(tile_id, name + " (" + shape + ")")
	emit_signal("set_tile_shape", tile_id, shape)
	
	
func _on_ExportDialog_file_selected(path):
	#Emit "export_tileset" signal
	emit_signal("export_tileset", path)
	
	
func update_tiles(tiles):
	#Clear current tiles
	get_node("TileList").clear()
	
	#Add each new tile
	for tile in tiles.get_children():
		#Create texture atlas
		var atlas = AtlasTexture.new()
		atlas.set_atlas(tile.get_texture())
		atlas.set_region(tile.get_region_rect())
		
		#Add item to tile list
		get_node("TileList").add_item(tile.get_name() + " (" + tile.shape + ")", atlas)

