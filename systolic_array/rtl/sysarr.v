// UNTESTED systolic array
module sysarr # ( parameter WORD_LEN = 4, ARR_WDT = 4, ARR_DPT = 4) (
    input clk, // clock
    input nrst, // reset
    input preload, // preload signal
    input switch, // switch signal for row processing

    input [((ARR_DPT)*WORD_LEN)-1 : 0] in, // input values for all rows
    input [((ARR_DPT)*ARR_WDT*2*WORD_LEN)-1 : 0] previous_ps, // previous partial sums for all rows
    input [ARR_WDT*WORD_LEN-1 : 0] weight, // weights for the array

    output [((ARR_DPT)*WORD_LEN)-1 : 0] in_forward, // forward input values (concatenated)
    output [((ARR_DPT)*ARR_WDT*2*WORD_LEN)-1 : 0] partial_sum // output partial sums (concatenated)
);


// Chained row outputs/inputs

// Chained row outputs/inputs with growing width
wire [((ARR_DPT+1)*WORD_LEN)-1:0] in_chain;
wire [((ARR_DPT+1)*ARR_WDT*2*WORD_LEN)-1:0] ps_chain;

assign in_chain[WORD_LEN-1:0] = in[WORD_LEN-1:0];
assign ps_chain[ARR_WDT*2*WORD_LEN-1:0] = previous_ps[ARR_WDT*2*WORD_LEN-1:0];

genvar i;
generate
    for (i = 0; i < ARR_DPT; i = i + 1) begin : row_gen
        localparam IN_WDT = (i+1)*WORD_LEN;
        localparam PS_WDT = (i+1)*ARR_WDT*2*WORD_LEN;
        sysrow #(
            .WORD_LEN(WORD_LEN),
            .ARR_WDT(ARR_WDT)
        ) sysrow_inst (
            .clk(clk),
            .nrst(nrst),
            .preload(preload),
            .switch(switch),
            .w(weight),
            .in(in_chain[(IN_WDT)-1:0]),
            .pps(ps_chain[(PS_WDT)-1:0]),
            .inf(in_chain[(IN_WDT+WORD_LEN)-1:IN_WDT]),
            .ps(ps_chain[(PS_WDT+ARR_WDT*2*WORD_LEN)-1:PS_WDT])
        );
    end
endgenerate

// Concatenate all row outputs for final outputs
assign in_forward = in_chain[((ARR_DPT+1)*WORD_LEN)-1:WORD_LEN];
assign partial_sum = ps_chain[((ARR_DPT+1)*ARR_WDT*2*WORD_LEN)-1:ARR_WDT*2*WORD_LEN];


endmodule