extends CanvasLayer

signal countdown_finished

##time it takes for the timer to tick, in seconds
@export var tick_time := 1
@export var starting_iterations := 3

@onready var start_timer_time_left_label: Label = %StartTimerTimeLeftLabel

var iterations := starting_iterations
var stop_animate := false


func _ready() -> void:
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)


func animate_time_label() -> void:
	start_timer_time_left_label.text = str(iterations)
	var tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).parallel()
	tween.finished.connect(_reset_time_label)
	tween.tween_property(start_timer_time_left_label, "self_modulate:a", 0, tick_time)
	iterations -= 1
	stop_animate = false


func _reset_time_label() -> void:
	if stop_animate: return
	
	start_timer_time_left_label.self_modulate.a = 1
	if iterations > 0:
		animate_time_label()
	else:
		iterations = starting_iterations
		countdown_finished.emit()
		hide()


func _on_peer_disconnected(_id) -> void:
	iterations = starting_iterations
	stop_animate = true
