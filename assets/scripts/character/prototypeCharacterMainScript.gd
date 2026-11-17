extends CharacterBody3D

### Any @export variable has been added so that dmitri or i can easily
### edit the variable. Usually, if it is not a Node3D or green named
### var, then it is added for dmitri's ease of access.
### thanks bud

#Camera variable with the camera node connected through direct paths.
@onready var cameraPC3D: Node3D = $protoCharCamNode/cameraPC3D

#same here, but for jump velocity of player.
const JUMP_VELOCITY = 6
#This gives us a variable that allows us to manipulate how many jumps
#the game is allowed to give the player.
var jumps_left = 2

#Adds the variable health bar as a progress bar. This allows me to add
#A health bar to the character.
@export var health_bar: ProgressBar 

#Exports the variable of a fistNode for the player's first fist proto
#Basically allows you to chose whichever node is attached to the user
#to be a fist.
@export var fistLeft: Node3D
@export var fistRight: Node3D

#Exports the variable punch_distance so that it can be easily edited
#in the godot editor (for prototyping)
@export var punch_distance: float = 0.5
#Same here, but for punch time
@export var punch_time: float = 0.1
#same here, but for the swing attack time.
@export var swing_time: float = 0.15
#Same here, but for swing attack distance.
@export var swing_distance: float = 2

#Gives the fist starting postion as a vector 3. Does not need to be set
#to something because this can change depending on where the player
#spawns in. 
var fistLeft_start_position: Vector3
var fistRight_start_position: Vector3

#A bunch of variables that are used as metaphoricals to tell whether
#the player is quick stepping, or is about to quick step
var quick_step = true
var quick_stepping = false

#these variables are here to be exported into the inspector for ease
#of access. The normal speed variable is the normal speed of the
#player without quickstepping. The qs speed variable is the speed of
#the quickstep. The qs cooldown is the time it takes before you can
#use qs again. The qs runtime is the distance of the qs and how long
#it lasts.
@export var normal_speed = 7.00
@export var qs_speed = 30.0
@export var qs_cooldown = 5.0
@export var qs_runtime = 0.04

#variable to set current speed to normal speed, lowkey a backassed
#way to set speed in a movement script, but yea thats how we do it.
var current_speed = normal_speed

#Adds the variable max health (the maximum health of the player),
#which, by the way, is also determined by the maximum of the progress
#bar; and the variable current health, which will change over time.
var max_health: float = 100.0
var current_health: float = 100.0

#The input function. If left click is pressed, the call the punch
#function
func _input(event):
	if event.is_action_pressed("left_click"):
		#This makes it run 10 times so that it feels like a rush atk
		for i in range(0, 10):
			#it will run punch 1
			punch1()
			#wait .1 second
			await get_tree().create_timer(0.1).timeout
			#run punch 2
			punch2()
			#wait 1 second
			await get_tree().create_timer(0.1).timeout
			#then repeat another 9 times before ending, all in 
			#quick succession.
			
	#if right click is pressed, swing. I have not written anything
	#into the code for it to be blocked from being used when already
	#using a move. May do that later somewhat, but I want it available
	#for combos.
	if event.is_action_pressed("right_click"):
		swing()
		
