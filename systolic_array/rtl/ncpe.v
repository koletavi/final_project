// naive implementation of configirable Processing Element 
module ncpe #( parameter WORD_LEN = 4 ) (
input clk 	,	//clock
input nrst 	,	//negetive reset
input preload 	, 	// preload
input switch	,	// switch , 1 = os switch  0 = ws

input [WORD_LEN-1 : 0] w 	,	// weight
input [WORD_LEN-1 : 0] in 	, 	// in
input [2*WORD_LEN-1 : 0] pps 	, 	// previous partial sum

output [WORD_LEN-1 : 0] inf 	,	// in forward
output [2*WORD_LEN-1 : 0] ps		// partial sum
);

wire [2*WORD_LEN-1 : 0] ps_os ;
wire [2*WORD_LEN-1 : 0] ps_ws ; 

// mux chosing the working method of the pe
assign ps = switch ? ps_os : ps_ws ;


// instantization of ospe
os #(WORD_LEN) os_i (
.clk(clk) 		, 
.nrst(nrst) 		, 
.preload(preload) 	,

.weight(w) 		, 
.in_active(in)		,
.acc_preload(pps)	,

.partial_sum(ps_os)
);

// instantization of wspe
ws #(WORD_LEN) ws_i (
.clk(clk)		,
.nrst(nrst)		,
.preload(preload)	,

.weight_preload(w)	,
.in_active(in)		,
.previous_ps(pps)	,

.in_forward(inf)	,
.partial_sum(ps_ws)
);

endmodule
