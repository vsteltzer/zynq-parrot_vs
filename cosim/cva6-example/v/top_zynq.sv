
`timescale 1 ns / 1 ps

module top_zynq
   #(
     // NOTE these parameters are usually overridden by the parent module (top.v)
     // but we set them to make expectations consistent

     // Parameters of Axi Slave Bus Interface S00_AXI
     parameter integer C_S00_AXI_DATA_WIDTH   = 32

     // needs to be updated to fit all addresses used
     // by bsg_zynq_pl_shell read_locs_lp (update in top.v as well)
     , parameter integer C_S00_AXI_ADDR_WIDTH   = 6
     , parameter integer C_S01_AXI_DATA_WIDTH   = 64
     // the ARM AXI S01 interface drops the top two bits
     , parameter integer C_S01_AXI_ADDR_WIDTH   = 64
     , parameter integer C_M00_AXI_DATA_WIDTH   = 64
     , parameter integer C_M00_AXI_ADDR_WIDTH   = 32
     )
   (
    // AXI4-Lite Slave bus
    input wire                                   s00_axi_aclk
    ,input wire                                  s00_axi_aresetn
    ,input wire [C_S00_AXI_ADDR_WIDTH-1 : 0]     s00_axi_awaddr
    ,input wire [2 : 0]                          s00_axi_awprot
    ,input wire                                  s00_axi_awvalid
    ,output wire                                 s00_axi_awready
    ,input wire [C_S00_AXI_DATA_WIDTH-1 : 0]     s00_axi_wdata
    ,input wire [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] s00_axi_wstrb
    ,input wire                                  s00_axi_wvalid
    ,output wire                                 s00_axi_wready
    ,output wire [1 : 0]                         s00_axi_bresp
    ,output wire                                 s00_axi_bvalid
    ,input wire                                  s00_axi_bready
    ,input wire [C_S00_AXI_ADDR_WIDTH-1 : 0]     s00_axi_araddr
    ,input wire [2 : 0]                          s00_axi_arprot
    ,input wire                                  s00_axi_arvalid
    ,output wire                                 s00_axi_arready
    ,output wire [C_S00_AXI_DATA_WIDTH-1 : 0]    s00_axi_rdata
    ,output wire [1 : 0]                         s00_axi_rresp
    ,output wire                                 s00_axi_rvalid
    ,input wire                                  s00_axi_rready

    // AXI4 Slave bus
    ,input wire                                s01_axi_aclk
    ,input wire                                s01_axi_aresetn
    ,input wire [C_S01_AXI_ADDR_WIDTH-1:0]     s01_axi_awaddr
    ,input wire                                s01_axi_awvalid
    ,output wire                               s01_axi_awready
    ,input wire [3:0]                          s01_axi_awid
    ,input wire                                s01_axi_awlock
    ,input wire [3:0]                          s01_axi_awcache
    ,input wire [2:0]                          s01_axi_awprot
    ,input wire [7:0]                          s01_axi_awlen
    ,input wire [2:0]                          s01_axi_awsize
    ,input wire [1:0]                          s01_axi_awburst
    ,input wire [3:0]                          s01_axi_awqos
    ,input wire                                s01_axi_awuser

    ,input wire [C_S01_AXI_DATA_WIDTH-1:0]     s01_axi_wdata
    ,input wire                                s01_axi_wvalid
    ,output wire                               s01_axi_wready
    ,input wire                                s01_axi_wlast
    ,input wire [(C_S01_AXI_DATA_WIDTH/8)-1:0] s01_axi_wstrb
    ,input wire                                s01_axi_wuser

    ,output wire                               s01_axi_bvalid
    ,input wire                                s01_axi_bready
    ,output wire [3:0]                         s01_axi_bid
    ,output wire [1:0]                         s01_axi_bresp
    ,output wire                               s01_axi_buser

    ,input wire [C_S01_AXI_ADDR_WIDTH-1:0]     s01_axi_araddr
    ,input wire                                s01_axi_arvalid
    ,output wire                               s01_axi_arready
    ,input wire [3:0]                          s01_axi_arid
    ,input wire                                s01_axi_arlock
    ,input wire [3:0]                          s01_axi_arcache
    ,input wire [2:0]                          s01_axi_arprot
    ,input wire [7:0]                          s01_axi_arlen
    ,input wire [2:0]                          s01_axi_arsize
    ,input wire [1:0]                          s01_axi_arburst
    ,input wire [3:0]                          s01_axi_arqos
    ,input wire                                s01_axi_aruser

    ,output wire [C_S01_AXI_DATA_WIDTH-1:0]    s01_axi_rdata
    ,output wire                               s01_axi_rvalid
    ,input wire                                s01_axi_rready
    ,output wire [3:0]                         s01_axi_rid
    ,output wire                               s01_axi_rlast
    ,output wire [1:0]                         s01_axi_rresp
    ,output wire                               s01_axi_ruser

    // AXI3 Master bus
    ,input wire                                 m00_axi_aclk
    ,input wire                                 m00_axi_aresetn
    ,output wire [C_M00_AXI_ADDR_WIDTH-1:0]     m00_axi_awaddr
    ,output wire                                m00_axi_awvalid
    ,input wire                                 m00_axi_awready
    ,output wire [5:0]                          m00_axi_awid
    ,output wire [1:0]                          m00_axi_awlock
    ,output wire [3:0]                          m00_axi_awcache
    ,output wire [2:0]                          m00_axi_awprot
    ,output wire [3:0]                          m00_axi_awlen
    ,output wire [2:0]                          m00_axi_awsize
    ,output wire [1:0]                          m00_axi_awburst
    ,output wire [3:0]                          m00_axi_awqos

    ,output wire [C_M00_AXI_DATA_WIDTH-1:0]     m00_axi_wdata
    ,output wire                                m00_axi_wvalid
    ,input wire                                 m00_axi_wready
    ,output wire [5:0]                          m00_axi_wid
    ,output wire                                m00_axi_wlast
    ,output wire [(C_M00_AXI_DATA_WIDTH/8)-1:0] m00_axi_wstrb

    ,input wire                                 m00_axi_bvalid
    ,output wire                                m00_axi_bready
    ,input wire [5:0]                           m00_axi_bid
    ,input wire [1:0]                           m00_axi_bresp

    ,output wire [C_M00_AXI_ADDR_WIDTH-1:0]     m00_axi_araddr
    ,output wire                                m00_axi_arvalid
    ,input wire                                 m00_axi_arready
    ,output wire [5:0]                          m00_axi_arid
    ,output wire [1:0]                          m00_axi_arlock
    ,output wire [3:0]                          m00_axi_arcache
    ,output wire [2:0]                          m00_axi_arprot
    ,output wire [3:0]                          m00_axi_arlen
    ,output wire [2:0]                          m00_axi_arsize
    ,output wire [1:0]                          m00_axi_arburst
    ,output wire [3:0]                          m00_axi_arqos

    ,input wire [C_M00_AXI_DATA_WIDTH-1:0]      m00_axi_rdata
    ,input wire                                 m00_axi_rvalid
    ,output wire                                m00_axi_rready
    ,input wire [5:0]                           m00_axi_rid
    ,input wire                                 m00_axi_rlast
    ,input wire [1:0]                           m00_axi_rresp
    );

   logic [3:0][C_S00_AXI_DATA_WIDTH-1:0]        csr_data_lo;
   logic [C_S00_AXI_DATA_WIDTH-1:0]             pl_to_ps_fifo_data_li, ps_to_pl_fifo_data_lo;
   logic                                        pl_to_ps_fifo_v_li, pl_to_ps_fifo_ready_lo;
   logic                                        ps_to_pl_fifo_v_lo, ps_to_pl_fifo_yumi_li;

   localparam debug_lp = 0;
   localparam memory_upper_limit_lp = 241*1024*1024;
   localparam csr_num_lp = 2;
   logic [csr_num_lp-1:0][64-1:0] csr_data_li;

   assign csr_data_li[0] = ariane.i_ariane.csr_regfile_i.cycle_q[0+:64];
   assign csr_data_li[1] = ariane.i_ariane.csr_regfile_i.instret_q[0+:64];

   // use this as a way of figuring out how much memory a RISC-V program is using
   // each bit corresponds to a region of memory
   logic [127:0] mem_profiler_r;

   // Connect Shell to AXI Bus Interface S00_AXI
   bsg_zynq_pl_shell #
     (
      .num_regs_ps_to_pl_p (4)
      // standard memory map for all blackparrot instances should be
      //
      // 0: reset for bp (low true); note: it is only legal to assert reset if you are
      //    finished with all AXI transactions (fixme: potential improvement to detect this)
      // 4: = 1 if the DRAM has been allocated for the device in the ARM PS Linux subsystem
      // 8: the base register for the allocated dram
      //

      // need to update C_S00_AXI_ADDR_WIDTH accordingly
      ,.num_fifo_ps_to_pl_p(1)
      ,.num_fifo_pl_to_ps_p(1)
      ,.num_regs_pl_to_ps_p(4 + (2*csr_num_lp))
      ,.C_S_AXI_DATA_WIDTH(C_S00_AXI_DATA_WIDTH)
      ,.C_S_AXI_ADDR_WIDTH(C_S00_AXI_ADDR_WIDTH)
      ) zps
       (
        .csr_data_o(csr_data_lo)

        // (MBT)
        // note: this ability to probe into the core is not supported in ASIC toolflows but
        // is supported in Verilator, VCS, and Vivado Synthesis.

        // it is very helpful for adding instrumentation to a pre-existing design that you are
        // prototyping in FPGA, where you don't necessarily want to put the support into the ASIC version
        // or don't know yet if you want to.

        // in additional to this approach of poking down into pre-existing registers, you can also
        // instantiate counters, and then pull control signals out of the DUT in order to figure out when
        // to increment the counters.
        //

        ,.csr_data_i({ csr_data_li
                       , mem_profiler_r[127:96]
                       , mem_profiler_r[95:64]
                       , mem_profiler_r[63:32]
                       , mem_profiler_r[31:0]
                     })

        ,.pl_to_ps_fifo_data_i (pl_to_ps_fifo_data_li)
        ,.pl_to_ps_fifo_v_i    (pl_to_ps_fifo_v_li)
        ,.pl_to_ps_fifo_ready_o(pl_to_ps_fifo_ready_lo)

        ,.ps_to_pl_fifo_data_o (ps_to_pl_fifo_data_lo)
        ,.ps_to_pl_fifo_v_o    (ps_to_pl_fifo_v_lo)
        ,.ps_to_pl_fifo_yumi_i (ps_to_pl_fifo_yumi_li)

        ,.S_AXI_ACLK   (s00_axi_aclk)
        ,.S_AXI_ARESETN(s00_axi_aresetn)
        ,.S_AXI_AWADDR (s00_axi_awaddr)
        ,.S_AXI_AWPROT (s00_axi_awprot)
        ,.S_AXI_AWVALID(s00_axi_awvalid)
        ,.S_AXI_AWREADY(s00_axi_awready)
        ,.S_AXI_WDATA  (s00_axi_wdata)
        ,.S_AXI_WSTRB  (s00_axi_wstrb)
        ,.S_AXI_WVALID (s00_axi_wvalid)
        ,.S_AXI_WREADY (s00_axi_wready)
        ,.S_AXI_BRESP  (s00_axi_bresp)
        ,.S_AXI_BVALID (s00_axi_bvalid)
        ,.S_AXI_BREADY (s00_axi_bready)
        ,.S_AXI_ARADDR (s00_axi_araddr)
        ,.S_AXI_ARPROT (s00_axi_arprot)
        ,.S_AXI_ARVALID(s00_axi_arvalid)
        ,.S_AXI_ARREADY(s00_axi_arready)
        ,.S_AXI_RDATA  (s00_axi_rdata)
        ,.S_AXI_RRESP  (s00_axi_rresp)
        ,.S_AXI_RVALID (s00_axi_rvalid)
        ,.S_AXI_RREADY (s00_axi_rready)
        );

   // Address Translation (MBT):
   //
   // The Zynq PS Physical address space looks like this:
   //
   // 0x0000_0000 - 0x0003_FFFF  +256 KB On-chip memory (optional), else DDR DRAM
   // 0x0004_0000 - 0x1FFF_FFFF  +512 MB DDR DRAM for Zynq P2 board
   // 0x2000_0000 - 0x3FFF_FFFF  Another 512 MB DDR DRAM, if the board had it, it does not
   // 0x4000_0000 - 0x7FFF_FFFF  1 GB Mapped to PL via M_AXI_GP0
   // 0x8000_0000 - 0xBFFF_FFFF  1 GB Mapped to PL via M_AXI_GP1
   // 0xFFFC_0000 - 0xFFFF_FFFF  Alternate location for OCM
   //
   // BlackParrot's Physical address space looks like this:
   //    (see github.com/black-parrot/black-parrot/blob/master/docs/platform_guide.md)
   //
   // 0x00_0000_0000 - 0x00_7FFF_FFFF local addresses; 2GB: < 9'b0, 7b tile, 4b device, 20b 1MB space>
   // 0x00_8000_0000 - 0x00_9FFF_FFFF cached dram (up to 512 MB, mapped to Zynq)
   // 0x00_A000_0000 - 0x00_FFFF_FFFF cached dram that does not exist on Zynq board (another 1.5 GB)
   // 0x01_0000_0000 - 0x0F_FFFF_FFFF cached dram that does not exist on Zynq board (another 60 GB)
   // 0x10_0000_0000 - 0x1F_FFFF_FFFF on-chip address space for streaming accelerators
   // 0x20_0000_0000 - 0xFF_FFFF_FFFF off-chip address space
   //
   // Currently, we allocate the Zynq M_AXI_GP0 address space to handle management of the shell
   // that interfaces Zynq to external "accelerators" like BP.
   //
   // So the M_AXI_GP1 address space remains to map BP. A straight-forward translation is to
   // map 0x8000_0000 - 0x8FFF_FFFF of Zynq Physical Address Space (PA) to the same addresses in BP
   //  providing 256 MB of DRAM, leaving 256 MB for the Zynq PS system.
   //
   // Then we can map 0xA000_0000-0xAFFF_FFFF of ARM PA to 0x00_0000_0000 - 0x00_0FFF_FFFF of BP,
   // handling up to tiles 0..15. (This is 256 MB of address space.)
   //
   // since these addresses are going to pop out of the M_AXI_GP1 port, they will already have
   // 0x8000_0000 subtracted, it will ironically have to be added back in by this module
   //
   // M_AXI_GP1: 0x0000_0000 - 0x1000_0000 -> add      0x8000_0000.
   //            0x2000_0000 - 0x3000_0000 -> subtract 0x2000_0000.

   // Life of an address (FPGA):
   //
   //                NBF Loader                 mmap                  Xilinx IPI Switch         This Module
   //  NBF (0x8000_0000) -> ARM VA (0x8000_0000) -> ARM PA (0x8000_0000) -> M_AXI_GP1 (0x0000_0000) -> BP (0x8000_0000)
   //  NBF (0x0000_0000) -> ARM VA (0xA000_0000) -> ARM PA (0xA000_0000) -> M_AXI_GP1 (0x2000_0000) -> BP (0x0000_0000)
   //
   // Life of an address (Verilator):
   //                  NBF Loader              bp_zynq_pl          Verilator Bit Truncation     This Module
   //  NBF (0x8000_0000) -> ARM VA (x8000_0000) ->  ARM PA (0x8000_0000) -> M_AXI_GP1 (0x0000_0000) -> BP (0x8000_0000)
   //  NBF (0x0000_0000) -> ARM VA (xA000_0000) ->  ARM PA (0xA000_0000) -> M_AXI_GP1 (0x2000_0000) -> BP (0x0000_0000)
   //
   //

   logic [64-1:0] io_awaddr;
   logic io_awvalid, io_awready;
   logic [64-1:0] io_wdata;
   logic [8-1:0] io_wstrb;
   logic io_wvalid, io_wready;
   logic [1:0] io_bresp;
   logic io_bvalid, io_bready;
   logic [64-1:0] io_araddr;
   logic io_arvalid, io_arready;
   logic [64-1:0] io_rdata;
   logic [1:0] io_rresp;
   logic io_rvalid, io_rready;

   logic io_v, io_we;
   logic [64-1:0] io_addr, io_data;

   logic [64-1:0] waddr_translated_lo, raddr_translated_lo;

        // Zynq PA 0x8000_0000 .. 0x8FFF_FFFF -> AXI 0x0000_0000 .. 0x0FFF_FFFF -> BP 0x8000_0000 - 0x8FFF_FFFF
        // Zynq PA 0xA000_0000 .. 0xAFFF_FFFF -> AXI 0x2000_0000 .. 0x2FFF_FFFF -> BP 0x0000_0000 - 0x0FFF_FFFF
   assign waddr_translated_lo = {32'b0, ~s01_axi_awaddr[29], 3'b0, s01_axi_awaddr[0+:28]};

        // Zynq PA 0x8000_0000 .. 0x8FFF_FFFF -> AXI 0x0000_0000 .. 0x0FFF_FFFF -> BP 0x8000_0000 - 0x8FFF_FFFF
        // Zynq PA 0xA000_0000 .. 0xAFFF_FFFF -> AXI 0x2000_0000 .. 0x2FFF_FFFF -> BP 0x0000_0000 - 0x0FFF_FFFF
   assign raddr_translated_lo = {32'b0, ~s01_axi_araddr[29], 3'b0, s01_axi_araddr[0+:28]};

   // to translate from BP DRAM space to ARM PS DRAM space
   // we xor-subtract the BP DRAM base address (32'h8000_0000) and add the
   // ARM PS allocated memory space physical address.

   logic [64-1:0] axi_awaddr, axi_araddr;
   assign m00_axi_awaddr = (axi_awaddr[0+:32] ^ 32'h8000_0000) + csr_data_lo[2];
   assign m00_axi_araddr = (axi_araddr[0+:32] ^ 32'h8000_0000) + csr_data_lo[2];

   // BlackParrot reset signal is connected to a CSR (along with
   // the AXI interface reset) so that a regression can be launched
   // without having to reload the bitstream
   wire resetn_li = csr_data_lo[0][0] & s01_axi_aresetn;
   wire core_resetn_li = csr_data_lo[3][0] & s01_axi_aresetn;

   // AXI4 to AXI3 stiching
   assign m00_axi_awid[5] = '0;
   assign m00_axi_arid[5] = '0;
   assign m00_axi_wid = m00_axi_awid;
   assign m00_axi_awlock[1] = '0;
   assign m00_axi_arlock[1] = '0;

   assign pl_to_ps_fifo_v_li    = io_v & io_we;
   assign pl_to_ps_fifo_data_li = {(io_v & io_we), io_addr[22:0], io_data[7:0]};

   bsg_dff_reset #(.width_p(128)) dff
     (.clk_i(s01_axi_aclk)
      ,.reset_i(~resetn_li)
      ,.data_i(mem_profiler_r
               | m00_axi_awvalid << (axi_awaddr[29-:7])
               | m00_axi_arvalid << (axi_araddr[29-:7])
               )
      ,.data_o(mem_profiler_r)
      );

   ariane_top
    #(.AXI_ADDR_WIDTH(64)
     ,.AXI_DATA_WIDTH(64)
     ,.AXI_USER_WIDTH(1)
     )
    ariane
     (.clk_i(s01_axi_aclk)
     ,.resetn_i(resetn_li)
     ,.core_resetn_i(core_resetn_li)

     ,.s_awvalid_i (s01_axi_awvalid)
     ,.s_awburst_i (s01_axi_awburst)
     ,.s_awaddr_i  (waddr_translated_lo)
     ,.s_awlen_i   (s01_axi_awlen)
     ,.s_awsize_i  (s01_axi_awsize)
     ,.s_awid_i    (s01_axi_awid)
     ,.s_awcache_i (s01_axi_awcache)
     ,.s_awprot_i  (s01_axi_awprot)
     ,.s_awqos_i   (s01_axi_awqos)
     ,.s_awuser_i  (s01_axi_awuser)
     ,.s_awlock_i  (s01_axi_awlock)
     ,.s_awready_o (s01_axi_awready)

     ,.s_wvalid_i  (s01_axi_wvalid)
     ,.s_wstrb_i   (s01_axi_wstrb)
     ,.s_wdata_i   (s01_axi_wdata)
     ,.s_wlast_i   (s01_axi_wlast)
     ,.s_wuser_i   (s01_axi_wuser)
     ,.s_wready_o  (s01_axi_wready)

     ,.s_bready_i  (s01_axi_bready)
     ,.s_bvalid_o  (s01_axi_bvalid)
     ,.s_bresp_o   (s01_axi_bresp)
     ,.s_bid_o     (s01_axi_bid)
     ,.s_buser_o   (s01_axi_buser)

     ,.s_arvalid_i (s01_axi_arvalid)
     ,.s_arburst_i (s01_axi_arburst)
     ,.s_araddr_i  (raddr_translated_lo)
     ,.s_arlen_i   (s01_axi_arlen)
     ,.s_arsize_i  (s01_axi_arsize)
     ,.s_arid_i    (s01_axi_arid)
     ,.s_arcache_i (s01_axi_arcache)
     ,.s_arprot_i  (s01_axi_arprot)
     ,.s_arqos_i   (s01_axi_arqos)
     ,.s_aruser_i  (s01_axi_aruser)
     ,.s_arlock_i  (s01_axi_arlock)
     ,.s_arready_o (s01_axi_arready)

     ,.s_rready_i  (s01_axi_rready)
     ,.s_rvalid_o  (s01_axi_rvalid)
     ,.s_rdata_o   (s01_axi_rdata)
     ,.s_rresp_o   (s01_axi_rresp)
     ,.s_rid_o     (s01_axi_rid)
     ,.s_rlast_o   (s01_axi_rlast)
     ,.s_ruser_o   (s01_axi_ruser)

     ,.m_awready_i (m00_axi_awready)
     ,.m_awvalid_o (m00_axi_awvalid)
     ,.m_awburst_o (m00_axi_awburst)
     ,.m_awaddr_o  (axi_awaddr)
     ,.m_awlen_o   (m00_axi_awlen) //8->4
     ,.m_awsize_o  (m00_axi_awsize)
     ,.m_awid_o    (m00_axi_awid) //5->6
     ,.m_awcache_o (m00_axi_awcache)
     ,.m_awprot_o  (m00_axi_awprot)
     ,.m_awqos_o   (m00_axi_awqos)
     ,.m_awuser_o  ()
     ,.m_awlock_o  (m00_axi_awlock) //1->2

     ,.m_wready_i  (m00_axi_wready)
     ,.m_wvalid_o  (m00_axi_wvalid)
     ,.m_wstrb_o   (m00_axi_wstrb)
     ,.m_wdata_o   (m00_axi_wdata)
     ,.m_wlast_o   (m00_axi_wlast)
     ,.m_wuser_o   ()

     ,.m_bvalid_i  (m00_axi_bvalid)
     ,.m_bresp_i   (m00_axi_bresp)
     ,.m_bid_i     (m00_axi_bid) //5->6
     ,.m_buser_i   ('0)
     ,.m_bready_o  (m00_axi_bready)

     ,.m_arready_i (m00_axi_arready)
     ,.m_arvalid_o (m00_axi_arvalid)
     ,.m_arburst_o (m00_axi_arburst)
     ,.m_araddr_o  (axi_araddr)
     ,.m_arlen_o   (m00_axi_arlen) //8->4
     ,.m_arsize_o  (m00_axi_arsize)
     ,.m_arid_o    (m00_axi_arid) //5->6
     ,.m_arcache_o (m00_axi_arcache)
     ,.m_arprot_o  (m00_axi_arprot)
     ,.m_arqos_o   (m00_axi_arqos)
     ,.m_aruser_o  ()
     ,.m_arlock_o  (m00_axi_arlock) //1->2

     ,.m_rvalid_i  (m00_axi_rvalid)
     ,.m_rdata_i   (m00_axi_rdata)
     ,.m_rresp_i   (m00_axi_rresp)
     ,.m_rid_i     (m00_axi_rid) //5->6
     ,.m_rlast_i   (m00_axi_rlast)
     ,.m_ruser_i   ('0)
     ,.m_rready_o  (m00_axi_rready)

     ,.io_awready_i(io_awready)
     ,.io_awvalid_o(io_awvalid)
     ,.io_awaddr_o (io_awaddr)

     ,.io_wready_i (io_wready)
     ,.io_wvalid_o (io_wvalid)
     ,.io_wstrb_o  (io_wstrb)
     ,.io_wdata_o  (io_wdata)

     ,.io_bvalid_i (io_bvalid)
     ,.io_bresp_i  (io_bresp)
     ,.io_bready_o (io_bready)

     ,.io_arready_i(io_arready)
     ,.io_arvalid_o(io_arvalid)
     ,.io_araddr_o (io_araddr)

     ,.io_rvalid_i (io_rvalid)
     ,.io_rdata_i  (io_rdata)
     ,.io_rresp_i  (io_rresp)
     ,.io_rready_o (io_rready)
     );

   axi_lite_to_dma
    #(.addr_width_p(64)
     ,.data_width_p(64)
     )
    i_axi_lite_converter
     (.clk_i(s01_axi_aclk)
     ,.reset_i(~resetn_li)

     ,.awready_o(io_awready)
     ,.awvalid_i(io_awvalid)
     ,.awaddr_i (io_awaddr)

     ,.wready_o (io_wready)
     ,.wvalid_i (io_wvalid)
     ,.wstrb_i  (io_wstrb)
     ,.wdata_i  (io_wdata)

     ,.bvalid_o (io_bvalid)
     ,.bresp_o  (io_bresp)
     ,.bready_i (io_bready)

     ,.arready_o(io_arready)
     ,.arvalid_i(io_arvalid)
     ,.araddr_i (io_araddr)

     ,.rvalid_o (io_rvalid)
     ,.rdata_o  (io_rdata)
     ,.rresp_o  (io_rresp)
     ,.rready_i (io_rready)

     ,.ready_i  (pl_to_ps_fifo_ready_lo)
     ,.v_o      (io_v)
     ,.we_o     (io_we)
     ,.addr_o   (io_addr)
     ,.data_o   (io_data)

     ,.ready_o  ()
     ,.v_i      ('0)
     ,.data_i   ('0)
     );

   // synopsys translate_off
   always @(negedge s01_axi_aclk)
     if (s01_axi_awvalid & s01_axi_awready)
       if (debug_lp) $display("top_zynq: AXI Write Addr %x -> %x (BP)",s01_axi_awaddr,waddr_translated_lo);

   always @(negedge s01_axi_aclk)
     if (s01_axi_arvalid & s01_axi_arready)
       if (debug_lp) $display("top_zynq: AXI Read Addr %x -> %x (BP)",s01_axi_araddr,raddr_translated_lo);

   always @(negedge s01_axi_aclk)
     begin
        if (m00_axi_awvalid && ((axi_awaddr ^ 32'h8000_0000) >= memory_upper_limit_lp))
          $display("top_zynq: unexpectedly high DRAM write: %x",axi_awaddr);
        if (m00_axi_arvalid && ((axi_araddr ^ 32'h8000_0000) >= memory_upper_limit_lp))
          $display("top_zynq: unexpectedly high DRAM read: %x",axi_araddr);
     end

   always @(negedge m00_axi_aclk)
     if (m00_axi_awvalid & m00_axi_awready)
       if (debug_lp) $display("top_zynq: (BP DRAM) AXI Write Addr %x -> %x (AXI HP0)",axi_awaddr,m00_axi_awaddr);

   always @(negedge s01_axi_aclk)
     if (m00_axi_arvalid & m00_axi_arready)
       if (debug_lp) $display("top_zynq: (BP DRAM) AXI Read Addr %x -> %x (AXI HP0)",axi_araddr,m00_axi_araddr);
   // synopsys translate_on

endmodule
