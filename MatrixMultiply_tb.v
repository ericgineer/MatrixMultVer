// A testbench for matrix multiplication

`timescale 1ns/1ns

`define dsize 8

`define rowsA 3
`define colsA 1

`define rowsB 1
`define colsB 3

module MatrixMultiply_tb();
	reg clk;
	reg rst;
	reg vin;
	wire vout;
	
	reg [`rowsA * `colsA * `dsize - 1:0] A;  // Input matrix A
	reg [`rowsB * `colsB * `dsize - 1:0] B;  // Input matrix B
	wire [`rowsA * `colsB * `dsize - 1:0] C; // Output matrix C
	reg [`rowsA * `colsB * `dsize - 1:0] Cver; // Verification matrix C
	
	integer fidA, freadA;
	integer fidB, freadB;
	integer fidC, freadC;
	integer i, j;
	integer tmpA, tmpB, tmpC;
	
	always #1 clk = ~clk;
	
	matrixMult #(.dsize(`dsize),.rowsA(`rowsA),.colsA(`colsA),.rowsB(`rowsB),.colsB(`colsB))
	 matrixMult (.clk(clk),
				 .rst(rst),
				 .vin(vin),
				 .vout(vout),
				 .A(A),
				 .B(B),
				 .C(C));
	
	initial
	begin
		clk <= 1'b1;
		rst <= 1'b1;
		vin <= 1'b0;
		fidA <= $fopen("C:/Users/eric/Documents/FPGA/MatrixMultiply/A.csv","r");
		fidB <= $fopen("C:/Users/eric/Documents/FPGA/MatrixMultiply/B.csv","r");
		fidC <= $fopen("C:/Users/eric/Documents/FPGA/MatrixMultiply/C.csv","r");
		@(posedge clk);
		for (i = 0; i < `rowsA * `colsA; i = i + 1)
		begin
			if (!$feof(fidA))
			begin
				freadA <= $fscanf(fidA,"%f\n",tmpA);
				A[(i+1)*`dsize-1 -: `dsize] <= tmpA;
			end
		end
		for (i = 0; i < `rowsB * `colsB; i = i + 1)
		begin
			if (!$feof(fidB))
			begin
				freadA <= $fscanf(fidB,"%f\n",tmpB);
				B[(i+1)*`dsize-1 -: `dsize] <= tmpB;
			end
		end
		for (i = 0; i < `rowsA * `colsB; i = i + 1)
        begin
            if (!$feof(fidC))
            begin
                freadC <= $fscanf(fidC,"%f\n",tmpC);
                Cver[(i+1)*`dsize-1 -: `dsize] <= tmpC;
            end
        end
	end
	
	initial
	begin
		@(posedge clk);
		rst <= 1'b0;
		repeat(10) @(posedge clk);
		vin <= 1'b1;
		@(posedge clk);
		vin <= 1'b0;
		while(!vout) @(posedge clk);
		//repeat(10) @(posedge clk);
		@(posedge clk);
		$fclose(fidA);
        $fclose(fidB);
        $fclose(fidC);
		$stop;
	end
	
	// Output verification
    always @(posedge clk)
    begin 
        if (vout)
        begin
            if (Cver == C) $display("Verification passed! :)\n");
            else begin
                $display("Verification failed! :(\n");
                $display("C = %h\n",C);
                $display("Cver = %h\n",Cver);
            end
       end
    end
endmodule
		
			