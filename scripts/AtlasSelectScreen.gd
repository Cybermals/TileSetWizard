extends Control

signal load_atlas(path, tile_size)


func _ready():
	pass


func _on_ChooseButton_pressed():
	#Display file dialog
	get_node("FileDialog").popup()


func _on_AboutButton_pressed():
	#Show about dialog
	get_node("AboutDialog/WindowDialog").popup()


func _on_NextButton_pressed():
	#Emit load atlas signal
	var path = get_node("AtlasPath").get_text()
	var tile_size = get_node("TileSize").get_value()
	emit_signal("load_atlas", path, tile_size)


func _on_FileDialog_file_selected(path):
	#Set atlas path
	get_node("AtlasPath").set_text(path)
