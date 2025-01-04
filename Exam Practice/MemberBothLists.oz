declare 
fun {MemberBothLists Xs Ys Z} 
    case Xs 
    of nil then false 
    [] Hx|Tx then 
        case Ys
        of nil then false 
        [] Hy|Ty then 
            if {And Hx == Z Hy == Z} then true
            else {MemberBothLists Tx Ty Z}
            end
        end
    end
end

{Browse {MemberBothLists [a b c] [a b c] a}}
{Browse {MemberBothLists [a b c] [a b c d] d}}