extends CharacterBody2D

@export var move_speed = 20.0

@onready var player = get_tree().get_first_node_in_group("player")
@onready var sprite = $Sprite2D
@onready var animation = $AnimationPlayer

func _ready():
	animation.play("walk")

func _physics_process(_delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * move_speed
	move_and_slide()
	
	# Adicionando animacao
	if direction.x > 0.1:
		sprite.flip_h = true
	elif direction.x < -0.1:
		sprite.flip_h = false

