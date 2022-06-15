classdef Class_Plate
    
    % This code open the constructor mode, where defines the plate's
    % characteristics. This parameters are about geometrical and phisical
    % characteristics. Besides that, we have the behavior of nonlinearity
    % of the plate and the time of analysis.
    
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
        
        sup           = 0;
        type_sup      = 0;
        a             = 0;
        beta          = 0;
        h             = 0;
        nu            = 0;
        E             = 0;
        rho           = 0;
        
    end
    
    %% Constructor method
    methods
        
        % =============================================================== %
        
        % Constructor function
        function plate = Class_Plate(sup, type_sup, a, beta, h, nu, E, rho)
            if (nargin > 0)
                
                plate.sup           = sup;
                plate.type_sup      = type_sup;
                plate.a             = a;
                plate.beta          = beta;
                plate.h             = h;
                plate.nu            = nu;
                plate.E             = E;
                plate.rho           = rho;
                
            else
                
                plate.sup           = 0;
                plate.type_sup      = 1;
                plate.a             = 0.508;
                plate.beta          = 1;
                plate.h             = 0.0034;
                plate.nu            = 0.3;
                plate.E             = 207000000000;
                plate.rho           = 7770;
                
            end
        end
        
    end
    
end