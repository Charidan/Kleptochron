extends Node

var time = 0

func _physics_process(delta):
	time += 1

	
func reset_time():
	time = 0