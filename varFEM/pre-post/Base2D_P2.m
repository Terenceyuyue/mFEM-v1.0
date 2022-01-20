% This is not a separate matlab script storing the base matrix of P2 Lagrange element.
% see Base2D.m
%
% Copyright (C) Terence Yu.

%% u.val
if mycontains(wStr,'.val')
    w1 = lambda(:,1)'.*(2*lambda(:,1)'-1);
    w2 = lambda(:,2)'.*(2*lambda(:,2)'-1);
    w3 = lambda(:,3)'.*(2*lambda(:,3)'-1);
    w4 = 4*lambda(:,2)'.*lambda(:,3)';
    w5 = 4*lambda(:,1)'.*lambda(:,3)';
    w6 = 4*lambda(:,1)'.*lambda(:,2)';
    w1 = repmat(w1,NT,1); w2 = repmat(w2,NT,1); w3 = repmat(w3,NT,1);
    w4 = repmat(w4,NT,1); w5 = repmat(w5,NT,1); w6 = repmat(w6,NT,1);
end
%% u.dx
if mycontains(wStr,'.dx')
    w1 = zeros(NT,nQuad); w2 = w1; w3 = w1; w4 = w1; w5 = w1; w6 = w1;
    for p = 1:nQuad
        w1(:,p) = Dlambdax(:,1)*(4*lambda(p,1)-1);
        w2(:,p) = Dlambdax(:,2)*(4*lambda(p,2)-1);
        w3(:,p) = Dlambdax(:,3)*(4*lambda(p,3)-1);
        w4(:,p) = 4*(Dlambdax(:,2)*lambda(p,3) + Dlambdax(:,3)*lambda(p,2));
        w5(:,p) = 4*(Dlambdax(:,1)*lambda(p,3) + Dlambdax(:,3)*lambda(p,1));
        w6(:,p) = 4*(Dlambdax(:,1)*lambda(p,2) + Dlambdax(:,2)*lambda(p,1));
    end
end
%% u.dy
if mycontains(wStr,'.dy')
    w1 = zeros(NT,nQuad); w2 = w1; w3 = w1; w4 = w1; w5 = w1; w6 = w1;
    for p = 1:nQuad
        w1(:,p) = Dlambday(:,1)*(4*lambda(p,1)-1);
        w2(:,p) = Dlambday(:,2)*(4*lambda(p,2)-1);
        w3(:,p) = Dlambday(:,3)*(4*lambda(p,3)-1);
        w4(:,p) = 4*(Dlambday(:,2)*lambda(p,3) + Dlambday(:,3)*lambda(p,2));
        w5(:,p) = 4*(Dlambday(:,1)*lambda(p,3) + Dlambday(:,3)*lambda(p,1));
        w6(:,p) = 4*(Dlambday(:,1)*lambda(p,2) + Dlambday(:,2)*lambda(p,1));
    end
end
%% u.grad
if mycontains(wStr,'.grad')
    w1 = zeros(NT,2*nQuad); w2 = w1; w3 = w1; w4 = w1; w5 = w1; w6 = w1;
    for p = 1:nQuad
        w1(:,2*p-1:2*p) = Dlambda1*(4*lambda(p,1)-1);
        w2(:,2*p-1:2*p) = Dlambda2*(4*lambda(p,2)-1);
        w3(:,2*p-1:2*p) = Dlambda3*(4*lambda(p,3)-1);
        w4(:,2*p-1:2*p) = 4*(Dlambda2*lambda(p,3) + Dlambda3*lambda(p,2));
        w5(:,2*p-1:2*p) = 4*(Dlambda1*lambda(p,3) + Dlambda3*lambda(p,1));
        w6(:,2*p-1:2*p) = 4*(Dlambda1*lambda(p,2) + Dlambda2*lambda(p,1));
    end
end

w = {w1,w2,w3,w4,w5,w6};