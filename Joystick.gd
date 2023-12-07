extends Area2D

@onready var big_c = $BigCircle
@onready var small_c = $BigCircle/SmallCircle

@onready var max_distance = $CollisionShape2D.shape.radius

var touched = false

#func _ready() -> void:
	#if OS.has_feature("mobile"):
		#visible = false

func _input(event):
	if event in InputEventScreenTouch:
		var distance =  event.position.distance_tp(big_c.global_position)
		if not touched:
			if distance < max_distance:
				touched = true
		else:
			small_c.position = Vector2(0, 0)
			touched = false

func _process(delta):
	if touched:
		small_c.global_position = get_global_mouse_position()
		small_c.position = big_c.position + (small_c.position - big_c.position).clamped(max_distance)
