module multiplier #(
	N = 16,
	Q = 8
)
(
	input[N-1: 0] A,
	input[N-1: 0] B,
	output[N-1: 0] C, 
		
);

	reg[2*N-1: 0] mult_output, tmp3;
	reg[N-1: 0] tmp1, tmp2;
	always(*) begin
		if(~A[N-1] & ~B[N-1]) begin 
			tmp1 = A;
			tmp2 = B; 
			tmp3 = tmp2 * tmp1;
			mult_output = tmp3;
		end
		else if(~A[N-1] & B[N-1]) begin
			tmp1 = A;
			tmp2 = ~B + 1'b1;
			tmp3 = tmp2 * tmp1;
			mult_output = ~tmp3 + 1'b1;
		end
		else if(A[N-1] & ~B[N-1]) begin
			tmp1 = B;
			tmp2 = ~A + 1'b1;
			tmp3 = tmp2 * tmp1;
			mult_output = ~tmp3 + 1'b1;
		end
		else if(A[N-1] & B[N-1]) begin
			tmp1 = ~A + 1'b1;
			tmp2 = ~B + 1'b1;
			tmp3 = tmp2 * tmp1;
			mult_output = tmp3;
		end
	end

	assign C = mult_output[N-1+Q: Q]

endmodule
