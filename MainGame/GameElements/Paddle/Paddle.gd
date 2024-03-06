@tool
extends CharacterBody2D


@export var paddle_width := 25 :
	set(new_val):
		if not is_inside_tree():
			await ready
		
		paddle_width = new_val
		_recalculate_paddle()
		
@export var paddle_height := 200 :
	set(new_val):
		if not is_inside_tree():
			await ready
			
		paddle_height = new_val
		_recalculate_paddle()
		

@export var speed := 500
@export var player_id := 1 


@onready var input_synchronizer: MultiplayerSynchronizer = %InputSynchronizer
@onready var collision_shape_2d: CollisionShape2D = %CollisionShape2D
@onready var polygon_2d: Polygon2D = %Polygon2D
@onready var spawn_position : Vector2 # set by main game


func _enter_tree() -> void:
	set_multiplayer_authority(player_id)


func _ready() -> void:
	global_position = spawn_position - Vector2(paddle_width, paddle_height) / 2


func _physics_process(delta: float) -> void:
	if not Engine.is_editor_hint():
		velocity = Vector2(0, input_synchronizer.direction_y * speed)
		move_and_slide()
	

func _recalculate_paddle() -> void:
	collision_shape_2d.shape.size = Vector2i(paddle_width, paddle_height)
	collision_shape_2d.position = Vector2.ZERO
	collision_shape_2d.position += Vector2(paddle_width, paddle_height) / 2 
	
	polygon_2d.polygon = [Vector2i(0, 0),
									Vector2i(paddle_width, 0),
									Vector2i(paddle_width, paddle_height),
									Vector2i(0, paddle_height)
									]
