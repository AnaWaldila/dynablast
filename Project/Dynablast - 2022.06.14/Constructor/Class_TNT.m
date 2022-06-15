classdef Class_TNT
    
    % This class is to construct the TNT parameters. Characteristics like
    % scalar distance, weight an type of explosion are presents here.
    % Considering the negative phase or not is presents.
    
    % Variables
    % sup: type of support (0 for simple support and 1 for campled)
    % type_sup: type of support of membrane (1 for immovable, 2 for movable
    % and 3 for stress free)
    % phase: phase for analisys (1 for positive phase, 2 for negative 
    % phase, 3 for free vibration)
    % type: type of explosion (1 for Hemispherical and 2 for Spherical)
    % Z: Scale distance (kg/m^1/3)
    % W: TNT's mass (kg)
    % time: time of analisys (s)
    % negative: negative phase (0 for not and 1 for yes)
    % db_pamx: Sobrepressure experimental data
    % db_pmin: Underpressure experimental data
    % db_td: positive time (positive phase) experimental data
    % db_tm: negative time (negative phase) experimental data
    % db_id: positive impulse (positive phase) experimental data
    % option:  
    % 1 for 'Abaco and calculate tm - Rigby Calibration', 
    % 2 for 'Abaco and calculate tm - Ana Calibration' and 
    % 3 for 'Experimental Data'
    % 4 for 'Abaco - Rigby Calibration'
    
    %% Public attributes
    properties (SetAccess = public, GetAccess = public)
        
        Z            = 0;   
        W            = 0;   
        type         = 0;  
        negative     = 0;  
        db_pmax      = 0;   
        db_pmin      = 0;
        db_td        = 0;  
        db_id        = 0;
        db_im        = 0;
        option       = 0;
                
    end
    
    %% Constructor method
    methods
        
        % =============================================================== %
        
        % Constructor function
        function tnt = Class_TNT(Z, W, type, negative, ...
                db_pmax, db_pmin, db_td, db_id, db_im, option)
            if (nargin > 0)
                tnt.Z            = Z;
                tnt.W            = W;
                tnt.type         = type;
                tnt.negative     = negative;
                tnt.db_pmax      = db_pmax;
                tnt.db_pmin      = db_pmin;
                tnt.db_td        = db_td;
                tnt.db_id        = db_id;
                tnt.db_im        = db_im;
                tnt.option       = option;
                            
            else
                tnt.Z            = 5.64;
                tnt.W            = 0.24;
                tnt.type         = 1;
                tnt.negative     = 1;
                tnt.db_pmax      = 57086.09;
                tnt.db_pmin      = 15420.247;
                tnt.db_td        = 0.00202;
                tnt.db_id        = 37.3129;
                tnt.db_im        = 40.536;
                tnt.option       = 1;
                                
            end
        end
        
        
    end
    
end