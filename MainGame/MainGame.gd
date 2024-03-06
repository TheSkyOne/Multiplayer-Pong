extends Node2D

@export var paddle_scene : PackedScene
@onready var ball: CharacterBody2D = $Ball
@onready var multiplayer_spawner: MultiplayerSpawner = $MultiplayerSpawner
@onready var score_area_left: Area2D = %ScoreAreaLeft
@onready var score_area_right: Area2D = %ScoreAreaRight


func _ready() -> void:
	%TimerUI.countdown_finished.connect(_on_countdown_finished)
	get_tree().paused = true
	%TimerUI.animate_time_label()
	
	%ScoreUI.show()
	
	multiplayer_spawner.spawn_function = _spawn_paddle
	score_area_left.global_position.x = -ball.get_radius()
	score_area_right.global_position.x = Globals.viewport_size.x + ball.get_radius()
	
	if not multiplayer.is_server():
		return
	
	var idx := 0
	for player_id in Globals.players:
		var spawn_point := get_tree().get_nodes_in_group("spawn_points")[idx] as Marker2D
		var spawn_point_position := spawn_point.global_position
		multiplayer_spawner.spawn([player_id, spawn_point_position])
		idx += 1
	
	for point in get_tree().get_nodes_in_group("spawn_points"):
		point.queue_free()


func _spawn_paddle(args: Array) -> CharacterBody2D:
	var paddle : CharacterBody2D = paddle_scene.instantiate()
	paddle.player_id = args[0]
	paddle.spawn_position = args[1]
	return paddle


func _on_countdown_finished() -> void:
	get_tree().paused = false

