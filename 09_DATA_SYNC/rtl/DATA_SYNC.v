// ============================================================================
// Module Name  : DATA_SYNC
// Description  : Synthesizable Data Synchronizer for Clock Domain Crossing (CDC)
//                implements the Synchronized MUX-Select Synchronization Scheme.
// Parameters   : NUM_STAGES - Number of Flip Flop synchronizer stages (default = 2)
//                BUS_WIDTH  - Width of synchronized data bus (default = 8)
// Inputs       : unsync_bus   - Unsynchronized data bus from source domain
//                bus_enable   - Enable control signal from source domain
//                CLK          - Destination domain clock
//                RST          - Destination domain active-low async reset
// Outputs      : sync_bus     - Synchronized data bus in destination domain
//                enable_pulse - 1-clock-cycle enable pulse in destination domain
// ============================================================================

module DATA_SYNC #(
    parameter NUM_STAGES = 2,
    parameter BUS_WIDTH  = 8
)(
    input  wire [BUS_WIDTH-1:0] unsync_bus,
    input  wire                 bus_enable,
    input  wire                 CLK,
    input  wire                 RST,
    output reg  [BUS_WIDTH-1:0] sync_bus,
    output reg                  enable_pulse
);

    // ------------------------------------------------------------------------
    // Internal Registers & Signals
    // ------------------------------------------------------------------------
    reg [NUM_STAGES-1:0] sync_stage_reg;
    reg                  enable_flop;
    wire                 generated_pulse;

    // ------------------------------------------------------------------------
    // 1. Multi Flip-Flop Synchronizer Chain for bus_enable
    // ------------------------------------------------------------------------
    always @(posedge CLK or negedge RST) begin
        if (!RST) begin
            sync_stage_reg <= {NUM_STAGES{1'b0}};
        end else begin
            sync_stage_reg <= {sync_stage_reg[NUM_STAGES-2:0], bus_enable};
        end
    end

    // ------------------------------------------------------------------------
    // 2. Pulse Generator Block (Rising Edge Detector)
    // ------------------------------------------------------------------------
    always @(posedge CLK or negedge RST) begin
        if (!RST) begin
            enable_flop <= 1'b0;
        end else begin
            enable_flop <= sync_stage_reg[NUM_STAGES-1];
        end
    end

    assign generated_pulse = sync_stage_reg[NUM_STAGES-1] && (!enable_flop);

    // ------------------------------------------------------------------------
    // 3. MUX-Select Registered Data Bus (sync_bus)
    // ------------------------------------------------------------------------
    always @(posedge CLK or negedge RST) begin
        if (!RST) begin
            sync_bus <= {BUS_WIDTH{1'b0}};
        end else if (generated_pulse) begin
            sync_bus <= unsync_bus;
        end
    end

    // ------------------------------------------------------------------------
    // 4. Destination Domain Enable Pulse Register (enable_pulse)
    // ------------------------------------------------------------------------
    always @(posedge CLK or negedge RST) begin
        if (!RST) begin
            enable_pulse <= 1'b0;
        end else begin
            enable_pulse <= generated_pulse;
        end
    end

endmodule
