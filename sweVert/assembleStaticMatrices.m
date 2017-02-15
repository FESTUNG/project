function problemData = assembleStaticMatrices(problemData)
problemData.globM = assembleMatElemPhiPhi(problemData.g, problemData.hatM);
problemData.globH = assembleMatElemDphiPhi(problemData.g, problemData.hatH);
problemData.globQ = problemData.fn_assembleMatEdgeTrapPhiPhiNu(problemData.g, problemData.g.markE0Tint, problemData.hatQdiag, problemData.hatQoffdiag);

globQAvg = problemData.fn_assembleMatEdgeTrapPhiPhiNu(problemData.g, problemData.g.markE0Tint, problemData.hatQdiag, problemData.hatQoffdiag, 1:2);
problemData.globQavg = globQAvg{1};
problemData.globQup = assembleMatEdgeTrapPhiPhiNuBottomUp(problemData.g, problemData.g.markE0Tint | problemData.g.markE0TbdrF, problemData.hatQdiag, problemData.hatQoffdiag);

problemData.globS = assembleMatEdgeTrapPhiPerQuad(problemData.g, problemData.hatSdiag);
problemData.barGlobS = assembleMatEdgeTrapPhi1DPerQuad(problemData.g, problemData.barHatSdiag);

problemData.tildeGlobH = assembleMatElemDphiPhi1D(problemData.g, problemData.tildeHatH);
problemData.tildeGlobQ = assembleMatEdgeTrapPhiPhi1DNu(problemData.g, problemData.g.g1D, problemData.g.markE0Tint, problemData.tildeHatQdiag, problemData.tildeHatQoffdiag);

% AR: -------------------------------------------------------------------------------------------------------------
problemData.tildeGlobQbdr = assembleMatEdgeTrapPhiIntPhi1DIntNu(problemData.g, problemData.g.g1D, problemData.g.markE0Tbdr .* ~(problemData.g.markE0TprescH), problemData.tildeHatQdiag);
% AR: -------------------------------------------------------------------------------------------------------------

for m = 1 : 2
  problemData.tildeGlobH{m} = problemData.gConst * problemData.tildeGlobH{m};
  problemData.tildeGlobQ{m} = problemData.gConst * problemData.tildeGlobQ{m};
  problemData.tildeGlobQbdr{m} = problemData.gConst * problemData.tildeGlobQbdr{m};
end % for m
end % function