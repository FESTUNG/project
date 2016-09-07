% Visualize the triangulation with global and local indices.

%===============================================================================
%> @file visualizeGrid.m
%>
%> @brief Visualize the triangulation with global and local indices.
%===============================================================================
%>
%> @brief Visualize the triangulation with global and local indices.
%>
%> @par Example
%> @parblock
%> @code
%> g = generateGridData([0, -1; sqrt(3), 0; 0, 1; -sqrt(3), 0], [4,1,3; 1,2,3]);
%> g.idE = (abs(g.nuE(:,2)) > 0) .* ((g.nuE(:,1)>0) + (g.nuE(:,2)>0)*2+1);
%> visualizeGrid(g)
%> @endcode
%> produces the following output:
%> @image html  generateGridData.png
%> @endparblock
%>
%> @param  g          The lists describing the geometric and topological 
%>                    properties of a triangulation (see 
%>                    <code>generateGridData()</code>) 
%>                    @f$[1 \times 1 \text{ struct}]@f$
%>
%> This file is part of FESTUNG
%>
%> @copyright 2014-2015 Florian Frank, Balthasar Reuter, Vadym Aizinger
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
function visualizeGridTrap(g)
figure('Color', [1, 1, 1]); % white background
hold('on'),  axis('off')
daspect([1, 1, 1]) % adjust aspect ration, requires Octave >= 3.8
textarray = @(x1,x2,s) arrayfun(@(a,b,c) text(a,b,int2str(c),'Color','blue'), x1, x2, s);
%% Trapezoidal boundaries.
X1 = reshape(g.coordV(:,1), [], g.numElem(2) + 1).';
X2 = reshape(g.coordV(:,2), [], g.numElem(2) + 1).';
surf(X1, X2, zeros(size(X1)), 'facecolor', 'none');
%% Local edge numbers.
w = [4/9, 4/9, 1/18, 1/18; 1/18, 1/18, 4/9, 4/9; ...
     1/18, 4/9, 4/9, 1/18; 4/9, 1/18, 1/18, 4/9].';
for kE = 1 : 4
  textarray(reshape(g.coordV(g.V0T,1),g.numT,4)*w(:,kE), ...
            reshape(g.coordV(g.V0T,2),g.numT,4)*w(:,kE), kE*ones(g.numT, 1))
end % for
%% Global vertex numbers.
textarray(g.coordV(:,1), g.coordV(:,2), (1:g.numV)');
%% Local vertex numbers.
w = ones(4) / 18 + eye(4) * (5/6 - 1/18);
for kE = 1 : 4
  textarray(reshape(g.coordV(g.V0T,1),g.numT,4)*w(:,kE), ...
            reshape(g.coordV(g.V0T,2),g.numT,4)*w(:,kE), kE*ones(g.numT, 1))
end % for
%% Global edge numbers.
textarray(g.baryE(:,1), g.baryE(:,2), (1:g.numE)');
%% Element numbers.
textarray(g.baryT(:,1), g.baryT(:,2), (1:g.numT)');
%% Edge IDs.
markEbdr = g.idE ~= 0; % mark boundary edges
textarray(g.baryE(markEbdr,1) + g.nuE(markEbdr,1).*g.areaE(markEbdr)/8, ...
  g.baryE(markEbdr,2) + g.nuE(markEbdr,2).*g.areaE(markEbdr)/8, g.idE(markEbdr))
end % function
