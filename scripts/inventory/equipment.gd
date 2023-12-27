class_name Equipment
extends Resource

enum EquipmentSlotType {
	LeftHand,
	RightHand
}

@export var left_hand: Weapon
@export var right_hand: Weapon

signal equipment_change

func _init():
	call_deferred("_ready")

func _ready():
	print("Equipment ready ...")
	pass
				
func equip(item: Item, equipment_slot_type: EquipmentSlotType):
	print("Equip")
	match equipment_slot_type:
		EquipmentSlotType.LeftHand:
			left_hand = item
		EquipmentSlotType.RightHand:
			right_hand = item
	equipment_change.emit()
	
func unequip(equipment_slot_type: EquipmentSlotType):
	print("UnEquip")
	match equipment_slot_type:
		EquipmentSlotType.LeftHand:
			left_hand = null
		EquipmentSlotType.RightHand:
			right_hand = null
	equipment_change.emit()
