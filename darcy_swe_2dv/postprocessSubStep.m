% Third step of the three-part substepping algorithm.

%===============================================================================
%> @file
%>
%> @brief Third step of the three-part substepping algorithm.
%===============================================================================
%>
%> @brief Third step of the three-part substepping algorithm.
%>
%> The routine iterateSubSteps() repeatedly executes three steps until the 
%> parameter <code>problemData.isSubSteppingFinished</code> becomes 
%> <code>true</code>.
%> These three steps are:
%>
%>  1. darcy_swe_2dv/preprocessSubStep.m
%>  2. darcy_swe_2dv/solveSubStep.m
%>  3. darcy_swe_2dv/postprocessSubStep.m
%> 
%> This routine calls @link swe_2dv/postprocessStep.m @endlink and
%> @link swe_2dv/outputStep.m @endlink.
%> Afterwards, it evaluates the flux term from free flow domain to
%> subsurface domain for the current time level in each quadrature point on
%> all edges and adds it to <tt>problemData.hCouplingQ0E0T</tt> to compute
%> the time-averaged coupling condition.
%>
%> @param  problemData  A struct with problem parameters, precomputed
%>                      fields, and solution data structures (either filled
%>                      with initial data or the solution from the previous
%>                      loop iteration), as provided by configureProblem()  
%>                      and preprocessProblem(). @f$[\text{struct}]@f$
%> @param  nStep        The current iteration number of the main loop. 
%> @param  nSubStep     The current iteration number of the substepping.
%>
%> @retval problemData  The input struct enriched with postprocessed data
%>                      for this loop iteration. @f$[\text{struct}]@f$
%>
%> This file is part of FESTUNG
%>
%> @copyright 2014-2018 Balthasar Reuter, Florian Frank, Vadym Aizinger
%>
%> @author Balthasar Reuter, 2018
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
function problemData = postprocessSubStep(problemData, nStep, nSubStep)
problemData.sweData = problemData.sweSteps.postprocessStep(problemData.sweData, (nStep - 1) * problemData.numSubSteps + nSubStep);
problemData.sweData = problemData.sweSteps.outputStep(problemData.sweData, (nStep - 1) * problemData.numSubSteps + nSubStep);

% Coupling term for Darcy head
if problemData.isCouplingDarcy
  [Q,~] = quadRule1D(problemData.qOrd);
  Q0T1D = problemData.sweData.g.g1D.mapRef2Phy(Q);
  zBotQ0E0T = problemData.sweData.zBotCont(Q0T1D);
  
  % Evaluate primary variables in quadrature points of bottom edge of SWE domain at old time level
  hQ0E0T1 = problemData.sweData.cDiscRK{1,1} * problemData.sweData.basesOnQuad1D.phi1D{problemData.qOrd}.';
  u1Q0E0T1 = problemData.sweData.cDiscRK{1,2} * problemData.sweData.basesOnQuad2D.phi1D{problemData.qOrd}(:, :, 2).';
  hCouplingQ0E0T1 = problemData.sweData.g.g1D.markT2DT * (hQ0E0T1 + zBotQ0E0T) + 0.5 / problemData.sweData.gConst * ( u1Q0E0T1 .* u1Q0E0T1 );
  
  % Evaluate primary variables in quadrature points of bottom edge of SWE domain at new time level
  hQ0E0T2 =  problemData.sweData.cDiscRK{end,1} * problemData.sweData.basesOnQuad1D.phi1D{problemData.qOrd}.';
  u1Q0E0T2 = problemData.sweData.cDiscRK{end,2} * problemData.sweData.basesOnQuad2D.phi1D{problemData.qOrd}(:, :, 2).';
  hCouplingQ0E0T2 = problemData.sweData.g.g1D.markT2DT * (hQ0E0T2 + zBotQ0E0T) + 0.5 / problemData.sweData.gConst * ( u1Q0E0T2 .* u1Q0E0T2 );
  
  % Integrate coupling condition over time (using trapezoidal rule)
  problemData.hCouplingQ0E0T = problemData.hCouplingQ0E0T + ...
    0.5 * problemData.sweData.tau / problemData.darcyData.tau * (hCouplingQ0E0T1 + hCouplingQ0E0T2);
end % if

problemData.isSubSteppingFinished = nSubStep >= problemData.numSubSteps;
end % function
