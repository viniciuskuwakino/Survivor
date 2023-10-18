extends CharacterBody2D

var move_speed = 40.0
@onready var sprite = $Sprite2D
@onready var walkTimer = get_node("%WalkTimer")

func _physics_process(delta):
	move()
	
func move():
	var x = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y = Input.get_action_strength("down") - Input.get_action_strength("up")
	var mov = Vector2(x, y)
	
	# Adicionando animacao
	if mov.x > 0:
		sprite.flip_h = true
	elif mov.x < 0:
		sprite.flip_h = false
	
	if mov != Vector2.ZERO:
		if walkTimer.is_stopped():
			if sprite.frame >= sprite.hframes - 1:
				sprite.frame = 0
			else:
				sprite.frame += 1
			
			walkTimer.start()
			
	
	velocity = mov.normalized() * move_speed
	move_and_slide()
