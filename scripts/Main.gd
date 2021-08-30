extends Node

var tileset
var shapes = []


func _ready():
	pass


func _on_AtlasSelectScreen_load_atlas(path, tile_size):
	#Load texture atlas image
	var tex = ImageTexture.new()
	
	if tex == null:
		show_error("Failed to open image '" + path + "'.")
		return
		
	tex.load(path)
		
	#Get texture size
	var size = tex.get_size()
	
	#Generate tile collision shapes
	var left = 0
	var top = 0
	var right = tile_size
	var bottom = tile_size
	
	var square = ConvexPolygonShape2D.new()
	square.set_points(PoolVector2Array([
		Vector2(left, bottom),
		Vector2(left, top),
		Vector2(right, top),
		Vector2(right, bottom)
	]))
	
	var slope_L = ConvexPolygonShape2D.new()
	slope_L.set_points(PoolVector2Array([
		Vector2(left, bottom),
		Vector2(right, top),
		Vector2(right, bottom)
	]))
	
	var slope_R = ConvexPolygonShape2D.new()
	slope_R.set_points(PoolVector2Array([
		Vector2(left, bottom),
		Vector2(left, top),
		Vector2(right, bottom)
	]))
	
	var gentle_slope_1L = ConvexPolygonShape2D.new()
	gentle_slope_1L.set_points(PoolVector2Array([
		Vector2(left, bottom),
		Vector2(right, bottom / 2),
		Vector2(right, bottom)
	]))
	
	var gentle_slope_2L = ConvexPolygonShape2D.new()
	gentle_slope_2L.set_points(PoolVector2Array([
		Vector2(left, bottom),
		Vector2(left, bottom / 2),
		Vector2(right, top),
		Vector2(right, bottom)
	]))
	
	var gentle_slope_1R = ConvexPolygonShape2D.new()
	gentle_slope_1R.set_points(PoolVector2Array([
		Vector2(left, bottom),
		Vector2(left, top),
		Vector2(right, bottom / 2),
		Vector2(right, bottom)
	]))
	
	var gentle_slope_2R = ConvexPolygonShape2D.new()
	gentle_slope_2R.set_points(PoolVector2Array([
		Vector2(left, bottom),
		Vector2(left, bottom / 2),
		Vector2(right, bottom)
	]))
	
	shapes = [
		square,
		slope_L,
		slope_R,
		gentle_slope_1L,
		gentle_slope_2L,
		gentle_slope_1R,
		gentle_slope_2R
	]
	
	#Generate default tileset
	tileset = TileSet.new()
	var id = 0
	
	for y in range(size.y / tile_size):
		for x in range(size.x / tile_size):
			#Create a new tile
			tileset.create_tile(id)
			tileset.tile_set_name(id, "Tile_" + str(x) + "_" + 
				str(y))
			tileset.tile_set_texture(id, tex)
			tileset.tile_set_region(
				id,
				Rect2(
					x * tile_size, 
					y * tile_size, 
					tile_size, 
					tile_size
				)
			)
			tileset.tile_set_shape(id, 0, shapes[0])
			
			#Next tile ID
			id += 1
			
	#Update tile list
	get_node("TileEditScreen").update_tiles(tileset)
	
	#Switch to tile edit screen
	get_node("AtlasSelectScreen").hide()
	get_node("TileEditScreen").show()
		
		
func show_error(msg):
	#Show error message
	get_node("ErrorDialog").set_text(msg)
	get_node("ErrorDialog").popup()


func _on_TileEditScreen_set_tile_shape(tile_id, shape_id):
	#Set new collision shape
	tileset.tile_set_shape(tile_id, 0, shapes[shape_id])


func _on_TileEditScreen_back():
	#Switch to atlas select screen
	get_node("TileEditScreen").hide()
	get_node("AtlasSelectScreen").show()


func _on_TileEditScreen_save(path):
	#Save tileset
	if ResourceSaver.save(path, tileset, 
		ResourceSaver.FLAG_BUNDLE_RESOURCES):
		show_error("Failed to save tileset '" + path + "'.")
		return
		
	#Switch back to atlas select screen
	_on_TileEditScreen_back()

