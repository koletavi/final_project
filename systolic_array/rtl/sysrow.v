// UNTESTED systolic array row
module sysrow #( parameter WORD_LEN = 4 , ARR_WDT = 4 ) (
input clk	,
input nrst	,
input preload	,
input switch	,


input [ARR_WDT*WORD_LEN-1 : 0] 	w			,	// weight
input [WORD_LEN-1 : 0] 	in				, 	// in
input [ARR_WDT*2*WORD_LEN-1 : 0] pps			, 	// previous partial sum

output [WORD_LEN-1 : 0] inf 				,	// in forward
output [ARR_WDT*2*WORD_LEN-1 : 0] ps				// partial sum
);

wire [WORD_LEN-1 : 0] 	w_w	[ARR_WDT-1 : 0]	;	// weight
wire [WORD_LEN-1 : 0] in_w 	[ARR_WDT   : 1] ; 
wire [2*WORD_LEN-1 : 0] pps_w 	[ARR_WDT-1 : 0]	; 	// previous partial sum

wire [2*WORD_LEN-1 : 0] ps_w 	[ARR_WDT-1 : 0];			// partial sum

genvar i ;

generate

		ncpe # ( WORD_LEN ) ncpe_i (
		.clk(clk)	,
		.nrst(nrst)	,
		.preload(preload),
		.switch(switch)	,

		.w(w[0])	,
		.in(in)	,
		.pps(pps[0])	,

		.inf(in_w[1])	,
		.ps(ps_w[0])
		);
	for ( i=1 ; i<ARR_WDT ; i=i+1 ) begin
		ncpe # ( WORD_LEN ) ncpe_i (
		.clk(clk)	,
		.nrst(nrst)	,
		.preload(preload),
		.switch(switch)	,

		.w(w[i])	,
		.in(in_w[i])	,
		.pps(pps[i])	,

		.inf(in_w[i+1])	,
		.ps(ps_w[i])
		);
	end
assign ps = ps_w[ARR_WDT-1];
assign inf= in_w[ARR_WDT];
endgenerate 

endmodule 
