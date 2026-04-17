extends CharacterBody2D

@export var speed: float = 100.0
@export var pace_distance: float = 200.0  # Total distance to travel before turning
@export var direction: int = 1            # 1 for Right, -1 for Left
@onready var sprite_2d: Sprite2D = $Sprite2D

var start_position: Vector2

func _ready():
	# Record where the enemy starts
	start_position = global_position

func _physics_process(delta):
	
	# Add gravity so it stays on the floor
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Calculate how far we've moved from the start
	var distance_moved = abs(global_position.x - start_position.x)

	# If we've reached the limit, flip direction and reset start point to avoid "drift"
	if distance_moved >= pace_distance:
		direction *= -1
		start_position.x = global_position.x
		
		# Optional: Flip the sprite visually
		$Sprite2D.flip_h = direction < 0

	# Apply horizontal movement
	velocity.x = direction * speed

	move_and_slide()


func _on_test_hide_sprite(value: bool) -> void:
	if value == true:
		sprite_2d.modulate = Color(0.781, 0.0, 0.0, 1.0)
