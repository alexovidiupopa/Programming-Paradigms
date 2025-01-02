
declare
fun {Count Xs Y} 
   if Xs == nil then 0
   else 
      case Xs of H|T then
      if H == Y then 1+{Count T Y}
	 else
	    {Count T Y}
	 end
      end
   
   end
end


declare 
fun {MemberTwice Xs Y} 
    {Count Xs Y} > 1
end

{Browse {MemberTwice [a b c d b e] b}}
{Browse {MemberTwice [a b c d b e] a}}