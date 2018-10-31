extends Area2D
signal hit

export (int) var speed
var screensize

func _ready():
	screensize = get_viewport_rect().size

func _physics_process(delta):
	#Change the below to not use ui input at some point
	#TODO: Change this later
	var velocity = Vector2()
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	position += velocity
	position.x = clamp(position.x, 0, screensize.x)
	position.y = clamp(position.y, 0, screensize.y)

func _on_Character_body_entered(body):
	#TODO: Stop movement on hit
	emit_signal("hit")
	