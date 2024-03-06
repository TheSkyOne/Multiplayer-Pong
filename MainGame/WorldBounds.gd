extends Node2D


func _ready() -> void:
	$Top.global_position = Vector2i.ZERO
	$Bottom.global_position = Vector2i(0, Globals.viewport_size.y)

