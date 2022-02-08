/*This code simulates a percolation model on a (bounded) square
lattice using an algorithm proposed in a paper by Newman and Ziff[1].

This C code remains mostly as the original, which was found
both in aforementioend paper[1] and the co-author's (Mark Newman) website:

http://www-personal.umich.edu/~mejn/percolation/index.html

H. Paul Keeler made slight modifications to the code, but these were mainly
comments.

Information on this algorithm can also be found in the book by
Newman [Section 16.5, 2].

Resources on the internet include:
https://pypercolate.readthedocs.io/en/stable/newman-ziff.html

Note: This code uses rnglong to generate (uniform random variables).
To compile the code, you need to link the file rnglong.c. 
For example, on a Linux machine with ggc run:  

gcc  perc_commented.c rnglong.c -o perc_commented && ./perc_commented

References:
[1] 2001, Newman and Ziff, "Fast monte carlo algorithm for site or bond percolation"
[2] 2010, Newman, "Networks -- An Introduction"
[3] 1997, Knuth, "The Art of Computer Programming -- Volume 1 -- Fundamental Algorithms"
*/

#include <stdlib.h>
#include <stdio.h>

#include "rnglong.h" //for generating uniform pseudo-random variables

#define L 128 /* Linear dimension */
#define N (L * L) /*Number of sites */
#define EMPTY (-N - 1) /*A negative number representing unconnected sites */

int ptr[N];   /* Array of pointers (not C pointers, but graph-theoretic pointers) */
int nn[N][4]; /* Nearest neighbors */
int order[N]; /* Occupation order */

// function definitions
void boundaries();          // create lattice
void permutation();         // perform random permumation of integers 0 to N-1
void percolate();           // find the big component using union-find method
int findroot(int i);        // recursive uniuon-find method
int findrootHalving(int i); // non-recursive uniuon-find method

// helper function -- not in the original paper[1]
void printIntArray(int input_array[], int numbArray); // print out int array

void boundaries()
{
  int i;
  /* This function defines neighbour sites for each site in the square
  lattice. For other non-lattice percolation models, this function
  needs to be changed accordingly.
  */

  for (i = 0; i < N; i++)
  {
    nn[i][0] = (i + 1) % N;     // east (or right) neighbour site
    nn[i][1] = (i + N - 1) % N; // west (or left) neighbour site
    nn[i][2] = (i + L) % N;     // south (or bottom) neighbour site
    nn[i][3] = (i + N - L) % N; // north (or top) neighbour site

    if (i % L == 0)
      // if site is on the west (or left) boundary
      nn[i][1] = i + L - 1; // wrap around to other side

    if ((i + 1) % L == 0)
      // if site is on the east (or right) boundary
      nn[i][0] = i - L + 1; // wrap around to other side
  }
}

void permutation()
{
  /*This function generates a random shuffle. It performs the
  Durstenfield version of Fisher-Yates shuffle.  See Algorithm P
  in "Art of Scientific Programming -- Volume 1" by Knuth.
  Alternatively:

 https://en.wikipedia.org/wiki/Fisher%E2%80%93Yates_shuffle

*/
  int i, j;
  int temp;
 
  double randUni; 

  //  initialize order array
  for (i = 0; i < N; i++)
  {
    order[i] = i;
  }
  for (i = 0; i < N; i++)
  {    
    // randUni = ((double)rand() / (RAND_MAX)); // random number on (0,1) -- old (bad) generator
    randUni = RNGLONG; //random number on (0,1)    
    j = i + (N - i) * randUni; // random integer j st i<=j<N

    temp = order[i];
    order[i] = order[j];
    order[j] = temp;
  }
}

int findroot(int i)
{
  /* This function performs a root-finding method based
  on recursion. This method is called path compressing.
  Newman and Ziff presented this code in the appendix of
  their paper[1], but the method is standard in the literature.

  WARNING: This function access the global variable (array) ptr
  */

  if (ptr[i] < 0)
  {
    return i;
  }
  // the next two lines used to be one line in the original code
  ptr[i] = findroot(ptr[i]);
  return ptr[i];
}

int findrootHalving(int i)
{
  /* This function performs a (graph) root-finding method
  that doesn't use recursion. This method is called path halving.
  Newman and Ziff presented this code in the appendix of their
  paper[1], but the method is standard in the literature.
  
  WARNING: This function accesses the global variable (array) ptr
*/
  int r, s;
  r = s = i;
  while (ptr[r] >= 0)
  {
    ptr[s] = ptr[r];
    s = r;
    r = ptr[r];
  }
  return r;
}

void percolate()
{
  /* This is the man function that performs the union-find methods 
  to find the big component for each set of occupied sites

  WARNING: This function access the global variable (array) ptr
  */
  int i, j;
  int s1, s2;
  int r1, r2;
  int big = 0;

  for (i = 0; i < N; i++)
    ptr[i] = EMPTY;

  for (i = 0; i < N; i++)
  {
    r1 = s1 = order[i];

    ptr[s1] = -1;
    for (j = 0; j < 4; j++)
    {
      s2 = nn[s1][j];
      if (ptr[s2] != EMPTY)
      {
        r2 = findroot(s2);

        if (r2 != r1)
        {
          if (ptr[r1] > ptr[r2])
          {
            ptr[r2] += ptr[r1];
            ptr[r1] = r2;
            r1 = r2;
          }
          else
          {
            ptr[r1] += ptr[r2];
            ptr[r2] = r1;
          }
          if (-ptr[r1] > big)
            big = -ptr[r1];
        }
      }
    }

    printf("%i %i\n", i + 1, big); // remove line to speed up calculations
  }
}

void printIntArray(int input_array[], int numbArray)
{ 
  /* This simple function simply prints out an int array. 
  It was not in the original code by Newman and Ziff.
  */

  printf("["); //print opening bracket

  for (int i = 0; i < numbArray - 1; i++)
  {
    printf("%i, ", input_array[i]);
  }
  //print closing bracket
  printf("%i]\n", input_array[numbArray - 1]);
}

int main()
{
  // rngseed(0);
  boundaries();
  permutation(); // only source of randomness
  percolate();

  printf("The percolation magic is finished.\n");
}
