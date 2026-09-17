// REGISTER_FILE: 8 registers x 16-bit, single shared Address bus for read/write,
// synchronous read/write on posedge CLK, asynchronous ACTIVE-LOW reset
module REGISTER_FILE #(
    parameter DATA_WIDTH = 16,
    parameter ADDR_WIDTH = 3     // 8 registers -> 3-bit address
)(
    input  wire                    CLK,
    input  wire                    RST,      // active low, asynchronous
    input  wire                    WrEn,
    input  wire                    RdEn,
    input  wire [ADDR_WIDTH-1:0]   Address,
    input  wire [DATA_WIDTH-1:0]   WrData,
    output reg  [DATA_WIDTH-1:0]   RdData
);

    reg [DATA_WIDTH-1:0] Reg_File [0:7];
    integer i;

    always @(posedge CLK or negedge RST) begin
        if (!RST) begin
            for (i = 0; i < 8; i = i + 1)
                Reg_File[i] <= {DATA_WIDTH{1'b0}};
            RdData <= {DATA_WIDTH{1'b0}};
        end else begin
            // Only one operation (read or write) is evaluated at a time
            if (WrEn)
                Reg_File[Address] <= WrData;
            else if (RdEn)
                RdData <= Reg_File[Address];
        end
    end

endmodule
