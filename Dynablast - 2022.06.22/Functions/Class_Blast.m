classdef Class_Blast
    
    % =================================================================== %
    % DESCRIPTION
    
    % This class calculate parameters about the blast wave. In this case,
    % we are considering these parameters: scalar distance, mass, negative
    % phase and type of explosion.
    % This code presents 3 types of input data: The first one represents
    % the code written by Samuel E. Rigby [3]. Second one developed by Ana
    % Waldila de Q. R. Reis [2]. The last one, the user input data about the
    % experimental data.
    % The Newton - Raphson Method was developed by Ambarish Prashant 
    % Chandurkar [1].
    % Observation: The table ConWepValues.mat was developed by Samuel E.
    % Rigby. This table was incorporated here to calculated the parameters
    % of blast wave using the equations also developed by him.
    
    % Variables
    % type: type of explosion (1 for Hemispherical and 2 for Spherical)
    % Z: Scale distance (kg/m^1/3)
    % W: TNT's mass (kg)
    % phase: phase for analisys (1 for positive phase, 2 for negative 
    % phase, 3 for free vibration)
    % time: time of analisys (s)
    % negative: negative phase (0 for not and 1 for yes)
    % option: 1 for 'Abaco - Rigby Calibration', 
    % 2 for 'Abaco and calculate tm - Rigby Calibration', 
    % 3 for 'Abaco and calculate tm - Ana Calibration' and 
    % 4 for 'Experimental Data'
    
    % REFERENCES:
    % [1] Chandurkar, A. P. The Newton - Raphson Method.
    % https://www.mathworks.com/matlabcentral/fileexchange/68885-the-newton-raphson-method
    % [2] Reis, A. W. Q. R. Análise dinâmica de placas considerando efeito
    % de membrana submetidas a carregamentos explosivos. Master's thesis.
    % (Master of Science in Civil Engineering) - Engineering Faculty, Rio
    % de Janeiro State University, Rio de Janeiro, 2019.
    % [3] Rigby, S. E. Blast.m - a simple tool for predicting blast pressure
    % parameters. https://blast.shef.ac.uk/?q=software
    
    % =================================================================== %
    
    %% Public attributes
    properties (SetAccess = public, GetAccess = public)
        
        tnt             Class_TNT              % TNT's properties
        analysis        Class_Analysis         % Type Analysis propertie
        advanalysis     Class_AdvAnalysis      % Type of Advanced Analysis
        prt             Class_Parameters       % Advanced Considerations
        
        pmax    = 0;    % Variable about max pressure in positive phase
        pmin    = 0;    % Variable about min pressure in negative phase
        td      = 0;    % Variable about the time that is during the
                        % positive phase
        tm      = 0;    % Negative time
        id      = 0;    % Variable about positive impulse in positive phase
        im      = 0;    % Variable about negative impulse in negative phase
        expo    = 0;    % Variable about the decaiment coefficient
        eq_p1   = 0;    % Positive equation
        eq_p2   = 0;    % Negative equation
        pos     = 0;    % Positive pressure (depending by time parameter)
        neg     = 0;    % Negative pressure (depending by time parameter)
        
    end
    
    %% Constructor Mode
    methods
        
        function this = Class_Blast(tnt, analysis, advanalysis, prt)
            if (nargin > 0)
                
                % Functions
                this = this.Max_Pressure(tnt, analysis, advanalysis, prt);
                this = this.Min_Pressure(tnt, analysis, advanalysis, prt);
                this = this.Positive_Time(tnt, analysis, advanalysis, prt);
                this = this.Positive_Impulse(tnt, analysis, advanalysis, prt);
                this = this.Negative_Impulse(tnt, analysis, advanalysis, prt);
                this = this.Negative_Time(tnt, analysis, advanalysis, prt);
                this = this.Exponent();
                this = this.Positive_Equation();
                this = this.Negative_Equation(tnt, analysis, advanalysis, prt);
                
            else
                this.tnt = Class_TNT();   % Empty constructor
            end
            
        end
        
    end
    
    %% Public Methods
    methods
        
        % =============================================================== %
        
        % Function about sobrepressure in positive phase - S.I.: Pa
        function this = Max_Pressure(this, tnt, analysis, advanalysis, prt)
            
            this.tnt            = tnt;
            this.analysis       = analysis;
            this.advanalysis    = advanalysis;
            this.prt            = prt;
            
            option              = this.tnt.option;
            Z                   = this.prt.Z;
            
            if option == 1 || option == 4   
                
                % Abaco - Rigby Calibration 
                
                type	= this.tnt.type;
                
                % Rigby [3] abacus development - ConWepValues.mat
                load ConWepValues.mat surface air 
                
                switch type
                    case 1  % Hemispherical
                        this.pmax = double(1000 * (10^(interp1(...
                            log10(surface(:,1)),log10(surface(:,3)),...
                            log10(Z),'cubic'))));
                    case 2  % Spherical
                        this.pmax = double(1000 * 10^(interp1(...
                            log10(air(:,1)),log10(air(:,3)),...
                            log10(Z),'cubic')));
                end
                                
            elseif option == 2  
                
                % Abaco - Ana Calibration
                
                type	= this.tnt.type;
                
                switch type
                    
                    case 1  % Hemispherical
                        
                        if (0.07071 < Z && Z <= 0.1895)
                            this.pmax = 1000000 * 26.303 * Z^(-1.226);
                        elseif (0.1895 < Z && Z <= 0.48735)
                            this.pmax = 1000000 * 13.015 * Z^(-1.637);
                        elseif (0.48735 < Z && Z <= 1.096)
                            this.pmax = 1000000 * 8.1 * Z^(-2.322);
                        elseif (1.096 < Z && Z <= 2.418)
                            this.pmax = 1000000 * 8.0956 * Z^(-2.943);
                        elseif (2.418 < Z && Z <= 5.442)
                            this.pmax = 1000000 * 4.9419 * Z^(-2.427);
                        elseif (5.442 < Z)
                            this.pmax = 1000000 * 0.8645 * Z^(-1.411);
                        end
                        
                    case 2  % Spherical
                        
                        if (0.07457 < Z && Z <= 0.22794)
                            this.pmax = 1000000 * 24.974 * Z^(-1.154);
                        elseif (0.22794 < Z && Z <= 0.62306)
                            this.pmax = 1000000 * 7.6735 * Z^(-1.951);
                        elseif (0.62306 < Z && Z <= 3.0697)
                            this.pmax = 1000000 * 4.8029 * Z^(-2.885);
                        elseif (3.0697 < Z && Z <= 6.06257)
                            this.pmax = 1000000 * 1.9941 * Z^(-2.054);
                        elseif (6.06257 < Z)
                            this.pmax = 1000000 * 0.6288 * Z^(-1.436);
                        end
                        
                end
                
            elseif option == 3  
                
                % Experimental Data
                
                db_pmax = this.tnt.db_pmax;
                this.pmax = db_pmax;
                
            end
            
        end
        
        % =============================================================== %
        
        % Function about sobrepressure in negative phase - S.I.: Pa
        function this = Min_Pressure(this, tnt, analysis, advanalysis, prt)
            
            this.tnt            = tnt;
            this.analysis       = analysis;
            this.advanalysis    = advanalysis;
            this.prt            = prt;
            
            option              = this.tnt.option;
            Z                   = this.prt.Z;
            negative            = this.prt.negative;
                
            % Default value
            this.pmin = 0; 
            
            if negative == 1
                
                if option == 4 || option == 1   
                    
                    % Abaco - Rigby Calibration
                    
                    type	= this.tnt.type;
                    
                    switch type
                        
                        case 1  % Hemispherical
                            
                            if (Z <= 0.669)
                                A = 0; B = 0; C = 0; D = 100E-3;
                            elseif (Z > 0.669) && (Z <= 1.27)
                                A = -32.91E-3; B = 2; C = 13E-3; D = 106E-3;
                            elseif (Z > 1.27) && (Z <= 2.78)
                                A = 93E-3; B = -1.215; C = 0; D = 0;
                            elseif (Z > 2.78)
                                A = 72.99E-3; B = -0.978; C = 0; D = 0;
                            end
                            this.pmin = double(10^6 * (( A * ( Z ^ B ) ) ...
                                + ( C * Z ) + D));
                            
                        case 2  %Spherical
                            
                            if (Z <= 0.7)
                                A = 0; B = 0; C = 0; D = 100E-3;
                            elseif (Z > 0.7) && (Z <= 1.469)
                                A = -29.078E-3; B = 2; C = 0.0352E-3; D = 114E-3;
                            elseif (Z > 1.469) && (Z <= 2.754)
                                A = 84.132E-3; B = -1.286; C = 0; D = 0;
                            elseif (Z > 2.754)
                                A = 59.559E-3; B = -0.945; C = 0; D = 0;
                            end
                            this.pmin = double(10^6 * (( A * ( Z ^ B ) )...
                                + ( C * Z ) + D));
                            
                    end
                    
                elseif option == 2  
                    
                    % Abaco - Ana Calibration
                    
                    type	= this.tnt.type;
                    
                    switch type
                        
                        case 1  % Hemispherical
                            
                            if (0.071 < Z && Z <= 0.668)
                                this.pmin = 1000 * (101);
                            elseif (0.668 < Z && Z <= 1.27)
                                this.pmin = 1000 * ( -32.9 * Z^2 + ...
                                    13.0 * Z + 106 );
                            elseif (1.27 < Z && Z <= 2.78)
                                this.pmin = 1000 * 93.0 * Z^(-1.22);
                            elseif (2.78 < Z && Z <= 37.6)
                                this.pmin = 1000 * 73.0 * Z^(-0.978);
                            end
                            
                        case 2  %Spherical
                            
                            if (0.09014 < Z && Z <= 1.04853)
                                this.pmin = 1000000 * (- 0.0703 * Z^3 - ...
                                    0.0698 * Z^2 + 0.0528 * Z + 0.2846);
                            elseif (1.04853 < Z && Z <= 2.8610)
                                this.pmin = 1000000 * 0.1944 * Z^(-1.45);
                            elseif (2.8610 < Z)
                                this.pmin = 1000000 * 0.1553 * Z^(-1.208);
                            end
                            
                    end
                    
                elseif option ==  3  
                    
                    % Experimental Data
                    
                    db_pmin     = this.tnt.db_pmin;
                    this.pmin   = db_pmin;
                    
                end
                
            end
            
        end
        
        % =============================================================== %
        
        % Function about the "positive" time for positive phase - S.I.: s
        function this = Positive_Time(this, tnt, analysis, advanalysis, prt)
            
            this.tnt            = tnt;
            this.analysis       = analysis;
            this.advanalysis    = advanalysis; 
            this.prt            = prt;
            
            option              = this.tnt.option;
            Z                   = this.prt.Z;
            W                   = this.prt.W;
                                    
            if option == 1 || option == 4   
                
                % Abaco - Rigby Calibration
                
                type	= this.tnt.type;
                
                % Rigby [3] abacus development - ConWepValues.mat
                load ConWepValues.mat surface air 
                
                switch type
                    case 1  % Hemispherical
                        this.td = double(0.001 * (W^(1/3)) * 10^...
                            (interp1(log10(surface(:,1)),log10(...
                            surface(:,5)),log10(Z),'cubic')));
                    case 2  % Spherical
                        this.td = double(0.001 * (W^(1/3)) * 10^...
                            (interp1(log10(air(:,1)),log10(...
                            air(:,5)),log10(Z),'cubic')));
                end
                                
            elseif option == 2  
                
                % Abaco - Ana Calibration
                
                type	= this.tnt.type;
                
                switch type
                    
                    case 1  % Hemispherical
                        
                        if (0.20993 < Z && Z <= 1.0355)
                            this.td = 0.001 * ( 2.2064 * Z^3 - 0.3363 * Z^2 - ...
                                0.5644 * Z + 0.3756 ) * ( W^(1/3) );
                        elseif (1.0355 < Z && Z <= 1.49339)
                            this.td = 0.001 * ( 8.2395 * Z^3 - 34.896 * Z^2 + ...
                                48.909 * Z - 20.496 ) * ( W^(1/3) );
                        elseif (1.49339 < Z && Z <= 4.001)
                            this.td = 0.001 * ( -0.2695 * Z^3 + 2.3907 * Z^2 - ...
                                6.1005 * Z + 6.8329 ) * ( W^(1/3) );
                        elseif (4.001 < Z)
                            this.td = 0.001 * ( 1.5602 * log(Z) +1.2416 ) * ...
                                ( W^(1/3) );
                        end
                        
                    case 2  % Spherical
                        
                        if (0.2210 < Z && Z <= 0.7790)
                            this.td = 0.001 * ( - 4.2668 * Z^3 - 1.9736 * Z^2 + ...
                                0.132 * Z + 0.2145 ) * ( W^(1/3) );
                        elseif (0.7790 < Z && Z <= 1.50769)
                            this.td = 0.001 * ( 7.5882 * Z^3 - 29.13 * Z^2 + ...
                                36.646 * Z - 13.319 ) * ( W^(1/3) );
                        elseif (1.50769 < Z && Z <= 3.7612)
                            this.td = 0.001 * ( -0.205 * Z^3 + 1.5627 * Z^2 - ...
                                3.1864 * Z + 3.6534 ) * ( W^(1/3) );
                        elseif (3.7612 < Z)
                            this.td = 0.001 * ( - 0.0029 * Z^2 + 0.2159 * Z + ...
                                2.1382 ) * ( W^(1/3) );
                        end
                        
                end
                
            elseif option == 3  
                
                % Experimental Data
                
                db_td   = this.tnt.db_td;
                this.td = db_td;
                
            end
            
        end
        
        % =============================================================== %
        
        % Function about "positive" impulse - S.I.: Pa.s
        function this = Positive_Impulse(this, tnt, analysis, ...
                advanalysis, prt)
            
            this.tnt            = tnt;
            this.analysis       = analysis;
            this.advanalysis    = advanalysis;
            this.prt            = prt;
            
            option              = this.tnt.option;
            Z                   = this.prt.Z;
            W                   = this.prt.W;
                        
            if option == 1 || option == 4   
                
                % Abaco - Rigby Calibration
                
                type	= this.tnt.type;
                
                % Rigby [3] abacus development - ConWepValues.mat
                load ConWepValues.mat surface air 
                
                switch type
                    case 1  % Hemispherical
                        this.id = double((W^(1/3)) * 10^(interp1(...
                            log10(surface(:,1)),log10(surface(:,7)),...
                            log10(Z),'cubic')));
                    case 2  % Spherical
                        this.id = double((W^(1/3)) * 10^(interp1(...
                            log10(air(:,1)),log10(air(:,7)),...
                            log10(Z),'cubic')));
                end
                
            elseif option == 2 
                
                % Abaco - Ana Calibration
                
                type	= this.tnt.type;
                
                switch type
                    
                    case 1  % Hemispherical
                        
                        if (0.0717 < Z && Z <= 0.1985)
                            this.id = 1000 * ( 0.4352 * Z^( -1.949 ) ) * ...
                                ( W^(1/3) );
                        elseif (0.1985 < Z && Z <= 1.2895)
                            this.id = 1000 * ( 0.8709 * Z^( -1.501 ) ) * ...
                                ( W^(1/3) );
                        elseif (1.2895 < Z)
                            this.id = 1000 * ( 0.7805 * Z^( -1.104 ) ) * ...
                                ( W^(1/3) );
                        end
                        
                    case 2  % Spherical
                        
                        if (0.07073 < Z && Z <= 0.2953)
                            this.id = 1000 * ( 0.3108 * Z^(-1.876) ) * ...
                                ( W^(1/3) );
                        elseif (0.2953 < Z && Z <= 2.1275)
                            this.id = 1000 * ( 0.5802 * Z^(-1.356) ) * ...
                                ( W^(1/3) );
                        elseif (2.1275 < Z)
                            this.id = 1000 * ( 0.4716 * Z^(-1.084) ) * ...
                                ( W^(1/3) );
                        end
                        
                end
                
            elseif option == 3  
                
                % Experimental Data
                
                db_id   = this.tnt.db_id;
                this.id = db_id;
                
            end
              
        end
        
        % =============================================================== %
        
        % Function about "negative" impulse - S.I.: Pa.s
        function this = Negative_Impulse(this, tnt, analysis, ...
                advanalysis, prt)
            
            this.tnt            = tnt;
            this.analysis       = analysis;
            this.advanalysis    = advanalysis;
            this.prt            = prt;
            
            option              = this.tnt.option;
            Z                   = this.prt.Z;
            W                   = this.prt.W;
            negative            = this.prt.negative;
            
            % Default value
            this.im = 0;    
            
            if negative == 1
                
                if option == 1 || option == 4   
                    
                    % Abaco - Rigby Calibration
                    
                    type	= this.tnt.type;
                    
                    switch type
                        
                        case 1  % Hemispherical
                            
                            if (Z <= 0.58)
                                A = -724.37E-3; B = 2;
                                C = 445.34E-3; D = 553E-3;
                            elseif (Z > 0.58) && (Z <= 1.19)
                                A = 11.356E-3; B = 2;
                                C = -314.76E-3; D = 752E-3;
                            elseif (Z > 1.19) && (Z <= 5.25)
                                A = 461.8E-3; B = -0.88; C = 0; D = 0;
                            elseif (Z > 5.25)
                                A = 433.6E-3; B = -0.842; C = 0; D = 0;
                            end
                            this.im = double(( W^(1/3) ) * ...
                                (1000 * (( A * ( Z ^ B ) ) + ( C * Z ) + D)));
                            
                        case 2  % Spherical
                            
                            if (Z <= 0.304)
                                A = 0; B = 0; C = 0; D = 496E-3;
                            elseif (Z > 0.304) && (Z <= 1.44)
                                A = 36.919E-3; B = 2;
                                C = -298.72E-3; D = 583E-3;
                            elseif (Z > 1.44)
                                A = 316.36E-3; B = -0.879;
                                C = 0; D = 0;
                            end
                            this.im = double(( W^(1/3) ) * ...
                                (1000 * (( A * ( Z ^ B ) ) + ( C * Z ) + D)));
                            
                    end
                    
                elseif option == 2  
                    
                    % Abaco - Ana Calibration
                    
                    type	= this.tnt.type;
                    
                    switch type
                        
                        case 1  % Hemispherical
                            
                            if (0.071 < Z && Z <= 0.58)
                                this.im = ( -724 * Z^2 + 445 * Z + 553 ) * ...
                                    ( W^(1/3) );
                            elseif (0.58 < Z && Z <= 1.19)
                                this.im = ( 11.4 * Z^2 - 315 * Z + 752 ) * ...
                                    ( W^(1/3) );
                            elseif (1.19 < Z && Z <= 5.25)
                                this.im = ( 462 * Z^(-0.880) ) * ( W^(1/3) );
                            elseif (5.25 < Z && Z <= 37.6)
                                this.im = ( 434 * Z^(-0.842) ) * ( W^(1/3) );
                            end
                            
                        case 2  % Spherical
                            
                            if (0.08484 < Z && Z <= 0.4742)
                                this.im = 1000 * ( - 2.931 * Z^3 - 3.5747 ...
                                    * Z^2 + 1.1692 * Z + 0.5213 ) * ( W^(1/3) );
                            elseif (0.4742 < Z && Z <= 1.602)
                                this.im = 1000 * ( 0.8315 * exp(-0.746 * Z) ) * ...
                                    ( W^(1/3) );
                            elseif (1.602 < Z)
                                this.im = 1000 * ( 0.3782 * Z^(-0.854) ) * ...
                                    ( W^(1/3) );
                            end
                            
                    end
                    
                elseif option == 3  
                    
                    % Experimental Data
                    
                    db_im   = this.tnt.db_im;
                    this.im = db_im;
                    
                end
                   
            end
             
        end
        
        % =============================================================== %
        
        % Function to calculate the "negative" time to negative phase.
        % S.I.: s
        function this = Negative_Time(this, tnt, analysis, advanalysis, prt)
            
            this.tnt            = tnt;
            this.analysis       = analysis;
            this.advanalysis    = advanalysis;
            this.prt            = prt;
            
            option              = this.tnt.option;
            Z                   = this.prt.Z;
            W                   = this.prt.W;
            negative            = this.prt.negative;
               
            % Default value
            this.tm = 0;    
            
            if negative == 1
                
                if option == 4  
                    
                    % Abaco - Rigby Calibration
                
                        type	= this.tnt.type;
                        
                        switch type
                            
                            case 1  % Hemispherical
                                
                                if (Z <= 0.267)
                                    A = 0; B = 0; C = 0; D = 10.57;
                                elseif (Z > 0.267) && (Z <= 2.9)
                                    A = -0.474; B = 2; C = 2.745; D = 9.87;
                                elseif (Z > 2.9)
                                    A = 0; B = 0; C = 0;
                                    D = 13.9;
                                end
                                this.tm = double(0.001 * ( W^(1/3) ) * ...
                                    (( A * ( Z ^ B ) ) + ( C * Z ) + D));
                                
                            case 2  % Spherical
                                
                                if (Z <= 0.537)
                                    A = 0.382;  B = 2;  C = 2.952; D = 7.917;
                                elseif (Z > 0.537) && (Z <= 2.83)
                                    A = -0.309; B = 2; C = 1.6443; D = 8.818;
                                elseif (Z > 2.83)
                                    A = 0; B = 0; C = 0; D = 11.0;
                                end
                                this.tm = double(0.001 * ( W^(1/3) ) * ...
                                    (( A * ( Z ^ B ) ) + ( C * Z ) + D));
                                
                        end
                      
                elseif option == 1 || option == 2 || option == 3  
                    
                    % Rigby and Ana Calculation | Experimental Data
                    
                    pressure = this.pmin;
                    impulse = this.im;
                    
                    this.tm = (16.0 / 9.0) * (impulse / pressure);
                     
                end
                
            end
            
        end
                
        % =============================================================== %
        
        % Funtion to calculate Newton - Raphson. Objective: to find an
        % exponent to positive phase equation
        function this = Exponent(this)
            
            syms Td aL t;
            
            impulse     = this.id;
            pressure    = this.pmax;
            pos_time    = this.td;
            
            impulse_int = subs(int(pressure * ( 1 - (t / Td) ) * ...
                exp(- aL * t / Td), t, 0, Td), Td, pos_time);
            
            equation = abs(impulse_int - impulse);
            
            this.expo = abs(double(this.Newton_Raphson(equation)));
            
        end
        
        % =============================================================== %
        
        % Funtion to calculate the positive equation
        function this = Positive_Equation(this)
            
            syms t;
            
            pressure = this.pmax;
            pos_time = this.td;
            exponent = this.expo;
            
            this.eq_p1 = pressure * ( 1 - (t / pos_time) ) * ...
                exp(- exponent * t / pos_time);
            
        end
        
        % =============================================================== %
        
        % Funtion to calculate the positive equation
        function this = Negative_Equation(this, tnt, analysis, ...
                advanalysis, prt)
            
            this.tnt            = tnt;
            this.analysis       = analysis;
            this.advanalysis    = advanalysis;
            this.prt            = prt;
            
            negative            = this.prt.negative;
                                    
            switch negative
                
                case 0
                    
                    this.eq_p2 = 0;
                    
                case 1
                    
                    syms t;
                    
                    neg_time = this.tm;
                    pos_time = this.td;
                    pressure = this.pmin;
                    
                    this.eq_p2 = - pressure * 6.75 * ...
                        ( (t - pos_time) / neg_time ) * ...
                        ( 1 - (t - pos_time) / neg_time )^2;
                    
            end
            
        end
        
    end
    
    %% Static Methods
    
    methods (Static)
        
        % =============================================================== %
        
        % Function about to calculate the positive pressure. S.I.: Pa
        function [pos] = Positive_Pressure(eq_p1, pos_time)
            
            syms t;
            pos = double(subs(eq_p1,t,pos_time));
            
        end
        
        % =============================================================== %
        
        % Function about to calculate the negative pressure. S.I.: Pa
        function [neg] = Negative_Pressure(eq_p2, neg_time)
            
            syms t;
            neg = double(subs(eq_p2,t,neg_time));
            
        end
         
        % =============================================================== %
        
        % Method to Newton Raphson
        
        % Function to calculate Newton Raphson method - To find in
        % MathWorks
        % https://la.mathworks.com/matlabcentral/fileexchange/68885-the-newton-raphson-method
        function newton = Newton_Raphson(func)
            
            % Author - Ambarish Prashant Chandurkar
            % The Newton Raphson Method
            
            syms aL
            f = func;                       % Enter the Function here
            g = diff(f);                    % The Derivative 
            n = 3;                          % The number of decimal places
            epsilon = 5*10^-(n+1);
            x0 = 0.8;                       % Enter the intial approximation
            
            for i = 1:100
                
                f0 = vpa(subs(f,aL,x0));     % Calculating the value of 
                                             % function at x0
                
                f0_der = vpa(subs(g,aL,x0)); % Calculating the value of 
                                             % function derivative at x0
                
                y = x0 - f0 / f0_der;        % The Formula
                
                err = abs(y-x0);
                
                if err<epsilon              % Checking the amount of error 
                                            % at each iteration
                    break
                end
                
                x0 = y;
                
            end
            
            y = y - rem(y,10^-n);           % Displaying upto required 
                                            % decimal places
            
            newton = y;                % The Root
            
        end
        
    end
    
end