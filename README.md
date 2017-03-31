May 2012. Joseph Austerweil.
============================
_( joseph.austerweil@gmail.com )_


Code for the simulations described in:
--------------------------------------

Griffiths, T. L., Austerweil, J. L., & Berthiaume, V. G. (2012). Comparing the inductive biases of simple neural networks and Bayesian models. The 34th Annual Conference of the Cognitive Science Society. Sapporo, Japan.

For supporting information (like how to run and whatnot), see the information on the lab wiki webpage. The main script is 'runFullSims.m'

Disclaimers:
-----------------

1. The code is not written to be very efficient. normal simulations take a few days to complete.
2. Parts of the code are messy and hard to follow.
3. Neither the University of California, Berkeley, any of my co-authors, or I are responsible for any negative consequences of using this code. Please use it at your own discretion. That being said, I seriously doubt that anything negative could happen from running the code.

Acknowledgements:
--------------------

The code includes functions written by others:
All code in './formdiscovery1.0/' was written by Charles Kemp and others (see his README for those functions written by other authors).

'matrix2latex.tex' was written by M. Koehler.
'divisor.m' was written by Yash Kochar.
'logdet.m' 'rows.m' 'wishpdf.m', 'wishpdfln.m', 'mywishpdfln.m' were written by Tom Minka (mywishpdfln.m was edited slightly by me).

Requirements:
--------------
- Matlab 2011b (hopefully find a fix for newer versions soon)
- Optimization toolbox

Setting up the Project:
--------------------
from the command line:

1. `git clone https://github.com/jsnelgro/dist-probmod.git`

2. `cd dist-probmod`

3. `sh install_<your os>.sh`

4. `matlab2011 -nodesktop -nosplash -r runFullSims` *(if you're on brie. Otherwise it's just `matlab -nodesktop -nosplash -r runFullSims`)*
