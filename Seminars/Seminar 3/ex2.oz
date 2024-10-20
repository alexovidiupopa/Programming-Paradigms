declare
fun {TakeAux Xs N I}
   if I > N then nil
   else
      case Xs of H|T then
	 H|{TakeAux T N I+1}
      end
   end
end

fun {Take Xs N}
   {TakeAux Xs N 1}
end

{Browse {Take [1 4 3 6 2] 3}}

declare
fun {DropAux Xs N I}
   if Xs == nil then nil
   else
      case Xs of H|T then
	 if I > N then
	    H|{DropAux T N I+1}
	 else
	    {DropAux T N I+1}
	 end
      end
   end
end

declare
fun {Drop Xs N}
   {DropAux Xs N 1}
end

{Browse {Drop [1 4 3 6 2] 3}}



