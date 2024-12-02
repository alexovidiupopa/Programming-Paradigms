declare 
fun {Concat L1 L2} 
	case L1 of nil then L2
	[] H|T then H|{Concat T L2}
	end
end

declare
fun {Contains E L} 
	case L of nil then false 
	[] H|T then 
		if H == E then true
		else {Contains E T}
		end
	end
end

% Lecture 5, slide 34/76
declare
fun {FreeSetAux Expr L}
	case Expr of apply(Expr1 Expr2) then 
		{Concat {FreeSetAux Expr1 L} {FreeSetAux Expr2 L}}
	[] let(ID#Expr1 Expr2) then 
		{Concat {FreeSetAux Expr1 ID|L} {FreeSetAux Expr2 ID|L}}
	[] lam(ID Expr1) then 
		{FreeSetAux Expr1 ID|L}
	[] ID then if {Contains ID L} then nil else [ID] end
	end
end

declare 
fun {FreeSet Expr}
	{FreeSetAux Expr nil}
end

{Browse {FreeSet apply(x let(x#y x))}} % [x y]
{Browse {FreeSet apply(y apply(let(x#x x) y))}} % [y y]

declare
Cnt = {NewCell 0}
fun {NewId}
    Cnt := @Cnt + 1
    {String.toAtom {Append "id<" {Append {Int.toString @Cnt} ">"}}}
end

fun {IsMember Env ID}
   case Env of
      nil then false
      [] A#B|T then 
            if ID == A then true 
            else {IsMember T ID} 
            end
      end
end

declare
fun {Fetch Env ID}
   case Env of
      nil then ID
   []  A#B|T then 
        if ID == A then B 
        else {Fetch T ID} 
        end
   end
end


declare
fun {AdjoinAux Env Expr}
   case Env of
      nil then nil
   [] A#B|T then
      case Expr of
        X#Y then 
            if A == X then {AdjoinAux T Expr}
            else (A#B)|{AdjoinAux T Expr} % or (A#B) | T, if we can only have 1 occurrence
            end
        end	 
   end
end

fun {Adjoin Env Expr}
   Expr | {AdjoinAux Env Expr}
end

{Browse {IsMember [a#e1 b#y c#e3] c}}
{Browse {IsMember [a#e1 b#y c#e3] y}}

{Browse {Fetch [a#e1 b#y c#e3] c}}
{Browse {Fetch [a#e1 b#y c#e3] d}}

{Browse {Adjoin [a#e1 b#y c#e3] c#e4}}
{Browse {Adjoin [a#e1 b#y c#e3] d#e4}}

declare
fun {RenameAux Expr Env}
    if {IsAtom Expr} then
        if {IsMember Env Expr} then % not unique variable, retrieve its id
            {Fetch Env Expr}
        else
            Expr
        end
    else
        case Expr of
	   nil then nil
	[] let(ID#Expr1 Expr2) then
            if {IsMember Env ID} then % the renamed ID is part of the Environment -> retrieve it and move on
                let({Fetch Env ID}#{RenameAux Expr1 Expr2} {RenameAux Expr2 Env})
            else
                local Envs in
                    Envs = {Adjoin Env ID#{NewId}}
                    let({Fetch Envs ID}#{RenameAux Expr1 Env} {RenameAux Expr2 Envs}) % the renamed ID is not part of the Environment -> rename to {NewId}, adjoin and move on
                end
	    end
	[] lam(ID Expr) then 
            if {IsMember Env ID} then % same as let
                lam({Fetch Env ID} {RenameAux Expr Env})
            else
                local Envs in
                    Envs = {Adjoin Env ID#{NewId}}
                    lam({Fetch Envs ID} {RenameAux Expr Envs})
                end
	    end
        [] apply(Expr1 Expr2) then % rename everything under expr1 and expr2
            apply({RenameAux Expr1 Env} {RenameAux Expr2 Env})
	end
    end      
end

declare
fun {Rename Expr}
    {RenameAux Expr nil}
end

{Browse {Rename lam(z lam(x z))}}
{Browse {Rename let(id#lam(z z) apply(id y))}}

declare 
fun {ReplaceIn Expr ID NewId}
	case Expr of nil then Expr
	[] let(L#R Res) then let({ReplaceIn L ID NewId}#{ReplaceIn R ID NewId} {ReplaceIn Res ID NewId}) % replace ID in all 3 members
	[] lam(T Body) then lam({ReplaceIn T ID NewId} {ReplaceIn Body ID NewId}) % replace ID in both members 
	[] apply(L R) then apply({ReplaceIn L ID NewId} {ReplaceIn R ID NewId}) % replace ID in both members
	[] T then if T == ID then NewId else T end % atom - either the one we're searching for, or another one
	end
end

declare 
fun {Subs Binding Expr}
	case Binding of nil then nil 
	[] Id#Exp then {ReplaceIn {Rename Expr} Id Exp}
	end
end

{Browse {Subs x#lam(x x) apply(x y)}}
{Browse {Subs x#lam(z z) apply(x lam(x apply(x z)))}}