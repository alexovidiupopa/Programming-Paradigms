declare
fun {FilterNaive L F}
   case L of
      X|Xs then
      if thread {F X} end
      then X | {FilterNaive Xs F}
      else {FilterNaive Xs F} end
   else
      nil
   end
end

{Browse {FilterNaive [1 3 4 5] IsOdd}}

declare
fun {Filter List Func}
   case List of nil then nil
   [] H|T then
      local
	 FilterHead = thread {Delay 2000} {Func H} end
	 FilterTail = {Filter T Func}
      in    
	 if FilterHead then H|FilterTail else FilterTail end
      end
   end
end

{Browse {Filter [1 2 4 5 6] IsEven}}