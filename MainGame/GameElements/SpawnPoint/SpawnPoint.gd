extends Marker2D

@export var x_offset := 100


func _ready() -> void:
	var x_pos := x_offset if name.contains("Left") else Globals.viewport_size.x - x_offset
	global_position = Vector2(x_pos, Globals.viewport_size.y/2)

