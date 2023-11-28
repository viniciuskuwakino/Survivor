extends Area2D


@export var experience = 1

var spr_green = preload("res://Ground/gemgreen.png")
var spr_blue = preload("res://Ground/gemblue.png")
var spr_red = preload("res://Ground/gemred.png")

var target = null
var speed = -0.8

@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D
@onready var sound = $snd_collected


func _ready():
	if experience < 5:
		return
	elif experience < 25:
		sprite.texture = spr_blue
	else:
		sprite.texture = spr_red


func _physics_process(delta):
	if target != null:
		global_position = global_position.move_toward(target.global_position, speed)
		speed += 2*delta


func collect():
	sound.play()
	collision.call_deferred("set", "disabled", true)
	sprite.visible = false
	return experience



func _on_snd_collected_finished():
	queue_free()





