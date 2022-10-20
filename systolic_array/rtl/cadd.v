//implementation of general adder 
module cadd #( parameter WORD_LEN = 4 )(
input [WORD_LEN-1 : 0]a  ,	// 1st summand
input [WORD_LEN-1 : 0]b  ,	// 2nd summand
output [WORD_LEN : 0] sum	// sum of both
);
assign sum = a + b ;
endmodule
