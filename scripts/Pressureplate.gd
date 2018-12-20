extends Area2D
signal plate_on(signal_value)
signal plate_off(signal_value)

export(String) var plate_name
var event_list = []

var sprite_on
var sprite_off

func _ready():
	sprite_on = find_node("sprite_on")
	sprite_off = find_node("sprite_off")
	
	self.connect('plate_on', self, "set_on")
	self.connect('plate_off', self, "set_off")
	
	self.connect("body_entered", self, "_on_pressureplate_body_entered", [self])
	
	# seed an initial event
	var event_type_string = 'plate_on' if is_on() else 'plate_off'
	event_list.append({'type': event_type_string, 'time': 0, 'state' : is_on()})

func _on_pressureplate_body_entered(body, origin):
	if body.get_filename() == global.CHARACTER_FILEPATH:
		origin.toggle()

func toggle():
	if sprite_on.is_visible():
		emit_signal("plate_off")
		print("plate_off")
	else:
		emit_signal("plate_on")
		print("plate_on")

func set_on():
	event_list.append({'type': 'plate_on', 'time': global.time, 'state' : is_on()})
	sprite_on.show()
	sprite_off.hide()

func set_off():
	event_list.append({'type': 'plate_off', 'time': global.time, 'state' : is_on()})
	sprite_on.hide()
	sprite_off.show()
	
func is_on():
	return sprite_on.is_visible()

func reset_to_events(events):
	if events == null:
		return
	var early_event = events[0]
	print(early_event)
	if early_event['type'] == "plate_on":
		sprite_on.show()
		sprite_off.hide()
	elif early_event['type'] == "plate_off":
		sprite_on.hide()
		sprite_off.show()

func finalize_jump(t):
	global.wipe_future(self, t)