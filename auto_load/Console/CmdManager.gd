extends Node


static func execute_command(words:PoolStringArray):
	var command:String = words[0]
	match command.to_lower():
		#Will execute the given method in the given node with some support for arguments
		"help":
			var msg = ""
			msg += "exec [node path] [method name] [method arguments/nothing]"
			msg += "children [node path]\n"
			msg += "node paths are written:\nI:999\nF:999.0\nS:\"text text text\""
			msg += "god\ntimer"
			Master.println(msg)
			return
		
		"exec":
			if words.size()==3||words.size()==4:
				var targetword : String = words[1]
				var targetArray : Array = targetword.split(".",false)
				var function : String = words[2]
				var wordammount = targetArray.size()
				var i :int = 0
				var target : Node = ref.level
				while i< wordammount:
					var takenode:bool = true
					i+=1
					var nodename = targetArray.pop_front()
					
					if i== 1:
						match nodename.to_lower():
							"world":
								target = ref.level
								takenode=false
							"master":
								target = Master
								takenode=false
							"player":
								target = ref.player
								takenode=false
					if takenode:
						target = target.get_node(nodename)
					if target == null:
						Master.println("node ["+targetword+"] does not exist",Color.red)
						return
				if target.has_method(function):
					if words.size()==3:
						target.call(function)
						return
					else:
						var argword = words[3]
						var argarray = CmdHelp.word_to_argarray(argword)
						target.callv(function,argarray)
						return
				else:
					ref.println("node ["+target.name+"] has no method named :\""+function+"\"",Color.red)
					return
			Master.println("wrong number of arguments for command: ["+command+"]" ,Color.red)
			return
		
		#Will output all direct children of a given node
		"children":
			if words.size()==2:
				var targetword : String = words[1]
				var targetArray : Array = targetword.split(".",false)
				var wordammount = targetArray.size()
				var i :int = 0
				var target : Node = ref.level
				while i< wordammount:
					var takenode:bool = true
					i+=1
					var nodename = targetArray.pop_back()
					if i== 1:
						match nodename.to_lower():
							"world":
								target = ref.level
								takenode=false
							"master":
								target = Master
								takenode=false
							"player":
								target = ref.player
								takenode=false
					if takenode:
						target = target.get_node(nodename)
				if target == null:
					Master.println("node ["+targetword+"] does not exist",Color.red)
					return
				for child in target.get_children():
					Master.println(child.name)
				return
			Master.println("wrong number of arguments for command: ["+command+"]" ,Color.red)
			return
		"god":
			if words.size()==1:
				ref.player.undamageable = !ref.player.undamageable
				match ref.player.undamageable:
					true:
						Master.println("Godmode ON",Color.green)
					false:
						Master.println("Godmode OFF",Color.green)
				return
			if words.size()==2:
				var boolword : String = words[1]
				var boolfromword = CmdHelp.word_to_bool(boolword)
				if boolfromword == null:
					Master.println("["+boolword+"] is not a valid value for command:["+command+"]",Color.red)
					return
				ref.player.undamageable = boolfromword
				match ref.player.undamageable:
					true:
						Master.println("Godmode ON",Color.green)
					false:
						Master.println("Godmode OFF",Color.green)
				return
			Master.println("wrong number of arguments for command: ["+command+"]" ,Color.red)
			return
		"timer":
			if words.size() == 1:
				if is_instance_valid(ref.level_timer):
					if ref.level_timer.is_stopped():
						if is_instance_valid(ref.player):
							ref.level_timer.start()
							Master.println("Timer start",Color.green)
							return
					else:
						ref.level_timer.stop()
						Master.println("Timer stop",Color.green)
						return
				else:
					Master.println("Timer not valid",Color.green)
					return
			Master.println("wrong number of arguments for command: ["+command+"]" ,Color.red)
			return
		
		
	Master.println("["+command+"] is not a valid command" ,Color.red)
