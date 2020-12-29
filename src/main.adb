with Ada.Text_IO; use Ada.Text_IO;

procedure Main is

   size: Integer := 50000;
   num_of_threads: Integer := 4;
   num_of_thread_elements: Integer := size / num_of_threads;
   type my_arr is array(0..size-1) of Long_Integer;
   arr: my_arr;

   function partical_sum (first_indx: Integer; last_indx: Integer) return Long_Integer;

   task type part_sum is
      entry start(num_of_thread: Integer);
      entry stop (result : out Long_Integer);
   end part_sum;

   task body part_sum is
      array_begin: Integer := 0;
      array_end: Integer := 0;
      sum: Long_Integer := 0;
   begin
      accept start(num_of_thread: Integer) do
         array_begin := num_of_thread * num_of_thread_elements;
         array_end := (num_of_thread + 1) * num_of_thread_elements - 1;
      end start;

      sum := partical_sum (array_begin, array_end);

      accept Stop (result : out Long_Integer) do
         result := sum;
      end Stop;
   end part_sum;

   function partical_sum (first_indx: Integer; last_indx: Integer) return Long_Integer is
      p_sum : Long_Integer := 0;
   begin
      for i in first_indx..last_indx loop
         p_sum := p_sum + arr(i);
      end loop;

      return p_sum;
   end partical_sum;

   result: Long_Integer := 0;
   part_res: Long_Integer := 0;

   part_res_arr: array(0..3) of part_sum;
begin

   for i in 0..size-1 loop
      arr(i) := long_integer(i);
   end loop;

   for i in part_res_arr'Range loop
      part_res_arr(i).start(i);
   end loop;

   for i in part_res_arr'Range loop
      part_res_arr(i).stop(part_res);
      result := result + part_res;
   end loop;

   Put_Line(result'Img);
end Main;

