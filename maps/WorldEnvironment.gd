tool
extends WorldEnvironment

func _ready():
	environment.fog_enabled = !Engine.editor_hint
#	 Engine.editor_hint:
		
