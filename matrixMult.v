`timescale 1ns/1ns

module matrixMult #(parameter dsize = 8, rowsA = 10, colsA = 10, rowsB = 10, colsB = 10)
				   (input clk,
				    input rst,
					input vin,
					output vout,
					input [rowsA * colsA * dsize - 1:0] A,
					input [rowsB * colsB * dsize - 1:0] B,
					output [rowsA * colsB * dsize - 1:0] C);
					
	integer i, j, m, n, k, w;
	
	
	reg [rowsA * colsA * dsize - 1:0] Atmp[rowsB:0];
	reg [rowsB * colsB * dsize - 1:0] Btmp[rowsB:0];
	reg [rowsA * colsB * dsize - 1:0] Ctmp[rowsB:0];
	
	reg [rowsB:0] v;
	
	assign C = Ctmp[rowsB];
	
	assign vout = v[rowsB];
					
	always @(posedge clk)
	begin
		if (rst)
		begin
		   for (i = 0; i <= colsB; i = i + 1) Atmp[i] <= {rowsA*colsA-1{1'b0}};
           for (i = 0; i <= colsB; i = i + 1) Btmp[i] <= {rowsB*colsB-1{1'b0}};
	       for (i = 0; i <= colsB; i = i + 1) Ctmp[i] <= {rowsA*colsA-1{1'b0}};
	       v <= {colsB+1{1'b0}};
		end else begin
		    v <= {v[rowsB-1:0],vin};
		    if (vin) Atmp[0] <= A;
		    if (vin) Btmp[0] <= B;
		    for (w = 1; w <= rowsB; w = w + 1)
		    begin
		        if (v[w-1]) Atmp[w] <= Atmp[w-1];
		        if (v[w-1]) Btmp[w] <= Btmp[w-1];
		    end
			for (m = 0; m < rowsA; m = m + 1)
			begin
				for (n = 0; n < colsB; n = n + 1)
				begin
				    j = 1;
					for (k = 0; k < rowsB; k = k + 1)
					begin
						if (v[j-1]) Ctmp[j][((m*colsB+n)+1)*dsize-1-:dsize] <= Ctmp[j-1][((m*colsB+n)+1)*dsize-1-:dsize] + Atmp[j-1][((m*colsA+k)+1)*dsize-1-:dsize] * Btmp[j-1][((k*colsB+n)+1)*dsize-1-:dsize];
						if (v[j-1]) $display("m = %f, n = %f, k = %f, j = %f\n",m,n,k,j);
						if (v[j-1]) $display("A = %f\n",Atmp[j-1][((m*colsA+k)+1)*dsize-1-:dsize]);
						if (v[j-1]) $display("B = %f\n",Btmp[j-1][((k*colsB+n)+1)*dsize-1-:dsize]);
						if (v[j-1]) $display("C = %f\n",Ctmp[j-1][((m*colsB+n)+1)*dsize-1-:dsize]);
						j = j + 1;
				    end
				end
		     end
		 end
	end
endmodule