declare
proc {WaitOr X Y}
   ShMem in
   thread {Wait X} ShMem = true {Browse X} end
   thread {Wait Y} ShMem = true {Browse Y} end
   {Wait ShMem}
end

{WaitOr 1 _}
{WaitOr _ 1}
{WaitOr _ _}