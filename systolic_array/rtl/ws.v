//implementation of weight stationary processing element
module ws #(parameter WORD_LEN = 4) (

input clk , // clk 
input nrst , // nrst
input preload , // preload- connected to valid of prev os_pe  

input [WORD_LEN-1 : 0] weight_preload , // the weight used
input [WORD_LEN-1 : 0] in_active , // input value
input [2*WORD_LEN-1 : 0] previous_ps ,

output [WORD_LEN-1 : 0] in_forward ,
output [2*WORD_LEN-1 : 0] partial_sum  // the calculation sent forward
//output valid // valid signal for next pe or output of the array

);

reg [WORD_LEN-1 : 0] w ;
reg [WORD_LEN-1 : 0] in ;
reg [2*WORD_LEN-1 : 0] ps  ; 


// outputs
assign partial_sum =  ps + in*w; 
assign in_forward = in ; 


// in register loading
always@(posedge clk , negedge nrst) 
	if(!nrst)
		in  <= {WORD_LEN{1'b0}};
	else
		in <= in_active ; 

// ps register loading
always@(posedge clk , negedge nrst) 
	if(!nrst)
		ps  <= {2*WORD_LEN{1'b0}};
	else
		ps <= previous_ps ; 


// weight register pre-loading
always@(posedge clk , negedge nrst) 
	if(!nrst)
		w <= {WORD_LEN{1'b0}};
	else 
		if (preload)begin
		end
		else 
			w <= weight_preload ; 

endmodule
