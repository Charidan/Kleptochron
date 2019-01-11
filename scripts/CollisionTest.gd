extends Node2D

func _ready():
	global.reset_time()
	
	var pp1 = find_node("PP_Door1")
	var pp2 = find_node("PP_Door2")
	var door = find_node("Door")
	var tdoor = find_node("TimeDoor")
	var tpp1 = find_node("PP_DoorT1")
	var tpp2 = find_node("PP_DoorT2")
	
	#TODO consider a variant architecture with a "network" entity that rebroadcasts signals between linked plates/doors/etc so you don't have to pair them all
	# maybe have it automatically find its tree-children and link them to itself so you can set up the signal links with the editor tree
	connect_plate_to_door(pp1, door)
	connect_plate_to_door(pp2, door)
	connect_plates(pp1, pp2)
	connect_plate_to_door(tpp1, tdoor)
	connect_plate_to_door(tpp2, tdoor)
	connect_plates(tpp1, tpp2)

func connect_plate_to_door(plate, door):
	plate.connect('plate_on', door, "open")
	plate.connect('plate_off', door, "close")

func connect_plates(a, b):
	a.connect('plate_on', b, "set_on")
	a.connect('plate_off', b, "set_off")
	
	b.connect('plate_on', a, "set_on")
	b.connect('plate_off', a, "set_off")