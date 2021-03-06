% Evaluate Taylor basis functions in the vertices of each element and store
% them in a a struct.

%===============================================================================
%> @file
%>
%> @brief Evaluate Taylor basis functions in the vertices of each element 
%>        and store them in a struct.
%===============================================================================
%>
%> @brief Evaluate Taylor basis functions in the vertices of each element 
%>        and store them in a struct.
%>
%> It evaluates the basis functions provided by <code>phiTaylorPhy()</code>
%> in all vertices of all elements and stores them in the array
%> <code>phiTaylorV0T</code> (@f$[K \times 3 \times N]@f$).
%> 
%> @param  g          The lists describing the geometric and topological 
%>                    properties of a triangulation (see 
%>                    <code>generateGridData()</code>) 
%>                    @f$[1 \times 1 \text{ struct}]@f$
%> @param  N          The number of local degrees of freedom. For polynomial
%>                    order @f$p@f$, it is given as @f$N = (p+1)(p+2)/2@f$
%>                    @f$[\text{scalar}]@f$
%> @param  basesOnQuad  A (possibly empty) struct to which the computed
%>                    array is added.
%>
%> @retval basesOnQuad  The struct with the added array phiTaylorV0T.
%>
%> This file is part of FESTUNG
%>
%> @copyright 2014-2016 Florian Frank, Balthasar Reuter, Vadym Aizinger
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
function basesOnQuad = computeTaylorBasesV0T(g, N, basesOnQuad)

% Check function arguments that are directly used
assert(0 < g.numT, 'Number of elements must be greater than zero')
validateattributes(g.coordV0T, {'numeric'}, {'size', [g.numT 3 2]}, mfilename, 'g.coordV0T')
assert(~isempty(find(N == ((0:4)+1).*((0:4)+2)/2, 1)), 'Number of degrees of freedom does not match a polynomial order') % N == (p+1)(p+2)/2
validateattributes(basesOnQuad, {'struct'}, {}, mfilename, 'basesOnQuad')

basesOnQuad.phiTaylorV0T = zeros(g.numT, 3, N);
for n = 1 : 3
  for i = 1 : N
    basesOnQuad.phiTaylorV0T(:, n, i) = phiTaylorPhy(g, i, g.coordV0T(:, n, 1), g.coordV0T(:, n, 2));
  end
end

end
