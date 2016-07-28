% Generic routine for iterating over arbitrary processes during one single
% time step.

%===============================================================================
%> @file iterateSubSteps.m
%>
%> @brief Generic routine for iterating over arbitrary processes during one single
%>        time step.
%===============================================================================
%>
%> @brief Generic routine for iterating over arbitrary processes during one single
%>        time step.
%>
%> This routine provides a generic interface for arbitrary processes during one 
%> single time step.
%> It makes the assumption that any kind of process can be subdivided into
%> three parts that are executed after each other:
%> 
%>  1. Pre-processing: Performs all tasks (e.g., assembly of matrix blocks,
%>     evaluation of boundary conditions, etc.) that are required for the
%>     computation of the next substep.
%>     See template/preprocessSubStep.m
%>  2. Solution: Computes the solution at the next substep, e.g., at a new
%>     Runge-Kutta step.
%>     See template/solveSubStep.m
%>  3. Post-processing: Performs any tasks that are necessary after
%>     computing the next substep, e.g., updating the new solution during a
%>     DIRK-iteration. This is usually also the place to decide, whether the
%>     substep loop should be terminated. For this, 
%>     <code>problemData.isSubsteppingFinished</code> must be
%>     set to <code>true</code>.
%>     See template/postprocessSubStep.m
%>
%> A struct <code>problemData</code> is passed to and returned from every
%> routine in the above steps, which allows to store problem data or 
%> computed values.
%>
%> @param  problemData  A struct that is passed to and returned from every
%>                      routine in all routines, which allows to store problem 
%>                      data or computed values.
%>         nStep        The index number of the current time step.
%>
%> This file is part of FESTUNG
%>
%> @copyright 2014-2016 Hennes Hajduk, Balthasar Reuter, Florian Frank, Vadym Aizinger
%> 
%> @par License
%> @parblock
%> This program is free software: you can redistribute it and/or modify
%> it under the terms of the GNU General Public License as published by
%> the Free Software Foundation, either version 3 of the License, or
%> (at your option) any later version.
%>
%> This program is distributed in the hope that it will be useful,
%> but WITHOUT ANY WARRANTY; without even the implied warranty of
%> MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%> GNU General Public License for more details.
%>
%> You should have received a copy of the GNU General Public License
%> along with this program.  If not, see <http://www.gnu.org/licenses/>.
%> @endparblock
%
function problemData = iterateSubSteps(problemData, nStep)
%% List of functions making up a substep
subStepList = { 'preprocessSubStep'; 'solveSubStep'; 'postprocessSubStep' };
%% Check existence of all required functions
assert(isequal(cellfun(@(fun) exist([ fun '.m'], 'file'), subStepList), 2 * ones(size(subStepList))), ...
  'Not all the required functions for the substepping of the problem steps found.')
%% Enter iterative loop
assert(isstruct(problemData) && isfield(problemData, 'isSubSteppingFinished') && islogical(problemData.isSubSteppingFinished), ...
  'Struct "problemData" must contain a logical variable "isSubSteppingFinished".');
nSubStep = 0;
while ~problemData.isSubSteppingFinished
  nSubStep = nSubStep + 1;
  for nFunc = 1 : length(subStepList)
    problemData = feval(subStepList{nFunc}, problemData, nStep, nSubStep);
  end % for
end % while
end % function