extends Control

export (String, MULTILINE) var about_text


func _ready():
	#Set about box text and make it read-only
	get_node("WindowDialog/AboutText").set_text(about_text)
	get_node("WindowDialog/AboutText").set_readonly(true)


func _on_OKButton_pressed():
	get_node("WindowDialog").hide()
	
	
func show_about_box():
	#Show the about box
	get_node("WindowDialog").popup()
	
