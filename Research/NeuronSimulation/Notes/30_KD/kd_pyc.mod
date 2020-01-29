TITLE D-type Voltage-gated Potassium Current (Id, Kd)
: Author: Payne Chang
: Based on Mathews PJ et al. (2010)
: Liquid junction potential is not corrected.

NEURON {
	SUFFIX kd
	USEION k READ ek WRITE ik
	RANGE g, gbar, minf, mtau, hinf, htau
}

UNITS {
	(mA) = (milliamp)
	(mV) = (millivolt)
}

: Global variables
PARAMETER {
	ek (mV)
	celsius	(degC)
	gbar = 0.003 (mho/cm2)
	
	: m (activation particle)
	mvhalf = -45 (mV)
	mk = -10 (mV)
	
	: h (inactivation particle)
	hvhalf = -57 (mV)
	hk = 6.3 (mV)
	hzeta = 0.22 (1)
}

: Range variables
ASSIGNED {
	v (mV)
	ik (mA/cm2)
	g (mho/cm2)
	
	: m (activation)
	minf (1)
	mtau (ms)
	
	: h (inactivation)
	hinf (1)
	htau (ms)
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
	UNITSOFF
	
	: m (activation)
	minf = 1.0 / (1.0 + exp((v - mvhalf) / mk))
	mtau = 21.5/(6*exp((v-(-50))/(7)) + 24*exp((v-(-50))/(-50.6))) + 0.35
	
	: h (inactivation)
	hinf = (1.0-hzeta) / (1.0 + exp((v - hvhalf) / hk)) + hzeta
	htau = 170/(5*exp((v-(-50))/(10)) + exp((v-(-60))/(-8))) + 10.7
	
	UNITSON
}
