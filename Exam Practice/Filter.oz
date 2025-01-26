
% The concurrency is useless as the concurrent thread is inside the conditional check, and the execution is blocked waiting for it to respond.
% An alternative for effective parallelism is to compute all {F X} in parallel, and collect successfull X in a non-deterministic stream (such as NewPort). 
% To preserve the order of elements at the end, we will have to send a position I along with each X element, and sort the entries according to the index.

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