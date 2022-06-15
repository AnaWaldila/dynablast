classdef Class_Stress
    
    % =================================================================== %
    % DESCRIPTION
    
    % This class has an objective to calculate the stress of the plate.
    % Usually, the stress is avaliated in the center of the plate.
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
        analysis    Class_Analysis	% Type Analysis propertie
        k1k3        Class_K1K3      % Plate's parameters
        
        w = 0;                      % Displacement in Z axis
        sb = sym(zeros(1,2));       % Matrix about bending stress
        sm = sym(zeros(1,2));       % Matrix about membrane stress
        st = sym(zeros(1,2));       % Matrix about total stress 
                                    % (bending + membrane)
        sr = sym(zeros(1,2));       % Matrix about the rate membrane 
                                    % stress and total stress
        
    end
    
    %% Constructor Mode
    methods
        
        function this = Class_Stress(plate, analysis, k1k3)
            
            if (nargin > 0)
                
                % Functions
                this = this.Displacement_Z(plate);
                this = this.BendingStress(plate);
                this = this.MembraneStress(analysis, k1k3);
                this = this.TotalStress();
                this = this.RelationStress();
                
            end
            
        end
        
    end
    
    %% Public methods
    methods
        
        % =============================================================== %
        
        % Function to determinate the displacement of z axis
        function this = Displacement_Z(this, plate)
            
            syms x y Y
            
            this.plate  = plate;
            
            sup         = this.plate.sup;
            a           = this.plate.a;
            beta        = this.plate.beta;
            h           = this.plate.h;
            b           = a / beta;
            Amp         = Y * h;    % Yamaki's Equation
            
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
        
        % Function to calculate Bending stress
        function this = BendingStress(this, plate)
            
            syms x y
            
            this.plate = plate;
            
            h          = this.plate.h;
            E          = this.plate.E;
            nu         = this.plate.nu;
            
            % ----------------------------------------------------------- %
            % Calculating displacement
            uz = this.w;
            
            % ----------------------------------------------------------- %
            % Calculating stress: 1 for X axis and 2 for Y axis
            this.sb(1,1) = subs(- E .* (h./2) .* ...
                ( diff(uz,x,2) + nu .* diff(uz,y,2) ) ./ ...
                (1 - nu^2) ./ 1000000, {x,y},{0,0});
            this.sb(1,2) = subs(- E .* (h./2) .* ...
                ( diff(uz,y,2) + nu .* diff(uz,x,2) ) ./ ...
                (1 - nu^2) ./ 1000000, {x,y},{0,0});
            
        end
        
        % =============================================================== %
        
        % Function about the membrane stress. SI.: MPa
        function this = MembraneStress(this, analysis, k1k3)
            
            syms x y Y
            
            this.analysis   = analysis;
            nonlinear       = this.analysis.nonlinear;
            
            this.k1k3       = k1k3;
            Airy            = this.k1k3.airy;
            
            switch nonlinear
                case 0
                    this.sm(1,1) = 0;
                    this.sm(1,2) = 0;
                case 1
                    % Calculating stress: 1 for X axis and 2 for Y axis
                    this.sm(1,1) = subs(diff(Airy, y, 2) ./ 1000000, ...
                        {x,y},{0,0});
                    this.sm(1,2) = subs(diff(Airy, x, 2) ./ 1000000, ...
                        {x,y},{0,0});
            end
            
        end
        
        % =============================================================== %
        
        % Function about the total stress. SI.: MPa
        function this = TotalStress(this)
            
            % Calculating stress: 1 for X axis and 2 for Y axis
            for i = 1 : 2
                this.st(1,i) = this.sb(1,i) + this.sm(1,i);
            end
            
        end
        
        % =============================================================== %
        
        % Function about the rate between membrane stress and total stress.
        function this = RelationStress(this)
            
            % Calculating stress: 1 for X axis and 2 for Y axis
            for i = 1 : 2
                this.sr(1,i) = this.sm(1,i) / this.st(i);
            end
            
        end
        
    end
    
end