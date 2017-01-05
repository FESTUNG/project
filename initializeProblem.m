function problemData = initializeProblem(problemData)
problemData.isFinished = false;

%% Initial data.
h0Cont = @(x1) problemData.hCont(0,x1);
u10Cont = @(x1,x2) problemData.u1Cont(0,x1,x2);
u20Cont = @(x1,x2) problemData.u2Cont(0,x1,x2);

% Vector of unknowns (H, U, W)
problemData.cDisc = cell(1,3);
problemData.cDisc{1} = projectFuncCont2DataDisc1D(problemData.g.g1D, h0Cont, problemData.qOrd, problemData.barHatM, problemData.basesOnQuad1D);
problemData.cDisc{2} = execin('darcyVert/projectFuncCont2DataDiscTrap', problemData.g, u10Cont, problemData.qOrd, problemData.hatM{1}, problemData.basesOnQuad2D);
problemData.cDisc{3} = execin('darcyVert/projectFuncCont2DataDiscTrap', problemData.g, u20Cont, problemData.qOrd, problemData.hatM{1}, problemData.basesOnQuad2D);
                                                  
%% Error computation and visualization of inital condition.
fprintf('L2 errors of cDisc w.r.t. the initial condition: %g, %g, %g\n', ...
  computeL2Error1D(problemData.g.g1D, problemData.cDisc{1}, h0Cont, problemData.qOrd, problemData.basesOnQuad1D), ...
  execin('darcyVert/computeL2ErrorTrap', problemData.g, problemData.cDisc{2}, u10Cont, problemData.qOrd, problemData.basesOnQuad2D), ...
  execin('darcyVert/computeL2ErrorTrap', problemData.g, problemData.cDisc{3}, u20Cont, problemData.qOrd, problemData.basesOnQuad2D));

if problemData.isVisSol
  cLagr = cellfun(@(c) execin('darcyVert/projectDataDisc2DataLagrTrap', c), problemData.cDisc, 'UniformOutput', false);
  execin('darcyVert/visualizeDataLagrTrap', problemData.g, cLagr, {'h', 'u1', 'u2'}, problemData.outputBasename, 0, problemData.outputTypes, struct('velocity', {{'u1','u2'}}));
end % if

end % function