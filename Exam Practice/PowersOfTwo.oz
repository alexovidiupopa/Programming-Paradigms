declare
fun {Produce N Limit}
   if N<Limit then
      N|{Produce N*2 Limit}
   else nil end
end

declare
fun {Consume Xs Min Max}
   case Xs of X|Xr then
      if X < Min then {Consume Xr X Max} else if X > Max then {Consume Xr Min X} end end
   [] nil then Min#Max
   end
end


declare
thread Stream = {Produce 1 10000} end
declare
thread Result = {Consume Stream N 10000} end

{Browse Stream}
