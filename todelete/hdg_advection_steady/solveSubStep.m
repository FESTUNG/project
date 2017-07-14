% Compute the solution of the current Runge-Kutta stage.

%===============================================================================
%> @file advection/solveSubStep.m
%>
%> @brief Compute the solution of the current Runge-Kutta stage.
%===============================================================================
%>
%> @brief Compute the solution of the current Runge-Kutta stage.
%>
%> The routine iterateSubSteps() repeatedly executes three steps until the
%> parameter <code>problemData.isSubSteppingFinished</code> becomes
%> <code>true</code>.
%> These three steps are:
%>
%>  1. preprocessSubStep()
%>  2. solveSubStep()
%>  3. postprocessSubStep()
%>
%>
%> @param  problemData  A struct with problem parameters, precomputed
%>                      fields, and solution data structures (either filled
%>                      with initial data or the solution from the previous
%>                      loop iteration), as provided by configureProblem()
%>                      and preprocessProblem(). @f$[\text{struct}]@f$
%> @param  nStep        The current iteration number of the main loop.
%> @param  nSubStep     The current iteration number of the substepping.
%>
%> @retval problemData  The input struct enriched with the new solution
%>                      for this Runge-Kutta stage. @f$[\text{struct}]@f$
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
function problemData = solveSubStep(problemData, nStep, nSubStep) %#ok<INUSL>
K = problemData.K;
Kedge = problemData.g.numE;
N = problemData.N;
Nmu = problemData.Nmu;
stab = problemData.stab;

%% Actual HDG
problemData.matLbar = - problemData.globG{1} - problemData.globG{2} ...
                      + stab * problemData.globRphi;
matL = problemData.matLbar; % Here goes the time discretization
% problemData.vecBphi = -problemData.globFphiD;
problemData.vecBphi = problemData.globH - problemData.globFphiD;
% problemData.vecBphi = - problemData.globFphiD;
vecQ = problemData.vecBphi; % Add here source terms if needed
problemData.matMbar =   problemData.globS ...
                      + problemData.globSout ...
                      - stab * problemData.globRmu;
matM = problemData.matMbar;

% res1 = matL * reshape( problemData.cDisc', K*N, 1) + matM * reshape( problemData.lambdaDisc', Kedge*Nmu, 1) - problemData.vecBphi;

% problemData.cDiscReshaped = reshape( problemData.cDisc', size(problemData.globMphi, 1), 1 );
% problemData.lambdaDiscReshaped = reshape( problemData.lambdaDisc', size(problemData.globP, 1), 1 );

%% Computing local solves
% There are two options.
% 1. Invert the block diagonal matrix L locally, i.e. each block is 
% inverted and then  we construct the inverse matrix L^{-1} from these 
% blocks. This is usuall quickest for large matrices and also saves a lot 
% of memory. It may be efficient to invert more than one block at once.
% 2. We invert the whole mass matrix. This may be very slow and memory
% consuming for large matrices (=many elements). I guess it may be faster
% for matrices of moderate size.
if (problemData.isTrueLocalSolve==true)
    blockSize = problemData.localSolveBlockSize;
    matLinvLocal = cell( K/blockSize, 1);
    %Invert every block locally
    for iE=1:K/blockSize
        iEs = (iE-1)*N*blockSize + 1; %index Element start
        iEe =  iE*N*blockSize; %index Element end
        matLinvLocal{iE} =  mldivide(matL(iEs:iEe,iEs:iEe), speye(N*blockSize,N*blockSize) );
    end
    %Construct inverse matrix
    matLinv = blkdiag(  matLinvLocal{:} );
    %Solve L x = [vecQ matM]
    localSolves = matLinv * [vecQ matM];
    LinvQ = localSolves(:, 1);
    LinvM = localSolves(:, 2:end);
else
    localSolves = mldivide(matL, [vecQ matM]);
    LinvQ = localSolves(:, 1);
    LinvM = localSolves(:, 2:end);
end
%% Solving global system for lambda
matN = - stab * problemData.globT - problemData.globKmuOut ;
matP = problemData.globP;

vecR = problemData.globKmuD;

% res2 = matN * reshape( problemData.cDisc', K*N, 1) + matP * reshape( problemData.lambdaDisc', Kedge*Nmu, 1)- vecR;

sysMatA = -matN * LinvM + matP;
sysRhs = vecR - matN * LinvQ;

problemData.lambdaDisc = mldivide( sysMatA, sysRhs );

%% Reconstructing local solutions from updated lambda
problemData.cDisc = LinvQ - LinvM * problemData.lambdaDisc;
problemData.cDisc = reshape( problemData.cDisc, problemData.N, problemData.g.numT )';
problemData.lambdaDisc = reshape( problemData.lambdaDisc, problemData.Nmu, problemData.g.numE )';
end % function