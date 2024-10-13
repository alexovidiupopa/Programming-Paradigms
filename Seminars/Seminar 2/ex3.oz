declare
fun lazy {Sieve L}
   case L of
      nil then nil
   [] H|T then H|{Sieve {Filter T H}}
   end
end

fun lazy {Filter L H}
   case L of
      nil then nil
   [] A|As then if (A mod H)==0 then {Filter As H}
		else A|{Filter As H}
		end
   end
end

fun lazy {Prime} {Sieve {Gen 2}} end

fun lazy {Gen N} N | {Gen N+1} end

% function to return the first prime number after a given value

declare
fun {GetAfterAux N L}
   case L of
      H|T then
      if H > N then H else {GetAfterAux N T}
      end
   end
end

declare
fun {GetAfter N}
   {GetAfterAux N {Prime}} % list returned by Prime is lazy so it won't be evaluated until actually required
end

declare Result = {GetAfter 100}
{Browse Result}   