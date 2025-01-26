declare
fun {Test F X}
   if {F X} then X else unit end   %% Use 'unit' instead of 'nil'
end

declare 
fun {Reader S}
   case S of nil then nil   %% Proper termination
   [] X|Xs then
      if X == unit then {Reader Xs} else X|{Reader Xs} end   %% Skip 'unit' values
   end
end

declare
proc {FilterHelper L F P}
   case L
   of nil then {Send P nil}   %% Ensure termination
   [] X|Xs then
      local Result in   %% Declare Result explicitly
         thread
            Result = {Test F X}
            if Result \= unit then {Send P Result} end   %% Only send valid values
         end
      end
      {FilterHelper Xs F P}
   end
end

declare
fun {Filter L F}
   local S P in
      P = {NewPort S}    %% Create port
      thread {FilterHelper L F P} end   %% Start producer in its own thread
      {Reader S}   %% Return the collected filtered results
   end
end

declare
fun {IsOdd X}
   X mod 2 \= 0
end

{Browse {Filter [1 2 3 4 5 6 7 8] IsOdd}}
