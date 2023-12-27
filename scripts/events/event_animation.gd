class_name EventAnimation
extends Event

@export var animation_player: AnimationPlayer
@export var animation_name : String

func run():
  animation_player.play(animation_name)
  await super.run()
