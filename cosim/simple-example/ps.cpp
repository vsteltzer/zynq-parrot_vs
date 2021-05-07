//
// this is an example of "host code" that can either run in cosim or on the PS
// (currently we have only implemented this for cosim!)
//


#include <stdlib.h>
#include <stdio.h>
#include "bp_zynq_pl.h"

int main(int argc, char **argv) {
        bp_zynq_pl *zpl = new bp_zynq_pl(argc, argv);

	// this program just communicates with a "loopback accelerator"
	// that has 4 control registers that you can read and write
	
	int val1 = 0xDEADBEEF;
	int val2 = 0xCAFEBABE;
	int mask1 = 0xf;
	int mask2 = 0x7;
	
	zpl->axil_write(0x0 + ADDR_BASE, val1, mask1);
	zpl->axil_write(0x4 + ADDR_BASE, val2, mask2);

	assert( (zpl->axil_read(0x0 + ADDR_BASE) == (val1 & BSG_expand_byte_mask(mask1))));
	assert( (zpl->axil_read(0x4 + ADDR_BASE) == (val2 & BSG_expand_byte_mask(mask2))));
	
	zpl->done();

	delete zpl;
	exit(EXIT_SUCCESS);
}

