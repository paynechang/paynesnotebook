:===============================================================================
: Ih based on Magee JC (1998), The Journal of Neuroscience
: Created by Payne Y. Chang
: Temporature fixed at 33 degC
: External [Na+] = 10 ~ 60 mM
: Reversal potential = -30 mV
: (C1 <-> C2)^2 (Rates: a, b), HH model

TITLE I-h channel based on Magee 1998

:===============================================================================
: Interface definition. Not a variable declaration block.
NEURON {
	SUFFIX h				: Density mechanism
	NONSPECIFIC_CURRENT i
	RANGE gbar				: Location dependent variables
}

:===============================================================================
: Units
UNITS {
	(mA) = (milliamp)
	(mV) = (millivolt)
}

:===============================================================================
: Global variable by default.
PARAMETER {
	gbar	= 0.0001	(mho/cm2)
	e		= -30		(mV)        
	
	:==============================
	: a
	a_a		= 0.1091	(/ms)
	a_vhalf	= -91.69	(mV)
	a_k		= 12.51		(mV)
	
	: b
	b_a		= 0.09848	(/ms)
	b_vhalf	= -35.73	(mV)
	b_k		= -22.11		(mV)
}

:===============================================================================
: Range variable by default. Not visible in hoc.
ASSIGNED {
	v	(mV)
	i	(mA/cm2)
	gh
	a	(/ms)
	b	(/ms)
	s_inf
	tau_s
}

:===============================================================================
: State variables
STATE {
	s
}

:===============================================================================
: Initiate variables
INITIAL {
	rates(v)
	s = s_inf
}

:===============================================================================
: Calculate gh and i
BREAKPOINT {
	SOLVE states METHOD cnexp
	gh = gbar * s^2
	i = gh * (v - e)
}

:===============================================================================
: Derivative states
DERIVATIVE states {
	rates(v)
	s' = (s_inf - s) / tau_s
}

:===============================================================================
: Calculate a
FUNCTION alpha(v(mV)) {
  alpha = a_a / (1.0 + exp((v - a_vhalf) / a_k))
}

:===============================================================================
: Calculate b
FUNCTION beta(v(mV)) {
  beta = b_a / (1.0 + exp((v - b_vhalf) / b_k))
}

:===============================================================================
: Calculate a and b
PROCEDURE rates(v(mV)) {
	a = alpha(v)
	b = beta(v)
	s_inf = a / (a + b)
	tau_s = 1.0 / (a + b)
}

:===============================================================================
