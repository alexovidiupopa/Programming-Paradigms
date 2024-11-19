declare
fun {Zip Tuple}
   {List.mapInd Tuple.1
    fun {$ Ind Elem}
       Elem#{List.nth Tuple.2 Ind}
    end}
end

{Browse {Zip [1 2 3]#[a b c]}}

declare
fun {UnZipIntern Tuple Left Right}
   case Tuple of
      nil then Left#Right
   [] H|T then {UnZipIntern T {List.append Left [H.1]} {List.append Right [H.2]}}
   end
end

declare
fun {UnZip Tuple}
   {UnZipIntern Tuple nil nil}
end

{Browse {UnZip [1#a 2#b 3#c]}}