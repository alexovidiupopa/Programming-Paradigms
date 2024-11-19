% step a)

declare
fun {FactA N K}
   if N==K then N
   else N * {FactA (N-1) K}
   end
end

declare
fun {CombA N K}
   if K == 0 then 1
   else
      {FactA N (N-K+1)} div {FactA K 1}
   end
end

{Browse {CombA 10 3}}
{Browse {CombA 10 0}}

% step b)

declare
fun {FactB N K Acc}
   if K == 1.0 then N * Acc
   else
      {FactB N K-1.0 (N-K+1.0) / K * Acc}
   end
end


declare
fun {CombB N K}
   if K == 0 then 1
   else
      {FactB {IntToFloat N} {IntToFloat K} 1.0}
end
end

{Browse {CombB 10 3}}
{Browse {CombB 5 0}}