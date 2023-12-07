extends CharacterBody2D


var acceleration = 123.0
var _input_vector: Vector2
var move_speed = 60.0
var hp = 30
var maxhp = 30
var last_movement = Vector2.UP
var time = 0

var experience = 0
var experience_level = 1
var collected_experience = 0

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

# Upgrades
var collected_upgrades = []
var upgrade_options = []
var speed = 0
var additional_attacks = 0
var spell_cooldown = 0

# Spell 1
var spell1_ammo = 0
var spell1_baseammo = 0
var spell1_attackspeed = 1.5
var spell1_level = 0

# Leaf Spell
var leaf_ammo = 0
var leaf_baseammo = 0
var leaf_attackspeed = 3
var leaf_level = 0

# Spear
var spear_ammo = 0
var spear_level = 0

# Alvo na mira
var enemy_close = []

@onready var sprite = $Sprite2D
@onready var walkTimer = get_node("%WalkTimer")

#GUI
@onready var expBar = get_node("%ExperienceBar")
@onready var lblLevel = get_node("%lbl_level")
@onready var levelPanel = get_node("%LevelUp")
@onready var upgradeOptions = get_node("%UpgradeOptions")
@onready var itemOptions = preload("res://Utils/item_option.tscn")
@onready var sndLevelUp = get_node("%snd_levelup")
@onready var healthBar = get_node("%HealthBar")
@onready var lblTimer = get_node("%lblTimer")
@onready var collectedWeapons = get_node("%CollectedWeapons")
@onready var collectedUpgrades = get_node("%CollectedUpgrades")
@onready var itemContainer = preload("res://Player/GUI/item_container.tscn")

@onready var deathPanel = get_node("%DeathPanel")
@onready var lblResult = get_node("%lbl_Result")
@onready var sndVictory = get_node("%snd_win")
@onready var sndLose = get_node("%snd_lose")


func _ready():
	upgrade_character("spell_1_1")
	attack()
	set_expbar(experience, calculate_experiencecap())
	_on_hurtbox_hurt(0,0,0)

func _physics_process(delta):
	move()
	

func move():
	
	if OS.has_feature("mobile"):
		var mov = $CanvasLayer/kjoy.get_joystick_dir()
		
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
	else:
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
	hp -= clamp(damage, 1.0, 999.0)
	healthBar.max_value = maxhp
	healthBar.value = hp
	if hp <= 0:
		death()


func _on_spell_1_timer_timeout():
	spell1_ammo += spell1_baseammo + additional_attacks
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
	leaf_ammo += leaf_baseammo + additional_attacks
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
	var calc_spawns = (spear_ammo + additional_attacks) - get_spear_total
	while calc_spawns > 0:
		var spear_spawn = spear.instantiate()
		spear_spawn.global_position = global_position
		spearBase.add_child(spear_spawn)
		calc_spawns -= 1
	
	var get_spears = spearBase.get_children()
	for i in get_spears:
		if i.has_method("update_spear"):
			i.update_spear()

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




func _on_grab_area_area_entered(area):
	if area.is_in_group("loot"):
		area.target = self


func _on_collect_area_area_entered(area):
	if area.is_in_group("loot"):
		var gem_exp = area.collect()
		calculate_experience(gem_exp)
		

func calculate_experience(gem_exp):
	var exp_required = calculate_experiencecap()
	collected_experience += gem_exp
	if experience + collected_experience >= exp_required: #level up
		collected_experience -= exp_required - experience
		experience_level += 1
		
		experience = 0
		exp_required = calculate_experiencecap()
		levelup()
	else:
		experience += collected_experience
		collected_experience = 0
	
	set_expbar(experience, exp_required)


func calculate_experiencecap():
	var exp_cap = experience_level
	if experience_level < 20:
		exp_cap = experience_level * 5
	elif experience_level < 40:
		exp_cap + 95 * (experience_level-19)*8
	else:
		exp_cap = 255 + (experience_level-39)*12
	
	return exp_cap

func set_expbar(set_value = 1, set_max_value = 100):
	expBar.value = set_value
	expBar.max_value = set_max_value

