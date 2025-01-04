declare
fun {Fact N} 
    if N == 0 then 1 
    else N * {Fact N-1} 
    end 
end 
     
declare
fun {Eval E}
   case E of intval(N) then N
   [] intfact(X) then {Fact {Eval X}}
   [] intminus(X Y) then {Eval X}-{Eval Y}
   end
end

{Browse {Eval intminus(intval(50) intfact(intval(4)))}}