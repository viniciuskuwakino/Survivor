extends Control

@onready var anim = $AnimatedSprite2D

#var level = "res://TitleScreen/cred.tscn"

func _ready():
	anim.play("anim")

func _on_btn_return_click_end():
	get_tree().change_scene_to_file("res://TitleScreen/menu.tscn")
