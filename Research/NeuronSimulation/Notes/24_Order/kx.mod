TITLE kx channel

NEURON {
	SUFFIX kx
	USEION k READ ek WRITE ik
	RANGE gkx, gkxbar, ninf, taun, alphan, betan
}

UNITS {
	(mA) = (milliamp)
	(mV) = (millivolt)

}

PARAMETER {
	ek = -200 (mV)
	gkxbar = 1 (mho/cm2)
	alpha_amp = 0.1	(/ms)
	beta_amp = 0.1	(/ms)
}

ASSIGNED {
	v (mV)
	ik (mA/cm2)
	gkx	(mho/cm2)
	ninf	(1)
	taun	(ms)
	alphan	(/ms)
	betan	(/ms)
}

STATE {
	n
}

BREAKPOINT {
	SOLVE states METHOD cnexp
	gkx = gkxbar * n * n
	ik = gkx * (v - ek)

}

INITIAL {
	rates(v)
	n=ninf
}

DERIVATIVE states {
	rates(v)
	n' = (ninf - n)/taun
}

PROCEDURE rates(v (mV)) {
	alphan = 1.414 * alpha_amp / (1 + exp((v - (-40(mV))) / (-10(mV))))
	betan = 0.5 * beta_amp / (1 + exp((v - (-60(mV))) /( 10(mV))))
	ninf = alphan / (alphan + betan)
	taun = 1 / (alphan + betan)
}














