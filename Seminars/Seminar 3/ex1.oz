declare
fun {Member Xs Y}
   if Xs == nil then false
   else
      case Xs of H|T then
	 if H == Y then true
	 else {Member T Y}
	 end
      end
   end
end


{Browse {Member [a b c] b}}
{Browse {Member [a b c] d}}