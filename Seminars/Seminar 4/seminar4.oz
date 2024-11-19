
% Lecture 5, slide 34/76
declare
fun {FreeSetIntern Expr FreeVars}
   case Expr of nil
   then FreeVars
   [] lam(Id Body) then
      {List.filter {FreeSetIntern Body FreeVars}
       fun {$ Elem} {Not Elem == Id} end }
   [] apply(Left Right) then
      {List.flatten FreeVars |
       {FreeSetIntern Left nil} |
       {FreeSetIntern Right nil}}
   [] let(Left#Right Result) then
      {List.filter
       {List.flatten FreeVars |
	{FreeSetIntern Right nil} |
	{FreeSetIntern Result nil}}
       fun {$ Elem} {Not Elem == Left} end}
   [] Id then
      Id|FreeVars
   end
end

declare
fun {FreeSet Expr}
   {FreeSetIntern Expr nil}
end

{Browse {FreeSet apply(x let(x#y x))}}
{Browse {FreeSet apply(y apply(let(x#x x) y))}}



declare
fun {IsMember Env Id}
   case Env of
      nil then false
   [] H|T then
      if H.1 == Id then true
      else {IsMember T Id}
      end
   end
end

declare
fun {Fetch Env Id}
   case Env of
      nil then Id
   [] H|T then
      if H.1 == Id then H.2
      else {Fetch T Id}
      end
   end
end

declare
fun {Adjoin Env Tuple}
   Tuple | {List.filter Env
	    fun {$ Entry} {Not Entry.1 == Tuple.1} end}
end

{Browse {IsMember [a#1 b#2 c#3] c}}
{Browse {IsMember [a#1 b#2 c#3] d}}
{Browse {Fetch [a#1 b#2 c#3] c}}
{Browse {Fetch [a#1 b#2 c#3] d}}
{Browse {Adjoin [a#1 b#2 c#3] c#4}}
{Browse {Adjoin [a#1 b#2 c#3] d#4}}


declare
Cnt={NewCell 0}

fun {NewId}
   Cnt:=@Cnt+1
   {String.toAtom {Append "id<" {Append {Int.toString @Cnt}">"}}}
end

declare
fun {Replace Expr Id IdNew}
   case Expr of nil then nil
   [] apply(Left Right) then
      apply({Replace Left Id IdNew} {Replace Right Id IdNew})
   [] lam(T Body) then
      lam({Replace T Id IdNew} {Replace Body Id IdNew})
   [] let(L#R Result) then
      let({Replace L Id IdNew}#{Replace R Id IdNew} {Replace Result Id IdNew})
   [] T then
      if T==Id then
	 IdNew
      else
	 T
      end
   end
end

declare
fun {RenameIntern Expr FreeVars}
   case Expr
   of nil then nil
   [] apply(Left Right) then
      apply({RenameIntern Left FreeVars} {RenameIntern Right FreeVars})
   [] lam(T Body) then
      local NewIdT in NewIdT={NewId}
	 lam({Replace T T NewIdT} {RenameIntern {Replace Body T NewIdT} FreeVars})
      end
   [] let(L#R Result) then
      local NewIdL in NewIdL={NewId}
	 let({Replace L L NewIdL}#{RenameIntern R FreeVars} {RenameIntern {Replace Result L NewIdL} FreeVars})
      end
   [] Id then
      if {List.sub "id<" {Atom.toString Id}} then Id
      elseif {List.member Id FreeVars} then Id
      else
	 {Replace Id Id {NewId}}
      end
   end
end

declare
fun {Rename Expr}
   {RenameIntern Expr {FreeSet Expr}}
end

{Browse {Rename lam(z lam(x z))}}
{Browse {Rename let(id#lam(z z) apply(id y))}}

%Subs operation
declare
fun {Subs Bind Expr}
   case Bind of nil then nil
   [] Id#Ex then
      {Replace {Rename Expr} Id Ex}
   end
end

{Browse {Subs x#lam(z z) apply(x lam(x apply(x z)))}}
{Browse {Subs x#lam(y z) apply(x lam(z apply(x z)))}}