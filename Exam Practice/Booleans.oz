declare
fun {Eval E}
   case E of boolval(N) then N
   [] booland(X Y) then {And {Eval X} {Eval Y}}
   [] boolor(X Y) then {Or {Eval X} {Eval Y}}
   end
end

{Browse {Eval booland(boolval(false) boolor(boolval(true) boolval(false)))}}
{Browse {Eval boolval(true)}}