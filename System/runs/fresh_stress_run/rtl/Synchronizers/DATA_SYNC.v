module DATA_SYNC #(
    parameter NUM_STAGES = 2,
    parameter BUS_WIDTH  = 8
) (
    input  wire                 dest_clk,
    input  wire                 dest_rst,
    input  wire [BUS_WIDTH-1:0] unsync_bus,
    input  wire                 bus_enable,
    output reg  [BUS_WIDTH-1:0] sync_bus,
    output reg                  enable_pulse_d
);

    reg [NUM_STAGES-1:0] sync_enable;
    reg                  pulse_d;

    // Synchronize bus_enable pulse into dest_clk domain
    always @(posedge dest_clk or negedge dest_rst) begin
        if (!dest_rst) begin
            sync_enable <= {NUM_STAGES{1'b0}};
        end
        else begin
            sync_enable <= {sync_enable[NUM_STAGES-2:0], bus_enable};
        end
    end

    // Pulse generator & bus latch
    always @(posedge dest_clk or negedge dest_rst) begin
        if (!dest_rst) begin
            pulse_d        <= 1'b0;
            enable_pulse_d <= 1'b0;
            sync_bus       <= {BUS_WIDTH{1'b0}};
        end
        else begin
            pulse_d        <= sync_enable[NUM_STAGES-1];
            enable_pulse_d <= sync_enable[NUM_STAGES-1] & ~pulse_d;
            if (sync_enable[NUM_STAGES-1] & ~pulse_d) begin
                sync_bus <= unsync_bus;
            end
        end
    end

endmodule
