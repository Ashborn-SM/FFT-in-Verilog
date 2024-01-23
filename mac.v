module mac #(
	parameter N = 32,
	parameter Q = 8 
)
(
	input 			clk,
	input 			reset,
	input[N-1: 0]		A, // input A
	input[N-1: 0]		B, // input B
	input[N-1: 0]		W, // twiddle factor
	output reg[N-1: 0]	C, // output(real + imag)
	output reg[N-1: 0]	D  // conjugate output
);

	localparam n = N/2;

	wire[n-1: 0] real_A, real_B, real_W;
	wire[n-1: 0] imag_A, imag_B, imag_W;
	wire[n-1: 0] B_W_r_r, B_W_r_i, B_W_i_r, B_W_i_i;	
	wire[n-1: 0] B_W_r_r_n, B_W_r_i_n, B_W_i_r_n, B_W_i_i_n;	
	wire[n-1: 0] real_0, imag_0, real_1, imag_1;

	assign real_A = A[N-1: n];
	assign real_B = B[N-1: n];
	assign real_W = W[N-1: n];

	assign imag_A = A[n-1: 0];
	assign imag_B = B[n-1: 0];
	assign imag_W = W[n-1: 0];

	multiplier #(.N(n), .Q(Q)) r_r(
		.A(real_B),
		.B(real_W),
		.C(B_W_r_r)	
	);

	multiplier #(.N(n), .Q(Q)) r_i(
		.A(real_B),
		.B(imag_W),
		.C(B_W_r_i)	
	);

	multiplier #(.N(n), .Q(Q)) i_r(
		.A(imag_B),
		.B(real_W),
		.C(B_W_i_r)	
	);

	multiplier #(.N(n), .Q(Q)) i_i(
		.A(imag_B),
		.B(imag_W),
		.C(B_W_i_i)	
	);

	twos_complement #(.N(n)) r_r_n(
		.A(B_W_r_r),
		.B(B_W_r_r_n)
	);

	twos_complement #(.N(n)) r_i_n(
		.A(B_W_r_i),
		.B(B_W_r_i_n)
	);

	twos_complement #(.N(n)) i_r_n(
		.A(B_W_i_r),
		.B(B_W_i_r_n)
	);

	twos_complement #(.N(n)) i_i_n(
		.A(B_W_i_i),
		.B(B_W_i_i_n)
	);

	adder #(.N(n)) r_0(
		.A(real_A),
		.B(B_W_r_r),	
		.C(B_W_i_i),
		.D(real_0)
	);

	adder #(.N(n)) r_1(
		.A(real_A),
		.B(B_W_r_r_n),	
		.C(B_W_i_i_n),
		.D(real_1)
	);

	adder #(.N(n)) i_0(
		.A(imag_A),
		.B(B_W_r_i),	
		.C(B_W_i_r),
		.D(imag_0)
	);

	adder #(.N(n)) i_1(
		.A(imag_A),
		.B(B_W_r_i_n),	
		.C(B_W_i_r_n),
		.D(imag_1)
	);


	always@(negedge clk, posedge reset) begin
		if(reset) begin
			C <= {N{1'b0}};
			D <= {N{1'b0}};
		end
		else begin
			C <= {real_0, imag_0};
			D <= {real_1, imag_1};
		end
	end

endmodule
