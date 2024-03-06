extends Node

signal close_game #emitted when one of the peers disconnects
signal ball_entered_score_area(area_name)

@onready var viewport_size := get_tree().root.size 

var players := {}
