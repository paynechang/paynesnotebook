:===============================================================================
: I-HCN1 based on Altomare (2001), JGP
: Created by Payne Y. Chang
: Temporature fixed at 33 degC
: Reversal potential = -30 mV

TITLE I-HCN1 channel based on Altomare (2001)

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
	f = 2.236	(1)
	r = 25.85	(mV)
	q10 = 4.5	(1)
	
	:==============================
	: alpha
	alpha_0	= 0.01406e-3	(/ms)
	z_alpha	= -0.9369		(1)
	
	:==============================
	: beta
	beta_0	= 743.6e-3	(/ms)
	z_beta	= 0.9369	(1)
	
	:==============================
	: gamma
	gamma_0	= 2.289e-3	(/ms)
	z_gamma	= -1.018	(1)
	
	:==============================
	: delta
	delta_0	= 74.36e-3	(/ms)
	z_delta	= 1.018		(1)
	
}

:===============================================================================
: Range variable by default. Not visible in hoc.
ASSIGNED {
	v	(mV)
	i	(mA/cm2)
	gh	(mho/cm2)
	alpha	(/ms)
	beta	(/ms)
	gamma	(/ms)
	delta	(/ms)
}

:===============================================================================
: State variables
STATE {
	c0 c1 c2 c3 c4 o0 o1 o2 o3 o4
}

:===============================================================================
: Initiate variables
INITIAL {
	SOLVE kin STEADYSTATE sparse
}

:===============================================================================
: Calculate gh and i
BREAKPOINT {
	SOLVE kin METHOD sparse
	gh = gbar * (o0 + o1 + o2 + o3 + o4)
	i = gh * (v - e)
}

:===============================================================================
: Kinetic scheme
KINETIC kin {

	rates(v)
	
	~ c0 <-> c1	(4 * gamma,     delta)
	~ c1 <-> c2	(3 * gamma, 2 * delta)
	~ c2 <-> c3	(2 * gamma, 3 * delta)
	~ c3 <-> c4	(    gamma, 4 * delta)
	
	~ c0 <-> o0	(alpha, beta)
	~ c1 <-> o1	(alpha * f, beta / f)
	~ c2 <-> o2	(alpha * f^2, beta / f^2)
	~ c3 <-> o3	(alpha * f^3, beta / f^3)
	~ c4 <-> o4	(alpha * f^4, beta / f^4)
	
	~ o0 <-> o1	(4 * gamma * f, delta / f)
	~ o1 <-> o2	(3 * gamma * f, 2 * delta / f)
	~ o2 <-> o3	(2 * gamma * f, 3 * delta / f)
	~ o3 <-> o4	(gamma * f, 4 * delta / f)
	
	CONSERVE c0 + c1 + c2 + c3 + c4 + o0 + o1 + o2 + o3 + o4 = 1
}

:===============================================================================
: Calculate rate
FUNCTION get_rate(v(mV), var_0(/ms), z_var(1)) {
  get_rate = var_0 * exp(z_var * v / r) * q10
}

:===============================================================================
: Calculate all variable values
PROCEDURE rates(v(mV)) {
	alpha = get_rate(v, alpha_0, z_alpha)
	beta = get_rate(v, beta_0, z_beta)
	gamma = get_rate(v, gamma_0, z_gamma)
	delta = get_rate(v, delta_0, z_delta)
}

:===============================================================================
