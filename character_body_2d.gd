extends CharacterBody2D

# -- Tuning of the movement --
const GRAVITY = 900.0
const JUMP_FORCE = 600.0
const CHARGE_SPEED = 400.0
const TRAJECTORY_STEPS = 30     # how many dots to preview
const TRAJECTORY_STEP_DT = .05 # simulated seconds per step

# -- State --
var charge: float = 0.0
var is_charging: bool = false
var is_grounded: bool = false

# -- Parasites host --
var current_host: CharacterBody2D = null

@onready var aim_line: Line2D = $aim_line

func _ready() -> void:
	_update_aim_line()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		is_grounded = true
		velocity.x  = 0.0

# -- move only when grounded
	if is_grounded:
		_handle_input()

	move_and_slide()
# -- Draw line
	_update_aim_line()

# ---------- Input ----------

func _handle_input() -> void:
	if Input.is_action_just_pressed("lmb"):
		_launch()

func _launch() -> void:
	is_grounded = false
	var direction = _get_aim_direction()
	velocity = direction * JUMP_FORCE

# ---------- Helpers ----------

#WIP
func on_enemy_entered(enemy: CharacterBody2D):
	attach_to_host(enemy)
	
#WIP
func attach_to_host(enemy: CharacterBody2D) -> void:
	current_host = enemy
	enemy.add_child(self)


func _get_aim_direction() -> Vector2:
	# get where mouse is moving
	var mouse_world = get_global_mouse_position()
	# make it direction
	var dir = (mouse_world - global_position).normalized()
	# Clamp to upper hemisphere only — parasite cant jump downwards
	if dir.y > 0:
		dir.y = 0
		dir = dir.normalized() if dir.length() > 0 else Vector2.UP
	return dir

# ---------- Visuals ----------

func _update_aim_line() -> void:
	if not is_grounded:
		aim_line.visible = false
		return

	aim_line.visible = true
	var direction = _get_aim_direction()
	var line_len = 80.0   # fixed length now
	aim_line.points = _simulate_trajectory(direction * JUMP_FORCE)

func _simulate_trajectory(launch_velocity: Vector2) -> PackedVector2Array:
	var points = PackedVector2Array()
	var pos = Vector2.ZERO          # start at character's local origin
	var vel = launch_velocity       # same velocity the real jump would use

	for i in TRAJECTORY_STEPS:
		points.append(pos)
		vel.y += GRAVITY * TRAJECTORY_STEP_DT   # same gravity as _physics_process
		pos += vel * TRAJECTORY_STEP_DT         # move forward one simulated step

	return points
