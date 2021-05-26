extends Position3D

export(NodePath) onready var holder_path
onready var holder = get_node(holder_path)

export(NodePath) onready var raycast_path
onready var raycast = get_node(raycast_path)


