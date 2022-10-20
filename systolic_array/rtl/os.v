//implementation of output stationary processing element
module os #(parameter WORD_LEN = 4) (
input clk , // clk 
input nrst , // nrst
input preload , // preload- connected to valid of prev os_pe  

input [WORD_LEN-1 : 0] weight , // the weight used
input [WORD_LEN-1 : 0] in_active , // input value
input [2*WORD_LEN-1 : 0] acc_preload , // acc value that gets set at reset

output [2*WORD_LEN-1 : 0] partial_sum  // the calculation sent forward
//output valid // valid signal for next pe or output of the array

);

reg [WORD_LEN-1 : 0] in ; 
reg [WORD_LEN-1 : 0] w ; 
reg [2*WORD_LEN-1 : 0] acc ; 
wire [2*WORD_LEN-1 : 0] next_acc ; 

// calculation of next acc
assign next_acc = !preload ? acc_preload : w*in + acc ; 


// output
assign partial_sum = next_acc ;


// Weight register loading
always@(posedge clk , negedge nrst) 
	if( !nrst )
		w <= {WORD_LEN{1'b0}} ;
	else	
		w <= weight ;


// in register pre-loading
always@(posedge clk , negedge nrst)
	if( !nrst )
		in <= {WORD_LEN{1'b0}} ;
	else
		in <= in_active ;
 
// acc advance
always@(posedge clk , negedge nrst )
	if(!nrst)
		acc <= {2*WORD_LEN{1'b0}} ;
	else
		if(preload) acc <= next_acc ;		
		else acc <= acc_preload ;
endmodule
