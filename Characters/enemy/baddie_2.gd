extends CharacterBody3D

@onready var player: CharacterBody3D = %entity_1_player

# Adds the variable health bar as a progress bar.
@export var healthBarPC: ProgressBar

@export var detectionDistance := 10.0
@export var loseDistance := 11.0
@export var movementSpeed := 5.0
@export var lookSpeed := 1.5

var isChasing := false
var lineOfSight := 0.0
var lineOfDirection := 1.0

@onready var navAgent: NavigationAgent3D = %EnemyNavAgent
@onready var headVisionPoint: Node3D = %HeadVisionPoint

var maxHealth: float = 100.0
var currentHealth: float = 100.0

var stunned: bool = false


func _ready() -> void:
	if healthBarPC:
		healthBarPC.max_value = maxHealth
		healthBarPC.value = currentHealth


func take_damage(amount: float) -> void:
	currentHealth -= amount
	currentHealth = clamp(currentHealth, 0, maxHealth)

	if healthBarPC:
		healthBarPC.value = currentHealth

	velocity.x = 0
	velocity.z = 0

	stunned = true
	await get_tree().create_timer(0.5).timeout
	stunned = false


func lookAround(delta):
	lineOfSight += lookSpeed * lineOfDirection * delta

	if lineOfSight >= PI / 2:
		lineOfSight = PI / 2
		lineOfDirection = -1.0

	elif lineOfSight <= -PI / 2:
		lineOfSight = -PI / 2
		lineOfDirection = 1.0

	headVisionPoint.rotation.y = lineOfSight


func chasePlayer():
	var distance = global_position.distance_to(player.global_position)

	if distance > loseDistance:
		isChasing = false
		velocity = Vector3.ZERO
		return

	if not wallCheck():
		isChasing = false
		velocity = Vector3.ZERO
		return

	var direction = global_position.direction_to(player.global_position)

	velocity = direction * movementSpeed

func wallCheck() -> bool:
	var start = headVisionPoint.global_position
	var end = player.global_position

	var query = PhysicsRayQueryParameters3D.create(
		start,
		end
	)

	query.exclude = [self]

	var result = get_world_3d().direct_space_state.intersect_ray(query)

	if result.is_empty():
		return false

	return result.collider == player


func checkForPlayer():
	var distance = global_position.distance_to(player.global_position)

	if distance > detectionDistance:
		return

	var directionToPlayer: Vector3 = (
		player.global_position - headVisionPoint.global_position
	).normalized()

	var forward: Vector3 = (
		-headVisionPoint.global_transform.basis.z
	).normalized()

	var dot: float = forward.dot(directionToPlayer)

	# Player must be inside the 180-degree field of view.
	if dot <= 0.0:
		return

	# Player must have a clear line of sight.
	if not wallCheck():
		return

	isChasing = true


func _physics_process(delta):
	if player == null:
		velocity = Vector3.ZERO
		move_and_slide()
		return

	if stunned:
		velocity.x = 0
		velocity.z = 0
		move_and_slide()
		return

	lookAround(delta)

	if isChasing:
		chasePlayer()
	else:
		checkForPlayer()

	move_and_slide()
