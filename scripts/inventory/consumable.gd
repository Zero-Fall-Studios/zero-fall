extends Item
class_name Consumable

@export var consume_on_pickup: bool = false

@export_group("Effects")
@export var health : int = 0
@export var armor : int = 0