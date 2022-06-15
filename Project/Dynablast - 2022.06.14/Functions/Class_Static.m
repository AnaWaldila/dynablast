classdef Class_Static < handle
    
    % =================================================================== %
    % DESCRIPTION
    
    % This class has an objective to calculate the static displacement
    % considering the max pressure static load. This case its only for
    % general button
    % It can be see in Reis [1].
    
    % Variables
    % type: type of explosion (1 for Hemispherical and 2 for Spherical)
    % sup: type of support (0 for simple support and 1 for campled)
    % type_sup: type of support of membrane (1 for immovable, 
    % 2 for movable and 3 for stress free)
    % phase: phase for analisys (1 for positive phase, 
    % 2 for negative phase, 3 for free vibration)
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
    
    % REFERENCES:
    % [1] Reis, A. W. Q. R. Análise dinâmica de placas considerando efeito
    % de membrana submetidas a carregamentos explosivos. Master's thesis.
    % (Master of Science in Civil Engineering) - Engineering Faculty, Rio
    % de Janeiro State University, Rio de Janeiro, 2019.
    % =================================================================== %
    
    %% Public attributes
    properties (SetAccess = public, GetAccess = public)
       
        tnt         Class_TNT       % TNT's properties
        plate       Class_Plate     % Plate's properties
        analysis    Class_Analysis	% Type Analysis propertie
        blast       Class_Blast     % Blast's load parameters
        k1k3        Class_K1K3      % Plate's parameters
        
        disp = 0;   % Static displacement
        
    end
    
    %% Constructor Mode
    methods
        
        function this = Class_Static(tnt, plate, analysis, blast, k1k3)
            
            if (nargin > 0)
                
                % Functions
                this = this.Disp_Static(tnt, plate, analysis, blast, k1k3);
            end
            
        end
        
    end
    
    %% Public methods
    methods
        
        function this = Disp_Static(this, tnt, plate, analysis, blast, k1k3)
            
            this.plate    = plate;
            this.tnt      = tnt;
            this.analysis = analysis;
            this.blast    = blast;
            this.k1k3     = k1k3;
            
            nonlinear       = this.analysis.nonlinear;
            sup             = this.plate.sup;
            rho             = this.plate.rho;
            h               = this.plate.h;
            
            % ----------------------------------------------------------- %
            
            % Calculating the linear and nonlinear (if it exist)
            % parameters
            
            K1 = this.k1k3.k1;
            
            switch nonlinear
                case 0 
                    K3 = 0;
                case 1
                    K3 = this.k1k3.k3;
            end
            
            % ----------------------------------------------------------- %
            
            % Calculating the load (In this case, the pmax)
            pmax = this.blast.pmax;
            
            switch sup
                case 0
                    P = pmax * 16 / pi^2 / rho / h^2;
                case 1
                    P = pmax * 16 / 9 / rho / h^2;
            end
            
            % ----------------------------------------------------------- %
            
            % Calculating the static displacement
            switch nonlinear
                case 0
                    
                    % Equation
                    EQ = [K1 -P]; % K1 * y - P = 0
                    
                    % Real Roots
                    r = roots(EQ);
                    
                case 1
                    
                    % Equation
                    EQ = [K3 0 K1 -P]; % K3 *y^3 + K1 * y - P = 0
                    
                    % Real Roots
                    r = roots(EQ);
                    r = r(imag(r)==0);
                    
            end
            
            % Displacement
            this.disp = r * h;
            
        end
        
    end
       
end