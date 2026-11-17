extends CharacterBody3D


@export_category("Movement")
@export var move_speed: float = 4.5
@export var acceleration: float = 18.0
@export var deceleration: float = 22.0
@export var rotation_speed: float = 10.0


@export_category("Camera")
@export var mouse_sensitivity: float = 0.003
@export var camera_pitch_min: float = -50.0
@export var camera_pitch_max: float = 35.0
@export var camera_follow_speed: float = 15.0


@export_category("Quickstep")
@export var normal_speed: float = 7.0
@export var qs_speed: float = 30.0
@export var qs_cooldown: float = 5.0
@export var qs_runtime: float = 0.04


var quick_step := true
var quick_stepping := false

var current_speed := normal_speed


var camera_yaw: float = 0.0
var camera_pitch: float = 0.0


const JUMP_VELOCITY := 6.0

var jumps_left := 2


@onready var camera_rig: Node3D = $CameraRig
@onready var camera_pivot: Node3D = $CameraRig/CameraPivot


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	# Start camera at player's position.
	camera_rig.global_position = global_position


func _unhandled_input(event: InputEvent) -> void:

	if event is InputEventMouseMotion:
		_rotate_camera(event.relative)

	elif event is InputEventKey:

		if event.pressed and event.keycode == KEY_ESCAPE:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _rotate_camera(mouse_delta: Vector2) -> void:

	camera_yaw -= mouse_delta.x * mouse_sensitivity

	camera_pitch -= mouse_delta.y * mouse_sensitivity

	camera_pitch = clamp(
		camera_pitch,
		deg_to_rad(camera_pitch_min),
		deg_to_rad(camera_pitch_max)
	)

	# CameraRig controls horizontal rotation.
	camera_rig.global_rotation.y = camera_yaw

	# CameraPivot controls vertical rotation.
	camera_pivot.rotation.x = camera_pitch


func _physics_process(delta: float) -> void:

	_follow_player(delta)
	_handle_movement(delta)

	move_and_slide()


func _follow_player(delta: float) -> void:

	camera_rig.global_position = camera_rig.global_position.lerp(
		global_position,
		camera_follow_speed * delta
	)


func _handle_movement(delta: float) -> void:

	var input_vector := Input.get_vector(
		"kb_left",
		"kb_right",
		"kb_backward",
		"kb_forward"
	)


	# No movement input.
	if input_vector.length_squared() == 0.0:

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


	# Camera-relative directions.
	var camera_forward := -camera_rig.global_transform.basis.z
	var camera_right := camera_rig.global_transform.basis.x


	# Ignore camera pitch.
	camera_forward.y = 0.0
	camera_right.y = 0.0

	camera_forward = camera_forward.normalized()
	camera_right = camera_right.normalized()


	# Calculate movement direction.
	var move_direction := (
		camera_right * input_vector.x
		+ camera_forward * input_vector.y
	).normalized()


	# Movement velocity.
	var target_velocity := move_direction * move_speed


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


	# Rotate Player toward movement direction.
	var target_angle := atan2(
		move_direction.x,
		move_direction.z
	)

	rotation.y = lerp_angle(
		rotation.y,
		target_angle,
		rotation_speed * delta
	)
