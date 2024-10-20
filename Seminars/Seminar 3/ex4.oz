declare
fun {PositionAux Xs Y I}
   if Xs == nil then 0
   else
      case Xs of H|T then
	 if H == Y then I
	 else
	    {PositionAux T Y I+1}
	 end
      end
   end
end
   
declare
fun {Position Xs Y}
   {PositionAux Xs Y 1}
end

{Browse {Position [a b c] c}}
{Browse {Position [a b c c] c}}
{Browse {Position [a b c] d}}
