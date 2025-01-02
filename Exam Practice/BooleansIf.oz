declare
fun {Eval E}
   case E of boolval(N) then N
   [] boolif(X Y Z) then if {Eval X} then {Eval Y} else {Eval Z} end
   [] boolnot(X) then {Not {Eval X}}
   end
end

{Browse {Eval boolif(boolval(false) (boolnot(boolval(false))) (boolval(false)))}}