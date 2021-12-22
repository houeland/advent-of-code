Module Snailfish

	Class ListNode
		Public LeftValue as Object
		Public RightValue as Object
		Public LeftNode as ListNode
		Public RightNode as ListNode
		Public ConsumedIdx as Object
	End Class

	Class Explosion
		Public GoLeft as Object
		Public GoRight as Object
		Public ExplodeHere as Object
	End Class

	Function MakeExample()
		' [[[[[9,8],1],2],3],4]
		Dim node98 As New ListNode()
		Dim node981 As New ListNode()
		Dim node9812 As New ListNode()
		Dim node98123 As New ListNode()
		Dim node981234 As New ListNode()
		node98.LeftValue = 9
		node98.RightValue = 8
		node981.LeftNode = node98
		node981.RightValue = 1
		node9812.LeftNode = node981
		node9812.RightValue = 2
		node98123.LeftNode = node9812
		node98123.RightValue = 2
		node981234.LeftNode = node98123
		node981234.RightValue = 3
		Return node981234
	End Function

	Sub AddRightmost(node, value)
		if not node.rightnode is nothing then
			addrightmost(node.rightnode, value)
		else
			node.rightvalue += value
		end if
	End Sub

	Sub AddLeftmost(node, value)
		if not node.leftnode is nothing then
			addleftmost(node.leftnode, value)
		else
			node.leftvalue += value
		end if
	End Sub

	Function ShouldExplode(node, depth)
		'Console.Write("checking at depth ")
		'Console.Write(depth)
		'Console.WriteLine("...")
		if depth >= 4 then
			'Console.WriteLine("explode!!")
			Dim e as New Explosion()
			e.GoLeft = node.LeftValue
			e.GoRight = node.RightValue
			e.ExplodeHere = True
			return e
		end if
		if not node.LeftNode is nothing then
			Dim e = ShouldExplode(node.LeftNode, depth+1)
			if not e is nothing then
				if not e.GoRight is nothing then
					if node.RightNode is nothing then
						node.RightValue += e.GoRight
					else
						AddLeftmost(node.RightNode, e.GoRight)
					end if
					e.GoRight = Nothing
				end if
				if e.ExplodeHere then
					node.LeftValue = 0
					node.LeftNode = Nothing
					e.ExplodeHere = False
				end if
				return e
			end if
		end if
		if not node.RightNode is nothing then
			Dim e = ShouldExplode(node.RightNode, depth+1)
			if not e is nothing then
				if not e.GoLeft is nothing then
					if node.LeftNode is nothing then
						node.LeftValue += e.GoLeft
					else
						AddRightmost(node.LeftNode, e.GoLEft)
					end if
					e.GoLeft = Nothing
				end if
				if e.ExplodeHere then
					node.RightValue = 0
					node.RightNode = Nothing
					e.ExplodeHere = False
				end if
				return e
			end if
		end if
		return Nothing
	End Function

	Function splitit(value)
		Dim node As New ListNode()
		node.LeftValue = math.floor(value / 2)
		node.RightValue = math.ceiling(value / 2)
		return node
	End Function

	Function ShouldSplit(node)
		if node.leftnode is nothing then
			if node.leftvalue >= 10 then
				node.leftnode = splitit(node.leftvalue)
				node.leftvalue = nothing
				return True
			end if
		else
			if ShouldSplit(node.leftnode) then
				return True
			end if
		end if
		if node.rightnode is nothing then
			if node.rightvalue >= 10 then
				node.rightnode = splitit(node.rightvalue)
				node.rightvalue = nothing
				return True
			end if
		else
			if ShouldSplit(node.rightnode) then
				return True
			end if
		end if
		return False
	End Function

	Sub Reduce(node)
		if not ShouldExplode(node, 0) is nothing then
			'PrintHierarchy(node)
			'Console.WriteLine("")
			Reduce(node)
		elseif ShouldSplit(node) then
			'PrintHierarchy(node)
			'Console.WriteLine("")
			Reduce(node)
		else
		end if
	End Sub

	Sub Reduce_verbose(node)
		if not ShouldExplode(node, 0) is nothing then
			PrintHierarchy(node)
			Console.WriteLine("")
			Reduce_verbose(node)
		elseif ShouldSplit(node) then
			PrintHierarchy(node)
			Console.WriteLine("")
			Reduce_verbose(node)
		else
		end if
	End Sub

	Sub PrintHierarchy(node)
		if node is Nothing then
		else
			Console.Write("[")
			if not node.LeftValue is nothing then
				Console.Write(node.LeftValue)
			end if
			PrintHierarchy(node.LeftNode)
			Console.Write(" ")
			if not node.RightValue is nothing then
				Console.Write(node.RightValue)
			end if
			PrintHierarchy(node.RightNode)
			Console.Write("]")
		end if
	End Sub

	Function BuildNode(chars, idx)
		'Console.Write("buildnode from:")
		'Console.WriteLine(chars(idx))
		Dim node As New ListNode()
		if chars(idx) = "[" then
			node.LeftNode = BuildNode(chars, idx+1)
			idx = node.LeftNode.ConsumedIdx
			'Console.Write("skip closebracket:")
			'Console.WriteLine(chars(idx))
			idx += 1
		else
			node.LeftValue = Convert.toInt32(chars(idx).ToString())
			idx += 1
		end if
		'Console.Write("skip comma:")
		'Console.WriteLine(chars(idx))
		idx += 1
		if chars(idx) = "[" then
			node.RightNode = BuildNode(chars, idx+1)
			idx = node.RightNode.ConsumedIdx
			'Console.Write("skip closebracket:")
			'Console.WriteLine(chars(idx))
			idx += 1
		else
			node.RightValue = Convert.toInt32(chars(idx).ToString())
			idx += 1
		end if
		node.ConsumedIdx = idx
		'Console.Write("yay emit node!  ")
		'PrintHierarchy(node)
		'Console.WriteLine("")
		return node
	End Function

	Function StrToNode(input)
		Dim chars() As Char = input.ToCharArray
		'Console.Write("skip first openbracket:")
		'Console.WriteLine(chars(0))
		Dim node = BuildNode(chars, 1)
		'Console.Write("skip last closebracket:")
		'Console.WriteLine(chars(node.ConsumedIdx))
		return node
	End Function

	Sub TryExample(input)
		Dim node = StrToNode(input)
		PrintHierarchy(node)
		Console.WriteLine("")
		Reduce(node)
		PrintHierarchy(node)
		Console.WriteLine("")
		Console.WriteLine("")
		Console.WriteLine("")
	End Sub

	Function Add(left, right)
		Dim node As New ListNode()
		node.LeftNode = left
		node.RightNode = right
		'PrintHierarchy(node)
		'Console.WriteLine("")
		Reduce(node)
		'PrintHierarchy(node)
		'Console.WriteLine("")
		return node
	End Function

	Function Add_verbose(left, right)
		Dim node As New ListNode()
		node.LeftNode = left
		node.RightNode = right
		PrintHierarchy(node)
		Console.WriteLine("")
		Reduce_verbose(node)
		PrintHierarchy(node)
		Console.WriteLine("")
		return node
	End Function

	Sub TryStuff()
		TryExample("[9,8]")
		TryExample("[[9,7],[4,[3,1]]]")
		TryExample("[[[[[9,8],1],2],3],4]")
		TryExample("[7,[6,[5,[4,[3,2]]]]]")
		TryExample("[[6,[5,[4,[3,2]]]],1]")
		TryExample("[[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]")
		TryExample("[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]")
		TryExample("[[[[4,3],4],4],[7,[[8,4],9]]]")
		TryExample("[[[[[4,3],4],4],[7,[[8,4],9]]],[1,1]]")
		Dim left = StrToNode("[[[[4,3],4],4],[7,[[8,4],9]]]")
		Dim right = StrToNode("[1,1]")
		Add(left, right)
		' Dim node = MakeExample()
		' PrintHierarchy(node)
		' Console.WriteLine("")
		' Dim e = Reduce(node)
		' Console.WriteLine("Hello, World!")
		' Console.WriteLine(e)
		' Console.WriteLine("yo")
		' PrintHierarchy(node)
		' Console.WriteLine("")
	End Sub

	Function ComputeMagnitude(node)
		Dim m = 0
		if node.leftnode is nothing then
			m += node.leftvalue * 3
		else
			m += computemagnitude(node.leftnode) * 3
		end if
		if node.rightnode is nothing then
			m += node.rightvalue * 2
		else
			m += computemagnitude(node.rightnode) * 2
		end if
		return m
	End Function

	Sub SolveAddProblem()
		Dim node = StrToNode(Console.ReadLine())
		Do
			PrintHierarchy(node)
			Console.WriteLine("")
			Dim line = Console.ReadLine()
			if line = "" then
				exit do
			end if
			Dim right = StrToNode(line)
			node = Add(node, right)
		Loop While True
		Console.Write("Magnitude: ")
		Console.WriteLine(ComputeMagnitude(node))
	End Sub

	Function DeepClone(oldnode)
		Dim newnode As New ListNode()
		if oldnode.leftnode is nothing then
			newnode.leftvalue = oldnode.leftvalue
		else
			newnode.leftnode = deepclone(oldnode.leftnode)
		end if
		if oldnode.rightnode is nothing then
			newnode.rightvalue = oldnode.rightvalue
		else
			newnode.rightnode = deepclone(oldnode.rightnode)
		end if
		return newnode
	End Function

	Sub SolveLargestProblem()
		Dim nodes as new list(of object)()
		dim bigman = -1000
		Do
			Dim line = Console.ReadLine()
			if line = "" then
				exit do
			end if
			Dim node = StrToNode(line)
			nodes.Add(node)
		Loop While True
		Console.WriteLine(nodes.count)
		for i = 0 to nodes.count-1
			for j = 0 to nodes.count-1
				if i = j then
					continue for
				end if
				dim left = deepclone(nodes(i))
				dim right = deepclone(nodes(j))
				dim val = ComputeMagnitude(add(left, right))
				console.writeline(i & " " & j & ":" & val)
				if val > bigman then
					bigman = val
				end if
			next
		next
		Console.WriteLine("largest magnitude: " & bigman)
	End Sub

	Sub Main()
		'SolveAddProblem()
		SolveLargestProblem()
		'dim left = strtonode("[[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]")
		'dim right = strtonode("[[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]")
		'dim added = Add_verbose(left, right)
		'Console.WriteLine("mag: " & ComputeMagnitude(added))
	End Sub

End Module
