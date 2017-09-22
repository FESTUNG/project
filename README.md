FESTUNG
=======
**FESTUNG** (Finite Element Simulation Toolbox for Unstructured Grids) is a Matlab / GNU Octave toolbox for the discontinuous Galerkin (DG) method on unstructured grids. It is primarily intended as a fast and flexible prototyping platform and testbed for students and developers. 

FESTUNG relies on fully vectorized matrix/vector operations to deliver optimized computational performance combined with a compact, user-friendly interface and a comprehensive documentation.

## Download
* Tarballs of previous code versions and further information about the project can be found on our [Project page](https://math.fau.de/FESTUNG).
* The latest published version can always be downloaded from the [Github repository](https://github.com/FESTUNG/project).

## Usage
To check out the latest version, run `git clone https://github.com/FESTUNG/project.git`

Model problems are defined following a generic [solver structure](doxygen/solver-structure.md).
Have a look at the implementation of the standard (element-based) DG discretizations of linear advection (folders `advection` for time-explicit and `advection_implicit` for time-implicit) or the LDG discretization of the diffusion operator (folder `diffusion`).
A hybridized DG discretization of linear advection can be found in the folder `hdg_advection`.

Start the computation for any of these problems using `main(<folder name>)`, for example

    $ main('advection')

Output files are written in [VTK format](http://www.vtk.org/VTK/img/file-formats.pdf) or [TecPlot ASCII file format](http://paulbourke.net/dataformats/tp/) and can be visualized, e.g., using [Paraview](http://www.paraview.org/).

## Development
When developing code for or with FESTUNG we suggest to stick to the [Naming Convention](NAMING_CONVENTION.md) to allow for better readability and a similar appearance of all code parts. All files should be documented using the [Doxygen syntax](http://www.stack.nl/~dimitri/doxygen/manual/).

## Documentation
All routines are carefully documented in the Doxygen format, which allows to produce [this documentation](https://www1.am.uni-erlangen.de/FESTUNG). It can be generated by calling 

    $ doxygen doxyfileFESTUNG

in the main directory.

## Contributors

FESTUNGs main developers are [Florian Frank](http://frank.ink), [Balthasar Reuter](https://math.fau.de/reuter), and [Vadym Aizinger](https://math.fau.de/aizinger). Its initial release was developed at the [Chair for Applied Mathematics I](https://www.mso.math.fau.de/applied-mathematics-1.html) at [Friedrich-Alexander-University Erlangen-Nürnberg](https://www.fau.eu).

### Third party libraries
* FESTUNG makes extensive use of the built-in routines in MATLAB / GNU Octave.
* [triquad](https://github.com/FESTUNG/project/blob/master/triquad.m) was written by Greg von Winckel. See [triquad.txt](https://github.com/FESTUNG/project/blob/master/triquad.txt) for license details.
* [m2cpp.pl](https://github.com/FESTUNG/project/blob/master/thirdParty/doxygenMatlab/m2cpp.pl) by Fabrice to generate a [Doxygen](http://www.stack.nl/~dimitri/doxygen/) documentation. See [license.txt](https://github.com/FESTUNG/project/blob/master/thirdParty/doxygenMatlab/license.txt) for license details.

## License 
* see [LICENSE](LICENSE.md) file

## Version 
* Version 0.1 as published in the paper *Frank, Reuter, Aizinger, Knabner:* "FESTUNG: A MATLAB / GNU Octave toolbox for the discontinuous Galerkin method. Part I: Diffusion operator". *In: Computers & Mathematics with Applications 70 (2015) 11-46, Available online 15 May 2015, ISSN 0898-1221, http://dx.doi.org/10.1016/j.camwa.2015.04.013.*
* Version 0.2 as published in the paper *Reuter, Aizinger, Wieland, Frank, Knabner:* "FESTUNG: A MATLAB / GNU Octave toolbox for the discontinuous Galerkin method. Part II: Advection operator and slope limiting". *In: Computers & Mathematics with Applications 72 (2016) 1896-1925, Available online 25 August 2016, ISSN 0898-1221, http://dx.doi.org/doi:10.1016/j.camwa.2016.08.006.*
* Version 0.3 as published in the paper *Jaust, Reuter, Aizinger, Schuetz, Knabner:* "FESTUNG: A MATLAB / GNU Octave toolbox for the discontinuous Galerkin method. Part III: Hybridized discontinuous Galerkin (HDG) formulation". *Submitted to: Computers & Mathematics with Applications (2017).*

## Contact
* Homepage: [https://math.fau.de/FESTUNG](https://math.fau.de/FESTUNG)
