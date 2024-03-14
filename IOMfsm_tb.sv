module top;

bit CLK = '0;
bit MNMX = '1;
bit TEST = '1;
bit RESET = '0;
bit READY = '1;
bit NMI = '0;
bit INTR = '0;
bit HOLD = '0;

wire logic [7:0] AD;
logic [19:8] A;
logic HLDA;
logic IOM;
logic WR;
logic RD;
logic SSO;
logic INTA;
logic ALE;
logic DTR;
logic DEN;


logic [19:0] Address;
wire [7:0]  Data;

logic CS1, CS2;

Intel8088 P(CLK, MNMX, TEST, RESET, READY, NMI, INTR, HOLD, AD, A, HLDA, IOM, WR, RD, SSO, INTA, ALE, DTR, DEN);
IOMFSM #(.IOM(0)) dut1 (CLK,RESET,ALE,RD,WR,CS1,Address,Data);
IOMFSM #(.IOM(0)) dut2 (CLK,RESET,ALE,RD,WR,CS2,Address,Data);
IOMFSM #(.IOM(1)) dut3 (CLK,RESET,ALE,RD,WR,CS1,Address,Data);
IOMFSM #(.IOM(1)) dut4 (CLK,RESET,ALE,RD,WR,CS2,Address,Data);

always_comb
begin
{CS1,CS2} = 2'b00;
if(!IOM)
begin 
	if(!Address[19])
		{CS1,CS2} = 2'b01;
	else
		{CS1,CS2} = 2'b10;
end
else
	if(16'h1C00 <= Address[15:0] <= 16'h1DFF)
		{CS1,CS2} = 2'b01;
	else if (16'hFF00 <= Address[15:0] <= 16'hFF0F)
		{CS1,CS2} = 2'b10;
	else 
		{CS1,CS2} = 2'b00;
end

// 8282 Latch to latch bus address
always_latch
begin
if (ALE)
	Address <= {A, AD};
end

// 8286 transceiver
assign Data =  (DTR & ~DEN) ? AD   : 'z;
assign AD   = (~DTR & ~DEN) ? Data : 'z;
always #50 CLK = ~CLK;

initial
begin
$dumpfile("dump.vcd"); $dumpvars;

repeat (2) @(posedge CLK);
RESET = '1;
repeat (5) @(posedge CLK);
RESET = '0;

repeat(10000) @(posedge CLK);
$finish();
end

endmodule
