extends CharacterBody2D

@export var speed = 400

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed

func _physics_process(delta):
	get_input()
	move_and_slide()
	
var is_carrying = false
var carried_marshmallow = null
var score = 0
@onready var carry_sprite = $CarriedMarshmallow/Sprite2D
@onready var score_label = get_node("/root/Node/Score")
@onready var roasting_spots = get_node("/root/Node/RoastingSpots").get_children()

var spot_marshmallow_map = {}

func _ready():
	$CarriedMarshmallow.visible = false
	roasting_spots = get_node("/root/Node/RoastingSpots").get_children()

	spot_marshmallow_map = {}

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if is_carrying:
			var mouse_pos = event.position
			for spot in roasting_spots:
				if spot.global_position.distance_to(mouse_pos) < 16: 
					if not spot_marshmallow_map.has(spot):
						place_marshmallow_on_spot(spot)
						break
		else:
			try_pick_roasted_marshmallow(event.position)

func pick_up_marshmallow():
	if not is_carrying:
		is_carrying = true
		$CarriedMarshmallow.visible = true
		carried_marshmallow = preload("res://scenes/marshmallow.tscn").instantiate()

func place_marshmallow_on_spot(spot):
	if spot != null and not spot_marshmallow_map.has(spot):
		var marshmallow = preload("res://scenes/marshmallow.tscn").instantiate()
		marshmallow.global_position = spot.global_position
		marshmallow.placed = true
		marshmallow.tile_coords = spot
		get_parent().add_child(marshmallow)
		
		spot_marshmallow_map[spot] = marshmallow

		is_carrying = false
		$CarriedMarshmallow.visible = false
	else:
		return

func try_pick_roasted_marshmallow(mouse_pos: Vector2):
	if is_carrying:
		return

	for spot in roasting_spots:
		if spot.global_position.distance_to(mouse_pos) < 16:
			if spot_marshmallow_map.has(spot):
				var marshmallow = spot_marshmallow_map[spot]
				if marshmallow.ready_for_collection():
					add_score(marshmallow.get_score())
					marshmallow.queue_free()
					spot_marshmallow_map.erase(spot)
					break

func add_score(points):
	score += points
	score_label.text = "Score: %d" % score

func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		print("pick pressed!")
		pick_up_marshmallow()
