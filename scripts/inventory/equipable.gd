extends Item
class_name Equipable

func equip(coords : Vector2):
	PickupSignalBus.equip_event.emit(coords, [self])
	
func unequip(coords : Vector2):
	PickupSignalBus.unequip_event.emit(coords, [self])
