extends Node3D

#Add an export for the character (basically you can assign a custom characterBody3D variable to the camera now)
@export var character: CharacterBody3D

#Add an export var for mouse sens, editable from camera pivot
@export var mouse_sens: float = 0.001

#Add an export var for the max and min pitches, editable from camera pivot
@export var max_pitch: float = 0.8
@export var min_pitch: float = -0.5

#Add Yaw and Pitch Float Variables
var yaw: float = 0.0
var pitch: float = 0.0

#on camera ready, we make sure that the mouse is captured into the
#screen so the mouse does not drag off the page. especially useful
#for dual monitor players.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

#On input read, if esc is pressed (ui_cancel) then if mouse_mode
#is already captured, make the mouse visible. If mouse mode is not
#captured, make the mouse captured.
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
#If the input event is the mouse moving, then capture the mouse and
#make the camera look and move.
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			camera_look(event.relative)

#This is the camera movement function. (Add more about transform.basis,
#character.transform.basis, etc)
func camera_look(mouse_movement: Vector2) -> void:
	#when you move the mouse left or right, it will horizontally move
	#the camera.
	yaw -= mouse_movement.x * mouse_sens

	#When you move the mouse up or down, it will vertically move the
	#camera.
	pitch -= mouse_movement.y * mouse_sens
	
	#this limits the pitch, or vertical movement, of the camera.
	pitch = clamp(pitch, min_pitch, max_pitch)

	
	#This will make sure that the camera pivot is rotated on y AND x
	rotation.x = pitch

	# this makes sure the character is rotated with the camera's yaw.
	character.rotation.y = yaw
