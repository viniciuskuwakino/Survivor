extends Control

@onready var anim = $AnimatedSprite2D

var level = "res://world.tscn"

func _ready():
	anim.play("anim")

func _on_btn_play_click_end():
	var _level = get_tree().change_scene_to_file(level)


func _on_btn_exit_click_end():
	get_tree().quit()


func _on_btn_cred_click_end():
	get_tree().change_scene_to_file("res://TitleScreen/cred.tscn")


func _on_btn_tuto_click_end():
	get_tree().change_scene_to_file("res://TitleScreen/tuto.tscn")
	
