`include "intrp_cntrl.v"
module tb;

parameter NUM_PHER=16;
parameter WIDTH=16;
parameter ADDR_WIDTH=16;

reg clk,rst,sel,enable,write,intrp_serviced;
reg [WIDTH-1:0]wdata;
reg [ADDR_WIDTH-1:0]addr;
reg [NUM_PHER-1:0]int_valid;
wire ready,error,intrp_valid;
wire [WIDTH-1:0]rdata;
wire [NUM_PHER-1:0]pher_with_intrp;

reg [8*30:1]testcase;
integer i,arr;
intrp_cntrl dut(.*);

always #5 clk=~clk;
initial begin
  clk=0;
  rst=1;
  rst_logic();
  repeat(2) @(posedge clk);
  rst=0;
  sel=1;
   $value$plusargs("testcase=%0s",testcase);
   $display("testcase=%0s",testcase);
  case(testcase)
    "LOW_PHERI_WITH_LOW_PRI_VALUE":begin
	  for(i=0;i<NUM_PHER;i=i+1)
	   write_logic(i,i);
	   @(posedge clk);
	    rst_logic();
	end
	"LOW_PHERI_WITH_HIGH_PRI_VALUE":begin
	   for(i=0;i<NUM_PHER;i=i+1)
	    write_logic(i,NUM_PHER-1-i);
		 @(posedge clk);
		 rst_logic();
	 end
	 "PHERI_WITH_RANDOM_PRI_VALUE":begin
	   for(i=0;i<NUM_PHER;i=i+1)
	   write_logic(i,arr[i]);  ////decalare an array which stores unique pri_valuse from 0 to 15 range
      @(posedge clk);
	  rst_logic();
	 end
	 "FIRST_COME_FIRST_SERVE":begin
	   
	 end
  endcase
 int_valid=$random;
 #100;
 $finish;
end

always@(posedge int_valid)begin
#20;      //to service processor takes 20 ns time 
	intrp_serviced=1;	//processor indicates to intrpt_cntrl  i serviced request(slave)
int_valid[pher_with_intrp]=0;
@(posedge clk);
intrp_serviced=0;
end
task rst_logic();
begin
  write=0;
  enable=0;
  sel=0;
  wdata=0;
  addr=0;
  intrp_serviced=0;
  int_valid=0;
end
endtask

task write_logic(input reg [ADDR_WIDTH-1:0]pher_number,input reg [ADDR_WIDTH:0]pri_value);
begin
  @(posedge clk);
  addr=pher_number;
  wdata=pri_value;
  write=1;
  enable=1;
  wait(ready==1);
end
endtask
endmodule

