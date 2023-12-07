extends TouchScreenButton


@onready var knob = $Knob
@onready var max_distance = shape.radius

var stick_center: Vector2 = texture_normal.get_size() / 2
var touched: bool = false

func _ready():
	set_process(false)


func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			set_process(true)
		elif not event.pressed:
			set_process(false)
			knob.position = stick_center

func _process(delta):
	knob.global_position = get_global_mouse_position()
	knob.position = stick_center + (knob.position - stick_center).limit_length(max_distance)

func get_joystick_dir() -> Vector2:
	var dir = knob.position - stick_center
	return dir.normalized()

