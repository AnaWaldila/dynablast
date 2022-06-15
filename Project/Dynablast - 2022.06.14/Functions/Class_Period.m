classdef Class_Period
    
    % =================================================================== %
    % DESCRIPTION
    
    % This class presents the linear and nonlinear period of the plate.
    % This process was present by Yamaki [3] and calculated by Soudack [2].
    % Also that, Reis [1] presented the process of calculus.
    
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
    % [2] Soudack, A. C. Nonlinear Differential Equations Satisfied by the
    % Jacobian Elliptic Functions. Mathematics Magazine, Vol 37, 1964.
    % [3] Yamaki, N. Influence of Large Amplitudes on Flexural Vibrations of
    % Elastic Plates.
    % =================================================================== %
    
    %% Public attributes
    properties (SetAccess = public, GetAccess = public)
       
        tnt         Class_TNT           % TNT's properties
        plate       Class_Plate         % Plate's properties
        analysis    Class_Analysis      % Type Analysis propertie
        prt         Class_Parameters    % Advanced Considerations
        k1k3        Class_K1K3          % Plate's parameters
        disp        Class_Disp          % Displacement's structure
        
        TNL = 0;    % Nonlinear period
        TL  = 0;    % Linear period
        RT  = 0;    % Rate between nonlinear period and total period
        
    end
    
    %% Constructor Mode
    methods
        
        function this = Class_Period(tnt, plate, analysis, k1k3, disp, prt)
            
            if (nargin > 0)
                
                % Functions
                this = this.NonlinearPeriod...
                    (tnt, plate, analysis, k1k3, disp, prt);
                this = this.LinearPeriod(k1k3);
                this = this.TotalPeriod();
                
            end
            
        end
        
    end
    
    %% Public methods
    methods
        
        % =============================================================== %
       
        % Function to calculate the nonlinear period
        function this = NonlinearPeriod...
                (this, tnt, plate, analysis, k1k3, disp, prt)
            
            this.plate      = plate;
            this.tnt        = tnt;
            this.analysis   = analysis;
            this.disp       = disp;
            this.k1k3       = k1k3;
            this.prt        = prt;
            
            nonlinear     = this.prt.nonlinear;
            h             = this.plate.h;
            
            switch nonlinear
                case 0
                    this.TNL = 0;
                case 1
                    wmax        = this.disp.major;
                    K1          = this.k1k3.k1;
                    K3          = this.k1k3.k3;
                    A           = wmax / h;
                    alpha       = sqrt(K1);
                    ni          = sqrt(K3);
                    lambda      = sqrt(alpha^2 + ni^2 * A^2);
                    k           = sqrt(ni^2 * A^2 / ...
                        (alpha^2 + ni^2 * A^2) / 2 );
                    
                    this.TNL    = 4 * ellipke(k) / lambda;
            end
            
        end
        
        % =============================================================== %
       
        % Function to calculate the linear period
        function this = LinearPeriod(this, k1k3)
            
            this.k1k3   = k1k3;
            
            K1          = this.k1k3.k1;
            
            this.TL = double(2 * pi / sqrt(K1));
            
        end
        
        % =============================================================== %
       
        % Function to calculate rate between nonlinear period and total
        % period
        function this = TotalPeriod(this)
            
            this.RT = this.TNL / (this.TNL + this.TL);
            
        end
        
    end
    
end