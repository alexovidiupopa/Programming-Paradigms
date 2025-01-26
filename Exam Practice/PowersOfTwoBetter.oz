declare
   fun {PowersOfTwo N}
      if N < 0 then nil
      else {FoldL [N] fun {$ X} X+1 end nil}  %% Generate list [N, N+1, ...]
      end
   end

   %% Producer: Generates powers of 2 and sends them to the consumer
   fun {Producer N P}
      case {PowersOfTwo N} of
         nil then nil
      [] H|T then
         {Send P 2^H}  %% Send powers of 2 as messages
         {Producer (H+1) P}  %% Recursively produce next power
      end
   end

   %% Consumer: Reads values from the port, computing min/max
   proc {Consumer S Min Max}
      case {Receive S} of
         stop then
            {Show 'Final Min:'} {Show Min}
            {Show 'Final Max:'} {Show Max}
      [] V then
            {Show 'Received:'} {Show V}
            NewMin = if Min==none then V else {Min Min V} end
            NewMax = if Max==none then V else {Max Max V} end
            {Consumer S NewMin NewMax}
      end
   end

   %% Main Execution
   proc {Main}
      S = {NewPort _}   %% Create a new port
      thread {Consumer S none none} end   %% Start consumer thread
      thread {Producer 3 S} {Send S stop} end  %% Start producer thread
   end

{Main}
