class_name EventScene
extends Event

@export var show_black_screen : bool = false
@export var fade_in : bool = false
@export var fade_out : bool = false
@export var fade_in_text : String

func run():
  if show_black_screen:
    SceneManager.show_black_screen()
  if fade_in:
    if fade_in_text:
      SceneManager.fade_in_text(fade_in_text)
    else:
      SceneManager.fade_in()
  if fade_out:
    SceneManager.fade_out()
  await super.run()
