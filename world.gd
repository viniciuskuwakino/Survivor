extends Node2D

func _process(delta):
	print("FPS: " + str(Engine.get_frames_per_second()))
