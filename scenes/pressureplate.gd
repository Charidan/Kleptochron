extends Area2D
#signal body_enter

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func toggle():
	print( 'hit' )
	
	var sprite_on = find_node("sprite_on")
	var sprite_off = find_node("sprite_off")
	
	if sprite_on.is_visible():
		sprite_on.hide()
		sprite_off.show()
	else:
		sprite_on.show()
		sprite_off.hide()