func levelup():
	sndLevelUp.play()
	lblLevel.text = str("Level: ", experience_level)
	var tween = levelPanel.create_tween()
	tween.tween_property(levelPanel, "position", Vector2(220,50),0.2).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
	tween.play()
	levelPanel.visible = true
	var options = 0
	var optionsmax = 3
	while options < optionsmax:
		var option_choice = itemOptions.instantiate()
		option_choice.item= get_random_item()
		upgradeOptions.add_child(option_choice)
		options += 1

	get_tree().paused = true

func upgrade_character(upgrade):
	match upgrade:
		"spell_1_1":
			spell1_level = 1
			spell1_baseammo += 1
		"spell_1_2":
			spell1_level = 2
			spell1_baseammo += 1
		"spell_1_3":
			spell1_level = 3
			spell1_baseammo += 1
		"spell_1_4":
			spell1_level = 4
			spell1_baseammo += 2
		"leaf_spell_1":
			leaf_level = 1
			leaf_baseammo += 1
		"leaf_spell_2":
			leaf_level = 2
			leaf_baseammo += 1
		"leaf_spell_3":
			leaf_level = 3
			leaf_attackspeed -= 0.5
		"leaf_spell_4":
			leaf_level = 4
			leaf_baseammo += 1
		"spear_1":
			spear_level = 1
			spear_ammo += 1
		"spear_2":
			spear_level = 2
		"spear_3":
			spear_level = 3
		"spear_4":
			spear_level = 4
		"bota_1", "bota_2", "bota_3", "bota_4":
			move_speed += 20.0
		"ring_1", "ring_2":
			additional_attacks += 1
		"food":
			hp += 20
			hp = clamp(hp, 0, maxhp)
			healthBar.value = hp
			
	adjust_gui_collection(upgrade)
	attack()
	var option_children = upgradeOptions.get_children()
	for i in option_children:
		i.queue_free()
	upgrade_options.clear()
	collected_upgrades.append(upgrade)
	levelPanel.visible = false
	levelPanel.position = Vector2(800,50)
	get_tree().paused = false
	calculate_experience(0)

func get_random_item():
	var dblist = []
	for i in UpgradeDb.UPGRADES:
		if i in collected_upgrades:
			pass
		elif i in upgrade_options:
			pass
		elif UpgradeDb.UPGRADES[i]["type"] == "item":
			pass
		elif UpgradeDb.UPGRADES[i]["prerequesite"].size() > 0:
			var to_add = true
			for n in UpgradeDb.UPGRADES[i]["prerequesite"]:
				if not n in collected_upgrades:
					to_add = false
			if to_add:
				dblist.append(i)
		else:
			dblist.append(i)
	if dblist.size() > 0:
		var randomitem = dblist.pick_random()
		upgrade_options.append(randomitem)
		return randomitem
	else: 
		return null


func change_time(argtime = 0):
	time = argtime
	var get_m = int(time/60.0)
	var get_s = time % 60
	if get_m < 10:
		get_m = str(0,get_m)
	if get_s < 10:
		get_s = str(0,get_s)
	lblTimer.text = str(get_m, ":", get_s)


func adjust_gui_collection(upgrade):
	var get_upgraded_displaynames = UpgradeDb.UPGRADES[upgrade]["displayname"]
	var get_type = UpgradeDb.UPGRADES[upgrade]["type"]
	if get_type != "item":
		var get_collected_displaynames = []
		for i in collected_upgrades:
			get_collected_displaynames.append(UpgradeDb.UPGRADES[i]["displayname"])
		if not get_upgraded_displaynames in get_collected_displaynames:
			var new_item = itemContainer.instantiate()
			new_item.upgrade = upgrade
			match get_type:
				"weapon":
					collectedWeapons.add_child(new_item)
				"upgrade":
					collectedUpgrades.add_child(new_item)
					

func death(is_boss_defeated=false):
	deathPanel.visible = true
	get_tree().paused = true
	var tween = deathPanel.create_tween()
	tween.tween_property(deathPanel, "position", Vector2(220,50),3.0).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()
	if is_boss_defeated:
		lblResult.text = "You Win"
		sndVictory.play()
	else:
		lblResult.text = "You Lose"
		sndLose.play()
		
	
	


func _on_btn_menu_click_end():
	get_tree().paused = false
	var _level = get_tree().change_scene_to_file("res://TitleScreen/menu.tscn")
