function [problemData] = adaptMesh(problemData, force)
if nargin < 2
  force = false;
end % if

% cDisc{1} in vertices of surface mesh
problemData.hV0T1D = problemData.cDiscRK{1, 1} * problemData.basesOnQuad1D.phi0D{problemData.qOrd}; 

% smoothed height in vertices of surface mesh
hSmoothV0T1D = problemData.hV0T1D;
for n = 1 : 2
  hSmoothV0T1D(:, n) = (1 ./ (1 + sum(problemData.g.g1D.markV0TV0T{n}, 2))) .* ...
                      (hSmoothV0T1D(:, n) + problemData.g.g1D.markV0TV0T{n} * problemData.hV0T1D(:, 3-n));
end % for n

% surface elevation in vertices of surface mesh
xiSmoothV0T1D = problemData.g.coordV0T(problemData.g.g1D.idxT2D0T(:,1), [1 2], 2) + hSmoothV0T1D;

if ~isreal(hSmoothV0T1D)
  error('Complex height');
end % if

% check for necessity of adaptation
markModifiedV0T1D = problemData.g.g1D.coordV0T(:, :, 2) ~= xiSmoothV0T1D;
if force || any(markModifiedV0T1D(:))
  % Change 1D coordinates
  idxV1D = problemData.g.g1D.V0T(markModifiedV0T1D);
  problemData.g.g1D.coordV(idxV1D,2) = xiSmoothV0T1D(markModifiedV0T1D);
  for n = 1 : 2
    problemData.g.g1D.coordV0T(markModifiedV0T1D(:, n), n, 2) = xiSmoothV0T1D(markModifiedV0T1D(:, n), n);
  end % for n
  
  % Change 2D coordinates
  idxV2D = problemData.g.g1D.idxV2D0V(idxV1D);
  problemData.g.coordV(idxV2D, 2) = xiSmoothV0T1D(markModifiedV0T1D);
  for k = 3 : 4
    problemData.g.coordV0T(:, k, 2) = problemData.g.coordV(problemData.g.V0T(:, k), 2);
  end % for k
  
  % Re-generate coordinate-dependent grid data
  problemData.g = problemData.g.generateCoordDependGridData(problemData.g);
  
  % Re-assemble static matrices
  problemData = assembleStaticMatrices(problemData);
  
  % Determine smoothed height
  [Q,~] = quadRule1D(problemData.qOrd);
  problemData.heightV0T1D = problemData.g.coordV0T(problemData.g.g1D.idxT2D0T(:,end), [4 3], 2) - problemData.g.coordV0T(problemData.g.g1D.idxT2D0T(:,1), [1 2], 2);
  assert(isequal(hSmoothV0T1D, problemData.heightV0T1D));
  problemData.heightQ0T1D = problemData.heightV0T1D(:,1) * (1-Q) + problemData.heightV0T1D(:,2) * Q;
end % if
end % function
