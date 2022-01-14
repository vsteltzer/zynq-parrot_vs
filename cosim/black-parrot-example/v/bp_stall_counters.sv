`include "bp_common_defines.svh"
`include "bp_top_defines.svh"
`include "bp_be_defines.svh"

module bp_stall_counters
  import bp_common_pkg::*;
  import bp_be_pkg::*;
  #(parameter bp_params_e bp_params_p = e_bp_default_cfg
    `declare_bp_proc_params(bp_params_p)
    , parameter width_p = 32

    , localparam commit_pkt_width_lp = `bp_be_commit_pkt_width(vaddr_width_p, paddr_width_p)
    )
   (input clk_i
    , input reset_i
    , input freeze_i

    , input fe_queue_empty_i

    , input [1:0] fe_state_n_i
    , input fe_queue_ready_i
    , input fe_icache_ready_i

    , input if2_v_i
    , input br_ovr_i
    , input ret_ovr_i
    , input icache_data_v_i

    // Backwards ISS events
    , input fe_cmd_nonattaboy_i
    , input fe_cmd_fence_i

    // ISD events
    , input mispredict_i

    , input control_haz_i
    , input long_haz_i

    , input data_haz_i
    , input aux_dep_i
    , input load_dep_i
    , input mul_dep_i
    , input fma_dep_i
    , input sb_iraw_dep_i
    , input sb_fraw_dep_i
    , input sb_iwaw_dep_i
    , input sb_fwaw_dep_i

    , input struct_haz_i
    , input long_busy_i
    , input long_i_busy_i
    , input long_f_busy_i

    // ALU events

    // MUL events

    // MEM events
    , input dcache_rollback_i
    , input dcache_miss_i
    , input dcache_fail_i

    // Trap packet
    , input [commit_pkt_width_lp-1:0] commit_pkt_i

    // output counters
    , output [width_p-1:0] mcycle_o
    , output [width_p-1:0] minstret_o

    , output [width_p-1:0] fe_wait_o
    , output [width_p-1:0] fe_queue_full_o

    , output [width_p-1:0] icache_rollback_o
    , output [width_p-1:0] icache_miss_o

    , output [width_p-1:0] branch_override_o
    , output [width_p-1:0] ret_override_o

    , output [width_p-1:0] fe_cmd_o
    , output [width_p-1:0] fe_cmd_fence_o

    , output [width_p-1:0] mispredict_o

    , output [width_p-1:0] control_haz_o
    , output [width_p-1:0] long_haz_o

    , output [width_p-1:0] data_haz_o
    , output [width_p-1:0] aux_dep_o
    , output [width_p-1:0] load_dep_o
    , output [width_p-1:0] mul_dep_o
    , output [width_p-1:0] fma_dep_o
    , output [width_p-1:0] sb_iraw_dep_o
    , output [width_p-1:0] sb_fraw_dep_o
    , output [width_p-1:0] sb_iwaw_dep_o
    , output [width_p-1:0] sb_fwaw_dep_o

    , output [width_p-1:0] struct_haz_o
    , output [width_p-1:0] long_i_busy_o
    , output [width_p-1:0] long_f_busy_o
    , output [width_p-1:0] long_if_busy_o

    , output [width_p-1:0] dcache_rollback_o
    , output [width_p-1:0] dcache_miss_o
    , output [width_p-1:0] dcache_fail_o

    , output [width_p-1:0] unknown_o

    , output [width_p-1:0] mem_instr_o
    , output [width_p-1:0] aux_instr_o
    , output [width_p-1:0] fma_instr_o
    , output [width_p-1:0] ilong_instr_o
    , output [width_p-1:0] flong_instr_o
    );

   bp_nonsynth_core_profiler
    #(.bp_params_p(bp_params_p))
    prof
    (.clk_i          (clk_i)
    ,.reset_i        (reset_i)
    ,.freeze_i       (freeze_i)
    ,.mhartid_i      ('0)
    ,.itlb_miss_r_i  ('0)
    ,.dtlb_miss_i    ('0)
    ,.eret_i         ('0)
    ,.exception_i    ('0)
    ,._interrupt_i   ('0)
    ,.*
    );

   wire stall_v = ~prof.commit_pkt.instret;

  // Output generation
  `define declare_counter(name)                              \
  bsg_counter_clear_up                                       \
   #(.max_val_p((width_p+1)'(2**width_p-1)), .init_val_p(0)) \
   ``name``_cnt                                              \
   (.clk_i(clk_i)                                            \
   ,.reset_i(reset_i)                                        \
   ,.clear_i(freeze_i)                                       \
   ,.up_i(stall_v & (prof.stall_reason_enum == ``name``))    \
   ,.count_o(``name``_o)                                     \
   );

  `declare_counter(fe_wait)
  `declare_counter(fe_queue_full)
  `declare_counter(icache_rollback)
  `declare_counter(icache_miss)
  `declare_counter(branch_override)
  `declare_counter(ret_override)
  `declare_counter(fe_cmd)
  `declare_counter(fe_cmd_fence)
  `declare_counter(mispredict)
  `declare_counter(control_haz)
  `declare_counter(long_haz)
  `declare_counter(data_haz)
  `declare_counter(aux_dep)
  `declare_counter(load_dep)
  `declare_counter(mul_dep)
  `declare_counter(fma_dep)
  `declare_counter(sb_iraw_dep)
  `declare_counter(sb_fraw_dep)
  `declare_counter(sb_iwaw_dep)
  `declare_counter(sb_fwaw_dep)
  `declare_counter(struct_haz)
  `declare_counter(long_i_busy)
  `declare_counter(long_f_busy)
  `declare_counter(long_if_busy)
  `declare_counter(dcache_rollback)
  `declare_counter(dcache_miss)
  `declare_counter(dcache_fail)

   bsg_counter_clear_up
    #(.max_val_p((width_p+1)'(2**width_p-1)), .init_val_p(0))
    unknown_cnt
    (.clk_i(clk_i)
    ,.reset_i(reset_i)
    ,.clear_i(freeze_i)
    ,.up_i(stall_v & (prof.stall_reason_enum == unknown))
    ,.count_o(unknown_o)
    );

   bsg_counter_clear_up
    #(.max_val_p((width_p+1)'(2**width_p-1)), .init_val_p(0))
    mcycle_cnt
    (.clk_i(clk_i)
    ,.reset_i(reset_i)
    ,.clear_i(freeze_i)
    ,.up_i(1'b1)
    ,.count_o(mcycle_o)
    );

   bsg_counter_clear_up
    #(.max_val_p((width_p+1)'(2**width_p-1)), .init_val_p(0))
    minstret_cnt
    (.clk_i(clk_i)
    ,.reset_i(reset_i)
    ,.clear_i(freeze_i)
    ,.up_i(prof.commit_pkt.instret)
    ,.count_o(minstret_o)
    );

   rv64_instr_fmatype_s instr;
   assign instr = prof.commit_pkt.instr;

   wire instret       = prof.commit_pkt.instret;
   wire ilong_instr_v = (instr.opcode inside {`RV64_OP_OP, `RV64_OP_32_OP})
                      & (instr inside {`RV64_DIV, `RV64_DIVU, `RV64_DIVW, `RV64_DIVUW ,`RV64_REM, `RV64_REMU, `RV64_REMW, `RV64_REMUW});
   wire flong_instr_v = (instr.opcode == `RV64_FP_OP) & (instr inside {`RV64_FDIV_S, `RV64_FDIV_D, `RV64_FSQRT_S, `RV64_FSQRT_D});
   wire fma_instr_v   = (instr.opcode inside {`RV64_FMADD_OP, `RV64_FMSUB_OP, `RV64_FNMSUB_OP, `RV64_FNMADD_OP})
                      | ((instr.opcode == `RV64_FP_OP)
                      & (instr inside {`RV64_FADD_S, `RV64_FADD_D, `RV64_FSUB_S, `RV64_FSUB_D, `RV64_FMUL_S, `RV64_FMUL_D}));
   wire aux_instr_v   = (instr.opcode == `RV64_FP_OP) & ~fma_instr_v & ~flong_instr_v;
   wire mem_instr_v   = (instr.opcode inside {`RV64_LOAD_OP, `RV64_FLOAD_OP, `RV64_STORE_OP, `RV64_FSTORE_OP, `RV64_MISC_MEM_OP, `RV64_AMO_OP});

   bsg_counter_clear_up
    #(.max_val_p((width_p+1)'(2**width_p-1)), .init_val_p(0))
    mem_instr_cnt
    (.clk_i(clk_i)
    ,.reset_i(reset_i)
    ,.clear_i(freeze_i)
    ,.up_i(instret & mem_instr_v)
    ,.count_o(mem_instr_o)
    );

   bsg_counter_clear_up
    #(.max_val_p((width_p+1)'(2**width_p-1)), .init_val_p(0))
    aux_instr_cnt
    (.clk_i(clk_i)
    ,.reset_i(reset_i)
    ,.clear_i(freeze_i)
    ,.up_i(instret & aux_instr_v)
    ,.count_o(aux_instr_o)
    );

   bsg_counter_clear_up
    #(.max_val_p((width_p+1)'(2**width_p-1)), .init_val_p(0))
    fma_instr_cnt
    (.clk_i(clk_i)
    ,.reset_i(reset_i)
    ,.clear_i(freeze_i)
    ,.up_i(instret & fma_instr_v)
    ,.count_o(fma_instr_o)
    );

   bsg_counter_clear_up
    #(.max_val_p((width_p+1)'(2**width_p-1)), .init_val_p(0))
    ilong_instr_cnt
    (.clk_i(clk_i)
    ,.reset_i(reset_i)
    ,.clear_i(freeze_i)
    ,.up_i(instret & ilong_instr_v)
    ,.count_o(ilong_instr_o)
    );

   bsg_counter_clear_up
    #(.max_val_p((width_p+1)'(2**width_p-1)), .init_val_p(0))
    flong_instr_cnt
    (.clk_i(clk_i)
    ,.reset_i(reset_i)
    ,.clear_i(freeze_i)
    ,.up_i(instret & flong_instr_v)
    ,.count_o(flong_instr_o)
    );

endmodule
