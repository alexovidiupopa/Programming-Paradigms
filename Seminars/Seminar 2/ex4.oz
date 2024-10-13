declare
fun {Insert T N}
   if T == nil then bst(node: N right: nil left:nil)
   elseif T.node < N then bst(node: T.node left: T.left right: {Insert T.right N})
   else bst(node: T.node left: {Insert T.left N} right: T.right)
   end
end



declare
Y = nil
E1 = 5
E2 = 10
E3 = 60
E4 = 25
X = bst(node:10 left: bst(node:3 left: nil right:nil) right: bst(node: 30 left: nil right: nil))
{Browse {Insert {Insert {Insert {Insert X E1 } E2 } E3 } E4 }}


declare
fun {Smallest T}
   if T.left == nil then T.node
   else {Smallest T.left}
   end
end


declare
X2 = bst(node: 10 left: bst(node: 9 left: bst(node: 3 left: nil right: nil) right: bst(node: 40 left: nil right: nil)) right: 50)
{Browse {Smallest X2}}

declare
fun {Biggest T}
   if T.right == nil then T.node
   else {Biggest T.right}
   end
end

declare
X3 = bst(node: 10 left: 5 right: bst(node: 20 left: nil right: bst(node: 100 left: nil right: nil)))

{Browse {Biggest X3}}




declare
fun {IsSorted T}
   if T == nil then true
   elseif {And T.left == nil T.right == nil} then true
   elseif {And T.left == nil T.node < T.right.node} then {IsSorted T.right}
   elseif {And T.left == nil T.node > T.right.node} then false
   elseif {And T.right == nil T.node >= T.left.node} then {IsSorted T.left}
   elseif {And T.right == nil T.node < T.left.node} then false
   elseif {And T.node >= T.left.node T.node < T.right.node} then {And {IsSorted T.left} {IsSorted T.right}}
   else false
   end
end

declare
X4 = bst(node: 20 left: bst(node: 10 left: nil right: nil) right: bst(node: 15 left: 23 right: bst(node: 30 left: nil right: bst(node: 40 left: nil right: nil))))
X5 = bst(node: 20 left: bst(node: 10 left: nil right: nil) right: bst(node: 30 left: nil right: nil))
X6 = bst(node: 20 left: bst(node: 10 left: nil right: nil) right: bst(node: 25 left: bst(node:23 left: nil right: nil) right: bst(node: 30 left: nil right: bst(node: 21 left: nil right: nil))))
{Browse X4}
{Browse {IsSorted X4}}
{Browse X5}
{Browse {IsSorted X5}}
{Browse X6}
{Browse {IsSorted X6}}