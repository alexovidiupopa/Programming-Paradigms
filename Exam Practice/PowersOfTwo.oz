declare
fun {Produce N Limit}
   if N<Limit then
      N|{Produce N*2 Limit}
   else nil end
end

declare
fun {Consume Xs Min Max}
   case Xs of H|T then
      if H < Min then {Consume T H Max} 
        else if H > Max then {Consume T Min H} 
        else {Consume T Min Max}
        end 
    end
   [] nil then Min#Max
   end
end

N = 1
Stream = thread {Produce N 10000} end
Result = thread {Consume Stream 1000000 1} end

{Browse Result}
{Browse Stream}
