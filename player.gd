extends CharacterBody2D

var is_carrying = false
var carried_marshmallow = null
var score = 0
@onready var carry_sprite = $CarriedMarshmallow/Sprite2D
@onready var score_label = get_node("/root/Node/Score")
@onready var roasting_spots = get_node("/root/Node/RoastingSpots").get_children()
const Marshmallow = preload("res://Marshmallow.gd")


func _ready():
	$CarriedMarshmallow.visible = false

func pick_up_marshmallow():
	if not is_carrying:
		is_carrying = true
		$CarriedMarshmallow.visible = true
		carried_marshmallow = preload("res://scenes/marshmallow.tscn").instantiate()

func try_place_marshmallow():
	if is_carrying:
		var spot = find_nearest_empty_spot()
		if spot:
			carried_marshmallow.global_position = spot.global_position
			carried_marshmallow.placed = true
			get_parent().add_child(carried_marshmallow)
			is_carrying = false
			$CarriedMarshmallow.visible = false
			carried_marshmallow = null

func try_pick_roasted_marshmallow():
	for spot in roasting_spots:
		for child in spot.get_children():
			if child is Marshmallow and child.ready_for_collection():
				add_score(child.get_score())
				child.queue_free()

func add_score(points):
	score += points
	score_label.text = "Score: %d" % score

func find_nearest_empty_spot():
	for spot in roasting_spots:
		if spot.get_child_count() == 0:
			if global_position.distance_to(spot.global_position) < 32:
				return spot
	return null

func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		if is_carrying:
			try_place_marshmallow()
		else:
			try_pick_roasted_marshmallow()
