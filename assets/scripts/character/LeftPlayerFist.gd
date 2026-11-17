extends Area3D

#This variable sets the damage of this area3d. I called it projectile
#damage because i was being lazy and following a tutorial. it does
#one damage for simple prototyping.
@export var light_damage: float = 1.0

#This function automatically runs on game ready.
func _ready() -> void:
	#When the game starts, make sure to run the function
	#_on_body_entered specifically when body_entered happens, or when
	#Area3D hits a body.
	body_entered.connect(_on_left_click)

#This function says that if a body, like a node3d, has a function
#method "take_damage," then it will take the projectile damage given.
#This can be especially useful in the future for damage subtypes and
#different types of enemies.
func _on_left_click(body: Node3D) -> void:
	#If the body has the method take_damage
	if body.has_method("take_damage"):
		#Then give it the projectile damage
		body.take_damage(light_damage)
