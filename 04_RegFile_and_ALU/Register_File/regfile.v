module REG_FILE (
    input  wire        CLK,
    input  wire        RST,      // active low, asynchronous
    input  wire        WrEn,
    input  wire        RdEn,
    input  wire [2:0]  Address,
    input  wire [15:0] WrData,
    output reg  [15:0] RdData
);

    reg [15:0] Reg_File [0:7];

    always @(posedge CLK or negedge RST) begin
        if (!RST) begin
            Reg_File[0] <= 16'b0;
            Reg_File[1] <= 16'b0;
            Reg_File[2] <= 16'b0;
            Reg_File[3] <= 16'b0;
            Reg_File[4] <= 16'b0;
            Reg_File[5] <= 16'b0;
            Reg_File[6] <= 16'b0;
            Reg_File[7] <= 16'b0;
            RdData      <= 16'b0;
        end else begin
            // Only one operation (read or write) is evaluated at a time
            if (WrEn)
                Reg_File[Address] <= WrData;
            else if (RdEn)
                RdData <= Reg_File[Address];
        end
    end

endmodule
