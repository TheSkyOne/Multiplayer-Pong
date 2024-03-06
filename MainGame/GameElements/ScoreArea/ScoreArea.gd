extends Area2D


@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	collision_shape_2d.shape.size.y = Globals.viewport_size.y


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Ball":
		Globals.ball_entered_score_area.emit(name)
