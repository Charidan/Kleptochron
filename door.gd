extends StaticBody2D

var open = false
var left_moving = false
var right_moving = false
const SPEED = 1
const POS_LEFT_OPEN = Vector2(-10, 0)
const POS_LEFT_CLOSE = Vector2(-5, 0)
const POS_RIGHT_OPEN = Vector2(10, 0)
const POS_RIGHT_CLOSE = Vector2(5, 0)

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _physics_process(delta):
	if left_moving:
		if open:
			left_moving = move_towards(find_node('leftdoor'), POS_LEFT_OPEN, delta)
		else:
			left_moving =move_towards(find_node('leftdoor'), POS_LEFT_CLOSE, delta)
	if right_moving:
		if open:
			right_moving = move_towards(find_node('rightdoor'), POS_RIGHT_OPEN, delta)
		else:
			right_moving = move_towards(find_node('rightdoor'), POS_RIGHT_CLOSE, delta)

func move_towards(obj, dest, delta):
	var distance = (dest - obj.position)
	var momentum = (SPEED * delta)
	if distance.length() < momentum:
		obj.position = dest
		return false
	obj.position += distance.normalized() * momentum
	return true

func toggle():
	left_moving = true
	right_moving = true
	open = !open
