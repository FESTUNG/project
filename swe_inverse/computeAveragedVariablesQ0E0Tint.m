% Uses the evaluation of the unknowns of the 2D Shallow-Water Equations to 
% compute their harmonic averages of Roe-Pike type for interior edges.
%
%===============================================================================
%> @file
%>
%> @brief Uses the evaluation of the unknowns of the 2D Shallow-Water Equations 
%>        to compute their harmonic averages of Roe-Pike type for interior edges
%>        (see @ref ROE1985 for details).
%===============================================================================
%>
%> @brief Uses the evaluation of the unknowns of the 2D Shallow-Water Equations 
%>        to compute their harmonic averages of Roe-Pike type for interior edges
%>        (see @ref ROE1985 for details).
%>
%> This routine uses the limits of the height and momenta on both sides of the
%> edges to compute a stable avarage, later to be used for flux approximation.
%> Let @f$\mathbf{c} = \begin{bmatrix} c^1 \\ c^2 \\ c^3 \end{bmatrix} =
%> \begin{bmatrix} h \\ uH \\ vH \end{bmatrix}@f$
%> be the vector of primary unknowns of the 2D Shallow-Water Equations and
%> @f$\mathbf{c}_- = \begin{bmatrix} c^1_- \\ c^2_- \\ c^3_- \end{bmatrix} =
%> \begin{bmatrix} h_- \\ uH_- \\ vH_- \end{bmatrix}@f$, 
%> @f$\mathbf{c}_+ = \begin{bmatrix} c^1_+ \\ c^2_+ \\ c^3_+ \end{bmatrix} =
%> \begin{bmatrix} h_+ \\ uH_+ \\ vH_+ \end{bmatrix}@f$
%> the limits of @f$\mathbf{c}@f$ from each side of an edge of the grid.
%> The harmonic average as defined in @ref ROE1985 is
%> @f$\hat{\mathbf{c}} = \frac{h_-^{\frac{1}{2}} \mathbf{c}_- + h_+^{\frac{1}{2}} \mathbf{c}_+}{h_-^{\frac{1}{2}} + h_+^{\frac{1}{2}}}.@f$
%> 
%> To obtain harmonic averages  of the velocities one has to compute
%> @f$\frac{h_-^{\frac{1}{2}} \frac{\mathbf{c}^{2,3}_-}{h_-} + h_+^{\frac{1}{2}} \frac{\mathbf{c}^{2,3}_+}{h_+}}{h_-^{\frac{1}{2}} + h_+^{\frac{1}{2}}} = 
%> \frac{h_-^{\frac{-1}{2}} \mathbf{c}^{2,3}_- + h_+^{\frac{-1}{2}} \mathbf{c}^{2,3}_+}{h_-^{\frac{1}{2}} + h_+^{\frac{1}{2}}} =
%> \frac{\frac{ h_+^{\frac{1}{2}} \mathbf{c}^{2,3}_- + h_-^{\frac{1}{2}} \mathbf{c}^{2,3}_+ }{ h_-^{\frac{1}{2}} h_+^{\frac{1}{2}} } }{h_-^{\frac{1}{2}} + h_+^{\frac{1}{2}}} =
%> \frac{h_+^{\frac{1}{2}} \mathbf{c}^{2,3}_- + h_-^{\frac{1}{2}} \mathbf{c}^{2,3}_+ }{h_- h_+^{\frac{1}{2}} + h_-^{\frac{1}{2}}h_+}.@f$
%>
%> There are different types of averages available:
%> full-harmonic uses the Roe-Pike approach to compute averaged velocities and 
%> the height average.
%> semi-harmonic uses this approach to compute averaged velocities and takes the
%> mean of the height for the rest.
%> mean uses mean values for the velocities and height.
%>
%> @param cQ0E0Tint      The values of each unknown of the system evaluated in
%>                       each quadrature point of each local edge of a 
%>                       particular local index. @f$[3 \times 1 \text{ cell}]@f$
%> @param cQ0E0Text      The values of each unknown of the system evaluated in
%>                       each quadrature point of each local edge of the 
%>                       neighbouring elements for a particular combination of 
%>                       local indices. @f$[3 \times 1 \text{ cell}]@f$
%> @param hQ0E0Tint      The values of the height evaluated in
%>                       each quadrature point of each local edge of a 
%>                       particular local index. @f$[KR \times 1]@f$ (R is the 
%>                       number of quadrature points and weights.)
%> @param hQ0E0Text      The values of the height evaluated in
%>                       each quadrature point of each local edge of the 
%>                       neighbouring elements for a particular combination of 
%>                       local indices. @f$[KR \times 1]@f$
%> @param averagingType  Type of avaraging as described above.
%>
%> @retval cRoePikeQ0E0T Cell containing the values of the avarages of the 
%>                       height and both velocity components for each quadrature
%>                       point of the edges with the same local index as the 
%>                       input parameters. @f$[3 \times 1 \text{ cell}]@f$
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
function cRoePikeQ0E0T = computeAveragedVariablesQ0E0Tint(cQ0E0Tint, cQ0E0Text, hQ0E0Tint, hQ0E0Text, averagingType)

validateattributes(cQ0E0Tint, {'cell'}, {'size', [3 1]}, mfilename, 'cQ0E0Tint');
validateattributes(cQ0E0Text, {'cell'}, {'size', [3 1]}, mfilename, 'cQ0E0Text');

assert(isequal(size(hQ0E0Tint), size(hQ0E0Text)), 'The number of values in limits from both sides must be the same.');

cRoePikeQ0E0T = cell(3,1);

switch averagingType
  case 'full-harmonic'
    hL = sqrt(hQ0E0Tint);
    hR = sqrt(hQ0E0Text);
    hIntExtInv = 1 ./ (hR .* hQ0E0Tint + hL .* hQ0E0Text);
    
    cRoePikeQ0E0T{1} = (hL .* hQ0E0Tint + hR .* hQ0E0Text) ./ (hL + hR);
    cRoePikeQ0E0T{2} = (hR .* cQ0E0Tint{2} + hL .* cQ0E0Text{2}) .* hIntExtInv;
    cRoePikeQ0E0T{3} = (hR .* cQ0E0Tint{3} + hL .* cQ0E0Text{3}) .* hIntExtInv;

  case 'semi-harmonic'
    hL = sqrt(hQ0E0Tint);
    hR = sqrt(hQ0E0Text);
    hIntExtInv = 1 ./ (hR .* hQ0E0Tint + hL .* hQ0E0Text);
    
    cRoePikeQ0E0T{1} = 0.5 * (hQ0E0Tint + hQ0E0Text);
    cRoePikeQ0E0T{2} = (hR .* cQ0E0Tint{2} + hL .* cQ0E0Text{2}) .* hIntExtInv;
    cRoePikeQ0E0T{3} = (hR .* cQ0E0Tint{3} + hL .* cQ0E0Text{3}) .* hIntExtInv;

  case 'mean'
    hIntExtInv = 0.5 ./ (hQ0E0Tint .* hQ0E0Text);
    
    cRoePikeQ0E0T{1} = 0.5 * (hQ0E0Tint + hQ0E0Text);
    cRoePikeQ0E0T{2} = (hQ0E0Text .* cQ0E0Tint{2} + hQ0E0Tint .* cQ0E0Text{2}) .* hIntExtInv;
    cRoePikeQ0E0T{3} = (hQ0E0Text .* cQ0E0Tint{3} + hQ0E0Tint .* cQ0E0Text{3}) .* hIntExtInv;

  otherwise
    error('Unknown averaging type for interior edges')
end % switch
end

