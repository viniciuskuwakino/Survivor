extends ColorRect

@onready var lblName = $lbl_name
@onready var lblDescription = $lbl_description
@onready var lblLevel = $lbl_level
@onready var itemIcon = $ColorRect/ItemIcon

var mouse_over = false
var item = null
var is_mobile = false
@onready var player = get_tree().get_first_node_in_group("player")

signal selected_upgrade(upgrade)

func _ready():
	if OS.has_feature("mobile"):
		is_mobile = true
		
		
	connect("selected_upgrade", Callable(player,"upgrade_character"))
	if item == null:
		item = "food"
	lblName.text = UpgradeDb.UPGRADES[item]["displayname"]
	lblDescription.text = UpgradeDb.UPGRADES[item]["details"]
	lblLevel.text = UpgradeDb.UPGRADES[item]["level"]
	itemIcon.texture = load(UpgradeDb.UPGRADES[item]["icon"])

func _input(event):
	if is_mobile == false:
		if event.is_pressed():
			if mouse_over:
				print("ITEM: " + item)
				emit_signal("selected_upgrade", item)
	#print(event is InputEventScreenTouch)
	##print(event.is_pressed())
	#if event.is_pressed():
		#print(item)
	
	#if event is InputEventScreenTouch and event.is_pressed():
		#print("Clicou")
	
	#if event.is_action("click"):
		##print("ITEM: " + item)
		##if item:
			##print(item)
	


func _on_mouse_entered():
	mouse_over = true


func _on_mouse_exited():
	mouse_over = false


func _on_gui_input(event):
	if is_mobile == true:
		if event.is_action("click"):
			emit_signal("selected_upgrade", item)
