% Performs all post-processing steps. Error evaluation for analytical problems.

%===============================================================================
%> @file darcyVvert/postprocessProblem.m
%>
%> @brief Performs all post-processing tasks. Error evaluation for analytical problems.
%===============================================================================
%>
%> @brief Performs all post-processing tasks. Error evaluation for analytical problems.
%>
%> This routine is called after the main loop.
%>
%> @param  problemData  A struct with problem parameters and solution
%>                      vectors. @f$[\text{struct}]@f$
%>
%> @retval problemData  A struct with all necessary parameters and definitions
%>                      for the problem description and precomputed fields.
%>                      @f$[\text{struct}]@f$
%>
%> This file is part of FESTUNG
%>
%> @copyright 2014-2016 Balthasar Reuter, Florian Frank, Vadym Aizinger
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
function problemData = postprocessProblem(problemData)
if all(isfield(problemData, { 'hCont', 'q1Cont', 'q2Cont' }))
  K = problemData.g.numT;
  N = problemData.N;

  hCont = @(x1,x2) problemData.hCont(problemData.tEnd, x1, x2);
  q1Cont = @(x1,x2) problemData.q1Cont(problemData.tEnd, x1, x2);
  q2Cont = @(x1,x2) problemData.q2Cont(problemData.tEnd, x1, x2);

  hDisc = reshape(problemData.sysY(2*K*N+1 : 3*K*N), N, K)';
  q1Disc = reshape(problemData.sysY(1 : K*N), N, K)';
  q2Disc = reshape(problemData.sysY(K*N+1 : 2*K*N), N, K)';

  problemData.error = [ computeL2ErrorTetra(problemData.g, hDisc, hCont, ...
                          problemData.qOrd+1, problemData.basesOnQuad), ...
                        computeL2ErrorTetra(problemData.g, q1Disc, q1Cont, ...
                          problemData.qOrd+1, problemData.basesOnQuad), ...
                        computeL2ErrorTetra(problemData.g, q2Disc, q2Cont, ...
                          problemData.qOrd+1, problemData.basesOnQuad) ];

  fprintf('L2 errors of h, q1, q2 w.r.t. the analytical solution: %g, %g, %g\n', problemData.error);
end % if

fprintf('Sum, max, min, and MD5-hash of sysY: %g, %g, %g, %s\n', sum(problemData.sysY), max(problemData.sysY), min(problemData.sysY), DataHash(problemData.sysY));
end % function

