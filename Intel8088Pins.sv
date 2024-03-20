interface Intel8088Pins(input CLK, input RESET);

logic MNMX;
logic TEST;
logic READY;
logic NMI;
logic INTR;
logic HOLD;
tri [7:0]AD;
tri [19:8]A;
logic HLDA;
logic IOM;
logic WR;
//logic CS;
logic RD;
logic SSO;
logic INTA;
logic ALE;			
logic DTR;
logic DEN;
logic [7:0]Data;


modport Processor (input CLK, MNMX, TEST, RESET, NMI, INTR, HOLD, READY,
					output A, HLDA, IOM, WR, RD, SSO, INTA, ALE, DTR, DEN, 
					inout AD);

modport Peripheral (input CLK, RESET, WR, RD, ALE);

endinterfaceinterface Intel8088Pins(input CLK, input RESET);

logic MNMX;
logic TEST;
logic READY;
logic NMI;
logic INTR;
logic HOLD;
tri [7:0]AD;
tri [19:8]A;
logic HLDA;
logic IOM;
logic WR;
logic RD;
logic SSO;
logic INTA;
logic ALE;			
logic DTR;
logic DEN;
tri [7:0]Data;
logic [19:0] Address;


	modport Processor (input CLK, MNMX, TEST, RESET, NMI, INTR, HOLD, READY,HLDA ,
					output A,  IOM, WR, RD, SSO, INTA, ALE, DTR, DEN, 
					inout AD);

	modport Peripheral (input CLK, RESET, WR, RD, ALE,Address,
			   	inout Data);

endinterface
