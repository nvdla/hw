// ===================================================================
// CLASS: common covergroup
//  - sample bit toggle
//    - transition: 0<->1
// ===================================================================

covergroup bit_toggle_cg(string cg_name, int width = 32)
    with function sample(bit [31:0] x);

    option.name = cg_name;
    option.per_instance = 1;

    bit_0_transition: coverpoint x[0]  {
        bins zeroone = (0 => 1);
        bins onezero = (1 => 0);
        option.weight = (0<width);
    }
    bit_1_transition: coverpoint x[1]  {
        bins zeroone = (0 => 1);
        bins onezero = (1 => 0);
        option.weight = (1<width);
    }
    bit_2_transition: coverpoint x[2]  {
        bins zeroone = (0 => 1);
        bins onezero = (1 => 0);
        option.weight = (2<width);
    }
    bit_3_transition: coverpoint x[3]  {
        bins zeroone = (0 => 1);
        bins onezero = (1 => 0);
        option.weight = (3<width);
    }
    bit_4_transition: coverpoint x[4] {
        bins zeroone = (0 => 1);
        bins onezero = (1 => 0);
        option.weight = (4<width);
    }
    bit_5_transition: coverpoint x[5] {
        bins zeroone = (0 => 1);
        bins onezero = (1 => 0);
        option.weight = (5<width);
    }
    bit_6_transition: coverpoint x[6] {
        bins zeroone = (0 => 1);
        bins onezero = (1 => 0);
        option.weight = (6<width);
    }
    bit_7_transition: coverpoint x[7] {
        bins zeroone = (0 => 1);
        bins onezero = (1 => 0);
        option.weight = (7<width);
    }
    bit_8_transition: coverpoint x[8] {
        bins zeroone = (0 => 1);
        bins onezero = (1 => 0);
        option.weight = (8<width);
    }
    bit_9_transition: coverpoint x[9] {
        bins zeroone = (0 => 1);
        bins onezero = (1 => 0);
        option.weight = (9<width);
    }
    bit_10_transition: coverpoint x[10] {
        bins zeroone = (0 => 1);
        bins onezero = (1 => 0);
        option.weight = (10<width);
    }
    bit_11_transition: coverpoint x[11] {
        bins zeroone = (0 => 1);
        bins onezero = (1 => 0);
        option.weight = (11<width);
    }
    bit_12_transition: coverpoint x[12] {
        bins zeroone = (0 => 1);
        bins onezero = (1 => 0);
        option.weight = (12<width);
    }
    bit_13_transition: coverpoint x[13] {
        bins zeroone = (0 => 1);
        bins onezero = (1 => 0);
        option.weight = (13<width);
    }
    bit_14_transition: coverpoint x[14] {
        bins zeroone = (0 => 1);
        bins onezero = (1 => 0);
        option.weight = (14<width);
    }
    bit_15_transition: coverpoint x[15] {
        bins zeroone = (0 => 1);
        bins onezero = (1 => 0);
        option.weight = (15<width);
    }
    bit_16_transition: coverpoint x[16] {
        bins zeroone = (0 => 1);
        bins onezero = (1 => 0);
        option.weight = (16<width);
    }
    bit_17_transition: coverpoint x[17] {
        bins zeroone = (0 => 1);
        bins onezero = (1 => 0);
        option.weight = (17<width);
    }
    bit_18_transition: coverpoint x[18] {
        bins zeroone = (0 => 1);
        bins onezero = (1 => 0);
        option.weight = (18<width);
    }
    bit_19_transition: coverpoint x[19] {
        bins zeroone = (0 => 1);
        bins onezero = (1 => 0);
        option.weight = (19<width);
    }
    bit_20_transition: coverpoint x[20] {
        bins zeroone = (0 => 1);
        bins onezero = (1 => 0);
        option.weight = (20<width);
    }
    bit_21_transition: coverpoint x[21] {
        bins zeroone = (0 => 1);
        bins onezero = (1 => 0);
        option.weight = (21<width);
    }
    bit_22_transition: coverpoint x[22] {
        bins zeroone = (0 => 1);
        bins onezero = (1 => 0);
        option.weight = (22<width);
    }
    bit_23_transition: coverpoint x[23] {
        bins zeroone = (0 => 1);
        bins onezero = (1 => 0);
        option.weight = (23<width);
    }
    bit_24_transition: coverpoint x[24] {
        bins zeroone = (0 => 1);
        bins onezero = (1 => 0);
        option.weight = (24<width);
    }
    bit_25_transition: coverpoint x[25] {
        bins zeroone = (0 => 1);
        bins onezero = (1 => 0);
        option.weight = (25<width);
    }
    bit_26_transition: coverpoint x[26] {
        bins zeroone = (0 => 1);
        bins onezero = (1 => 0);
        option.weight = (26<width);
    }
    bit_27_transition: coverpoint x[27] {
        bins zeroone = (0 => 1);
        bins onezero = (1 => 0);
        option.weight = (27<width);
    }
    bit_28_transition: coverpoint x[28] {
        bins zeroone = (0 => 1);
        bins onezero = (1 => 0);
        option.weight = (28<width);
    }
    bit_29_transition: coverpoint x[29] {
        bins zeroone = (0 => 1);
        bins onezero = (1 => 0);
        option.weight = (29<width);
    }
    bit_30_transition: coverpoint x[30] {
        bins zeroone = (0 => 1);
        bins onezero = (1 => 0);
        option.weight = (30<width);
    }
    bit_31_transition: coverpoint x[31] {
        bins zeroone = (0 => 1);
        bins onezero = (1 => 0);
        option.weight = (31<width);
    }
endgroup : bit_toggle_cg

