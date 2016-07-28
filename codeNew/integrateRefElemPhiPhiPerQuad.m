% Evaluates all permutations of two basis functions in all quadrature points on 
% the reference triangle and multiplies with the according quadrature weight.
%
%===============================================================================
%> @file integrateRefElemPhiPhiPerQuad.m
%>
%> @brief Evaluates all permutations of two basis functions in all quadrature 
%>        points on the reference triangle and multiplies with the according 
%>        quadrature weight.
%===============================================================================
%>
%> @brief Evaluates all permutations of two basis functions in all quadrature 
%>        points on the reference triangle and multiplies with the according 
%>        quadrature weight.
%>
%> It computes a multidimensional array @f$\hat{\mathsf{M}}
%>    \in \mathbb{R}^{N\times N\times R}@f$, which is defined by
%> @f[
%> \left[\hat{\mathsf{M}}\right]_{i,r,l} \;:=\;
%> \hat{\varphi}_i (\hat{q_r})\,
%> \hat{\varphi}_l (\hat{q_r})\,
%> \omega_r
%> @f]
%> with the quadrature points @f$q_r@f$ given by
%> <code>quadRule2D()</code>
%>
%> @param  N    The local number of degrees of freedom
%> @retval ret  The computed array @f$[N\times R\times N]@f$
%>
%> This file is part of FESTUNG
%>
%> @copyright 2014-2016 Hennes Hajduk, Florian Frank, Balthasar Reuter, Vadym Aizinger
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
function ret = integrateRefElemPhiPhiPerQuad(N)
global gPhi2D
p = (sqrt(8*N+1)-3)/2;  qOrd = max(2*p, 1);  [~, ~, W] = quadRule2D(qOrd);
ret = zeros(N, length(W), N);
for i = 1 : N
  for l = 1 : N
    ret(i, :, l) = gPhi2D{qOrd}(:, i) .* gPhi2D{qOrd}(:, l) .* W.';
  end % for
end % for
end % function