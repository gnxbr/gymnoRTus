import Vector::*;

module [Module] mkRegDelayer#(Bit#(stages) dummy, a defv, a in) (ReadOnly#(a))
		provisos (Bits#(a, sa));

	Reg#(Vector#(stages, a)) r <- mkReg(replicate(defv));

	rule update;
		r <= shiftInAtN(r, in);
	endrule

	method a _read = r[0];

endmodule
