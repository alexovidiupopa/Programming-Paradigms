declare
fun {MemberAux Xs Ys Z Fx Fy}
    case Xs#Ys of nil#nil then {And Fx == 1 Fy == 1}
    [] (X|Xr)#nil then
        if X == Z then Fy == 1 % stop searching since it was found in X, we only need to check if it was also found in Y
        else {MemberAux Xr nil Z Fx Fy}
        end
    [] nil#(Y|Yr) then
        if Y == Z then Fx == 1  % stop searching since it was found in Y, we only need to check if it was also found in X
        else {MemberAux nil Yr Z Fx Fy}
        end
    [] (X|Xr)#(Y|Yr) then
        if {And X == Z Y == Z} then true % stop searching since it was found in both lists
        elseif {And X == Z Y \= Z} then {MemberAux Xr Yr Z 1 Fy} % search further in Y, with Z found in X
        elseif {And X \= Z Y == Z} then {MemberAux Xr Yr Z Fx 1} % search further in X, with Z found in Y
        else {MemberAux Xr Yr Z Fx Fy}
        end
    end
end

declare
fun {MemberBothLists Xs Ys Z}
    {MemberAux Xs Ys Z 0 0}
end

{Browse {MemberBothLists [a b c] [a c d] c}}
{Browse {MemberBothLists [a b c] [a b d c] c}}
{Browse {MemberBothLists [a b c d] [a b d] d}}
{Browse {MemberBothLists [a b c] [a d] b}}