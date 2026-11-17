extends CharacterBody3D

#I have recently revamped the entire dude main script.

@export_category("Movement")
@export var move_speed: float = 4.5
@export var acceleration: float = 18.0
@export var deceleration: float = 22.0
@export var rotation_speed: float = 10.0

@export_category("Camera")
@export var mouse_sensitivity: float = 0.003
@export var camera_pitch_min: float = -50.0
@export var camera_pitch_max: float = 35.0

@onready var camerapivot: Node3D = $camerapivot

var camera_pitch: float = 0.0
@onready var cameraPC3D: Node3D = $camerapivot/springarm/unusedcam

var camera_yaw: float = 0.0

@export_category("Quickstep")
@export var normal_speed = 7.00
@export var qs_speed = 30.0
@export var qs_cooldown = 5.0
@export var qs_runtime = 0.04

var quick_step = true
var quick_stepping = false

var current_speed = normal_speed

const JUMP_VELOCITY = 6

var jumps_left = 2

@onready var camera_rig: Node3D = %CameraRig

func _ready() -> void:
	# Tell the camera who it should follow.
	camera_rig.target = self
	
func quick_step_timer():
	#Recall that qs_runtime is an export variable.
	#Putting it here allows us to edit it very quickly.
	await get_tree().create_timer(qs_runtime).timeout
	
	quick_stepping = false
	
	#Same with qs_cooldown.
	await get_tree().create_timer(qs_cooldown).timeout
	
	quick_step = true
	
#The function physics process sets up all the physics movements for
#the player to use.
func _physics_process(delta):
	
	_handle_movement(delta)

	move_and_slide()
	
func _handle_movement(delta):
	
	var input_dir := Input.get_vector(
		"kb_left",
		"kb_right",
		"kb_backward",
		"kb_forward"
	)
	
	if input_dir.length_squared() == 0.0:

		velocity.x = move_toward(
			velocity.x,
			0.0,
			deceleration * delta
		)

		velocity.z = move_toward(
			velocity.z,
			0.0,
			deceleration * delta
		)

		return


	if not is_on_floor():
		velocity += get_gravity() * delta

	if is_on_floor():
		jumps_left = 2

	if Input.is_action_just_pressed("kb_jump") and jumps_left > 0:
		velocity.y = JUMP_VELOCITY
		jumps_left -= 1
		
	var forward := -camera_rig.global_transform.basis.z
	var right := camera_rig.global_transform.basis.x

#set the forward and right y planes to 0
	forward.y = 0.0
	right.y = 0.0

	#normalize both forward and right.
	forward = forward.normalized()
	right = right.normalized()

	var move_direction = (
		right * input_dir.x
		+ forward * input_dir.y
	).normalized()
	
	var target_velocity = move_direction * move_speed
	
	velocity.x = move_toward(
		velocity.x,
		target_velocity.x,
		acceleration * delta
	)

	velocity.z = move_toward(
		velocity.z,
		target_velocity.z,
		acceleration * delta
	)
	
	var target_angle := atan2(
		move_direction.x,
		move_direction.z
	)

	rotation.y = lerp_angle(
		rotation.y,
		target_angle,
		rotation_speed * delta
	)
	
	if Input.is_action_just_pressed("shift_qs") and quick_step and move_direction != Vector3.ZERO:
		#quick_step is now false
		quick_step = false
		#then for a little bit quick stepping is true (which means that you are
		#in the sequence of doing the action)
		quick_stepping = true
		#and the velocity of x and z is equal to our direction times
		#our quickstep speed.
		velocity.x = move_direction.x * qs_speed
		velocity.z = move_direction.z * qs_speed
		
		#then start the quick step timer which starts the cooldown mode for the
		#action, and resets quick_step to true.
		quick_step_timer()
	# allow the character to move.
	move_and_slide()
