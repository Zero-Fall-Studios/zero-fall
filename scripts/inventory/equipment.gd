class_name Equipment
extends Resource

enum EquipmentSlotType {
	LeftHand,
	RightHand
}

@export var left_hand: Weapon
@export var right_hand: Weapon

signal on_equip(item: Item, equipment_slot_type: EquipmentSlotType)
signal on_unequip(equipment_slot_type: EquipmentSlotType)

# func _init():
# 	call_deferred("_ready")

# func _ready():
# 	print("Equipment ready ...")
# 	pass
				
func equip(item: Item, equipment_slot_type: EquipmentSlotType):
	match equipment_slot_type:
		EquipmentSlotType.LeftHand:
			left_hand = item
		EquipmentSlotType.RightHand:
			right_hand = item
	on_equip.emit(item, equipment_slot_type)
	
func unequip(equipment_slot_type: EquipmentSlotType):
	match equipment_slot_type:
		EquipmentSlotType.LeftHand:
			left_hand = null
		EquipmentSlotType.RightHand:
			right_hand = null
	on_unequip.emit(equipment_slot_type)
