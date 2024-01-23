module adder#(
	parameter N = 16 
)
(
	input[N-1: 0] A,
	input[N-1: 0] B,
	input[N-1: 0] C,
	output[N-1: 0] D
);

	assign D = A + B + C;

endmodule
