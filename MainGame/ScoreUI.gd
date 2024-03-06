extends CanvasLayer



func _ready() -> void:
	Globals.ball_entered_score_area.connect(_on_ball_entered_score_area)
	%ScoresContainer.add_theme_constant_override("separation", Globals.viewport_size.x / 2)


func _on_ball_entered_score_area(score_area_name: String) -> void:
	if score_area_name.contains("Left"):
		%ScoreRight.text = str(%ScoreRight.text.to_int() + 1)
	elif score_area_name.contains("Right"):
		%ScoreLeft.text = str(%ScoreLeft.text.to_int() + 1)

