classdef Class_Strain
        
    % =================================================================== %
    % DESCRIPTION
    
    % This class has an objective to calculate the strain of the plate.
    % For this, its necessaire to include parameters of the plate and TNT.
    % This calculus is only for general button.
    % This process can be see in Feldgun [1] and Reis [2]. The processo of
    % strain calcule can be see in Yamaki [3].
    
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
    % Z: Scale distance (kg/m^1/3)
    % W: TNT's mass (kg)
    % phase: phase for analisys (1 for positive phase, 
    % 2 for negative phase, 3 for free vibration)
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
        
        plate       Class_Plate     % Plate's properties
        analysis    Class_Analysis  % Type Analysis propertie
        k1k3        Class_K1K3      % Plate's parameters
        
        w = 0;                      % Displacement in Z axis
        u = sym(zeros(1,3));        % Matrix about displacement
        eb = sym(zeros(1,3));       % Matrix about bending strain
        em = sym(zeros(1,3));       % Matrix about membrane strain
        et = sym(zeros(1,3));       % Matrix about total strain 
                                    % (bending + membrane)
        
    end
    
    %% Constructor Mode
    methods
        
        function this = Class_Strain(plate, analysis, k1k3)
            
            if (nargin > 0)
                
                % Functions
                this = this.Displacement_Z(plate);
                this = this.Displacement_XY(plate, k1k3);
                this = this.BendingStrain(plate);
                this = this.MembraneStrain(analysis);
                this = this.TotalStrain();
                
            end
            
        end
        
    end
    
    %% Public methods
    methods
        
        % =============================================================== %
        
        % Function to determinate the displacement of z axis
        function this = Displacement_Z(this, plate)
            
            syms x y Y
            
            this.plate      = plate;
            
            sup             = this.plate.sup;
            a               = this.plate.a;
            beta            = this.plate.beta;
            h               = this.plate.h;
            b               = a / beta;
            Amp             = Y * h;    % Yamaki's Equation
            
            % ----------------------------------------------------------- %
            
            % Determinating the equation each boundary condition
            switch sup
                case 0 % ---------------------------------- Support: Simple
                    this.w = (Amp) * ...
                        cos(pi * x / a) * cos(pi * y / b);
                case 1 % --------------------------------- Support: Campled
                    this.w = (Amp) .* ...
                        (cos(pi * x ./ a) * cos(pi * y ./ b)).^2;
            end
            
        end
        
        % =============================================================== %
        
        % Function to determinate the displacement of x axis
        function this = Displacement_XY(this, plate, k1k3)
            
            syms x y Y
            
            this.plate	= plate;
            this.k1k3	= k1k3;
            
            nu          = this.plate.nu;
            E           = this.plate.E;
            Airy        = this.k1k3.airy;
            disp_z      = this.w;
            
            % ----------------------------------------------------------- %
            
            % Seeing in Yamaki (1989)
            
            % Strain in X axis
            this.u(1,1) = int((1 / E) * (diff(Airy,y,2) - ...
                nu * diff(Airy,x,2)) - 0.5 * (diff(disp_z,x))^2, x, 0, x);
            
            % Strain in Y axis
            this.u(1,2) = int((1 / E) * (diff(Airy,x,2) - ...
                nu * diff(Airy,y,2)) - 0.5 * (diff(disp_z,y))^2, y, 0, y);
            
        end
        
        % =============================================================== %
        
        % Function to calculate Bending Strain
        function this = BendingStrain(this, plate)
            
            syms x y
            
            this.plate   = plate;
            
            h            = this.plate.h;
            
            % ----------------------------------------------------------- %
            % Calculating displacement
            uz = this.w;
            
            % ----------------------------------------------------------- %
            % Calculating strain: 1 for X axis, 2 for Y axis and 3 for XY 
            this.eb(1,1) = - h / 2 * diff(uz, x, 2);
            this.eb(1,2) = - h / 2 * diff(uz, y, 2);
            this.eb(1,3) = - h / 2 * diff(diff(uz,x),y);
            
        end
        
        % =============================================================== %
        
        % Function to calculate Membrane Strain
        function this = MembraneStrain(this, analysis)
            
            syms x y
                        
            this.analysis   = analysis;
            nonlinear       = this.analysis.nonlinear;
            
            % ----------------------------------------------------------- %
            % Calculating displacement
            uz = this.w;
            ux = this.u(1,1);
            uy = this.u(1,2);
            
            % ----------------------------------------------------------- %
            
            switch nonlinear
                case 0
                    this.em(1,1) = 0;
                    this.em(1,2) = 0;
                    this.em(1,3) = 0;
                case 1
                    
                    % Calculating strain: 1 for X axis, 2 for Y axis 
                    % and 3 for XY
                    this.em(1,1) = diff(ux,x) + 0.5 * (diff(uz,x))^2;
                    this.em(1,2) = diff(uy,y) + 0.5 * (diff(uz,y))^2;
                    this.em(1,3) = 0.5 * (diff(ux,y) + diff(uy,x) + ...
                        diff(uz,x) * diff(uz,y));
                    
            end
            
        end
        
        % =============================================================== %
        
        % Function to calculate total Strain
        function this = TotalStrain(this)
            
            % Calculating strain: 1 for X axis, 2 for Y axis and 3 for XY
            for i = 1 : 3
                this.et(1,i) = this.eb(1,i) + this.em(1,i);
            end
                           
        end
        
    end
    
end