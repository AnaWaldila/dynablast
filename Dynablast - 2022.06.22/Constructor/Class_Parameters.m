classdef Class_Parameters
    
    % =================================================================== %
    % DESCRIPTION
    
    % This class represents a verification with all parameters that are
    % presents in both cases: general analysis and advanced analysis.
    % For each case, some parameters changes for general or advanced
    % analysis. Because of this, a behavior of blast wave and plate's
    % parameters can change. 
    % So, its easier manipulate the advanced parameters hear than
    % modificate all time in Class_Blast, Class_K1K3, Class_Disp and
    % Class_Period
    
    % =================================================================== %
    
    %% Public attributes
    properties (SetAccess = public, GetAccess = public)
        
        tnt             Class_TNT              % TNT's properties
        analysis        Class_Analysis         % Type Analysis propertie
        advanalysis     Class_AdvAnalysis      % Type of Advanced Analysis
        
        Z           = 0;    % Variable about parameter Z
        W           = 0;    % Variable about parameter W
        negative    = 0;    % Variable about negative phase consideration
                            % negative = 0 (OFF), negative = 1 (ON)
        nonlinear   = 0;    % Variable about (non)linearyti consideration
                            % nonlinear = 0 (OFF), nonlinear = 1(ON)
        
    end
    
    %% Constructor Mode
    methods
        
        function this = Class_Parameters(tnt, analysis, advanalysis)
            if (nargin > 0)
                
                % Functions
                this = this.Parameter_Z(tnt, analysis, advanalysis);
                this = this.Parameter_W(tnt, analysis, advanalysis);
                this = this.Parameter_Nonlinear(analysis, advanalysis);
                this = this.Parameter_Negative(tnt, analysis, advanalysis);
            
            end
            
        end
                
    end
    
    %% Public Methods
    methods
       
        % =============================================================== %
        
        % Function about parameter Z (scaled distance)
        function this = Parameter_Z(this, tnt, analysis, advanalysis)
            
            this.tnt            = tnt;
            this.analysis       = analysis;
            this.advanalysis    = advanalysis;
            
            button              = this.analysis.gen_button;
            parameter           = this.advanalysis.adv_parameter;
            
            switch button
                case 0  % General Button (Do not use advanced analysis)
                    this.Z           = this.tnt.Z;
                case 1  % Advanced Button
                    switch parameter
                        case 1  % Using advanced analysis (variating Z)
                            this.Z   = this.advanalysis.Z_initial;
                        case 2  % Using advanced analysis (variating W)
                            this.Z   = this.advanalysis.Z_initial;
                        case 3 % Using advanced analysis (DAF - Variating W)
                            this.Z   = this.tnt.Z;
                        case 4  % Using advanced analysis: variating total 
                                % time per structure's linear period
                            this.Z   = this.advanalysis.Z_initial;
                        case 5  % Using advanced analysis: variating total 
                                % time per structure's nonlinear period
                            this.Z   = this.advanalysis.Z_initial;
                        case 6 % Using advanced analysis: variating total Z
                               % and calculating stress in the middle of
                               % the plate
                            this.Z   = this.advanalysis.Z_initial;
                        case 7 % Using advanced analysis (DAF - Variating Z)
                            this.Z   = this.advanalysis.Z_initial;
                        case 8 % Using advanced analysis (General Equation)
                            this.Z   = this.advanalysis.Z_initial;
                            
                    end
            end
            
        end
        
        % =============================================================== %
        
        % Function about parameter W (TNT's weight)
        function this = Parameter_W(this, tnt, analysis, advanalysis)
            
            this.tnt            = tnt;
            this.analysis       = analysis;
            this.advanalysis    = advanalysis;
            
            button              = this.analysis.gen_button;
            parameter           = this.advanalysis.adv_parameter;
            
            switch button
                case 0  % General Button (Do not use advanced analysis)
                    this.W         = this.tnt.W;
                case 1  % Advanced Button
                    switch parameter
                        case 1  % Using advanced analysis (variating Z)
                            this.W         = this.tnt.W;
                        case 2  % Using advanced analysis (variating W)
                            this.W         = this.advanalysis.W_initial;
                        case 3 % Usind advanced analysis (DAF)
                            this.W         = this.advanalysis.W_initial;
                        case 4  % Using advanced analysis: variating total 
                                % time per structure's linear period
                            this.W         = this.tnt.W;
                        case 5  % Using advanced analysis: variating total 
                                % time per structure's nonlinear period
                            this.W         = this.tnt.W;
                        case 6 % Using advanced analysis: variating total Z
                               % and calculating stress in the middle of
                               % the plate
                            this.W         = this.tnt.W;
                        case 7 % Using advanced analysis (DAF - Variating Z)
                            this.W         = this.tnt.W;
                        case 8 % Using advanced analysis (General Equation)
                            this.W         = this.advanalysis.W_initial;
                                                     
                    end
            end
            
        end
        
        % =============================================================== %
        
        % Function about parameter nonlinearyti
        function this = Parameter_Nonlinear(this, analysis, advanalysis)
            
            this.analysis       = analysis;
            this.advanalysis    = advanalysis;
            
            button              = this.analysis.gen_button;
            parameter           = this.advanalysis.adv_parameter;
            
            % analysis about advanced analysis
            switch button
                case 0  % General Button (Do not use advanced analysis)
                    this.nonlinear = this.analysis.nonlinear;
                case 1  % Advanced Button
                    switch parameter
                        case 1  % Using advanced analysis (variating Z)
                            this.nonlinear = this.analysis.nonlinear;
                        case 2  % Using advanced analysis (variating W)
                            this.nonlinear = this.advanalysis.adv_nonlinear;
                        case 3 % Usind advanced analysis (DAF)
                            this.nonlinear = this.analysis.nonlinear;
                        case 4  % Using advanced analysis: variating total 
                                % time per structure's linear period
                            this.nonlinear = this.analysis.nonlinear;
                        case 5  % Using advanced analysis: variating total 
                                % time per structure's nonlinear period
                            this.nonlinear = this.analysis.nonlinear;
                        case 6 % Using advanced analysis: variating total Z
                               % and calculating stress in the middle of
                               % the plate
                            this.nonlinear = this.analysis.nonlinear;
                        case 7 % Using advanced analysis (DAF - Variating Z)
                            this.nonlinear = this.analysis.nonlinear;
                        case 8 % Using advanced analysis (General Equation)
                            this.nonlinear = this.analysis.nonlinear;
                            
                    end
            end
            
        end
        
        % =============================================================== %
        
        % Function about parameter negative phase
        function this = Parameter_Negative(this, tnt, analysis, advanalysis)
            
            this.tnt            = tnt;
            this.analysis       = analysis;
            this.advanalysis    = advanalysis;
            
            button              = this.analysis.gen_button;
            parameter           = this.advanalysis.adv_parameter;
            
            % analysis about advanced analysis
            switch button
                case 0  % General Button (Do not use advanced analysis)
                    this.negative  = this.tnt.negative;
                case 1  % Advanced Button
                    switch parameter
                        case 1  % Using advanced analysis (variating Z)
                            this.negative  = this.tnt.negative;
                        case 2  % Using advanced analysis (variating W)
                            this.negative  = this.advanalysis.adv_negative;
                        case 3 % Usind advanced analysis (DAF)
                            this.negative  = this.tnt.negative;
                        case 4  % Using advanced analysis: variating total 
                                % time per structure's linear period
                            this.negative  = this.tnt.negative;
                        case 5  % Using advanced analysis: variating total 
                                % time per structure's nonlinear period
                            this.negative  = this.tnt.negative;
                        case 6 % Using advanced analysis: variating total Z
                               % and calculating stress in the middle of
                               % the plate
                            this.negative  = this.tnt.negative;
                        case 7 % Using advanced analysis (DAF - Variating Z)
                            this.negative  = this.tnt.negative;
                        case 8 % Using advanced analysis (General Equation)
                            this.negative  = this.tnt.negative;
                            
                    end
            end
            
        end
        
    end
    
end