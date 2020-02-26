module testbench;
logic[2:0] f;
logic[31:0] a,b,y;
logic[31:0] yex;
logic zex,oex;
logic clk, reset;
logic z,o;
logic[31:0] vectornum, errors;
logic[107:0] testvectors[0:20];

alu dut(.f(f), .a(a), .b(b), .y(y), .zero(z), .OF(o));

initial
	begin
		$readmemh("vector", testvectors);
		vectornum = 0; errors = 0;
		reset = 0;
	end

always
	begin
		clk <= 1; #5; clk <= 0; #5;
	end

always @(posedge clk)
	begin
		{f, a, b, yex, zex, oex} = testvectors[vectornum]; #10;
	end

always @(negedge clk)
	if (~reset)
	begin
		if(y !== yex)
		begin
			$display("Error: inputs = %h", {f, a, b});
			$display("outputs = %h (%h expected)", y, yex);
			errors = errors + 1;
		end
		if(z != zex)
		begin
			$display("Error: inputs = %h", {f, a, b});
			$display("outputs = %h (%h expected)", z, zex);
			errors = errors + 1;
		end
		if(o != oex)
		begin
			$display("Error: inputs = %h", {f, a, b});
			$display("outputs = %h (%h expected)", o, oex);
			errors = errors + 1;
		end
		vectornum = vectornum + 1;
		if(vectornum >= 20)
		begin
			$display("%d tests completed with %d errors", vectornum, errors);
			$finish;
		end
	end
endmodule
