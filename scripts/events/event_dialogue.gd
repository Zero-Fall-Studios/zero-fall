class_name EventDialogue
extends Event

@export var dialogues : Array[String]
@export var time_to_wait_in_beteen_dialogues : float

func run():
  var data = []
  for dialogue in dialogues:
    var obj = {}
    obj["text"] = dialogue
    obj["duration"] = time_to_wait_in_beteen_dialogues
    data.append(obj)
  await Dialogue.show_dialogues(data)
  await super.run()
