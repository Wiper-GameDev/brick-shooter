extends CharacterBody2D


const SPEED = 300.0
var last_mouse_position: float;


func _ready():
	last_mouse_position = get_global_mouse_position().x

func _physics_process(delta):
	var direction = Input.get_axis("move_left", "move_right")
	if not direction:
		var mouse_pos = get_global_mouse_position()
		if mouse_pos.x != last_mouse_position:
			last_mouse_position = mouse_pos.x
			move_and_collide(Vector2(mouse_pos.x - position.x, 0))
	else:
		move_and_collide(Vector2(SPEED * delta * direction, 0))
