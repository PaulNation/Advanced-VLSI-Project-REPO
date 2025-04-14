module coeff_selector #(
    parameter TAP_WIDTH      = 32,
    // Feed-forward taps: include current sample x(n)
    parameter FF_TAP_COUNT   = 4,
    // Feedback taps: note that A[0] is assumed to be 1 (unity gain)
    parameter FB_TAP_COUNT   = 3,
    parameter NUM_LP_FILTERS   = 20
)
(
    input  logic [8:0]           filter_index,  // 0 to 19 selecting one of 20 filters
    output logic signed [TAP_WIDTH-1:0]   B [0:FF_TAP_COUNT-1],       // 4 feed-forward taps
    output logic signed [TAP_WIDTH-1:0]   A [0:FB_TAP_COUNT-1]        // 3 feedback taps (A0 to A2)
);

    // 3D array: dimensions are [filter][coeff_type][tap_index]
    // coeff_type: 0 for B taps, 1 for A taps.
    // Each filter stores 4 taps for both B and A.
    logic signed [TAP_WIDTH-1:0] mem [0:NUM_LP_FILTERS-1][0:1][0:FF_TAP_COUNT-1];

    // Initialize the 3D memory with filter coefficients.
    // (Only filters 0 to 3 are shown here; the remaining filters should be filled similarly.)
    initial begin
        // Filter 0: cutoff frequency = 1000 Hz
        mem[0][0][0] = 2;
        mem[0][0][1] = 6;
        mem[0][0][2] = 6;
        mem[0][0][3] = 2;
        mem[0][1][0] = -22432;
        mem[0][1][1] = 20560;
        mem[0][1][2] = -6303;
        mem[0][1][3] = 0;

        // Filter 1: cutoff frequency = 2000 Hz
        mem[1][0][0] = 14;
        mem[1][0][1] = 43;
        mem[1][0][2] = 43;
        mem[1][0][3] = 14;
        mem[1][1][0] = -20298;
        mem[1][1][1] = 17066;
        mem[1][1][2] = -4845;
        mem[1][1][3] = 0;

        // Filter 2: cutoff frequency = 3000 Hz
        mem[2][0][0] = 43;
        mem[2][0][1] = 130;
        mem[2][0][2] = 130;
        mem[2][0][3] = 43;
        mem[2][1][0] = -18179;
        mem[2][1][1] = 14050;
        mem[2][1][2] = -3715;
        mem[2][1][3] = 0;

        // Filter 3: cutoff frequency = 4000 Hz
        mem[3][0][0] = 92;
        mem[3][0][1] = 278;
        mem[3][0][2] = 278;
        mem[3][0][3] = 92;
        mem[3][1][0] = -16080;
        mem[3][1][1] = 11468;
        mem[3][1][2] = -2837;
        mem[3][1][3] = 0;

        // Filter 4: cutoff frequency = 5000 Hz
        mem[4][0][0] = 164;
        mem[4][0][1] = 493;
        mem[4][0][2] = 493;
        mem[4][0][3] = 164;
        mem[4][1][0] = -14004;
        mem[4][1][1] = 9282;
        mem[4][1][2] = -2154;
        mem[4][1][3] = 0;

        // Filter 5: cutoff frequency = 6000 Hz
        mem[5][0][0] = 259;
        mem[5][0][1] = 778;
        mem[5][0][2] = 778;
        mem[5][0][3] = 259;
        mem[5][1][0] = -11952;
        mem[5][1][1] = 7457;
        mem[5][1][2] = -1620;
        mem[5][1][3] = 0;

        // Filter 6: cutoff frequency = 7000 Hz
        mem[6][0][0] = 378;
        mem[6][0][1] = 1136;
        mem[6][0][2] = 1136;
        mem[6][0][3] = 378;
        mem[6][1][0] = -9922;
        mem[6][1][1] = 5962;
        mem[6][1][2] = -1201;
        mem[6][1][3] = 0;

        // Filter 7: cutoff frequency = 8000 Hz
        mem[7][0][0] = 523;
        mem[7][0][1] = 1569;
        mem[7][0][2] = 1569;
        mem[7][0][3] = 523;
        mem[7][1][0] = -7911;
        mem[7][1][1] = 4773;
        mem[7][1][2] = -868;
        mem[7][1][3] = 0;

        // Filter 8: cutoff frequency = 9000 Hz
        mem[8][0][0] = 692;
        mem[8][0][1] = 2078;
        mem[8][0][2] = 2078;
        mem[8][0][3] = 692;
        mem[8][1][0] = -5918;
        mem[8][1][1] = 3868;
        mem[8][1][2] = -599;
        mem[8][1][3] = 0;

        // Filter 9: cutoff frequency = 10000 Hz
        mem[9][0][0] = 888;
        mem[9][0][1] = 2666;
        mem[9][0][2] = 2666;
        mem[9][0][3] = 888;
        mem[9][1][0] = -3937;
        mem[9][1][1] = 3232;
        mem[9][1][2] = -376;
        mem[9][1][3] = 0;

        // Filter 10: cutoff frequency = 11000 Hz
        mem[10][0][0] = 1112;
        mem[10][0][1] = 3337;
        mem[10][0][2] = 3337;
        mem[10][0][3] = 1112;
        mem[10][1][0] = -1966;
        mem[10][1][1] = 2855;
        mem[10][1][2] = -181;
        mem[10][1][3] = 0;

        // Filter 11: cutoff frequency = 12000 Hz
        mem[11][0][0] = 1365;
        mem[11][0][1] = 4095;
        mem[11][0][2] = 4095;
        mem[11][0][3] = 1365;
        mem[11][1][0] = -0;
        mem[11][1][1] = 2730;
        mem[11][1][2] = -0;
        mem[11][1][3] = 0;

        // Filter 12: cutoff frequency = 13000 Hz
        mem[12][0][0] = 1649;
        mem[12][0][1] = 4948;
        mem[12][0][2] = 4948;
        mem[12][0][3] = 1649;
        mem[12][1][0] = 1966;
        mem[12][1][1] = 2855;
        mem[12][1][2] = 181;
        mem[12][1][3] = 0;

        // Filter 13: cutoff frequency = 14000 Hz
        mem[13][0][0] = 1967;
        mem[13][0][1] = 5901;
        mem[13][0][2] = 5901;
        mem[13][0][3] = 1967;
        mem[13][1][0] = 3937;
        mem[13][1][1] = 3232;
        mem[13][1][2] = 376;
        mem[13][1][3] = 0;

        // Filter 14: cutoff frequency = 15000 Hz
        mem[14][0][0] = 2322;
        mem[14][0][1] = 6966;
        mem[14][0][2] = 6966;
        mem[14][0][3] = 2322;
        mem[14][1][0] = 5918;
        mem[14][1][1] = 3868;
        mem[14][1][2] = 599;
        mem[14][1][3] = 0;

        // Filter 15: cutoff frequency = 16000 Hz
        mem[15][0][0] = 2718;
        mem[15][0][1] = 8154;
        mem[15][0][2] = 8154;
        mem[15][0][3] = 2718;
        mem[15][1][0] = 7911;
        mem[15][1][1] = 4773;
        mem[15][1][2] = 868;
        mem[15][1][3] = 0;

        // Filter 16: cutoff frequency = 17000 Hz
        mem[16][0][0] = 3159;
        mem[16][0][1] = 9479;
        mem[16][0][2] = 9479;
        mem[16][0][3] = 3159;
        mem[16][1][0] = 9922;
        mem[16][1][1] = 5962;
        mem[16][1][2] = 1201;
        mem[16][1][3] = 0;

        // Filter 17: cutoff frequency = 18000 Hz
        mem[17][0][0] = 3652;
        mem[17][0][1] = 10958;
        mem[17][0][2] = 10958;
        mem[17][0][3] = 3652;
        mem[17][1][0] = 11952;
        mem[17][1][1] = 7457;
        mem[17][1][2] = 1620;
        mem[17][1][3] = 0;

        // Filter 18: cutoff frequency = 19000 Hz
        mem[18][0][0] = 4204;
        mem[18][0][1] = 12612;
        mem[18][0][2] = 12612;
        mem[18][0][3] = 4204;
        mem[18][1][0] = 14004;
        mem[18][1][1] = 9282;
        mem[18][1][2] = 2154;
        mem[18][1][3] = 0;

        // Filter 19: cutoff frequency = 20000 Hz
        mem[19][0][0] = 4822;
        mem[19][0][1] = 14467;
        mem[19][0][2] = 14467;
        mem[19][0][3] = 4822;
        mem[19][1][0] = 16080;
        mem[19][1][1] = 11468;
        mem[19][1][2] = 2837;
        mem[19][1][3] = 0;




    end

    // Combinational logic to select and output the coefficients for the chosen filter.
    // The B coefficients (all 4 taps) come from mem[filter_index][0][*].
    // The A coefficients (only the first 3 taps, with the assumption that A[3] is 0) come from mem[filter_index][1][0:2].
    always_comb begin
        B[0] = mem[filter_index][0][0];
        B[1] = mem[filter_index][0][1];
        B[2] = mem[filter_index][0][2];
        B[3] = mem[filter_index][0][3];

        A[0] = mem[filter_index][1][0];
        A[1] = mem[filter_index][1][1];
        A[2] = mem[filter_index][1][2];
    end

endmodule
