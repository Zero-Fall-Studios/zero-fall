class_name UI
extends CanvasLayer
@export var label_health : Label
@export var label_armor : Label
@export var left_hand : TextureRect
@export var right_hand : TextureRect
@export var left_bar : ColorRect
@export var right_bar : ColorRect
@export var player : Character

func _ready():
	if player:
		player.health_changed.connect(_on_health_changed)
		player.armor_changed.connect(_on_armor_changed)
		player.inventory.equipment.on_equip.connect(_on_equip)
		player.inventory.equipment.on_unequip.connect(_on_unequip)

func _on_health_changed(health: int, health_max: int):
	label_health.text = str(health)
	update_health_bar(health, health_max)

func _on_armor_changed(armor: int, armor_max: int):
	label_armor.text = str(armor)
	update_armor_bar(armor, armor_max)

func _on_equip(item: Item, equipment_slot_type: Equipment.EquipmentSlotType):
	match equipment_slot_type:
		Equipment.EquipmentSlotType.LeftHand:
			left_hand.texture = item.texture
		Equipment.EquipmentSlotType.RightHand:
			right_hand.texture = item.texture

func _on_unequip(equipment_slot_type: Equipment.EquipmentSlotType):
	match equipment_slot_type:
		Equipment.EquipmentSlotType.LeftHand:
			left_hand.texture = null
		Equipment.EquipmentSlotType.RightHand:
			right_hand.texture = null

func update_health_bar(health: int, health_max: int):
	var health_percentage = float(health) / float(health_max)
	if health_percentage >= 1:
		health_percentage = 1
	left_bar.size.x = 15 * health_percentage

func update_armor_bar(armor: int, armor_max: int):
	var armor_percentage = float(armor) / float(armor_max)
	if armor_percentage >= 1:
		armor_percentage = 1
	right_bar.size.x = 15 * armor_percentage
		