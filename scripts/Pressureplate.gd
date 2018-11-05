extends Area2D
signal plate_on(signal_value)
signal plate_off(signal_value)

export(String) var plate_name

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func toggle():
	var sprite_on = find_node("sprite_on")
	var sprite_off = find_node("sprite_off")
	
	if sprite_on.is_visible():
		sprite_on.hide()
		sprite_off.show()
		emit_signal("plate_off", plate_name)
	else:
		sprite_on.show()
		sprite_off.hide()
		emit_signal("plate_on", plate_name)

func is_on():
	return find_node("sprite_on").is_visible()