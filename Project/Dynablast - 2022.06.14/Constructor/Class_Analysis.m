classdef Class_Analysis
    
    % This code open the constructor mode, where defines the
    % characteristics of the analysis
    
    % Variables
    % sup: type of support (0 for simple support and 1 for campled)
    % type_sup: type of support of membrane (1 for immovable, 2 for movable
    % and 3 for stress free)
    % a: length for x direction (m)
    % beta: ratio a / b
    % E: Young's Modulus (N/m²)
    % h: tickness (m)
    % nu: Poisson's coeficient
    % rho: material's density (kg/m³)
    % type: type of explosion (1 for Hemispherical and 2 for Spherical)
    % Z: Scale distance (kg/m^1/3)
    % W: TNT's mass (kg)
    % nonlinear: nonlinear effect (0 for not and 1 for yes)
    % time: time of analisys (s)
    
    %% Public attributes
    properties (SetAccess = public, GetAccess = public)
        
        nonlinear     = 0;  % Defines if the nonlinearity is ON or OFF
        time          = 0;  % Defines the time of the analysis
        gen_button    = 0;  % Verificate the button (general button = 0, 
                            % advanced button = 1)
                
    end
    
    %% Constructor method
    methods
        
        % =============================================================== %
        
        % Constructor function
        function analysis = Class_Analysis...
                (nonlinear, time, gen_button)
            if (nargin > 0)
                
                analysis.nonlinear     = nonlinear;
                analysis.time          = time;
                analysis.gen_button    = gen_button;
                                                
            else
                
                analysis.nonlinear     = 1;
                analysis.time          = 0.08;
                analysis.gen_button    = 0;
                                
            end
        end
                
    end
    
end