#the swing movement and physics function. 
func swing():
	var fistRST = create_tween()

	fistRST.tween_property(
		fistRight,
		"position",
		fistRight_start_position + Vector3(0.0, 0.0, 0.1),
		swing_time * 0.4
	)

	#this gives the first tween property or point. it uses the original
	#variable fistRight, which is the assigned Node3D For the fist
	#on the right side, and it's original starting position. Then,
	#it adds a vector3 point to make it move, along with a swing time
	#multiplied by 0.2
	
	fistRST.tween_property(
		fistRight,
		"position",
		fistRight_start_position + Vector3(-0.2, 0.0, -0.1),
		swing_time * 0.4
	)
	
	fistRST.tween_property(
		fistRight,
		"position",
		fistRight_start_position + Vector3(-0.4, 0.0, -0.2),
		swing_time * 0.4
	)
	
	fistRST.tween_property(
		fistRight,
		"position",
		fistRight_start_position + Vector3(-0.6, -0.0, -0.3),
		swing_time * 0.4
	)
	
	fistRST.tween_property(
		fistRight,
		"position",
		fistRight_start_position + Vector3(-0.7, -0.0, -0.5),
		swing_time * 0.4
	)
	
	fistRST.tween_property(
		fistRight,
		"position",
		fistRight_start_position + Vector3(-0.8, -0.0, -0.7),
		swing_time * 0.4
	)
	
	fistRST.tween_property(
		fistRight,
		"position",
		fistRight_start_position + Vector3(-0.9, 0.0, -0.9),
		swing_time * 0.4
	)
	
	fistRST.tween_property(
		fistRight,
		"position",
		fistRight_start_position + Vector3(-0.8, 0.0, -0.7),
		swing_time * 0.4
	)
	
	fistRST.tween_property(
		fistRight,
		"position",
		fistRight_start_position + Vector3(-0.7, 0.0, -0.5),
		swing_time * 0.4
	)
	fistRST.tween_property(
		fistRight,
		"position",
		fistRight_start_position + Vector3(-0.6, 0.0, -0.3),
		swing_time * 0.4
	)
	
	fistRST.tween_property(
		fistRight,
		"position",
		fistRight_start_position + Vector3(-0.4, 0.0, -0.2),
		swing_time * 0.4
	)
	
	
	fistRST.tween_property(
		fistRight,
		"position",
		fistRight_start_position + Vector3(-0.2, 0.0, -0.1),
		swing_time * 0.4
	)
	
	#arm comes back to the start. That's all there is to it. Not
	#gonna get too in depth into this, but I will try my best to show
	#you it in action and explain it to you if you ask me about it. It
	#is very annoying to tweak, i know that, especially if you're just now
	#learning programming.
	fistRST.tween_property(
		fistRight,
		"position",
		fistRight_start_position + Vector3(0.1, 0.0, 0.1),
		swing_time * 0.4
	)
	
	fistRST.tween_property(
		fistRight,
		"position",
		fistRight_start_position + Vector3(0.0, 0.0, 0.0),
		swing_time * 0.4
	)

#The punch function creates a tween for movement.
func punch1():
	#The variable tween just creates a tween.
	var fistLeftTween = create_tween()
	

	#This tween property simply moves the fist forward, and sets
	#The fist starting position
	fistLeftTween.tween_property(
		fistLeft,
		"position",
		fistLeft_start_position + Vector3(0, 0, -punch_distance),
		punch_time
	)
	


	#Moves the fist back, using that original starting position
	#WITHOUT the extras. Note both use all the variables set above.
	fistLeftTween.tween_property(
		fistLeft,
		"position",
		fistLeft_start_position,
		punch_time
	)
	
#Basically a copy pasted version of punch1 from above. I literally
#just moved the function above to down here and changed the names of
#the variables. Now, we have two fists that move correctly. The
#_input function is what actually does all the work. Without that, 
#both fists would move at the exact same time, or possibly not at all!
func punch2():
	var fistRightTween = create_tween()
	
	fistRightTween.tween_property(
		fistRight,
		"position",
		fistRight_start_position + Vector3(0, 0, -punch_distance),
		punch_time
	)
	
	fistRightTween.tween_property(
		fistRight,
		"position",
		fistRight_start_position,
		punch_time
	)


