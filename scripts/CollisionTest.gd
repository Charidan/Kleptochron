extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	global.reset_time()
	# Called when the node is added to the scene for the first time.
	# Initialization here
	var pp1 = find_node("PP_Door1")
	var pp2 = find_node("PP_Door2")
	var timeplate = find_node("PP_Time")
	var door = find_node("Door")
	var tdoor = find_node("TimeDoor")
	var tpp1 = find_node("PP_DoorT1")
	var tpp2 = find_node("PP_DoorT2")
	
	connect_plate_to_door(pp1, door)
	connect_plate_to_door(pp2, door)
	connect_plates(pp1, pp2)
	connect_plate_to_door(tpp1, tdoor)
	connect_plate_to_door(tpp2, tdoor)
	connect_plates(tpp1, tpp2)
	
	timeplate.connect('plate_on', self, 'travel_back', [300])

func connect_plate_to_door(plate, door):
	plate.connect('plate_on', door, "open")
	plate.connect('plate_off', door, "close")

func connect_plates(a, b):
	a.connect('plate_on', b, "set_on")
	a.connect('plate_off', b, "set_off")
	
	b.connect('plate_on', a, "set_on")
	b.connect('plate_off', a, "set_off")

func travel_back(signal_value, delta=600):
	if signal_value == 'time':
		global.time_travel_back(delta, self.get_children())