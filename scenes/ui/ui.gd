extends CanvasLayer
@onready var label_health : Label = $LabelHealth
@onready var player : PlayerGrapple = %PlayerGrapple

func _ready():
	var callable = Callable(self, "_health_change")
	player.connect("health_change", callable)

func _health_change(health):
	label_health.text = "HP - " + str(health)
