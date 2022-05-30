function pde = PlateBendingData(varargin)

% data for plate
if nargin == 0
    t = 0.1; % plate thickness (m)
    E = 10920; % Young's modulus (Nm/kg^2)
    nu = 0.3;  % Poisson's ratio
    D = E*t^3/12/(1-nu^2); % flexural rigidity
    c = 0; % ������ϳ���
    para = struct('t',t, 'E',E, 'nu',nu, 'D',D, 'c',c);    
end

% exact solution
    function val =  uexact(p)
        x = p(:,1); y = p(:,2);
        val =  sin(2*pi*x).*cos(2*pi*y);
    end

% load data (right hand side function)
    function val =  f(p)
        x = p(:,1); y = p(:,2);
        val =  D*64*pi^4*sin(2*pi*x).*cos(2*pi*y) + c*uexact(p);
    end

% derivative of the exact solution
    function val =  Dw(p)
        x = p(:,1); y = p(:,2);
        val(:,1) = 2*pi*cos(2*pi*x).*cos(2*pi*y);
        val(:,2) = -2*pi*sin(2*pi*x).*sin(2*pi*y);
    end

% Dirichlet boundary condition
    function val = g_D(p)
        val = uexact(p);
    end

pde = struct('para', para, 'f',@f, 'uexact',@uexact, 'g_D',@g_D, 'Dw',@Dw);
end