extends Control

export (String, MULTILINE) var about_text


func _ready():
	#Set about text and make it read-only
	get_node("WindowDialog/AboutText").set_text(about_text)
	get_node("WindowDialog/AboutText").set_readonly(true)


func _on_OkButton_pressed():
	#Hide about dialog
	get_node("WindowDialog").hide()

