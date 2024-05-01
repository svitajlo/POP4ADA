with Ada.Text_IO; use Ada.Text_IO;
with GNAT.Semaphores; use GNAT.Semaphores;

procedure Dinner_Philosophers is
   task type Phylosopher is
      entry Start(Id : Integer);
   end Phylosopher;

   Forks : array (1..5) of Counting_Semaphore(1, Default_Ceiling);

   task body Phylosopher is
      Id : Integer;
      Id_Left_Fork, Id_Right_Fork : Integer;
   begin
      accept Start (Id : in Integer) do
         Phylosopher.Id := Id;
      end Start;

      if Id = 1 then
         Id_Left_Fork := 2;
         Id_Right_Fork := 1;
      else
         Id_Left_Fork := Id;
         Id_Right_Fork := Id rem 5 + 1;
      end if;

      for I in 1..10 loop
         Put_Line("Phylosopher " & Id'Img & " thinking " & I'Img & " time");

         Forks(Id_Left_Fork).Seize;
         Put_Line("Phylosopher " & Id'Img & " took left fork");

         Forks(Id_Right_Fork).Seize;
         Put_Line("Phylosopher " & Id'Img & " took right fork");

         Put_Line("Phylosopher " & Id'Img & " eating" & I'Img & " time");

         Forks(Id_Right_Fork).Release;
         Put_Line("Phylosopher " & Id'Img & " put right fork");

         Forks(Id_Left_Fork).Release;
         Put_Line("Phylosopher " & Id'Img & " put left fork");
      end loop;
   end Phylosopher;

   Phylosophers : array (1..5) of Phylosopher;

begin
   for I in Phylosophers'Range loop
      Phylosophers(I).Start(I);
   end loop;
end Dinner_Philosophers;
