extends CharacterBody2D


@export var move_speed := 300
@export var max_angle := PI/4
@export var move_dir := _get_rand_ball_dir()

@onready var initial_move_speed := move_speed
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	randomize()
	Globals.ball_entered_score_area.connect(_reset_ball)
	global_position = Globals.viewport_size / 2


func _process(delta: float) -> void:
	velocity = move_dir * move_speed * delta
	var collision = move_and_collide(velocity)
	
	if collision:
		var collision_normal := collision.get_normal()
		move_dir = move_dir.bounce(collision_normal)
		
		var collider := collision.get_collider()
		if collider.name.contains("Paddle"):
			move_speed += 20


func _draw() -> void:
	draw_circle(Vector2.ZERO, collision_shape_2d.shape.radius, Color.WHITE)


func get_radius() -> int:
	return collision_shape_2d.shape.radius


func _reset_ball(_area_name: String) -> void:
	global_position = Globals.viewport_size / 2
	move_speed = initial_move_speed
	move_dir = _get_rand_ball_dir()


func _get_rand_ball_dir() -> Vector2:
	var new_dir := Vector2.from_angle(randf_range(-max_angle, max_angle))
	var flipped := (randi() % 2) * 2 -1
	return new_dir * flipped
