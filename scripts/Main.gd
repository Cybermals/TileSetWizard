extends Node

export (PackedScene) var Tile


func _ready():
	pass


func _on_AtlasSelectScreen_next():
	#Try to load atlas texture
	var path = get_node("AtlasSelectScreen").get_texture_atlas_path()
	var atlas_tex = load(path)
	
	if atlas_tex == null:
		#Report error
		show_error("Failed to load image '" + path + "'")
		return
		
	#Get texture size and tile size
	var tex_size = atlas_tex.get_size()
	var tile_size = get_node("AtlasSelectScreen").get_tile_size()
	
	#Generate tiles
	var rect = Rect2(0, 0, tile_size, tile_size)
	
	for y in range(tex_size.y / tile_size):
		for x in range(tex_size.x / tile_size):
			#Update rect
			rect.position.x = x * tile_size
			rect.position.y = y * tile_size
			
			#Create new tile
			var tile = Tile.instance()
			get_node("TileCollection").add_child(tile)
			tile.set_name("Tile_" + str(x) + "_" + str(y))
			tile.set_position(rect.position)
			tile.add_to_group("tiles")
			tile.set_texture(atlas_tex)
			tile.set_region_rect(rect)
	
	#Switch to edit tileset screen
	get_node("AtlasSelectScreen").hide()
	get_node("EditTileSetScreen").show()
	get_node("EditTileSetScreen").update_tiles(get_node("TileCollection"))


func _on_EditTileSetScreen_back():
	#Mark all tiles to be freed
	get_tree().call_group(get_tree().GROUP_CALL_DEFAULT, "tiles", "queue_free")
	
	#Switch to atlas select screen
	get_node("EditTileSetScreen").hide()
	get_node("AtlasSelectScreen").show()


func _on_EditTileSetScreen_export_tileset(path):
	#Save the tileset scene
	if !save_scene(path):
		show_error("Failed to export tileset '" + path + "'")
		return
	
	#Return to atlas select screen
	get_node("EditTileSetScreen").hide()
	get_node("AtlasSelectScreen").show()
	
	
func _on_EditTileSetScreen_set_tile_name(idx, name):
	#Rename the given tile
	get_node("TileCollection").get_child(idx).set_name(name)


func _on_EditTileSetScreen_set_tile_shape(idx, shape):
	#Set the shape of the given tile
	get_node("TileCollection").get_child(idx).set_collision_shape(shape)
	
	
func show_error(msg):
	#Set error text and display error dialog
	get_node("ErrorDialog").set_text(msg)
	get_node("ErrorDialog").popup()
	
	
func _set_owner(node, owner):
	#Set the owner of the node
	if node != owner:
	    node.set_owner(owner)
	
	#Set the owner of all child nodes too
	for child in node.get_children():
		_set_owner(child, owner)
		
		
func save_scene(path):
	#Save the tile collection as a scene
	var root = get_node("TileCollection")
	_set_owner(root, root)
	var scene = PackedScene.new()
	scene.pack(get_node("TileCollection"))
	return ResourceSaver.save(path, scene, ResourceSaver.FLAG_RELATIVE_PATHS)

