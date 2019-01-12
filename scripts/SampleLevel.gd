extends Node2D

func _ready():
	global.reset_time()
	
	var pp1 = find_node("Pressureplate")
	var door = find_node("door_treasure")
	
	connect_plate_to_door(pp1, door)

func connect_plate_to_door(plate, door):
	plate.connect('plate_on', door, "open")
	plate.connect('plate_off', door, "close")

func connect_plates(a, b):
	a.connect('plate_on', b, "set_on")
	a.connect('plate_off', b, "set_off")
	
	b.connect('plate_on', a, "set_on")
	b.connect('plate_off', a, "set_off")
