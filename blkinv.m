% Computes the inverse of a block diagonal matrix.
%===============================================================================
%> @file blkinv.m
%>
%> @brief Computes the inverse of a block diagonal matrix.
%===============================================================================
%>
%> @brief Computes the inverse of a block diagonal matrix.
%>
%> TODO
%> 
%> All other entries are zero.
%> @param  A          A block diagonal matrix @f$\mathsf{A}@f$.
%> 
%> @param  blockSize  Size of blocks to invert concurrently.
%> 
%> @retval invA       Inverse @f$\mathsf{A}^{-1}@f$ of block matrix @f$\mathsf{A}@f$. 
%>
%> The function takes a block diagonal matrix @f$\mathsf{A}@f$ and computes its 
%> inverse @f$\mathsf{A}^{-1}@f$. 
%> 
%>
%>
%>
%> This file is part of FESTUNG
%>
%> @copyright 2014-2017 Balthasar Reuter, Florian Frank, Vadym Aizinger
%> @author Balthasar Reuter, 2017
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
function invA = blkinv(A, blockSize)
validateattributes(A, {'numeric'}, {'square'}, 'A')
validateattributes(blockSize, {'numeric'}, {'scalar', '>', 0}, 'blockSize')

n = size(A,1);
numBlocks = ceil(n / blockSize);
idxEnd = 0;
    
invA = cell(numBlocks, 1);
for idxBlock = 1 : numBlocks - 1
  idxStart = (idxBlock - 1) * blockSize + 1;
  idxEnd = idxBlock * blockSize;
  invA{idxBlock} = A(idxStart : idxEnd, idxStart : idxEnd) \ speye(blockSize);
end % for
invA{numBlocks} = A(idxEnd + 1 : end, idxEnd + 1 : end) \ speye(n - (numBlocks - 1) * blockSize);
invA = blkdiag(invA{:});
end % function
