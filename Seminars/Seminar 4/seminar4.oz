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
            else (A#B)|{AdjoinAux T Expr} 
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
fun {RenameHelper Expr Env}
    if {IsAtom Expr} then
        if {IsMember Env Expr} then
            {Fetch Env Expr}
        else
            Expr
        end
    else
        case Expr of
            nil then nil
        [] apply(Expr1 Expr2) then
            apply({RenameHelper Expr1 Env} {RenameHelper Expr2 Env})
        [] lam(ID Expr) then
            if {IsMember Env ID} then
                lam({Fetch Env ID} {RenameHelper Expr Env})
            else
                local Envs in
                    Envs = {Adjoin Env ID#{NewId}}
                    lam({Fetch Envs ID} {RenameHelper Expr Envs})
                end
            end
        [] let(ID#Expr1 Expr2) then
            if {IsMember Env ID} then
                let({Fetch Env ID}#{RenameHelper Expr1 Expr2} {RenameHelper Expr2 Env})
            else
                local Envs in
                    Envs = {Adjoin Env ID#{NewId}}
                    let({Fetch Envs ID}#{RenameHelper Expr1 Env} {RenameHelper Expr2 Envs})
                end
            end
        end  
    end      
end

declare
fun {Rename Expression}
    {RenameHelper Expression nil}
end

{Browse {Rename lam(z lam(x z))}}
{Browse {Rename let(id#lam(z z) apply(id y))}}

declare 
fun {ReplaceIn Expr ID NewId}
	case Expr of nil then Expr
	[] let(L#R Res) then let({ReplaceIn L ID NewId}#{ReplaceIn R ID NewId} {ReplaceIn Res ID NewId})
	[] lam(T Body) then lam({ReplaceIn T ID NewId} {ReplaceIn Body ID NewId})
	[] apply(L R) then apply({ReplaceIn L ID NewId} {ReplaceIn R ID NewId})
	[] T then if T == ID then NewId else T end
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