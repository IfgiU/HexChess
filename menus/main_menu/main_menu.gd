extends Control


#func _ready():
	#RenderingServer.set_default_clear_color(Global.main_color)


func _on_start_pressed():
	get_tree().change_scene_to_file("res://menus/game_ui/GameUI.tscn")


func _on_options_pressed():
	get_tree().change_scene_to_file("res://menus/settings/settings.tscn")


func _on_quit_pressed():
	get_tree().quit()


func _on_help_pressed():
	OS.shell_open("https://youtu.be/snmEj7Xve_U?si=2eZjsbpv2QA6KF4j")


func _on_credits_pressed():
	OS.shell_open("https://thisisnowtaken.itch.io/")
