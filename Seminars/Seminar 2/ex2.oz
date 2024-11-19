declare
fun {ReverseAux L1 L2}
   case L1 of
      nil then L2
   [] H|T then {ReverseAux T H|L2}
   end
end

declare
fun {Reverse2 L1}
   {ReverseAux L1 nil}
end

{Browse {Reverse2 ['I' 'want' 2 go 'there']}}


