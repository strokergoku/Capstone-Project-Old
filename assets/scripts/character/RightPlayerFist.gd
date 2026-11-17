extends Area3D

#This variable sets the damage of this area3d. I call it light damage
#for the normal attack, and medium damage for the swinging attack.
@export var light_damage: float = 1.0
@export var med_damage: float = 5.0


#This function automatically runs on game ready.
func _ready() -> void:
	#When the game starts, make sure to run the function
	#_on_body_entered specifically when body_entered happens, or when
	#Area3D hits a body.
	body_entered.connect(_on_left_click)
	body_entered.connect(_on_right_click)

#This function says that if a body, like a node3d, has a function
#method "take_damage," then it will take the projectile damage given.
#This can be especially useful in the future for damage subtypes and
#different types of enemies.
func _on_left_click(body: Node3D) -> void:
	#If the body has the method take_damage:
	if body_entered.connect(_on_left_click) and Input.is_action_pressed("left_click"):
		if body.has_method("take_damage"):
			#Then give it the light damage damage
			body.take_damage(light_damage)
		
#This function is the SAME as _on_left_click, EXCEPT: if it does NOT
#connect and  right click at the same time, then, take light damage!
#(ie just do a normal attack. I think i have some bugs with this so
#may take it out idk)
func _on_right_click(body: Node3D) -> void:
	if body_entered.connect(_on_right_click) and Input.is_action_pressed("right_click"):
		if body.has_method("take_damage"):
			body.take_damage(med_damage)
		else:
			body.take_damage(light_damage)
