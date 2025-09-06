module intrp_cntrl(
//processor interface
clk,rst,write,sel,enable,wdata,addr,ready,rdata,error,
intrp_valid,    //intrp_valid(interrupt) to processor
pher_with_intrp,
intrp_serviced, //intrp_serviced tells doubt is clarified or not
//pheriperal interface
int_valid //Slaves are i/p
);

parameter NUM_PHER=16;
parameter WIDTH=16;
parameter ADDR_WIDTH=16;
parameter S_NO_INTRPT                     =3'b001;  
parameter S_INTRPT_GIVEN_TO_PROC           =3'b010;
parameter S_INTRPT_SERVICED_PENDING_INTRPT =3'b100;

input clk,rst,sel,enable,write,intrp_serviced;
input[WIDTH-1:0]wdata;
input[ADDR_WIDTH-1:0]addr;
input[NUM_PHER-1:0]int_valid;
output reg ready,error,intrp_valid;
output reg [WIDTH-1:0]rdata;
output reg [NUM_PHER-1:0]pher_with_intrp;

//internal registers
reg[WIDTH-1:0]pri_reg[NUM_PHER-1:0];
integer i;
reg[3:0]state,nxt_state;
reg[4:0]cur_high_pri_value;
reg[3:0]intrp_with_high_pri_value;
reg first_match_f;

//program the registers
always@(posedge clk)begin
   if(rst)begin
    rdata=0;
	ready=0;
    error=0;
	intrp_valid=0;
	pher_with_intrp=0;
	for(i=0;i<NUM_PHER;i=i+1)pri_reg[i]=0;
	state=S_NO_INTRPT;
	nxt_state=S_NO_INTRPT;
    cur_high_pri_value=0;
    intrp_with_high_pri_value=0;
	first_match_f=0;
end
    else begin
	  if(enable)begin
	   ready=1;
	     if(write)begin
		   pri_reg[addr]=wdata;
		 end
		  else begin
		     rdata=pri_reg[addr];
		  end
       end
	     else begin
			  ready=0;
			end
		 end
	end
//handling the interrupts
always@(posedge clk)begin
  if(!rst)begin
     case(state)
	 S_NO_INTRPT:begin
	   if(int_valid!=0)begin
	     nxt_state=S_INTRPT_GIVEN_TO_PROC;
		 first_match_f=1;
	   end
	      else begin
		    nxt_state=S_NO_INTRPT;
		  end
	 end
	   S_INTRPT_GIVEN_TO_PROC:begin
	     for(i=0;i<NUM_PHER;i=i+1)begin
		   if(int_valid==1)begin
		     if(first_match_f==1)begin
			   cur_high_pri_value=pri_reg[i];
			   intrp_with_high_pri_value=i;
			   first_match_f=0;
			 end
			  else begin
			     if(cur_high_pri_value<pri_reg[i])begin
				  cur_high_pri_value=pri_reg[i];
				  intrp_with_high_pri_value=i;
				 end
			  end
		   end
		 end
		  intrp_valid=1;
		  pher_with_intrp=intrp_with_high_pri_value;
		  nxt_state=S_INTRPT_SERVICED_PENDING_INTRPT;
	   end
	   S_INTRPT_SERVICED_PENDING_INTRPT:begin
	     if(intrp_serviced==1)begin
		   if(int_valid!=0)begin
		    nxt_state=S_INTRPT_GIVEN_TO_PROC;
			cur_high_pri_value=0;
			intrp_with_high_pri_value=0;
			first_match_f=1;
			intrp_valid=0;
		   end
		    else begin
			  nxt_state=S_NO_INTRPT;
			end
		 end
	   end
	   endcase
  end
end	
always@(nxt_state)state=nxt_state;
endmodule
