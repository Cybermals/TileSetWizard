extends Control

signal set_tile_shape(tile_id, shape_id)
signal back
signal save(path)


func _ready():
	pass
	
	
func _on_Tiles_item_selected(index):
	#Update tile shape option button
	var shape = get_node("Tiles").get_item_text(index)
	
	if "square" in shape:
		get_node("TileShape").select(0)
		
	elif "slope-L" in shape:
		get_node("TileShape").select(1)
		
	elif "slope-R" in shape:
		get_node("TileShape").select(2)
		
	elif "gentle-slope-1L" in shape:
		get_node("TileShape").select(3)
		
	elif "gentle-slope-2L" in shape:
		get_node("TileShape").select(4)
		
	elif "gentle-slope-1R" in shape:
		get_node("TileShape").select(5)
		
	elif "gentle-slope-2R" in shape:
		get_node("TileShape").select(6)


func _on_TileShape_item_selected(ID):
	#Get selected tile and shape
	var sel = get_node("Tiles").get_selected_items()
	
	if not sel.size():
		return
		
	var tile_id = sel[0]
	var shape_id = get_node("TileShape").get_selected()
	
	#Update tile text
	var text = get_node("Tiles").get_item_text(tile_id)
	var shape = get_node("TileShape").get_item_text(shape_id)
	text = text.split(" ")[0] + " (" + shape + ")"
	get_node("Tiles").set_item_text(tile_id, text)
	
	#Emit set tile shape signal
	emit_signal("set_tile_shape", tile_id, shape_id)


func _on_BackButton_pressed():
	#Emit back signal
	emit_signal("back")


func _on_SaveButton_pressed():
	#Display file dialog
	get_node("FileDialog").popup()


func _on_FileDialog_file_selected(path):
	#Emit save signal
	emit_signal("save", path)
	
	
func update_tiles(tileset):
	#Clear existing tiles
	get_node("Tiles").clear()
	
	#Add new tiles
	for i in range(tileset.get_last_unused_tile_id()):
		#Get tile attribs
		var name = tileset.tile_get_name(i)
		var tex = tileset.tile_get_texture(i)
		var region = tileset.tile_get_region(i)
		
		#Create atlas texture for tile icon
		var icon = AtlasTexture.new()
		icon.set_atlas(tex)
		icon.set_region(region)
		
		#Add tile item
		get_node("Tiles").add_item(name + " (square)", icon)

