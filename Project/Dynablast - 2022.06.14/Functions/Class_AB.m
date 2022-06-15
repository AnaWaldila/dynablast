%% Class Class_AB to calculate the coeficients A and B to implamentate the function phi

classdef Class_AB < handle
    
        % Function to get the results for another classes.
        % Functions
        % K1: Linear parameter for Class_K1K3
        % K3: Nonlinear parameter for Classe_K1K3
        % Airy: Nonlinear function for Class_K1K3
        % Pos: Positive phase equation of blast load
        % Neg: Negative phase equation of blast load
        % td: "Positive" time of blast load for positive phase
        % tm: "Negative" time of blast load for negative phase
        % Variables
        % type: type of explosion (1 for Hemispherical and 2 for Spherical)
        % sup: type of support (0 for simple support and 1 for campled)
        % type_sup: type of support of membrane (1 for immovable, 2 for movable and 3 for stress free)
        % phase: phase for analisys (1 for positive phase, 2 for negative phase, 3 for free vibration)
        % a: length for x direction (m)
        % beta: ratio a / b
        % E: Young's Modulus (N/m²)
        % h: tickness (m)
        % nu: Poisson's coeficient
        % rho: material's density (kg/m³)
        % Z: Scale distance (kg/m^1/3)
        % W: TNT's mass (kg)
        % time: time of analisys (s)
        % nonlinear: nonlinear effect (0 for not and 1 for yes)
        % negative: negative phase (0 for not and 1 for yes)
    
    %% Constructor method
    methods
        %------------------------------------------------------------------
        function AB = Class_AB(app)
            if (nargin > 0)
                AB.app = app;
            end
        end
    end
    
    %% Private properties
    properties (Access = private)
        
       sup = 0; % If explosion support is simple, sup = 0. Else if support is campled, sup = 1
       app = []; % handle to GUI app object
            
    end
    
    methods (Static)
    
        % Function to calculate (simbolicaly) the function eta
        function [eta] = Eta_Equation()
            
            syms gama M real
            
            eta = 4*(-1)^M * gama * M^2 * (sinh(gama*pi))^2 ...
                / pi / (gama^2 + M^2)^2 / ...
                (sinh(gama*pi) * cosh(gama*pi) + gama * pi);
            
        end
        
        % Function to develop the matriz for each support case
        function [matriz_fi] = Matriz_fi(N, beta, sup)
            
            matriz_fi = sym(zeros(N+1,N+1));
            
            if sup == 0         % Simple Support
                
                matriz_fi(1,2) = -1/32/beta^2;
                matriz_fi(2,1) = -beta^2/32;
                
            elseif sup == 1     % Campled
                                
                matriz_fi(1,2) = -1/32/beta^2;
                matriz_fi(1,3) = -1/512/beta^2;
                matriz_fi(2,1) = -beta^2/32;
                matriz_fi(2,2) = -beta^2/16/(1+beta^2)^2;
                matriz_fi(2,3) = -beta^2/32/(1+4*beta^2)^2;
                matriz_fi(3,1) = -beta^2/512;
                matriz_fi(3,2) = -beta^2/32/(4+beta^2)^2;
                
            end
                        
        end
        
        function [A,B] = Coeficients_AB(beta, N, sup)
            
            syms gama M
            
            [eta] = Class_AB.Eta_Equation();
            [matriz_fi] = Class_AB.Matriz_fi(N, beta, sup);
            
            MNend = repmat((-1).^(1:N),N,1).*subs(subs(eta,gama,(1:N)/beta),M,(1:N)');
            M1N = repmat((-1).^(1:N),N,1).*subs(subs(eta,gama,(1:N)*beta),M,(1:N)');
            
            S = eval([eye(N) M1N; MNend eye(N)]);
            
            pq1 = sum(repmat((-1).^((0:N)'),1,N+1).*matriz_fi,1);
            pq2 = sum(repmat((-1).^(0:N),N+1,1).*matriz_fi,2);
            
            pq1(1)=[];
            pq2(1)=[];
            
            v = eval([-((1:N)').^2.*pq2; -((1:N)').^2.*beta^2.*pq1']);
            
            P = diag(diag(S),0);
            
            d = (P\S)\(P\v); %pre condicionamento à esquerda
            
            A = d(1:N);
            
            B = d(N+1:end);
            
        end
    
    end
    
end