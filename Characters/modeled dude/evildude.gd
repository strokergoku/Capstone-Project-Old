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
@onready var cameraPC3D: Node3D = $camerapivot/springarm/Camera3D

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

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
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

	camerapivot.rotation.x = camera_pitch
	camerapivot.rotation.y = camera_yaw
	
func _physics_process(delta: float) -> void:
		_handle_movement(delta)
		
		move_and_slide()
			
func _handle_movement(delta: float) -> void:
	var input_vector := Input.get_vector(
	"kb_left",
	"kb_right",
	"kb_forward",
	"kb_backward"
	)
		
	if input_vector.length_squared() == 0.0:
		velocity.x = move_toward(velocity.x, 0.0, deceleration * delta)
		velocity.z = move_toward(velocity.z, 0.0, deceleration * delta)
		return
		
	var camera_forward := Vector3(
		-sin(camera_yaw),
		0.0,
		-cos(camera_yaw)
	)

	var camera_right := Vector3(
		cos(camera_yaw),
		0.0,
		-sin(camera_yaw)
	)

	var move_direction := (
		camera_right * input_vector.x
		+ camera_forward * input_vector.y
	).normalized()
			
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
