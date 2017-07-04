% Assembles two matrices containing integrals over interior edges of products of
% two basis functions with a discontinuous coefficient function and with a
% component of the edge normal.

%===============================================================================
%> @file assembleMatEdgeTetraPhiPhiFuncDiscNu.m
%>
%> @brief Assembles two matrices containing integrals over interior edges of 
%>        products of two basis functions with a discontinuous coefficient 
%>        function and with a component of the edge normal.
%===============================================================================
%>
%> @brief Assembles the matrices @f$\mathsf{{R}}^m, m\in\{1,2\}@f$ containing 
%>        integrals over interior edges of products of two basis functions with 
%>        a discontinuous coefficient function and a component of the edge normal.
%>
%> The matrices @f$\mathsf{{R}}^m\in\mathbb{R}^{KN\times KN}@f$
%> consist of two kinds of contributions: diagonal blocks and off-diagonal
%> blocks. Diagonal blocks are defined as
%> @f[
%> [\mathsf{{R}}^m]_{(k-1)N+i,(k-1)N+j} = \frac{1}{2} 
%>  \sum_{E_{kn} \in \partial T_k \cap \mathcal{E}_\Omega}
%>  \nu_{kn}^m \sum_{l=1}^N D_{kl}(t) 
%>  \int_{E_kn} \varphi_{ki}\varphi_{kl}\varphi_{kj} \,,
%> @f]
%> and off-diagonal blocks are defined as
%> @f[
%> [\mathsf{{R}}^m]_{(k^--1)N+i,(k^+-1)N+j} =
%>   \frac{1}{2} \nu^m_{k^-n^-} \sum_{l=1}^N D_{k^+l}(t) \int_{E_{k^-n^-}} 
%>   \varphi_{k^-i} \varphi_{k^+l} \varphi_{k^+j} \mathrm{d}s \,.
%> @f]
%> with @f$\nu_{kn}@f$ the @f$m@f$-th component (@f$m\in\{1,2\}@f$) of the unit
%> normal and @f$D_{kl}(t)@f$ the coefficients of the discrete representation
%> of a function 
%> @f$ d_h(t, \mathbf{x}) = \sum_{l=1}^N D_{kl}(t) \varphi_{kl}(\mathbf{x}) @f$
%> on an element @f$T_k@f$.
%> All other entries are zero.
%>
%> To allow for vectorization, the assembly is reformulated as
%> @f$\mathsf{{R}}^m = \mathsf{{R}}^{m,\mathrm{diag}} + 
%>    \mathsf{{R}}^{m,\mathrm{offdiag}}@f$ with the blocks defined as
%> @f[
%> \mathsf{{R}}^{m,\mathrm{diag}} = \frac{1}{2} \sum_{n=1}^4 \sum_{l=1}^N
%>   \begin{bmatrix}
%>     \delta_{E_{1n}\in\mathcal{E}_\Omega} &   & \\
%>     & ~\ddots~ & \\
%>     &          & \delta_{E_{Kn}\in\mathcal{E}_\Omega}
%>   \end{bmatrix} \circ
%>   \begin{bmatrix}
%>     \nu^m_{1n} |E_{1n}| D_{1l}(t) & & \\
%>     & ~\ddots~ & \\
%>     &          & \nu^m_{Kn} |E_{Kn}| D_{Kl}(t)
%>   \end{bmatrix} \otimes [\hat{\mathsf{{R}}}^\mathrm{diag}]_{:,:,l,n}\;,
%> @f]
%> and
%> @f[
%> \mathsf{{R}}^{m,\mathrm{offdiag}} = \frac{1}{2} \sum_{n^-=1}^4 \sum_{l=1}^N
%>   \begin{bmatrix}
%>     0&\delta_{E_{1n^-} = E_{1n^+}}&\dots&\dots&\delta_{E_{1n^-}=E_{Kn^+}} \\
%>     \delta_{E_{2n^-} = E_{1n^+}}&0&\ddots& &\vdots \\
%>     \vdots & \ddots & \ddots & \ddots & \vdots \\
%>     \vdots & & \ddots & 0 & \delta_{E_{(K-1)n^-}=E_{Kn^+}} \\
%>     \delta_{E_{Kn^-} = E_{1n^+}}&\dots&\dots&\delta_{E_{Kn^-} = E_{(K-1)n^+}} &0
%>   \end{bmatrix} \circ \begin{bmatrix}
%>     \nu_{1n^-}^m |E_{1n^-}| & \dots & \nu_{1n^-}^m |E_{1n^-}| \\
%>     \vdots & & \vdots \\
%>     \nu_{Kn^-}^m |E_{Kn^-}| & \dots & \nu_{Kn^-}^m |E_{Kn^-}|
%>   \end{bmatrix} \circ \begin{bmatrix}
%>     D_{1l}(t) & \dots & D_{Kl}(t) \\
%>     \vdots & & \vdots \\
%>     D_{1l}(t) & \dots & D_{Kl}(t)
%>   \end{bmatrix} \otimes 
%> [\hat{\mathsf{{R}}}^\mathrm{offdiag}]_{:,:,l,n^-}\;,
%> @f]
%> where @f$\delta_{E_{kn}\in\mathcal{E}_\Omega}, \delta_{E_{in^-}=E_{jn^+}}@f$ 
%> denote the Kronecker delta, @f$\circ@f$ denotes the Hadamard product, and 
%> @f$\otimes@f$ denotes the Kronecker product.
%> The index @f$n^+@f$ is given implicitly by @f$n^-@f$ as described in
%> <code>mapLocalEdgeTetra()</code>.
%>
%> The entries of matrix 
%> @f$\hat{\mathsf{{R}}}^\mathrm{diag}\in\mathbb{R}^{N\times N\times N\times3}@f$
%> are given by
%> @f[
%> [\hat{\mathsf{{R}}}^\mathrm{diag}]_{i,j,l,n} =
%>   \int_0^1 \hat{\varphi}_i \circ \hat{\mathbf{\gamma}}_n(s) 
%>   \hat{\varphi}_l \circ \hat{\mathbf{\gamma}}_n(s) 
%>   \hat{\varphi}_j\circ \hat{\mathbf{\gamma}}_n(s) \mathrm{d}s \,,
%> @f]
%> where the mapping @f$\hat{\mathbf{\gamma}}_n@f$ is defined in 
%> <code>gammaMapTetra()</code>. The entries of matrix 
%> @f$\hat{\mathsf{{R}}}^\mathrm{offdiag} \in
%>    \mathbb{R}^{N\times N\times N\times4}@f$
%> are given by
%> @f[
%> [\hat{\mathsf{{R}}}^\mathrm{offdiag}]_{i,j,l,n^-} =
%>   \int_0^1 \hat{\varphi}_i \circ \hat{\mathbf{\gamma}}_{n^-}(s) 
%>   \hat{\varphi}_l\circ \hat{\mathbf{\gamma}}_{n^+}(s)
%>   \hat{\varphi}_j\circ \hat{\mathbf{\gamma}}_{n^+}(s) \mathrm{d}s \,.
%> @f]
%>
%> @param  g          The lists describing the geometric and topological 
%>                    properties of a triangulation (see 
%>                    <code>domainRectTrap()</code>) 
%>                    @f$[1 \times 1 \text{ struct}]@f$
%> @param  markE0T    <code>logical</code> arrays that mark each elements
%>                    edges on which the matrix blocks should be
%>                    assembled @f$[K \times 4]@f$
%> @param refEdgePhiIntPhiIntPhiInt  Local matrix 
%>                    @f$\hat{\mathsf{{R}}}^\text{diag}@f$ as provided
%>                    by <code>integrateRefEdgeTetraPhiIntPhiIntPhiInt()</code>.
%>                    @f$[N \times N \times N \times 4]@f$
%> @param refEdgePhiIntPhiExtPhiExt  Local matrix 
%>                    @f$\hat{\mathsf{{R}}}^\text{offdiag}@f$ as provided
%>                    by <code>integrateRefEdgeTetraPhiIntPhiExtPhiExt()</code>.
%>                    @f$[N \times N \times N \times 4]@f$
%> @param dataDisc    A representation of the discrete function 
%>                    @f$d_h(\mathbf(x))@f$, e.g., as computed by 
%>                    <code>projectFuncCont2DataDiscTetra()</code>
%>                    @f$[K \times N]@f$
%> @retval ret        The assembled matrices @f$[2 \times 1 \text{ cell}]@f$
%>
%> This file is part of FESTUNG
%>
%> @copyright 2014-2017 Balthasar Reuter, Florian Frank, Vadym Aizinger
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
function ret = assembleMatEdgeTetraPhiPhiFuncDiscNu(g, markE0T, refEdgePhiIntPhiIntPhiInt, refEdgePhiIntPhiExtPhiExt, dataDisc)

