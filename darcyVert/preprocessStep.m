function problemData = preprocessStep(problemData, nStep)

t = nStep * problemData.tau;

%% L2-projections of algebraic coefficients.
KDisc = cellfun(@(c) projectFuncCont2DataDiscTetra(problemData.g, @(x1,x2) c(t,x1,x2), problemData.N, problemData.qOrd, ...
                       problemData.globM, problemData.basesOnQuad), problemData.KCont, 'UniformOutput', false);
fDisc = projectFuncCont2DataDiscTetra(problemData.g, @(x1,x2) problemData.fCont(t,x1,x2), problemData.N, problemData.qOrd, ...
          problemData.globM, problemData.basesOnQuad);
                             
%% Assembly of time-dependent global matrices.
problemData.globG = assembleMatElemTetraDphiPhiFuncDisc(problemData.g, problemData.hatG, KDisc);
problemData.globR = assembleMatEdgeTetraPhiPhiFuncDiscNu(problemData.g, problemData.g.markE0Tint, ...
                    problemData.hatRdiag, problemData.hatRoffdiag, KDisc);

%% Assembly of Dirichlet boundary contributions.
hDCont = @(x1,x2) problemData.hDCont(t,x1,x2);
problemData.globRD = assembleMatEdgeTetraPhiIntPhiIntFuncDiscIntNu(problemData.g, ...
                     problemData.g.markE0TbdrD | problemData.g.markE0TbdrCoupling, problemData.hatRdiag, KDisc);
problemData.globJD = assembleVecEdgeTetraPhiIntFuncContNu(problemData.g, problemData.g.markE0TbdrD, ...
                     hDCont, problemData.N, problemData.qOrd, problemData.basesOnQuad);
problemData.globKD = assembleVecEdgeTetraPhiIntFuncCont(problemData.g, problemData.g.markE0TbdrD, ...
                     hDCont, problemData.N, problemData.qOrd, problemData.basesOnQuad, ones(problemData.g.numT, 4));
                  
%% Assembly of Neumann boundary contributions.
gNCont = @(x1,x2) problemData.gNCont(t,x1,x2);
problemData.globKN = assembleVecEdgeTetraPhiIntFuncCont(problemData.g, ...
                     problemData.g.markE0TbdrN, gNCont, problemData.N, problemData.qOrd, problemData.basesOnQuad);
                   
%% Assembly of the source contribution.
problemData.globL = problemData.globM * reshape(fDisc', problemData.g.numT * problemData.N, 1);

end % function
