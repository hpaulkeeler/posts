#define RNG_CONV 2.3283064365387e-10
#define RNGLONG (RNG_CONV*(rng_ia[rng_p=rng_mod[rng_p]] += rng_ia[rng_pp=rng_mod[rng_pp]]))
#define RNGLONGINT (rng_ia[rng_p=rng_mod[rng_p]] += rng_ia[rng_pp=rng_mod[rng_pp]])

extern unsigned long int rng_ia[1279];
extern int rng_p,rng_pp;
extern int rng_mod[1279];

void rngseed(unsigned long int s);
