TITLE K-DR channel
: Author: Payne Chang
: Based on Mohapatra (2012) ,Hoffman (1997), and Chen (2004)

NEURON {
	SUFFIX kdr
	USEION k READ ek WRITE ik
	RANGE g, gbar
	GLOBAL ninf, taun, linf, taul
}

UNITS {
	(mA) = (milliamp)
	(mV) = (millivolt)
}

PARAMETER {
	ek = -84 (mV)
	celsius	= 33 (degC)
	gbar = 0.003 (mho/cm2)
	
	: n (activation particle)
	vhalfn = -13.9 (mV)
	kn = -9.1 (mV)
	taun = 1.8 (ms)
	
	: l (inactivation particle)
	vhalfl = -28.8 (mV)
	kl = 11.4 (mV)
	taul = 500 (ms)
	lmin = 0.25 (1)	:# 1: No inactivation; 0: Max inactivation
}

ASSIGNED {
	v (mV)
	ik (mA/cm2)
	g (mho/cm2)
	
	ninf (1)
	linf (1)
}

STATE {
	n	: Activation particle
	l	: Inactivation particle
}

BREAKPOINT {
	SOLVE states METHOD cnexp
	g = gbar * n^4 * l
	ik = g * (v - ek)

}

INITIAL {
	rates(v)
	n = ninf
	l = linf
}

DERIVATIVE states {
	rates(v)
	n' = (ninf - n) / taun
	l' = (linf - l) / taul
}

PROCEDURE rates(v (mV)) {
	ninf = 1.0 / (1.0 + exp((v - vhalfn) / kn))
	linf = (1 - lmin) / (1.0 + exp((v - vhalfl) / kl)) + lmin
}