if iscell(dataDisc)
  if isequal(size(dataDisc), [2 2])
    ret = assembleMatEdgeTetraPhiPhiFuncDiscMatrixNu(g, markE0T, refEdgePhiIntPhiIntPhiInt, refEdgePhiIntPhiExtPhiExt, dataDisc);
  elseif isvector(dataDisc) && numel(dataDisc) == 2
    ret = assembleMatEdgeTetraPhiPhiFuncDiscVectorNu(g, markE0T, refEdgePhiIntPhiIntPhiInt, refEdgePhiIntPhiExtPhiExt, dataDisc);
  else
    error('dataDisc must be a KxN-matrix or a 2x1-cell or a 2x2-cell of such matrices.')
  end % if
else
  ret = assembleMatEdgeTetraPhiPhiFuncDiscScalarNu(g, markE0T, refEdgePhiIntPhiIntPhiInt, refEdgePhiIntPhiExtPhiExt, dataDisc);
end % if
end % function

function ret = assembleMatEdgeTetraPhiPhiFuncDiscMatrixNu(g, markE0T, refEdgePhiIntPhiIntPhiInt, refEdgePhiIntPhiExtPhiExt, dataDisc)
[K, N] = size(dataDisc{1,1});
ret = { sparse(K*N, K*N), sparse(K*N, K*N) };
for n = 1 : 4
  areaE0T = 0.5 * g.areaE0T(:,n) .* markE0T(:,n);
  for r = 1 : 2
    areaNuE0T = areaE0T .* g.nuE0T(:,n,r);
    markAreaNuE0T = spdiags(areaNuE0T, 0, K, K) * g.markE0TE0T{n};
    for m = 1 : 2
      % Off-diagonal blocks
      RtildeT = zeros(K*N, N);
      for l = 1 : N
        RtildeT = RtildeT + kron(dataDisc{r,m}(:,l), refEdgePhiIntPhiExtPhiExt(:,:,l,n).');
%         ret{m} = ret{m} + kron(spdiags(areaNuE0T .* dataDisc{r,m}(:,l), 0, K, K), ...
%                                refEdgePhiIntPhiIntPhiInt(:,:,l,n)) + ...
%                           kron(g.markE0TE0T{n} .* (areaNuE0T * dataDisc{r,m}(:,l)'), ...
%                                refEdgePhiIntPhiExtPhiExt(:,:,l,n));
      end % for l
      ret{m} = ret{m} + kronVec(markAreaNuE0T.', RtildeT).';
      % Diagonal blocks
      for l = 1 : N
        ret{m} = ret{m} + kron(spdiags(areaNuE0T .* dataDisc{r,m}(:,l), 0, K, K), ...
                               refEdgePhiIntPhiIntPhiInt(:,:,l,n));
      end % for l
    end  % for m
  end % for r
end  % for n
end  % function

function ret = assembleMatEdgeTetraPhiPhiFuncDiscVectorNu(g, markE0T, refEdgePhiIntPhiIntPhiInt, refEdgePhiIntPhiExtPhiExt, dataDisc)
[K, N] = size(dataDisc{1});
ret = { sparse(K*N, K*N), sparse(K*N, K*N) };
for n = 1 : 4
  areaE0T = 0.5 * g.areaE0T(:,n) .* markE0T(:,n);
  for m = 1 : 2
    areaNuE0T = areaE0T .* g.nuE0T(:,n,m);
    markAreaNuE0T = spdiags(areaNuE0T, 0, K, K) * g.markE0TE0T{n};
    % Off-diagonal blocks
    RtildeT = zeros(K*N, N);
    for l = 1 : N
      RtildeT = RtildeT + kron(dataDisc{m}(:,l), refEdgePhiIntPhiExtPhiExt(:,:,l,n).');
%       ret{m} = ret{m} + kron(spdiags(areaNuE0T .* dataDisc{m}(:,l), 0, K, K), ...
%                              refEdgePhiIntPhiIntPhiInt(:,:,l,n)) + ...
%                         kron(g.markE0TE0T{n} .* (areaNuE0T * dataDisc{m}(:,l)'), ...
%                              refEdgePhiIntPhiExtPhiExt(:,:,l,n));
    end % for l
    ret{m} = ret{m} + kronVec(markAreaNuE0T.', RtildeT).';
    % Diagonal blocks
    for l = 1 : N
      ret{m} = ret{m} + kron(spdiags(areaNuE0T .* dataDisc{m}(:,l), 0, K, K), ...
                             refEdgePhiIntPhiIntPhiInt(:,:,l,n));
    end % for l
  end % for m
end  % for n
end  % function

function ret = assembleMatEdgeTetraPhiPhiFuncDiscScalarNu(g, markE0T, refEdgePhiIntPhiIntPhiInt, refEdgePhiIntPhiExtPhiExt, dataDisc)
[K, N] = size(dataDisc);
ret = { sparse(K*N, K*N), sparse(K*N, K*N) };
for n = 1 : 4
  areaE0T = 0.5 * g.areaE0T(:,n) .* markE0T(:,n);
  % Off-diagonal blocks
  RtildeT = zeros(K*N, N);
  for l = 1 : N
    RtildeT = RtildeT + kron(dataDisc(:,l), refEdgePhiIntPhiExtPhiExt(:,:,l,n).');
  end % for l
  for m = 1 : 2
    areaNuE0T = areaE0T .* g.nuE0T(:,n,m);
    markAreaNuE0T = spdiags(areaNuE0T, 0, K, K) * g.markE0TE0T{n};
%     for l = 1 : N
%       ret{m} = ret{m} + kron(spdiags(areaNuE0T .* dataDisc(:,l), 0, K, K), ...
%                              refEdgePhiIntPhiIntPhiInt(:,:,l,n)) + ...
%                         kron(g.markE0TE0T{n} .* (areaNuE0T * dataDisc(:,l)'), ...
%                              refEdgePhiIntPhiExtPhiExt(:,:,l,n));
%     end % for l
    ret{m} = ret{m} + kronVec(markAreaNuE0T.', RtildeT).';
    % Diagonal blocks
    for l = 1 : N
      ret{m} = ret{m} + kron(spdiags(areaNuE0T .* dataDisc(:,l), 0, K, K), ...
                             refEdgePhiIntPhiIntPhiInt(:,:,l,n));
    end % for l
  end % for m
end  % for n
end  % function