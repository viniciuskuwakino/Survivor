extends CharacterBody2D

var move_speed = 40.0

func _physics_process(delta):
	move()
	
func move():
	var x = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y = Input.get_action_strength("down") - Input.get_action_strength("up")
	var mov = Vector2(x, y)
	
	velocity = mov.normalized() * move_speed
	move_and_slide()
