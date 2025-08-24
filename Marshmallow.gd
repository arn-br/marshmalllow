extends Node2D
class_name Marshmallow

enum State { RAW, MELTING1, MELTING2, PERFECT, BURNT }

var state = State.RAW
var roast_time = 0.0
var placed = false
var score_given = false

var tile_coords : Marker2D

const MELT1_TIME = 4.0
const MELT2_TIME = 8.0
const PERFECT_TIME = 16.0
const BURNT_TIME = 24.0

@onready var sprite = $Sprite2D

func _ready():
	$Sprite2D.scale = Vector2(0.15, 0.15)  # Make the sprite half size


func _process(delta):
	if placed:
		roast_time += delta
		update_state()
		update_sprite()

func update_state():
	if roast_time >= BURNT_TIME:
		state = State.BURNT
	elif roast_time >= PERFECT_TIME:
		state = State.PERFECT
	elif roast_time >= MELT1_TIME:
		state = State.MELTING1
	elif roast_time >= MELT2_TIME:
		state = State.MELTING2

func update_sprite():
	match state:
		State.RAW:
			sprite.texture = preload("res://pics/mm-raw.png")
		State.MELTING1:
			sprite.texture = preload("res://pics/mm-melted.png")
		State.MELTING2:
			sprite.texture = preload("res://pics/mm-melted2.png")
		State.PERFECT:
			sprite.texture = preload("res://pics/mm-perfect.png")
		State.BURNT:
			sprite.texture = preload("res://pics/mm-burnt.png")

func ready_for_collection():
	return placed and not score_given and state != State.RAW

func get_score():
	score_given = true
	match state:
		State.MELTING1:
			return 5
		State.MELTING2:
			return 5
		State.PERFECT:
			return 10
		State.BURNT:
			return 1
		_:
			return 0
