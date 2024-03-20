module top;

bit CLK = '0;
bit RESET ='0;
initial
	begin

		in.MNMX = '1;
		in.TEST = '1;
		in.READY = '1;
 		in.NMI = '0;
 		in.INTR = '0;
 		in.HOLD = '0;
	end

logic [19:0] Address;
wire [7:0]  Data;

logic CS1, CS2, CS3, CS4;


IOMFSM #(1) dut1 (in.Peripheral, CS1, Address, Data);
IOMFSM #(1) dut2 (in.Peripheral, CS2, Address, Data);
IOMFSM #(1) dut3 (in.Peripheral, CS3, Address, Data);
IOMFSM #(1) dut4 (in.Peripheral, CS4, Address, Data);

Intel8088Pins in(.CLK(CLK), .RESET(RESET));
Intel8088 P(in.Processor);

always_comb
	begin
		{CS1,CS2,CS3,CS4} = 4'b0000;
		if(~in.IOM && ~Address[19]) 
			CS1 = 1'b1;
		else if (~in.IOM && Address[19]) 
			CS2 = 1'b1;
		else if(in.IOM && Address[15:9] == 7'hE)
			CS3 = 1'b1;

		else if(in.IOM && Address[15:4] == 12'hFF0)
			CS4 = 1'b1;

	end
	
// 8282 Latch to latch bus address
always_latch
begin
if (in.ALE)
	Address <= {in.A, in.AD};
end

// 8286 transceiver
assign Data = (in.DTR & ~in.DEN) ? in.AD : 'z;
assign in.AD   = (~in.DTR & ~in.DEN) ? Data : 'z;

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
