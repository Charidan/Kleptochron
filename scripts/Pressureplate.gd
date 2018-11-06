extends Area2D
signal plate_on(signal_value)
signal plate_off(signal_value)

export(String) var plate_name
var event_list = []

var sprite_on
var sprite_off

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	sprite_on = find_node("sprite_on")
	sprite_off = find_node("sprite_off")
	
	self.connect('plate_on', self, "set_on")
	self.connect('plate_off', self, "set_off")
	
	self.connect("body_entered", self, "_on_pressureplate_body_entered", [self])

func _on_pressureplate_body_entered(body, origin):
	if body.get_name() == "Character":
		origin.toggle()

func toggle():
	if sprite_on.is_visible():
		emit_signal("plate_off", plate_name)
	else:
		emit_signal("plate_on", plate_name)

func set_on(signal_value):
	event_list.append(['plate_on', global.time, {'state' : is_on()}])
	if signal_value == plate_name:
		sprite_on.show()
		sprite_off.hide()

func set_off(signal_value):
	event_list.append(['plate_off', global.time, {'state' : is_on()}])
	if signal_value == plate_name:
		sprite_on.hide()
		sprite_off.show()
	
func is_on():
	return sprite_on.is_visible()

func reset_to_events(events):
	if events == null:
		return
	var early_event = events[0]
	#var late_event = null
	#if events[1]:
	#	late_event = events[1][0]
	print(early_event)
	if early_event[0] == "plate_on":
		sprite_on.show()
		sprite_off.hide()
	elif early_event[0] == "plate_off":
		sprite_on.hide()
		sprite_off.show()