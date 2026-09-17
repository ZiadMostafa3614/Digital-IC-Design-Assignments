module RegFile #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 4,
    parameter DEPTH      = 16
) (
    input  wire                  CLK,
    input  wire                  RST,
    input  wire [ADDR_WIDTH-1:0] Address,
    input  wire                  WrEn,
    input  wire                  RdEn,
    input  wire [DATA_WIDTH-1:0] WrData,
    output reg  [DATA_WIDTH-1:0] RdData,
    output reg                   RdData_Valid,
    output wire [DATA_WIDTH-1:0] REG0,
    output wire [DATA_WIDTH-1:0] REG1,
    output wire [DATA_WIDTH-1:0] REG2,
    output wire [DATA_WIDTH-1:0] REG3
);

    reg [DATA_WIDTH-1:0] reg_mem [0:DEPTH-1];
    integer i;

    // Synchronous Write & Reset with defaults for reserved registers
    always @(posedge CLK or negedge RST) begin
        if (!RST) begin
            for (i = 0; i < DEPTH; i = i + 1) begin
                if (i == 2)
                    reg_mem[i] <= 8'b10000001; // REG2: Prescale=32 (bits 7:2), Parity_Type=0 (bit 1), Parity_Enable=1 (bit 0)
                else if (i == 3)
                    reg_mem[i] <= 8'd32;       // REG3: Div_Ratio=32
                else
                    reg_mem[i] <= {DATA_WIDTH{1'b0}};
            end
        end
        else if (WrEn) begin
            reg_mem[Address] <= WrData;
            $display("[DEBUG_REGFILE] WRITE: Addr=0x%01h, Data=0x%02h at time %0t", Address, WrData, $time);
        end
    end

    // Synchronous Read & Read Data Valid
    always @(posedge CLK or negedge RST) begin
        if (!RST) begin
            RdData       <= {DATA_WIDTH{1'b0}};
            RdData_Valid <= 1'b0;
        end
        else if (RdEn) begin
            RdData       <= reg_mem[Address];
            RdData_Valid <= 1'b1;
            $display("[DEBUG_REGFILE] READ: Addr=0x%01h, Data=0x%02h at time %0t", Address, reg_mem[Address], $time);
        end
        else begin
            RdData_Valid <= 1'b0;
        end
    end

    // Reserved Register Outputs
    assign REG0 = reg_mem[0];
    assign REG1 = reg_mem[1];
    assign REG2 = reg_mem[2];
    assign REG3 = reg_mem[3];

endmodule
