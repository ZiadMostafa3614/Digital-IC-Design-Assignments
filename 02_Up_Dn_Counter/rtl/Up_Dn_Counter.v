module Up_Dn_Counter ( 
  input   wire  [4:0]     IN,
  input   wire            Load, Up, Down,
  input   wire            CLK,
  output  reg   [4:0]     Counter,
  output  reg             High, Low 
  );
  
  reg [4:0] Counter_intermediate ;
  
  always @ (posedge CLK)
    begin
      Counter <= Counter_intermediate ;    
    end
  
  always @ (*)
   begin
     if (Load)
       begin
         Counter_intermediate = IN ;
       end
     else if (Down && !Low)
       begin
         Counter_intermediate = Counter - 5'b1;
       end
     else if (Up && !High && !Down)
       begin
         Counter_intermediate = Counter + 5'b1;
       end
     else 
       begin
         Counter_intermediate = Counter ;
       end
   end
  
  always @(*)
    begin
      if (Counter == 5'b0)
        Low = 1'b1 ;
      else
        Low = 1'b0 ;
    end
  
  always @(*)
    begin
      if (Counter == 5'b11111)
        High = 1'b1 ;
      else
        High = 1'b0 ;
    end
  
endmodule
