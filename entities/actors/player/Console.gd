extends Control

var is_open = false
var max_lines = 1000
const line_width : int = 15
var current_scroll_line = 0

onready var CommandLine = $CommandLine
onready var CommandText:RichTextLabel = $CommandText

#TODO: pause the game/prevent movement when console is up

func _ready():
	Master.console = self

func _process(delta):
	var visible_lines = CommandText.rect_size.y/line_width -1
	#TODO: add previous command list you can access with arrows
	#TODO: add command completion with tab
	if Input.is_action_just_pressed("open_debug_console"):
		if !visible:
			open()
		elif visible :
			close()
	if is_open:
		if Input.is_action_just_pressed("enter_command")&&!CommandLine.text.empty():
			var linetext = CommandLine.text
			linetext = CmdHelp.clean_cmd(linetext)
			if linetext.empty():
				CommandLine.text = ""
			else:
				print_output("> "+CmdHelp.unescape_spaces(linetext))
				Master.enter_command(linetext)
				CommandLine.text = ""
		if Input.is_action_just_pressed("console_up"):
			scroll_to_line(clamp(current_scroll_line-visible_lines,0, clamp(CommandText.get_line_count()-visible_lines-1,0,CommandText.get_line_count()-1)))
		if Input.is_action_just_pressed("console_down"):
			scroll_to_line(clamp(current_scroll_line+visible_lines,0, clamp(CommandText.get_line_count()-visible_lines-1,0,CommandText.get_line_count()-1)))
		

func open():
	#Master.gui_entered()
	if CommandLine.text.find("²")== 0:
		CommandLine.text = ""
	if CommandLine.text.find("`")== 0:
		CommandLine.text = ""
	is_open = true
	CommandLine.grab_focus()
	show()

func close():
	#Master.gui_exited()
	is_open = false
	hide()

func print_output(text:String,color:Color = Color.white):
	text = ""+text
	CommandText.push_color(color)
	CommandText.add_text(text)
	CommandText.pop()
	CommandText.newline()
	var visible_lines = CommandText.rect_size.y/line_width -1
	scroll_to_line(clamp(CommandText.get_line_count()-visible_lines-1,0,CommandText.get_line_count()-1))
	remove_excess_lines()

func scroll_to_line(line:int):
	CommandText.scroll_to_line(line)
	current_scroll_line = line
	
func remove_excess_lines():
	var count = CommandText.get_line_count()
	var i = 0
	while count-i>max_lines:
		CommandText.remove_line(0)
		i+=1
