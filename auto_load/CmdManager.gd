extends Node


static func execute_command(words:PoolStringArray):
	var command:String = words[0]
	match command.to_lower():
		#Will execute the given method in the given node with some support for arguments
		"exec":
			if words.size()==3||words.size()==4:
				var targetword : String = words[1]
				var targetArray : Array = targetword.split(".",false)
				var function : String = words[2]
				var wordammount = targetArray.size()
				var i :int = 0
				var target : Node = Master.GameWorld
				while i< wordammount:
					var takenode:bool = true
					i+=1
					var nodename = targetArray.pop_front()
					
					if i== 1:
						match nodename.to_lower():
							"world":
								target = Master.GameWorld
								takenode=false
							"master":
								target = Master
								takenode=false
							"player":
								target = Master.Player
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
					Master.println("node ["+target.name+"] has no method named :\""+function+"\"",Color.red)
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
				var target : Node = Master.GameWorld
				while i< wordammount:
					var takenode:bool = true
					i+=1
					var nodename = targetArray.pop_back()
					if i== 1:
						match nodename.to_lower():
							"world":
								target = Master.GameWorld
								takenode=false
							"master":
								target = Master
								takenode=false
							"player":
								target = Master.Player
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
		
		
	Master.println("["+command+"] is not a valid command" ,Color.red)
