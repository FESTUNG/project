% Assembles two matrices containing integrals over edges of products of two 
% basis functions from the interior of each element with a component of the 
% edge normal.

%===============================================================================
%> @file
%>
%> @brief Assembles two matrices containing integrals over edges of products of
%>        two basis functions from the interior of each element, multiplied by
%>        the corresponding component of the unit normal.
%===============================================================================
%>
%> @brief Assembles two matrices @f$\mathsf{{Q}}^m_\mathrm{N}, m\in\{1,2\}@f$
%>        containing integrals over edges of products of two basis functions 
%>        from the  interior of each element with a component of the
%>        edge normal.
%>
%> The matrix @f$\mathsf{{Q}}^m_\mathrm{N} \in \mathbb{R}^{KN\times KN}@f$
%> is block diagonal and defined as 
%> @f[
%> [\mathsf{{Q}}^m_\mathrm{N}]_{(k-1)N+i,(k-1)N+j} =
%>  \sum_{E_{kn} \in \partial T_k \cap \mathcal{E}_N}
%>  \int_{E_{kn}} \nu_{kn}^m \varphi_{ki} \varphi_{kj} \mathrm{d}s \,.
%> @f]
%> with @f$\nu_{kn}@f$ the @f$m@f$-th component (@f$m\in\{1,2\}@f$) of the edge
%> normal.
%> All other entries are zero.
%> To allow for vectorization, the assembly is reformulated as
%> @f[
%> \mathsf{{Q}}^m_\mathrm{N} = \sum_{n=1}^{n_\mathrm{edges}}
%>   \begin{bmatrix}
%>     \delta_{E_{1n}\in\mathcal{E}_\mathrm{N}} &   & \\
%>     & ~\ddots~ & \\
%>     &          & \delta_{E_{Kn}\in\mathcal{E}_\mathrm{N}}
%>   \end{bmatrix} \circ \begin{bmatrix}
%>     \nu^m_{1n} | E_{1n} | &   & \\
%>     & ~\ddots~ & \\
%>     &          & \nu^m_{Kn} | E_{Kn} |
%>   \end{bmatrix} \otimes [\hat{\mathsf{{S}}}^\mathrm{diag}]_{:,:,n}\;,
%> @f]
%> where @f$\delta_{E_{kn}\in\mathcal{E}_\mathrm{N}}@f$ denotes the Kronecker 
%> delta, @f$\circ@f$ denotes the Hadamard product, and @f$\otimes@f$ denotes 
%> the Kronecker product.
%>
%> The entries of matrix 
%> @f$\hat{\mathsf{{S}}}^\mathrm{diag}\in\mathbb{R}^{N\times N\times{n_\mathrm{edges}}}@f$
%> are given by
%> @f[
%> [\hat{\mathsf{{S}}}^\mathrm{diag}]_{i,j,n} =
%>   \int_0^1 \hat{\varphi}_i \circ \hat{\mathbf{\gamma}}_n(s) 
%>   \hat{\varphi}_j\circ \hat{\mathbf{\gamma}}_n(s) \mathrm{d}s \,,
%> @f]
%> where the mapping @f$\hat{\mathbf{\gamma}}_n@f$ is defined in 
%> <code>gammaMap()</code>.
%>
%> It is essentially the same as the diagonal part of
%> <code>assembleMatEdgePhiPhiNu()</code>.
%>
%> @param  g          The lists describing the geometric and topological 
%>                    properties of a triangulation (see 
%>                    <code>generateGridData()</code>) 
%>                    @f$[1 \times 1 \text{ struct}]@f$
%> @param  markE0T    <code>logical</code> arrays that mark each triangles
%>                    (boundary) edges on which the matrix blocks should be
%>                    assembled @f$[K \times {n_\mathrm{edges}}]@f$
%> @param refEdgePhiIntPhiInt  Local matrix 
%>                    @f$\hat{\mathsf{{S}}}^\text{diag}@f$ as provided
%>                    by <code>integrateRefEdgePhiIntPhiInt()</code>.
%>                    @f$[N \times N \times {n_\mathrm{edges}}]@f$
%> @param areaNuMarkE0T (optional) argument to provide precomputed values
%>                    for the products of <code>markE0T</code>,
%>                    <code>g.areaE0T</code>, and <code>g.nuE0T</code>
%>                    @f$[2 \times 1 \text{ cell}]@f$
%> @retval ret        The assembled matrices @f$[2 \times 1 \text{ cell}]@f$
%>
%> This file is part of FESTUNG
%>
%> @copyright 2014-2017 Florian Frank, Balthasar Reuter, Vadym Aizinger
%>
%> @author Hennes Hajduk, 2016.
%> @author Balthasar Reuter, 2017.
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
function ret = assembleMatEdgePhiIntPhiIntNu(g, markE0T, refEdgePhiIntPhiInt, areaNuMarkE0T)
% Extract dimensions
K = g.numT;  N = size(refEdgePhiIntPhiInt, 1); nEdges = size(g.E0T, 2);

% Check function arguments that are directly used
validateattributes(markE0T, {'logical'}, {'size', [K nEdges]}, mfilename, 'markE0T');
validateattributes(refEdgePhiIntPhiInt, {'numeric'}, {'size', [N N nEdges]}, mfilename, 'refEdgePhiIntPhiInt');

if nargin < 4
  areaNuMarkE0T = cell(2,1);
  if isfield(g, 'areaNuE0T')
    areaNuMarkE0T{1} = markE0T .* g.areaNuE0T(:, :, 1);
    areaNuMarkE0T{2} = markE0T .* g.areaNuE0T(:, :, 2);
  else
    areaNuMarkE0T{1} = markE0T .* g.areaE0T .* g.nuE0T(:, :, 1);
    areaNuMarkE0T{2} = markE0T .* g.areaE0T .* g.nuE0T(:, :, 2);
  end % if
end % if

validateattributes(areaNuMarkE0T, {'cell'}, {'numel', 2}, mfilename, 'areaNuMarkE0T');
validateattributes(areaNuMarkE0T{1}, {'numeric'}, {'size', [K nEdges]}, mfilename, 'areaNuMarkE0T{1}');
validateattributes(areaNuMarkE0T{2}, {'numeric'}, {'size', [K nEdges]}, mfilename, 'areaNuMarkE0T{2}');

ret = { sparse(K*N, K*N), sparse(K*N, K*N) };
for m = 1 : 2
  for n = 1 : nEdges
    ret{m} = ret{m} + kron(spdiags(areaNuMarkE0T{m}(:, n), 0, K, K), refEdgePhiIntPhiInt(:, :, n));
  end % for n
end % for m
end % function
