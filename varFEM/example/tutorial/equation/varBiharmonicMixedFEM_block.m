function [u,w] = varBiharmonicMixedFEM_block(Th,pde)
%varBiharmonicMixedFEM_block solves the biharmonic equation using the mixed FEM
% variational formulation based programming in terms of block matrix
%
%     Laplace^2 u = f;   [a1,b1] * [a2,b2]
%               u = g_D;
%            Dn u = g_N.
%
% by writing in a mixed form
%
%       - Laplace u = w
%       - Laplace w = f
%
% Unlike the conforming or nonconforming FEMs, the second boundary condition
% is an Neumann boundary condition in this case.
%

node = Th.node; N = size(node,1);
quadOrder = 5;

%% Assemble stiffness matrix
% matrix A 
cf = @(p) 1 + 0*p(:,1); 
Coef = {cf}; 
Test = {'v.val'}; 
Trial = {'u.val'}; 
A = -assem2d(Th,Coef,Test,Trial,'P1',quadOrder);
% matrix B
cf = @(p) 1 + 0*p(:,1); 
Coef = {cf}; 
Test = {'v.grad'}; 
Trial = {'u.grad'}; 
B = assem2d(Th,Coef,Test,Trial,'P1',quadOrder);
% kk 
O = zeros(size(B));
kk = [A,  B;  B', O];
kk = sparse(kk);

%% Assemble right hand side
Coef = pde.f; 
Test = 'v.val';
ff = assem2d(Th,Coef,Test,[],'P1',quadOrder);
O = zeros(size(ff));
ff = [O; ff];

%% Assemble Neumann boundary conditions
Th.elem1d = Th.bdEdge; % all boundary edges
%Th.bdEdgeIdx1 = Th.bdEdgeIdx;
%Coef = @(p) pde.Du(p)*n;
Coef = interpEdgeMat(pde.Du,Th,quadOrder);
Test = 'v.val';
ff(1:N) = ff(1:N) + assem1d(Th,Coef,Test,[],'P1',quadOrder);

%% Apply Dirichlet boundary conditions
fixedNode = Th.bdNodeIdx;
g_D = pde.g_D;
id = fixedNode + N;
isBdDof = false(2*N,1); isBdDof(id) = true;
bdDof = isBdDof; freeDof = (~isBdDof);
nodeD = node(fixedNode,:); 
U = zeros(2*N,1); U(bdDof) = g_D(nodeD);
ff = ff - kk*U;

%% Direct Solver
U(freeDof) = kk(freeDof,freeDof)\ff(freeDof);
w = U(1:N);  u = U(N+1:end); 