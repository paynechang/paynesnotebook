TITLE K-A channel
: Author: Payne Chang
: Based on Hoffman et al (1997) and Chen et al (2004)

NEURON {
	SUFFIX ka
	USEION k READ ek WRITE ik
	RANGE g, gbar, minf, mtau, hinf, htau
}

UNITS {
	(mA) = (milliamp)
	(mV) = (millivolt)
}

PARAMETER {
	ek (mV)
	celsius	(degC)
	gbar = 0.003 (mho/cm2)
	
	: m (activation particle)
	mvhalf = -31.3 (mV)
	mk = -20.8 (mV)
	mtau = 0.2 (ms)
	
	: h (inactivation particle)
	hvhalf = -64.0 (mV)
	hk = 9 (mV)
}

ASSIGNED {
	v (mV)
	ik (mA/cm2)
	g (mho/cm2)
	
	htau (ms)
	
	minf (1)
	hinf (1)
}

STATE {
	m	: Activation particle
	h	: Inactivation particle
}

BREAKPOINT {
	SOLVE states METHOD cnexp
	g = gbar * m^4 * h
	ik = g * (v - ek)

}

INITIAL {
	rates(v)
	m = minf
	h = hinf
}

DERIVATIVE states {
	rates(v)
	m' = (minf - m) / mtau
	h' = (hinf - h) / htau
}

PROCEDURE rates(v (mV)) {
	minf = 1.0 / (1.0 + exp((v - mvhalf) / mk))
	hinf = 1.0 / (1.0 + exp((v - hvhalf) / hk))
	
	if(v > -20){
		htau = 5 + 2.6(ms / mV) * (v + 20) / 10
	}
	else{
		htau = 5
	}
}
