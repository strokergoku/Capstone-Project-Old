#Script by Max Ambrose Graves
#last updated 8/20/2026
extends CharacterBody3D

@onready var entity_1_player = %entity_1_player

#Adds the variable health bar as a progress bar. This allows me to add
#A health bar to the character.
@export var healthBarPC: ProgressBar 

#Adds the variable max health (the maximum health of the player),
#which, by the way, is also determined by the maximum of the progress
#bar; and the variable current health, which will change over time.
var maxHealth: float = 100.0
var currentHealth: float = 100.0

var stunned: bool = false

#On start of game and ready of game, if the health bar is active, then
#the progress bar's max value becomes the max health variable float.
#One the start of game and ready of game, if the health bar is active,
#then the progress bar's current value becomes the current health 
#that the player will start with. This is equivalent to resetting the
#Health bar on game restart and start. This is also a somewhat helpful
#Script for if we decide to add health powerups and debuffs into the
#Game.
func _ready() -> void:
	if healthBarPC:
		healthBarPC.max_value = maxHealth
		healthBarPC.value = currentHealth

#The take damage function, which is fed in float values. When it is
#called, such as by an enemy, current health will go down by the
#amount given by said enemy. The current health = clamp function checks 
#the current health, and makes sure it never goes below 0 or the 
#maximum health value. Therefore, at 0 hp, you die. it is important to 
#note we can seperate projectiles, melees and bump-into's from each
#as different damager's with different amounts of damage.
func take_damage(amount: float) -> void:
	currentHealth -= amount
	currentHealth = clamp(currentHealth, 0, maxHealth)
	
	#If health bar is active, then update it's value to current health.
	if healthBarPC:
		healthBarPC.value = currentHealth
		
		#Stop the enemy from moving immediately as a stun effect for the
		#damage taken. This makes the damage feel more real!
		velocity.x = 0
		velocity.z = 0
		
		#Stun the enemy for 1 second.
		stunned = true
		await get_tree().create_timer(0.5).timeout
		stunned = false

#This function is for moving physics bodies. Here, were are using it to
#move and update the enemy to the location of the player no matter
#where the enemy is. This helps us with prototyping things such as
#encounters, fights, and health systems.
func _physics_process(delta):
	#stun the enemy to stop the player chase
	if stunned:
		#this sets the enemy's horizontal movement to 0 so it cannot
		#move.
		velocity.x = 0
		velocity.z = 0 
		move_and_slide()
		return
		
	#If it can find %protoChar, then:
	if entity_1_player:
		#Set the variable direction to protocharacter's global
		#position minus the real global position of the enemy. This
		#basically subtracts the 
		var direction = entity_1_player.global_position - global_position
		# Set direction.y to zero.
		direction.y = 0
		#Normalize the direction
		direction = direction.normalized()
		
		
		#Basically starts moving the enemy immediately to the
		#location of the player as soon as possible. Does not
		#care about walls being in between player and enemy,
		#or height.
		
		#Note to team: we need to change this to a raycast
		#version of this script, so if rays going in a certain area
		#hit the player, then the enemy will start moving to the player
		# or something similar, being blocked and stopping with walls, etc.

		#Set the velocity.x to direction.x * 2.5
		velocity.x = direction.x * 2.5
		#Set the velocity.z to direction.z * 2.5
		velocity.z = direction.z * 2.5
		
		#get gravity for the enemy!
		if not is_on_floor():
			velocity += get_gravity() * delta

	#make the enemy start moving!
	move_and_slide()
