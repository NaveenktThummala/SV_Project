module IOMFSM #(parameter IOM = 1) (Intel8088Pins.Peripheral in,
					input CS,
					input [19:0]Address,
					inout [7:0]Data);


typedef enum logic [4:0] {
	IDLE = 5'b00001,
	FETCH_ADDRESS = 5'b00010,
	READ = 5'b00100,
	WRITE = 5'b01000,
	END = 5'b10000
} fsm_state;

fsm_state current_state, next_state;

logic OE, Write, LoadAddress; 
logic [7:0] memory [0:2**20-1];
logic [19:0] addr;

always_latch
begin
if(LoadAddress)
	addr <= Address;
end

always_ff @(posedge in.CLK)
begin
	if(Write)
		memory[addr] <= Data;
end

assign Data = OE ?  memory[addr] : 'z;

always_ff @(posedge in.CLK) 
begin
	if (in.RESET) 
	begin
		current_state <= IDLE;
	end 
	else 
	begin
		current_state <= next_state;
	end
end

always_comb
begin
	next_state = current_state;
	unique0 case (current_state)
		IDLE: 
		begin
			if (CS && in.ALE)  
				next_state = FETCH_ADDRESS;
		end
		FETCH_ADDRESS:
		begin
			if (!in.RD) 
			begin 
				next_state = READ; 
			end 
			else if (!in.WR) 
			begin 
				next_state = WRITE; 
			end
		end
		READ: 
		begin
			next_state = END; 
		end
		WRITE: 
		begin
			next_state = END; 
		end
		END: 
		begin
			next_state = IDLE;
		end
	endcase
end

always_comb 
begin
	{LoadAddress, OE, Write} = '0;
	unique0 case (current_state)
		IDLE: begin
		
        end
		FETCH_ADDRESS: 
		begin
			LoadAddress = '1; 
		end
		READ: 
		begin
			OE = '1;				
		end
		WRITE: 
		begin
			Write = '1;
		end
		END: begin
		
		end
	endcase
end
initial $readmemh("tracefile1.txt", memory);


endmodule
