// implementation of general multiplier
module cmult #(parameter WORD_LEN=4)(
input [WORD_LEN-1:0]a ,		// 1st factor
input [WORD_LEN-1:0]b ,		// 2nd factor
output [2*WORD_LEN-1:0] prd 	// product of the factors
);
assign prd=a*b;
endmodule
