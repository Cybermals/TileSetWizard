extends Control
signal next


func _ready():
	pass


func _on_ChooseButton_pressed():
	#Display file dialog
	get_node("FileDialog").popup()
	
	
func _on_AboutButton_pressed():
	#Show about box
	get_node("AboutBox").show_about_box()


func _on_NextButton_pressed():
	#Emit "next" signal
	emit_signal("next")


func _on_FileDialog_confirmed():
	#Replace current path with the selected one
	var path = get_node("FileDialog").get_current_path()
	get_node("TextureAtlasPath").set_text(path)


func _on_FileDialog_file_selected(path):
	#Replace current path with the selected one
	get_node("TextureAtlasPath").set_text(path)
	
	
func get_texture_atlas_path():
	#Return the texture atlas path
	return get_node("TextureAtlasPath").get_text()
	
	
func get_tile_size():
	#Return the selected tile size
	return get_node("TileSize").get_value()

