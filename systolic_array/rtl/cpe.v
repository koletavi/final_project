// implementation of the improved configurable processing element
module cpe #(parameter WORD_LEN=4) (
input clk			, // clock
input nrst			, // negetive reset
input preload			, // preload
input switch			, // switch , 1 = os switch  0 = ws

input [WORD_LEN-1:0] w		, // weight
input [WORD_LEN-1:0] in		, // in
input [WORD_LEN-1:0] pps	, // previous partial sum

output [WORD_LEN-1:0] inf	, // in forward	
output [2*WORD_LEN-1:0] ps	  //
);
 
reg [WORD_LEN-1:0] inreg; 	// in register
reg [WORD_LEN-1:0] wreg;	// w register
reg [2*WORD_LEN-1:0] psreg;	// ps register

wire [WORD_LEN-1:0] inwire; 	//output of in register
wire [WORD_LEN-1:0] wwire; 	//output of w register 
wire [2*WORD_LEN-1:0] prd; 	//prod outout
wire [2*WORD_LEN-1:0] pswire; 	//output of ps mux (the right one)
wire [2*WORD_LEN-1:0] nps; 	//output of psreg

// instantiation of multiplier
cmult #(WORD_LEN) mult (
.a(inwire),
.b(wwire),
.prd(prd)
);

// instantiation of adder
cadd #(2*WORD_LEN) add (
.a(prd) ,
.b(pswire),
.sum(ps) 
);

// input register loading
always @ (posedge clk, negedge nrst)
	if (!nrst) inreg <= {WORD_LEN{1'b0}};
	else inreg <= in; 

// weight register loading
always @ (posedge clk, negedge nrst)
	if (!nrst) wreg <= w;
	else 
		if (switch) wreg <= w;
		else 
			if(!preload) wreg <= w;

// ps register loading  
always @ (posedge clk, negedge nrst)
	if (!nrst) psreg <= {2*WORD_LEN{1'b0}};
	else 
		if (switch) 
			if(!preload) psreg <= pps;
			else psreg <= ps;
		else psreg <= pps;	

// wiring between registers and modules
assign inwire = !preload ? 0 : inreg; 
assign wwire = !preload ? 0 : wreg; 
assign pswire = switch? nps : pps ;
assign nps = psreg ;
assign inf = inreg ; 


endmodule
