extends CharacterBody2D

@onready var paddle = %Paddle
@export var SPEED = 100.0
@export var SPEED_MULTIPLIER = 1.02;
@export var MAX_SPEED = 150;
@onready var area_2d = $Area2D


var idle_on_paddle = true;
var direction = Vector2.ZERO;
var paddle_position: Vector2;

func _ready():
	randomize()
	area_2d.monitoring = false
	direction = Vector2([-1, 1][randi() % 2], -1)
	
func _physics_process(delta):
	if idle_on_paddle:
		return
		
	var collision = move_and_collide(SPEED * direction * delta)
	
	
	if collision:
		direction = direction.bounce(collision.get_normal())
		
		if collision.get_collider().is_in_group("paddle"):
			idle_on_paddle = true
			reparent(paddle)
			return
			
		
		if collision.get_collider().is_in_group("bricks"):
			var tilemap = collision.get_collider() as TileMap
			var cords = tilemap.get_coords_for_body_rid(collision.get_collider_rid())
			var cell = tilemap.get_cell_tile_data(0, cords)
			var next_tile  = cell.get_custom_data("next_tile")
			if next_tile == Vector2i.ZERO:
				tilemap.erase_cell(0, cords)
			else:
				tilemap.set_cell(0, cords, 0, next_tile)
			
		
		SPEED = min(SPEED * SPEED_MULTIPLIER, MAX_SPEED)


func _input(event):
	if event.is_action("shoot"):
		reparent(get_tree().root)
		idle_on_paddle = false


#func _on_area_2d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	#if not body is TileMap:
		#return
	#print("Body is Tilemap")
	##print(body_rid, body, body_shape_index, local_shape_index)
	#var cords = body.get_coords_for_body_rid(body_rid)
	#var cell = body.get_cell_tile_data(0, cords)
	#body.erase_cell(0, cords)

	
