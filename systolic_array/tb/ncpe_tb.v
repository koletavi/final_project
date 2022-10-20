module ncpe_tb ;


parameter WORD_LEN = 4	;

//control inputs
reg clk ;
reg nrst;
reg act ;
reg switch ; 
//value inputs
reg [WORD_LEN-1:0] w	;
reg [WORD_LEN-1:0] in	;
reg [2*WORD_LEN-1:0] pps;

//output
wire [2*WORD_LEN-1:0] ps;
wire [WORD_LEN-1:0] inf ;

//genral execcories
integer in_f , out_f ; 
integer i;


//instantistaion
ncpe #( WORD_LEN) ncpe_i ( 
.clk(clk)	,
.nrst(nrst)	,
.preload(act)	,
.switch(switch)	,

.w(w)		,
.in(in)		,
.pps(pps)	,

.inf(inf)	,
.ps(ps)
);

//clock defintion
always #5 clk = ~clk;


initial begin 
//file mangement
in_f = $fopen("../inputs/input_os.txt" , "r" );
out_f= $fopen("../outputs/output_ncpe.txt" , "w" );

//initialization of the control
clk = 1'b1 ;
nrst = 1'b0 ;
act = 1'b0 ;
switch = 1'b1 ;
w = 4'h0;
in = 4'h0; 

//pps preload
pps= 8'h00;

#10 nrst = 1'b1;
#10 act = 1'b1;
$fdisplay(out_f , "OS RUN\n");

//work example
for(i = 0 ; i<4 ; i=i+1) begin  
	$fscanf(in_f , "%d %d", w , in );
#10; 
	$fdisplay(out_f , "%d", ps);	
end

//act=1'b0;
pps=8'h0a;
//#10 //act =1'b1;
for(i = 0 ; i<2 ; i=i+1) begin  
	$fscanf(in_f , "%d %d", w , in );
#10; 
	$fdisplay(out_f , "%d", ps);
	
end

//act=1'b0;
nrst = 1'b0;

act=1'b0;
#10 nrst = 1'b1;
#10 act=1'b1;
while(!$feof(in_f))begin  
	$fscanf(in_f , "%d %d", w , in );
#10; 
	$fdisplay(out_f , "%d", ps);
	
end

$fclose(in_f);
#10; //140ns switching to weight stationary



//file mangement
in_f = $fopen("../inputs/input_ws.txt" , "r" );

//re-initialization of the control
clk = 1'b1 ;
nrst = 1'b0 ;
act = 1'b0 ;
switch = 1'b0 ;

#10 nrst = 1'b1 ;


//w preload
w = 4'd2 ;
#10 act=1'b1;

$fdisplay(out_f , "\nWS RUN\n");

//work example
for(i = 0 ; i<4 ; i=i+1) begin  
	$fscanf(in_f , "%d %d", pps , in );
#10; 
	$fdisplay(out_f , "%d", ps);	
end

for(i = 0 ; i<2 ; i=i+1) begin  
	$fscanf(in_f , "%d %d", pps , in );
#10; 
	$fdisplay(out_f , "%d", ps);
	
end

act=1'b0 ;
w = 4'd4;
nrst = 1'b0 ;
#10 nrst = 1'b1 ;
#10 act=1'b1;
while(!$feof(in_f))begin  
	$fscanf(in_f , "%d %d", pps , in );
#10; 
	$fdisplay(out_f , "%d %d", ps , inf);
	
end

$fclose(in_f);
$fclose(out_f);

$finish;  

end
endmodule 
