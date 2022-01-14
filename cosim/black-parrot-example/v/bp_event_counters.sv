`include "bp_common_defines.svh"
`include "bp_top_defines.svh"

module bp_event_counters
  import bp_common_pkg::*;
  import bp_be_pkg::*;
  #(parameter bp_params_e bp_params_p = e_bp_default_cfg
    `declare_bp_proc_params(bp_params_p)

    , parameter width_p = 32
    )
   (input clk_i
    , input reset_i
    , input freeze_i

    , input [`BSG_SAFE_CLOG2(num_core_p)-1:0] mhartid_i

    // IF1 events
    , input fe_stall_i
    , input fe_queue_full_i

    // IF2 events
    , input icache_access_i
    , input icache_rollback_i
    , input icache_miss_i
    
    , input taken_i
    , input ovr_taken_i
    , input ret_i
    , input ovr_ret_i

    // Backwards ISS events
    , input fe_cmd_nonattaboy_i

    // ISD events
    , input mispredict_i
    , input [1:0] mispredict_reason_i

    , input control_haz_i

    , input data_haz_i
    , input load_dep_i
    , input mul_dep_i

    , input struct_haz_i

    // ALU events

    // MUL events

    // MEM events
    , input dcache_access_i
    , input dcache_rollback_i
    , input dcache_miss_i

    // output counters
    , output [width_p-1:0] fe_stall_o
    , output [width_p-1:0] fe_queue_full_o

    , output [width_p-1:0] icache_access_o
    , output [width_p-1:0] icache_rollback_o
    , output [width_p-1:0] icache_miss_o

    , output [width_p-1:0] taken_o
    , output [width_p-1:0] ovr_taken_o
    , output [width_p-1:0] ret_o
    , output [width_p-1:0] ovr_ret_o

    , output [width_p-1:0] fe_cmd_nonattaboy_o

    , output [width_p-1:0] mispredict_o
    , output [width_p-1:0] mispredict_taken_o
    , output [width_p-1:0] mispredict_ntaken_o
    , output [width_p-1:0] mispredict_nonbr_o

    , output [width_p-1:0] control_haz_o

    , output [width_p-1:0] data_haz_o
    , output [width_p-1:0] load_dep_o
    , output [width_p-1:0] mul_dep_o

    , output [width_p-1:0] struct_haz_o

    , output [width_p-1:0] dcache_access_o
    , output [width_p-1:0] dcache_rollback_o
    , output [width_p-1:0] dcache_miss_o
    );

   bsg_counter_clear_up 
    #(.max_val_p((width_p+1)'(2**width_p-1)), .init_val_p(0))
    cnt_0
    (.clk_i(clk_i)
    ,.reset_i(reset_i)
    ,.clear_i(freeze_i)
    ,.up_i(fe_stall_i)
    ,.count_o(fe_stall_o)
    );

   bsg_counter_clear_up
    #(.max_val_p((width_p+1)'(2**width_p-1)), .init_val_p(0))
    cnt_1
    (.clk_i(clk_i)
    ,.reset_i(reset_i)
    ,.clear_i(freeze_i)
    ,.up_i(fe_queue_full_i)
    ,.count_o(fe_queue_full_o)
    );

   bsg_counter_clear_up
    #(.max_val_p((width_p+1)'(2**width_p-1)), .init_val_p(0))
    cnt_2
    (.clk_i(clk_i)
    ,.reset_i(reset_i)
    ,.clear_i(freeze_i)
    ,.up_i(icache_access_i)
    ,.count_o(icache_access_o)
    );

   bsg_counter_clear_up
    #(.max_val_p((width_p+1)'(2**width_p-1)), .init_val_p(0))
    cnt_3
    (.clk_i(clk_i)
    ,.reset_i(reset_i)
    ,.clear_i(freeze_i)
    ,.up_i(icache_rollback_i)
    ,.count_o(icache_rollback_o)
    );

   bsg_counter_clear_up
    #(.max_val_p((width_p+1)'(2**width_p-1)), .init_val_p(0))
    cnt_4
    (.clk_i(clk_i)
    ,.reset_i(reset_i)
    ,.clear_i(freeze_i)
    ,.up_i(icache_miss_i)
    ,.count_o(icache_miss_o)
    );

   bsg_counter_clear_up
    #(.max_val_p((width_p+1)'(2**width_p-1)), .init_val_p(0))
    cnt_5
    (.clk_i(clk_i)
    ,.reset_i(reset_i)
    ,.clear_i(freeze_i)
    ,.up_i(taken_i)
    ,.count_o(taken_o)
    );

   bsg_counter_clear_up
    #(.max_val_p((width_p+1)'(2**width_p-1)), .init_val_p(0))
    cnt_6
    (.clk_i(clk_i)
    ,.reset_i(reset_i)
    ,.clear_i(freeze_i)
    ,.up_i(ovr_taken_i)
    ,.count_o(ovr_taken_o)
    );

   bsg_counter_clear_up
    #(.max_val_p((width_p+1)'(2**width_p-1)), .init_val_p(0))
    cnt_7
    (.clk_i(clk_i)
    ,.reset_i(reset_i)
    ,.clear_i(freeze_i)
    ,.up_i(ret_i)
    ,.count_o(ret_o)
    );

   bsg_counter_clear_up
    #(.max_val_p((width_p+1)'(2**width_p-1)), .init_val_p(0))
    cnt_8
    (.clk_i(clk_i)
    ,.reset_i(reset_i)
    ,.clear_i(freeze_i)
    ,.up_i(ovr_ret_i)
    ,.count_o(ovr_ret_o)
    );

   bsg_counter_clear_up
    #(.max_val_p((width_p+1)'(2**width_p-1)), .init_val_p(0))
    cnt_9
    (.clk_i(clk_i)
    ,.reset_i(reset_i)
    ,.clear_i(freeze_i)
    ,.up_i(fe_cmd_nonattaboy_i)
    ,.count_o(fe_cmd_nonattaboy_o)
    );

   bsg_counter_clear_up
    #(.max_val_p((width_p+1)'(2**width_p-1)), .init_val_p(0))
    cnt_10
    (.clk_i(clk_i)
    ,.reset_i(reset_i)
    ,.clear_i(freeze_i)
    ,.up_i(mispredict_i)
    ,.count_o(mispredict_o)
    );

   bsg_counter_clear_up
    #(.max_val_p((width_p+1)'(2**width_p-1)), .init_val_p(0))
    cnt_11
    (.clk_i(clk_i)
    ,.reset_i(reset_i)
    ,.clear_i(freeze_i)
    ,.up_i(mispredict_i & (mispredict_reason_i == e_incorrect_pred_taken))
    ,.count_o(mispredict_taken_o)
    );

   bsg_counter_clear_up
    #(.max_val_p((width_p+1)'(2**width_p-1)), .init_val_p(0))
    cnt_12
    (.clk_i(clk_i)
    ,.reset_i(reset_i)
    ,.clear_i(freeze_i)
    ,.up_i(mispredict_i & (mispredict_reason_i == e_incorrect_pred_ntaken))
    ,.count_o(mispredict_ntaken_o)
    );

   bsg_counter_clear_up
    #(.max_val_p((width_p+1)'(2**width_p-1)), .init_val_p(0))
    cnt_13
    (.clk_i(clk_i)
    ,.reset_i(reset_i)
    ,.clear_i(freeze_i)
    ,.up_i(mispredict_i & (mispredict_reason_i == e_not_a_branch))
    ,.count_o(mispredict_nonbr_o)
    );

   bsg_counter_clear_up
    #(.max_val_p((width_p+1)'(2**width_p-1)), .init_val_p(0))
    cnt_14
    (.clk_i(clk_i)
    ,.reset_i(reset_i)
    ,.clear_i(freeze_i)
    ,.up_i(dcache_access_i)
    ,.count_o(dcache_access_o)
    );

   bsg_counter_clear_up
    #(.max_val_p((width_p+1)'(2**width_p-1)), .init_val_p(0))
    cnt_15
    (.clk_i(clk_i)
    ,.reset_i(reset_i)
    ,.clear_i(freeze_i)
    ,.up_i(dcache_rollback_i)
    ,.count_o(dcache_rollback_o)
    );

   bsg_counter_clear_up
    #(.max_val_p((width_p+1)'(2**width_p-1)), .init_val_p(0))
    cnt_16
    (.clk_i(clk_i)
    ,.reset_i(reset_i)
    ,.clear_i(freeze_i)
    ,.up_i(dcache_miss_i)
    ,.count_o(dcache_miss_o)
    );

   bsg_counter_clear_up
    #(.max_val_p((width_p+1)'(2**width_p-1)), .init_val_p(0))
    cnt_17
    (.clk_i(clk_i)
    ,.reset_i(reset_i)
    ,.clear_i(freeze_i)
    ,.up_i(control_haz_i)
    ,.count_o(control_haz_o)
    );

   bsg_counter_clear_up
    #(.max_val_p((width_p+1)'(2**width_p-1)), .init_val_p(0))
    cnt_18
    (.clk_i(clk_i)
    ,.reset_i(reset_i)
    ,.clear_i(freeze_i)
    ,.up_i(data_haz_i)
    ,.count_o(data_haz_o)
    );

   bsg_counter_clear_up
    #(.max_val_p((width_p+1)'(2**width_p-1)), .init_val_p(0))
    cnt_19
    (.clk_i(clk_i)
    ,.reset_i(reset_i)
    ,.clear_i(freeze_i)
    ,.up_i(load_dep_i)
    ,.count_o(load_dep_o)
    );

   bsg_counter_clear_up
    #(.max_val_p((width_p+1)'(2**width_p-1)), .init_val_p(0))
    cnt_20
    (.clk_i(clk_i)
    ,.reset_i(reset_i)
    ,.clear_i(freeze_i)
    ,.up_i(mul_dep_i)
    ,.count_o(mul_dep_o)
    );

   bsg_counter_clear_up
    #(.max_val_p((width_p+1)'(2**width_p-1)), .init_val_p(0))
    cnt_21
    (.clk_i(clk_i)
    ,.reset_i(reset_i)
    ,.clear_i(freeze_i)
    ,.up_i(struct_haz_i)
    ,.count_o(struct_haz_o)
    );

endmodule
