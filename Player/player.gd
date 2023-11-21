extends CharacterBody2D

var move_speed = 60.0
var hp = 5
var last_movement = Vector2.UP

# Ataques
var spell1 = preload("res://Player/Attack/spell_1.tscn")
var leaf = preload("res://Player/Attack/leaf_spell.tscn")
var spear = preload("res://Player/Attack/spear.tscn")

# AtaqueNodes
@onready var spell1Timer = get_node("%Spell1Timer")
@onready var spell1AttackTimer = get_node("%Spell1AttackTimer")
@onready var leafTimer = get_node("%LeafTimer")
@onready var leafAttackTimer = get_node("%LeafAttackTimer")
@onready var spearBase = get_node("%SpearBase")

# Spell 1
var spell1_ammo = 0
var spell1_baseammo = 1
var spell1_attackspeed = 1.5
var spell1_level = 0

# Leaf Spell
var leaf_ammo = 0
var leaf_baseammo = 5
var leaf_attackspeed = 3
var leaf_level = 0

# Spear
var spear_ammo = 1
var spear_level = 1

# Alvo na mira
var enemy_close = []

@onready var sprite = $Sprite2D
@onready var walkTimer = get_node("%WalkTimer")

func _ready():
	attack()
	

func _physics_process(delta):
	move()
	
func move():
	var x = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y = Input.get_action_strength("down") - Input.get_action_strength("up")
	var mov = Vector2(x, y)
	
	# Adicionando animacao
	if mov.x > 0:
		sprite.flip_h = true
	elif mov.x < 0:
		sprite.flip_h = false
	
	if mov != Vector2.ZERO:
		last_movement = mov
		if walkTimer.is_stopped():
			if sprite.frame >= sprite.hframes - 1:
				sprite.frame = 0
			else:
				sprite.frame += 1
			
			walkTimer.start()
			
	
	velocity = mov.normalized() * move_speed
	move_and_slide()


func attack():
	if spell1_level > 0:
		spell1Timer.wait_time = spell1_attackspeed
		if spell1Timer.is_stopped():
			spell1Timer.start()
	
	if leaf_level > 0:
		leafTimer.wait_time = leaf_attackspeed
		if leafTimer.is_stopped():
			leafTimer.start()
	
	if spear_level > 0:
		spawn_spear()


func _on_hurtbox_hurt(damage, _angle, _knockback):
	hp -= damage
	print(hp)


func _on_spell_1_timer_timeout():
	spell1_ammo += spell1_baseammo
	spell1AttackTimer.start()


func _on_spell_1_attack_timer_timeout():
	if spell1_ammo > 0:
		var spell1_attack = spell1.instantiate()
		spell1_attack.position = position
		spell1_attack.target = get_random_target()
		spell1_attack.level = spell1_level
		add_child(spell1_attack)
		spell1_ammo -= 1
		if spell1_ammo > 0:
			spell1AttackTimer.start()
		else:
			spell1AttackTimer.stop()


func _on_leaf_timer_timeout():
	leaf_ammo += leaf_baseammo
	leafAttackTimer.start()


func _on_leaf_attack_timer_timeout():
	if leaf_ammo > 0:
		var leaf_attack = leaf.instantiate()
		leaf_attack.position = position
		leaf_attack.last_movement = last_movement
		leaf_attack.level = leaf_level
		add_child(leaf_attack)
		leaf_ammo -= 1
		if leaf_ammo > 0:
			leafAttackTimer.start()
		else:
			leafAttackTimer.stop()

func spawn_spear():
	var get_spear_total = spearBase.get_child_count()
	var calc_spawns = spear_ammo - get_spear_total
	while calc_spawns > 0:
		var spear_spawn = spear.instantiate()
		spear_spawn.global_position = global_position
		spearBase.add_child(spear_spawn)
		calc_spawns -= 1

func get_random_target():
	if enemy_close.size() > 0:
		return enemy_close.pick_random().global_position
	else:
		return Vector2.UP

func _on_enemy_detection_area_body_entered(body):
	if not enemy_close.has(body):
		enemy_close.append(body)


func _on_enemy_detection_area_body_exited(body):
	if enemy_close.has(body):
		enemy_close.erase(body)


