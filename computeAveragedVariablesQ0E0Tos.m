% Uses the evaluation of the unknowns of the 2D Shallow-Water Equations to 
% compute their harmonic averages of Roe-Pike type for open sea boundary edges.
%
%===============================================================================
%> @file computeAveragedVariablesQ0E0Tos.m
%>
%> @brief Uses the evaluation of the unknowns of the 2D Shallow-Water Equations 
%>        to compute their harmonic averages of Roe-Pike type for open sea 
%>        boundary edges. (see @ref ROE1985 for details)
%===============================================================================
%>
%> @brief Uses the evaluation of the unknowns of the 2D Shallow-Water Equations 
%>        to compute their harmonic averages of Roe-Pike type for open sea 
%>        boundary edges. (see @ref ROE1985 for details)
%>
%> This routine uses the limits of the height and momenta on both sides of the
%> edges to compute a stable avarage, later to be used for flux approximation.
%> There are different types of averages available:
%> full-harmonic uses the Roe-Pike approach on both the normal component of the
%> velocity and the root of the graviational constant times the height.
%> semi-harmonic uses this approach on the normal component of the
%> velocity and takes the mean of the height for the rest.
%> mean uses mean values everywhere.
%> This routine makes use of the model formulation for open sea boundary edges
%> where momenta limits are equal.
%>
%> @param cQ0E0Tint      The values of each unknown of the system evaluated in
%>                       each quadrature point of each local edge of a 
%>                       particular local index. @f${3 \times 1}@f$
%> @param cQ0E0Text      The values of the boundary conditions for the 
%>                       free surface elevation and the momenta in
%>                       each quadrature point of each local edge of a 
%>                       particular local index. @f${3 \times 1}@f$
%> @param hQ0E0Tint      The values of the height evaluated in
%>                       each quadrature point of each local edge of a 
%>                       particular local index. @f$[K*numQuad1D \times 1]@f$
%> @param hQ0E0Text      The values of the height as prescribed by the 
%>                       difference of the boundary condition for the free 
%>                       surface elevation and the bathymetry.
%>                       @f$[K*numQuad1D \times 1]@f$
%> @param markQ0E0Tbdr   <code>logical</code> arrays that mark each triangles
%>                       (boundary) edges of a particular local index on which 
%>                       each quadrature point should be incorporated. 
%>                       @f$[K*numQuad1D \times 1]@f$
%> @param averagingType  Type of avaraging as described above.
%>
%> @retval cRoePikeQ0E0T Cell containing the values of the avarages of the 
%>                       height and both velocity components for each quadrature
%>                       point of the edges with the same local index as the 
%>                       input parameters. @f${3 \times 1}@f$
%>
%> This file is part of FESTUNG
%>
%> @copyright 2014-2016 Balthasar Reuter, Florian Frank, Vadym Aizinger
%>                      Modified 08/18/16 by Hennes Hajduk
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
%>
function cRoePikeQ0E0T = computeAveragedVariablesQ0E0Tos(cQ0E0Tint, cQ0E0Text, hQ0E0Tint, hQ0E0Text, markQ0E0Tbdr, averagingType)
cRoePikeQ0E0T = { zeros(size(hQ0E0Tint)); zeros(size(hQ0E0Tint)); zeros(size(hQ0E0Tint)) };

switch averagingType
  case 'full-harmonic'
    hL = sqrt(hQ0E0Tint(markQ0E0Tbdr));
    hR = sqrt(hQ0E0Text(markQ0E0Tbdr));
    hIntExtInv = 1 ./ (hL .* hR);
    
    cRoePikeQ0E0T{1}(markQ0E0Tbdr) = (hL .* hQ0E0Tint(markQ0E0Tbdr) + hR .* hQ0E0Text(markQ0E0Tbdr)) ./ (hL + hR);
    cRoePikeQ0E0T{2}(markQ0E0Tbdr) = cQ0E0Tint{2}(markQ0E0Tbdr) .* hIntExtInv;
    cRoePikeQ0E0T{3}(markQ0E0Tbdr) = cQ0E0Tint{3}(markQ0E0Tbdr) .* hIntExtInv;

  case 'semi-harmonic'
    hL = sqrt(hQ0E0Tint(markQ0E0Tbdr));
    hR = sqrt(hQ0E0Text(markQ0E0Tbdr));
    hIntExtInv = 1 ./ (hL .* hR);
    
    cRoePikeQ0E0T{1}(markQ0E0Tbdr) = 0.5 * (hQ0E0Tint(markQ0E0Tbdr) + hQ0E0Text(markQ0E0Tbdr));
    cRoePikeQ0E0T{2}(markQ0E0Tbdr) = cQ0E0Tint{2}(markQ0E0Tbdr) .* hIntExtInv;
    cRoePikeQ0E0T{3}(markQ0E0Tbdr) = cQ0E0Tint{3}(markQ0E0Tbdr) .* hIntExtInv;

  case 'mean'
    cRoePikeQ0E0T{1}(markQ0E0Tbdr) = 0.5 * (hQ0E0Tint(markQ0E0Tbdr) + hQ0E0Text(markQ0E0Tbdr));
    
    hIntExtInv = cRoePikeQ0E0T{1}(markQ0E0Tbdr) ./ (hQ0E0Tint(markQ0E0Tbdr) .* hQ0E0Text(markQ0E0Tbdr));
    cRoePikeQ0E0T{2}(markQ0E0Tbdr) = cQ0E0Tint{2}(markQ0E0Tbdr) .* hIntExtInv;
    cRoePikeQ0E0T{3}(markQ0E0Tbdr) = cQ0E0Tint{3}(markQ0E0Tbdr) .* hIntExtInv;

  otherwise
    error('Unknown averaging type for interior edges')
end % switch
end

