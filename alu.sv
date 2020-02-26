module alu(
		input logic[2:0] f,
		input logic[31:0] a,b,
		output logic[31:0] y,
		output logic zero, OF);

	logic[31:0] add, sub;
	logic ofadd, ofsub, slt;

	assign zero = (y == 0); //true when output is 0
	
	assign add = a + b; //adder and subtractor
	assign sub = a - b;

	assign ofadd = (a[31] == b[31] && add[31] != a[31]) ? 1 : 0; //2s complement OF occurs when sign (leftmost bit) is incorrect after operation is performed
	assign ofsub = (a[31] == b[31] && sub[31] != a[31]) ? 1 : 0;
	assign OF = (f == 3'd6) ? ofsub : ofadd; //if op is subtract, ofsub is assigned to OF, otherwise ofadd

	assign slt = ofsub ? ~(a[31]) : a[31]; //slt is the result of sub, if overflow occurs, assign opposite sign, otherwise keep same sign

	always_comb //using f as control, mux will determine which operation result to output to y
		case(f)
			3'd0: y = (a & b);
			3'd1: y = (a | b);
			3'd2: y = add;
			3'd4: y = (a & ~(b));
			3'd5: y = (a | ~(b));
			3'd6: y = sub;
			3'd7: y = {{31{1'b0}}, slt};
			default: y = 0;
		endcase
endmodule //alu 