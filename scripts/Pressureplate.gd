extends Area2D
signal plate_on(signal_value)
signal plate_off(signal_value)

export(String) var plate_name
var event_list = []

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	self.connect('plate_on', self, "set_on")
	self.connect('plate_off', self, "set_off")
	
	self.connect("body_entered", self, "_on_pressureplate_body_entered", [self])

func _on_pressureplate_body_entered(body, origin):
	if body.get_name() == "Character":
		origin.toggle()

func toggle():
	if find_node("sprite_on").is_visible():
		emit_signal("plate_off", plate_name)
		event_list.append('plate_off:' + str(global.time))
	else:
		emit_signal("plate_on", plate_name)
		event_list.append('plate_on:' + str(global.time))

func set_on(signal_value):
	print('Hi' + str(self))
	print(str(signal_value == plate_name))
	if signal_value == plate_name:
		find_node("sprite_on").show()
		find_node("sprite_off").hide()

func set_off(signal_value):
	print('Hi' + str(self))
	print(str(signal_value == plate_name))
	if signal_value == plate_name:
		find_node("sprite_on").hide()
		find_node("sprite_off").show()
	
func is_on():
	return find_node("sprite_on").is_visible()