class_name CmdHelp

extends Object


static func clean_cmd(cmd:String)-> String:
	while cmd.find(" ") == 0:
		cmd.erase(0,1)
	while cmd.find_last(" ") == cmd.length()-1:
		cmd.erase(cmd.length()-1,1)
	
	cmd = escape_spaces(cmd)
		
	while cmd.find("  ")!= -1:
		var doublespacepos = cmd.find("  ")
		cmd.erase(doublespacepos,1)

	return cmd

static func pre_clean_cmd(cmd:String)->String:
	while cmd.find(" ") == 0:
		cmd.erase(0,1)
	while cmd.find_last(" ") == cmd.length()-1:
		cmd.erase(cmd.length()-1,1)
	return cmd


static func escape_spaces(text:String) -> String:
	var pos1:int = 0
	var pos2:int = 0
	if text.count("\"")% 2 == 0 :
		
		while text.find("\"")!=-1:
			pos1 = text.find("\"")
			pos2 = text.find("\"",pos1+1)
			var text2:String = text
			text2.erase(pos2+1,text2.length()-pos2+1)
			text2.erase(0,pos1)
			text2 = text2.replace(" ","|_SPACE_|")
			text2 = text2.replace("\"","|_QUOTE_|")
			
			text.erase(pos1,pos2+1-pos1)
			text = text.insert(pos1,text2)
		text = text.replace("|_QUOTE_|","\"")
			
	return text

static func escape_comas(text:String) -> String:
	var pos1:int = 0
	var pos2:int = 0
	if text.count("\"")% 2 == 0 :
		
		while text.find("\"")!=-1:
			pos1 = text.find("\"")
			pos2 = text.find("\"",pos1+1)
			var text2:String = text
			text2.erase(pos2+1,text2.length()-pos2+1)
			text2.erase(0,pos1)
			text2 = text2.replace(",","|_COMA_|")
			text2 = text2.replace("\"","|_QUOTE_|")
			
			text.erase(pos1,pos2+1-pos1)
			text = text.insert(pos1,text2)
		text = text.replace("|_QUOTE_|","\"")
			
	return text

static func unescape_spaces(text:String) -> String:
	text = text.replace("|_SPACE_|"," ")
	return text


static func word_to_argarray(word:String)-> Array:
	word = escape_comas(word)
	var argarray:Array = []
	var argwordarray:Array = word.split(",",false)
	#var argword:String = "F:1.00"
	for argword in argwordarray:
		var ch1:String = argword
		ch1.erase(2,ch1.length()-2)
		var arg:String = argword
		arg.erase(0,2)
		
		match ch1:
			"F:":
				if arg.is_valid_float():
					argarray.append(arg.to_float())
				else:
					return[]
			"I:":
				if arg.is_valid_integer():
					argarray.append(arg.to_int())
				else:
					return[]
			"S:":
				arg = arg.replace("\"","")
				arg = arg.replace("|_COMA_|",",")
				arg = unescape_spaces(arg)
				arg = arg.replace("\"","")
				argarray.append(arg)
	return argarray
	


static func word_to_bool(word:String):
	match word.to_lower():
		"on","1","true","yes","one":
			return true
		"off","0","false","no","zero":
			return false
	return null
