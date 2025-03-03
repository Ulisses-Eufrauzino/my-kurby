extends Control

@onready var coins_counter: Label = $conteiner/coins_conteiner/coins_counter
@onready var timer_counter: Label = $conteiner/timer_conteiner/timer_counter
@onready var score_counter: Label = $conteiner/score_conteiner/score_counter
@onready var life_counter: Label = $conteiner/life_conteiner/life_counter
@onready var clock_timer: Timer = $clock_timer

var minutes = 0
var seconds = 0
@export_range(0,5) var default_minutes := 1
@export_range(0,59) var default_seconds := 0

signal time_is_up()

# Called when the node enters the scene tree for the first time.
func _ready():
	coins_counter.text = str("%04d" % Globlas.coins)
	score_counter.text = str("%06d" % Globlas.score)
	life_counter.text = str("%02d" % Globlas.player_life)
	timer_counter.text = str("%02d" % default_minutes) + ":" + str("%02d" % default_seconds)
	reset_clock_timer()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	coins_counter.text = str("%04d" % Globlas.coins)
	score_counter.text = str("%06d" % Globlas.score)
	life_counter.text = str("%02d" % Globlas.player_life)
	
	if minutes == 0 and seconds == 0:
		emit_signal("time_is_up")


func _on_clock_timer_timeout():
	if seconds == 0:
		if minutes > 0:
			minutes -= 1
			seconds = 60
	seconds -= 1
	
	timer_counter.text = str("%02d" % minutes) + ":" + str("%02d" % seconds)
	
func reset_clock_timer():
	minutes = default_minutes
	seconds = default_seconds
	
	
	
	
