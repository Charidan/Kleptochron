extends KinematicBody2D
signal hit

#export (int)
var speed = 5

var rotation_dir = 0

#func _ready():

func _physics_process(delta):
	var velocity = Vector2()
	#Change the below to not use ui input at some point
	#TODO: Change this later
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
		velocity = move_and_slide(velocity)
		look_at(position - velocity)
	position += velocity

func _on_Character_body_entered(body):
	#TODO: Stop movement on hit
	emit_signal("hit")
	