#On start of game and ready of game, if the health bar is active, then
#the progress bar's max value becomes the max health variable float.
#One the start of game and ready of game, if the health bar is active,
#then the progress bar's current value becomes the current health 
#that the player will start with. This is equivalent to resetting the
#Health bar on game restart and start. This is also a somewhat helpful
#Script for if we decide to add health powerups and debuffs into the
#Game.
func _ready() -> void:
	#On game ready, make the fistLeft starting position just the same
	#as the fist left position. Same for the fist right start position
	fistLeft_start_position = fistLeft.position
	fistRight_start_position = fistRight.position
	#If health bar exists, set the max value of the health bar to max
	#health variable, and the value of the health bar to the current
	#health variable.
	if health_bar:
		health_bar.max_value = max_health
		health_bar.value = current_health

#The take damage function, which is fed in float values. When it is
#called, such as by an enemy, current health will go down by the
#amount given by said enemy. it is important to note we can seperate 
#projectiles, melees and bump-into's from each other as different 
#damager's with different amounts of damage.
func take_damage(amount: float) -> void:

	current_health -= amount
	#The current health = clamp function checks 
	#the current health, and makes sure it never goes below 0 or the 
	#maximum health value. Therefore, at 0 hp, you die.
	current_health = clamp(current_health, 0, max_health)
	
	#If health bar is active, then update it's value to current health.
	if health_bar:
		health_bar.value = current_health

#This is the quick step timer, which i made to make sure that
#quick step indeed does have a cooldown. This makes sure
#that it will stop when needed, and go for as long
#as needed. 
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
	#This refers to gravity. if you are not on the floor, 
	#apply gravity to the player!
	if not is_on_floor():
		velocity += get_gravity() * delta

	#If you are on the floor, reset your jumps to 2 (for double jump)
	if is_on_floor():
		jumps_left = 2
	
	#If you have just pressed jump, and you have more than 0 jumps,
	#then make your velocity towards the sky = to the jump velocity variable
	#and remove one jump. This will automatically stop you from being
	#able to jump again, because it will detect you have jumps_left < 0
	if Input.is_action_just_pressed("kb_jump") and jumps_left > 0:
		velocity.y = JUMP_VELOCITY
		jumps_left -= 1

	# get the variable input_dir, which gives wasd input each frame!
	var input_dir := Input.get_vector(
		"kb_left",
		"kb_right",
		"kb_backward",
		"kb_forward"
	)

	# This gives the camera directions for us in variables.
	var forward := -cameraPC3D.global_transform.basis.z
	var right := cameraPC3D.global_transform.basis.x

	#set the forward and right y planes to 0
	forward.y = 0.0
	right.y = 0.0

	#normalize both forward and right.
	forward = forward.normalized()
	right = right.normalized()

	# Give us our own movement direction, that is normalized, in a variable.
	#(based on where the camera is looking as well) (i know, seems tedious, 
	#BUT its so much better)
	var direction := (right * input_dir.x + forward * input_dir.y).normalized()

	# If you have just pressed shift, or the quickstep button, and the
	#quickstep variable is on (ie you're able to quickstep) and your direction
	#does NOT equal vector3.zero, 
	
	if Input.is_action_just_pressed("shift_qs") and quick_step and direction != Vector3.ZERO:
		#quick_step is now false
		quick_step = false
		#then for a little bit quick stepping is true (which means that you are
		#in the sequence of doing the action)
		quick_stepping = true
		#and the velocity of x and z is equal to our direction times
		#our quickstep speed.
		velocity.x = direction.x * qs_speed
		velocity.z = direction.z * qs_speed

		#then start the quick step timer which starts the cooldown mode for the
		#action, and resets quick_step to true.
		quick_step_timer()

	# if you are NOT quick_stepping, then give normal movement.
	elif not quick_stepping:
		#if your direction is not equal to vector3.zero, then do direction.x/z
		#times your normal speed.
		if direction != Vector3.ZERO:
			velocity.x = direction.x * normal_speed
			velocity.z = direction.z * normal_speed
		#however, if your direction is something else, then movetowards 0 at
		#a normal speed (i think?)
		else:
			velocity.x = move_toward(velocity.x, 0, normal_speed)
			velocity.z = move_toward(velocity.z, 0, normal_speed)

	# allow the character to move.
	move_and_slide()
