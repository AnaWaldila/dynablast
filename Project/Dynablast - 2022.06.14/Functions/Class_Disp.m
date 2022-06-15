classdef Class_Disp
    
    % =================================================================== %
    % DESCRIPTION
    
    % Class Class_Disp to calculate the displacement in the center of the plate
    % This class is separete in 4 functions: Nonlinear_Negative (where
    % considering the nonlinear effect with negative phase), Linear_Negative
    % (considering the linear effect with negative phase), Nonlinear_Positive
    % (considering the nonlinear effect without negative phase) and
    % Linear_Positive (considering the linear effect without negative phase)
    % Calculus is based on the differential equation, presented by Yamaki
    % [3]. The solution of positive phase was presented by Feldgun [1] and
    % both cases (positive and negative phases) was presented by Reis [2]
    
    % Variables
    % sup: type of support (0 for simple support and 1 for campled)
    % type_sup: type of support of membrane (1 for immovable,
    % 2 for movable and 3 for stress free)
    % a: length for x direction (m)
    % beta: ratio a / b
    % E: Young's Modulus (N/m²)
    % h: tickness (m)
    % nu: Poisson's coeficient
    % rho: material's density (kg/m³)
    % type: type of explosion (1 for Hemispherical and 2 for Spherical)
    % phase_disp: phase for analisys (1 for positive phase,
    % 2 for negative phase, 3 for free vibration)
    % Z: Scale distance (kg/m^1/3)
    % W: TNT's mass (kg)
    % time: time of analisys (s)
    % nonlinear: nonlinear effect (0 for not and 1 for yes)
    % negative: negative phase (0 for not and 1 for yes)
    
    % REFERENCES
    % [1] Feldgun, V. R., Yankelevsky, D.Z., Karinski, Y.S. A nonlinear
    % SDOF model for blast response simulation of elastic this rectangular
    % plates. International Journal of Impact Engineering, 2016.
    % [2] Reis, A. W. Q. R. Análise dinâmica de placas considerando efeito
    % de membrana submetidas a carregamentos explosivos. Master's thesis.
    % (Master of Science in Civil Engineering) - Engineering Faculty, Rio
    % de Janeiro State University, Rio de Janeiro, 2019.
    % [3] Yamaki, N. Influence of Large Amplitudes on Flexural Vibrations of
    % Elastic Plates.
    % =================================================================== %
    
    %% Public attributes
    properties (SetAccess = public, GetAccess = public)
        
        tnt             Class_TNT           % TNT's properties
        plate           Class_Plate         % Plate's properties
        analysis        Class_Analysis      % Type Analysis propertie
        advanalysis     Class_AdvAnalysis   % Type of Advanced Analysis
        prt             Class_Parameters    % Advanced Considerations
        blast           Class_Blast         % Blast's load parameters
        k1k3            Class_K1K3          % Plate's parameters
        
        s1        = 0;          % EDO's solution of positive phase
        s2        = 0;          %¨EDO's solution of negative phase
        s3        = 0;          % EDO's solution of free vibration
        S         = 0;          % Plate's displacement
        major     = 0;          % Major value in historical displacement
        
    end
    
    %% Constructor Mode
    methods
        
        function this = Class_Disp(tnt, plate, analysis, blast, k1k3, ...
                advanalysis, prt)
            
            if (nargin > 0)
                
                % Functions
                this = this.Displacement(tnt, plate, analysis, blast, ...
                    k1k3, advanalysis, prt);
                this = this.Major_Value();
                
            end
            
        end
        
    end
    
    %% Static Methods
    methods (Static)
        
        % =============================================================== %
        
        % Auxiliar Function to verificate Nonlinear and Linear Analysis
        function [dydt] = Equation...
                (t, y, phase_disp, rho, h, sup, pmax, pmin, ...
                td, tm, expo, K1, K3)
            
            % Verificating the phase
            switch phase_disp
                
                case 1
                    
                    % Positive phase
                    Pos = pmax * ( 1 - (t / td) ) * exp(- expo * t / td);
                    
                    switch sup
                        case 0
                            P = Pos * 16 / pi^2 / rho / h^2;
                        case 1
                            P = Pos * 16 / 9 / rho / h^2;
                    end
                    
                    Load = P;
                    
                case 2
                    
                    % Negative phase
                    Neg = - pmin * 6.75 * ( (t - td) / tm ) * ...
                        ( 1 - (t - td) / tm )^2;
                    
                    switch sup
                        
                        case 0
                            N = Neg * 16 / pi^2 / rho / h^2;
                        case 1
                            N = Neg * 16 / 9 / rho / h^2;
                    end
                    
                    Load = N;
                    
                case 3
                    
                    % Free Vibration phase
                    
                    Load = 0;
                    
            end
            
            % ----------------------------------------------------------- %
            
            % Dismanbrate a second order differential equation in two
            % first order equations
            dydt = zeros(2,1);
            dydt(1) = y(2);
            dydt(2) = Load - K1.*y(1) - K3.*y(1)^3;
            
        end
        
    end
    
    %% General Methods
    methods
        
        % =============================================================== %
        
        % Function to calculate the displacement 
        function this = Displacement...
                (this, tnt, plate, analysis, blast, k1k3, advanalysis, prt)
            
            this.tnt            = tnt;
            this.plate          = plate;
            this.analysis       = analysis;
            this.prt            = prt;
            this.blast          = blast;
            this.k1k3           = k1k3;
            this.advanalysis    = advanalysis;
            
            time            = this.analysis.time;
            sup             = this.plate.sup;
            rho             = this.plate.rho;
            h               = this.plate.h;
            negative        = this.prt.negative;
                                                
            % Calculating parameters of blast load
            pmax = this.blast.pmax;
            pmin = this.blast.pmin;
            td   = this.blast.td;
            tm   = this.blast.tm;
            expo = this.blast.expo;
            
            % ----------------------------------------------------------- %
            
            % Calculating K1 (plate's linear behavior) and verificating if
            % exists K3 (plate's nonlinear behavior)
            
            K1 = this.k1k3.k1;
            K3 = this.k1k3.k3;
            
            % ----------------------------------------------------------- %
            
            % Solution for the Positive Phase - Positive phase always
            % exists
            [t,y] = ode45(@(t,y) this.Equation...
                (t, y, 1, rho, h, sup, pmax, pmin, ...
                td, tm, expo, K1, K3),  ...
                [0 td], [0 0]);
            this.s1 = [t,y];
            
            switch negative
                
                case 0
                    
                    % Solution for the Free Vibration
                    [t,y] = ode45(@(t,y) this.Equation...
                        (t, y, 3, rho, h, sup, pmax, pmin, ...
                        td, tm, expo, K1, K3), ...
                        [td, time], [this.s1(end,2) this.s1(end,3)]);
                    this.s3 = [t,y];
                    
                    % Final Solution
                    result = cat(1, this.s1, this.s3);
                    this.S = cat(2, result(:,1), h * result(:,2));
                    
                case 1
                                        
                    % Solution for the Negative Phase
                    [t,y] = ode45(@(t,y) this.Equation...
                        (t, y, 2, rho, h, sup, pmax, pmin, ...
                        td, tm, expo, K1, K3), ...
                        [td, td + tm], [this.s1(end,2) this.s1(end,3)]);
                    this.s2 = [t,y];
                    
                    % Solution for the Free Vibration
                    [t,y] = ode45(@(t,y) this.Equation...
                        (t, y, 3, rho, h, sup, pmax, pmin, ...
                        td, tm, expo, K1, K3), ...
                        [td + tm, time], [this.s2(end,2) this.s2(end,3)]);
                    this.s3 = [t,y];
                    
                    % Final Solution
                    result = cat(1, this.s1, this.s2, this.s3);
                    this.S = cat(2, result(:,1), h * result(:,2));
                    
            end
            
        end
        
        % =============================================================== %
        
        % Function to calculate the major value of displacement
        function this = Major_Value(this)
            
            displacement = this.S;
            
            this.major = max(abs(displacement(:,2)));
            
        end
        
    end
    
end