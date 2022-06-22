classdef Class_Advanced
    
    % =================================================================== %
    % DESCRIPTION
    
    % This class presents another behavior of the plates. Seeing the
    % functions descriptions. All these function can be see in Reis [1].
    
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
    
    % CASES
    % Case 1 - Parameter Z is variating
    % Case 2 - Parameter W is variating
    % Case 3 - Parameter W is variating
    % Case 4 - Parameter Z is variating
    % Case 5 - Parameter Z is variating 
    % Case 6 - Parameter Z is variating
    % Case 7 - Parameter Z is variating
    
    % REFERENCES:
    % [1] Reis, A. W. Q. R. Análise dinâmica de placas considerando efeito
    % de membrana submetidas a carregamentos explosivos. Master's thesis.
    % (Master of Science in Civil Engineering) - Engineering Faculty, Rio
    % de Janeiro State University, Rio de Janeiro, 2019.
    % =================================================================== %
    
    %% Public attributes
    properties (SetAccess = public, GetAccess = public)
        
        tnt         Class_TNT              % TNT's properties
        plate       Class_Plate            % Plate's properties
        analysis    Class_Analysis         % Type Analysis propertie
        advanalysis Class_AdvAnalysis      % Advanced Analysis properties
        k1k3        Class_K1K3             % K1 K3 plate's properties
        period      Class_Period           % Plate period
        disp        Class_Disp             % Plate displacement
        prt         Class_Parameters       % Advanced Considerations
        
        value_adv       = [];
        matrix_adv      = [];
        matrix_DispW    = [];
        matrix_DAF      = [];
        p               = [];
        A               = [];
        B               = [];
        C               = [];
        D               = [];
        E               = [];
        F               = [];
        
    end
    
    %% Constructor Mode
    methods
        
        function this = Class_Advanced(tnt, plate, analysis, ...
                advanalysis, k1k3, disp, period, prt)
            
            if (nargin > 0)
                
                % Functions
                this = this.Advanced_Calculus(tnt, plate, analysis, ...
                    advanalysis, k1k3, disp, period, prt);
                
            end
            
        end
        
    end
    
    %% Public Methods
    methods
        
        function this = Advanced_Calculus(this, tnt, plate, analysis, ...
                advanalysis, k1k3, disp, period, prt)
            
            this.tnt            = tnt;
            this.plate          = plate;
            this.analysis       = analysis;
            this.advanalysis    = advanalysis;
            this.prt            = prt;
            this.k1k3           = k1k3;
            this.disp           = disp;
            this.period         = period;
            
            adv_parameter       = this.advanalysis.adv_parameter;
            h                   = this.plate.h;
            
            % ----------------------------------------------------------- %
            % ----------------------------------------------------------- %
            
            if adv_parameter == 1
                % Function to avaliate the behavior of displacement
                %(linear / nonlinear) for one case of W when Z is not constant
                
                Z = 5;
                W_initial = this.prt.W;
                % In this case not variate W
                W_final   = this.prt.W;
                % Considering the user's value
                nonlinear = this.prt.nonlinear;
                % Considering the user's value
                negative  = this.prt.negative;
                
                % ------------------------------------------------------- %
                
                % Initial parameters
                N = 32;                % Number of steps
                stepZ = (37 - Z) / N;   % Step Z
                
                % ------------------------------------------------------- %
                
                % Calculating the curve
                
                for i = 1 : N
                    
                    % Create a new object adv
                    adv = Class_AdvAnalysis(nonlinear, adv_parameter, ...
                        Z, W_initial, W_final, N, negative);
                    
                    % Create object to avaliate parameters
                    prt = Class_Parameters(tnt, analysis, adv);
                    
                    % Create object blast with characteristics about
                    % objects adv and prt
                    blast = Class_Blast(tnt, analysis, adv, prt);
                    
                    % Create object k1k3 with characteristics about
                    % objects adv and prt
                    k1k3 = Class_K1K3(plate, analysis, adv, prt);
                    
                    % Create object disp with characteristics about
                    % object adv and prt
                    disp = Class_Disp(tnt, plate, analysis, blast, k1k3, ...
                        adv, prt);
                    major = disp.major;
                    
                    this.matrix_adv(i,1) = Z;
                    this.matrix_adv(i,2) = major / h;
                    
                    % This case we do not use the value Z implemented by the
                    % user. We use a static initial value of Z and for each
                    % loop this value needs to change a step determinated by
                    % stepZ. So, in this case, we have to send a parameter to
                    % the system and its needs to interpretate that an advaced
                    % analysis. In this case, the parameter for this function
                    % is n = 1, i.e, the last parameter in Major_Value.
                    Z = Z + stepZ;
                    
                end
                
                % ------------------------------------------------------- %
                % ------------------------------------------------------- %
                
            elseif adv_parameter == 2
                
                % Function to avaliate the behavior of displacement
                % (linear / nonlinear) for one case of Z when W_TNT is not
                % constant
                
                Z			= this.prt.Z;
                W_final 	= this.advanalysis.W_final;
                N			= this.advanalysis.interval;
                
                % ------------------------------------------------------- %
                
                % Initializing parameters
                
                nonlinear       = 0;
                negative        = 0;
                adv_W_initial	= 0.1;
                W_step			= (W_final - adv_W_initial) / N;
                MOFF			= zeros(N, 2);
                MON				= zeros(N, 2);
                
                % ------------------------------------------------------- %
                
                % Looping for each case of nonlinearity and negative phase
                % Looping use i is about nonlinearity
                % Looping use j is about negative phase
                
                % Create a new object adv
                advOFF = Class_AdvAnalysis(nonlinear, adv_parameter, ...
                    Z, adv_W_initial, W_final, N, negative);
                
                for i = 0 : 1
                    
                    % Loop i = 0 is Nonlinearity OFF
                    % Loop i = 1 is Nonlinearity ON
                    
                    % Reset TNT's weigth
                    advOFF.W_initial = 0.1;
                    
                    for k = 1 : N
                        
                        % Create object to avaliate parameters
                        prt = Class_Parameters(tnt, analysis, advOFF);
                        
                        % Create object blast with characteristics about
                        % the object adv
                        blast = Class_Blast(tnt, analysis, advOFF, prt);
                        
                        % Create object k1k3 with characteristics about
                        % the object adv
                        k1k3 = Class_K1K3(plate, analysis, advOFF, prt);
                        
                        % Create object disp with characteristics about
                        % the object adv
                        disp = Class_Disp(tnt, plate, analysis, blast, ...
                            k1k3, advOFF, prt);
                        
                        % Instructions
                        % i = 0: Nonlinearity OFF and Negative Phase OFF
                        % i = 1: Nonlinearity ON and Negative Phase OFF
                        major = disp.major;
                        MOFF(k, i + 1) = major;
                        
                        % Atualizating in new constructor object
                        advOFF.W_initial = advOFF.W_initial + W_step;
                        
                    end
                    
                    % Modificating the value in constructor
                    advOFF.adv_nonlinear = advOFF.adv_nonlinear + 1;
                    
                end
                
                % ------------------------------------------------------- %
                
                % Initializing parameters
                
                nonlinear       = 0;
                negative        = 1;
                adv_W_initial	= 0.1;
                
                % ------------------------------------------------------- %
                
                % Looping for each case of nonlinearity and negative phase
                % Looping use i is about nonlinearity
                % Looping use j is about negative phase
                
                % Create a new object adv
                advON = Class_AdvAnalysis(nonlinear, adv_parameter, ...
                    Z, adv_W_initial, W_final, N, negative);
                
                for i = 0 : 1
                    
                    % Loop i = 0 is Nonlinearity OFF
                    % Loop i = 1 is Nonlinearity ON
                    
                    % Reset TNT's weigth
                    advON.W_initial = 0.1;
                    
                    for k = 1 : N
                        
                        % Create object to avaliate parameters
                        prt = Class_Parameters(tnt, analysis, advON);
                        
                        % Create object blast with characteristics about
                        % the object adv
                        blast = Class_Blast(tnt, analysis, advON, prt);
                        
                        % Create object k1k3 with characteristics about
                        % the object adv
                        k1k3 = Class_K1K3(plate, analysis, advON, prt);
                        
                        % Create object disp with characteristics about
                        % the object adv
                        disp = Class_Disp(tnt, plate, analysis, blast, ...
                            k1k3, advON, prt);
                        
                        % Instructions
                        % i = 0: Nonlinearity OFF and Negative Phase ON
                        % i = 1: Nonlinearity ON and Negative Phase ON
                        major = disp.major;
                        MON(k, i + 1) = major;
                        
                        % Atualizating in new constructor object
                        advON.W_initial = advON.W_initial + W_step;
                        
                    end
                    
                    % Modificating the value in constructor
                    advON.adv_nonlinear = advON.adv_nonlinear + 1;
                    
                end
                
                % Create a matrix with results
                
                W_initial = 0.1;
                
                for i = 1 : N
                    
                    this.matrix_adv(i,1) = W_initial;
                    % Negative phase is OFF
                    % Column 1: Nonlinearity is OFF
                    % Column 2: Nonlinearity is ON
                    this.matrix_adv(i,2) = MOFF(i,1) / MOFF(i,2);
                    % Negative phase is ON
                    % Column 1: Nonlinearity is OFF
                    % Column 2: Nonlinearity is ON
                    this.matrix_adv(i,3) = MON(i,1) / MON(i,2);
                    
                    W_initial = W_initial + W_step;
                    
                end
                
                % ------------------------------------------------------- %
                % ------------------------------------------------------- %
                
            elseif adv_parameter == 3
                
                % Calculating FAD - Variating W
                
                % Initial parameters
                
                Z               = this.prt.Z;
                N               = this.advanalysis.interval;
                adv_W_final     = this.advanalysis.W_final;
                nonlinear       = this.prt.nonlinear;
                negative        = this.prt.negative;
                                
                adv_W_initial   = 0.1;
                W_step          = (adv_W_final - adv_W_initial) / N;
                
                % ------------------------------------------------------- %
                
                % Linear Period
                
                TL = this.period.TL;
                
                % ------------------------------------------------------- %
                
                % Create a new object adv
                adv = Class_AdvAnalysis(nonlinear, adv_parameter, ...
                    Z, adv_W_initial, adv_W_final, N, negative);
                
                for i = 1 : N
                    
                    % Create object to avaliate parameters
                    prt = Class_Parameters(tnt, analysis, adv);
                    
                    % Create object blast with characteristics about
                    % the object adv
                    blast = Class_Blast(tnt, analysis, adv, prt);
                    td = blast.td;
                    
                    % Create object k1k3 with characteristics about
                    % the object adv
                    k1k3 = Class_K1K3(plate, analysis, adv, prt);
                    
                    % Create object disp with characteristics about
                    % the object adv
                    disp = Class_Disp(tnt, plate, analysis, ...
                        blast, k1k3, adv, prt);
                    major = disp.major;
                    
                    % Calculating the static displacement
                    static = Class_Static(tnt, plate, analysis, blast, k1k3);
                    stat = static.disp;
                    
                    % Completing matrix
                    this.matrix_adv(i,1) = td / TL;
                    this.matrix_adv(i,2) = major / stat;
                    
                    % Modificating constructor
                    adv.W_initial = adv.W_initial + W_step;
                    
                end
                
                % ------------------------------------------------------- %
                % ------------------------------------------------------- %
                
            elseif adv_parameter == 4
                
                % Calculating plaste's behavior of td / linear period
                
                Z = 5;
                W_initial = this.prt.W;
                % In this case not variate W
                W_final   = this.prt.W;
                % Considering the user's value
                nonlinear = this.prt.nonlinear;
                % Considering the user's value
                negative  = this.prt.negative;
                
                % ------------------------------------------------------- %
                
                % Initial parameters
                N = 100;                % Number of steps
                stepZ = (40 - Z) / N;   % Step Z
                
                % ------------------------------------------------------- %
                
                % Linear Period
                
                TL = this.period.TL;
                
                % ------------------------------------------------------- %
                
                % Calculating the curve
                
                for i = 1 : N
                    
                    % Create a new object adv
                    adv = Class_AdvAnalysis(nonlinear, adv_parameter, ...
                        Z, W_initial, W_final, N, negative);
                    
                    % Create object to avaliate parameters
                    prt = Class_Parameters(tnt, analysis, adv);
                    
                    % Create object blast with characteristics about
                    % objects adv and prt
                    blast   = Class_Blast(tnt, analysis, adv, prt);
                    td      = blast.td;
                    tm      = blast.tm;
                    total   = td + tm;
                    
                    % Create object k1k3 with characteristics about
                    % objects adv and prt
                    k1k3 = Class_K1K3(plate, analysis, adv, prt);
                    
                    % Create object disp with characteristics about
                    % object adv and prt
                    disp = Class_Disp(tnt, plate, analysis, blast, k1k3, ...
                        adv, prt);
                    major = disp.major;
                    
                    this.matrix_adv(i,1) = td / TL;
                    this.matrix_adv(i,2) = total / TL;
                    this.matrix_adv(i,3) = major / h;
                    
                    % This case we do not use the value Z implemented by the
                    % user. We use a static initial value of Z and for each
                    % loop this value needs to change a step determinated by
                    % stepZ. So, in this case, we have to send a parameter to
                    % the system and its needs to interpretate that an advaced
                    % analysis. In this case, the parameter for this function
                    % is n = 1, i.e, the last parameter in Major_Value.
                    Z = Z + stepZ;
                    
                end
                
                % ------------------------------------------------------- %
                % ------------------------------------------------------- %
                
            elseif adv_parameter == 5
                
                % Calculating plaste's behavior of td / nonlinear period
                
                Z         = 5;
                W_initial = this.prt.W;
                % In this case not variate W
                W_final   = this.prt.W;
                % Considering the user's value
                nonlinear = this.prt.nonlinear;
                % Considering the user's value
                negative  = this.prt.negative;
                
                % ------------------------------------------------------- %
                
                % Initial parameters
                N = 200;                % Number of steps
                stepZ = (40 - Z) / N;   % Step Z
                
                % Calculating the curve
                
                for i = 1 : N
                    
                    % Create a new object adv
                    adv = Class_AdvAnalysis(nonlinear, adv_parameter, ...
                        Z, W_initial, W_final, N, negative);
                    
                    % Create object to avaliate parameters
                    prt = Class_Parameters(tnt, analysis, adv);
                    
                    % Create object blast with characteristics about
                    % objects adv and prt
                    blast   = Class_Blast(tnt, analysis, adv, prt);
                    td      = blast.td;
                    tm      = blast.tm;
                    total   = td + tm;
                    
                    % Create object k1k3 with characteristics about
                    % objects adv and prt
                    k1k3 = Class_K1K3(plate, analysis, adv, prt);
                    
                    % Create object disp with characteristics about
                    % object adv and prt
                    disp = Class_Disp(tnt, plate, analysis, blast, k1k3, ...
                        adv, prt);
                    major = disp.major;
                    
                    % Create object period with characteristics about
                    % the object adv
                    period = Class_Period(tnt, plate, analysis, k1k3, ...
                        disp, prt);
                    TNL = period.TNL;
                    
                    this.matrix_adv(i,1) = td / TNL;
                    this.matrix_adv(i,2) = total / TNL;
                    this.matrix_adv(i,3) = TNL;
                    this.matrix_adv(i,4) = major / h;
                    
                    Z = Z + stepZ;
                    
                end
                
                % ------------------------------------------------------- %
                % ------------------------------------------------------- %
                               
            elseif adv_parameter == 6
                
                % Calculating plaste's stress behavior
                
                syms Y
                
                Z         = 5;
                W_initial = this.prt.W;
                % In this case not variate W
                W_final   = this.prt.W;
                % Considering the user's value
                nonlinear = this.prt.nonlinear;
                % Considering the user's value
                negative  = this.prt.negative;
                
                % ------------------------------------------------------- %
                
                % Initial parameters
                N = 100;                % Number of steps
                stepZ = (40 - Z) / N;   % Step Z
                
                % Calculating the curve
                
                for i = 1 : N
                    
                    % Create a new object adv
                    adv = Class_AdvAnalysis(nonlinear, adv_parameter, ...
                        Z, W_initial, W_final, N, negative);
                    
                    % Create object to avaliate parameters
                    prt = Class_Parameters(tnt, analysis, adv);
                    
                    % Create object k1k3 with characteristics about
                    % objects adv and prt
                    k1k3 = Class_K1K3(plate, analysis, adv, prt);
                    
                    % Create object stress with characteristics about
                    % the object adv
                    stress  = Class_Stress(plate, analysis, k1k3);
                    sr      = stress.sr; % Relation stress
                                        
                    sxx = double(subs(simplifyFraction(sr(1,1)), ...
                        Y, i));
                    syy = double(subs(simplifyFraction(sr(1,2)), ...
                        Y, i));
                    
                    this.matrix_adv(i,1) = Z;
                    this.matrix_adv(i,2) = double(sxx); % Stress in X axis
                    this.matrix_adv(i,3) = double(syy); % Stress in Y axis
                    this.matrix_adv(i,4) = i;
                    
                    % This case we do not use the value Z implemented by the
                    % user. We use a static initial value of Z and for each
                    % loop this value needs to change a step determinated by
                    % stepZ. So, in this case, we have to send a parameter to
                    % the system and its needs to interpretate that an advaced
                    % analysis. In this case, the parameter for this function
                    % is n = 1, i.e, the last parameter in Major_Value.
                    Z = Z + stepZ;
                    
                end
                
                % ------------------------------------------------------- %
                % ------------------------------------------------------- %
                
            elseif adv_parameter == 7
                
                % Calculating FAD - Variating Z
                
                % Initial parameters
                
                Z               = 5;
                W_initial       = this.prt.W;
                % In this case not variate W
                W_final         = this.prt.W;
                % Considering the user's value
                nonlinear       = this.prt.nonlinear;
                % Considering the user's value
                negative        = this.prt.negative;
                
                % ------------------------------------------------------- %
                
                % Initial parameters
                N = 100;                % Number of steps
                stepZ = (40 - Z) / N;   % Step Z
                
                % ------------------------------------------------------- %
                
                % Linear Period
                
                TL = this.period.TL;
                
                % ------------------------------------------------------- %
                
                for i = 1 : N
                    
                    % Create a new object adv
                    adv = Class_AdvAnalysis(nonlinear, adv_parameter, ...
                        Z, W_initial, W_final, N, negative);
                    
                    % Create object to avaliate parameters
                    prt = Class_Parameters(tnt, analysis, adv);
                    
                    % Create object blast with characteristics about
                    % the object adv
                    blast = Class_Blast(tnt, analysis, adv, prt);
                    td = blast.td;
                    
                    % Create object k1k3 with characteristics about
                    % the object adv
                    k1k3 = Class_K1K3(plate, analysis, adv, prt);
                    
                    % Create object disp with characteristics about
                    % the object adv
                    disp = Class_Disp(tnt, plate, analysis, ...
                        blast, k1k3, adv, prt);
                    major = disp.major;
                    
                    % Calculating the static displacement
                    static = Class_Static(tnt, plate, analysis, blast, k1k3);
                    stat = static.disp;
                    
                    % Completing matrix
                    this.matrix_adv(i,1) = td / TL;
                    this.matrix_adv(i,2) = major / stat;
                    
                    % Modificating constructor
                    Z = Z + stepZ;
                    
                end
                
                % ------------------------------------------------------- %
                % ------------------------------------------------------- %
                
            elseif adv_parameter == 8
                
                % Calculating general equation to the plate
                
                % Matrix about equation's coeffitients and TNT weight
                NW = 10;
                coef = zeros(7, NW);
                
                % Considering the user's value
                nonlinear       = this.prt.nonlinear;
                % Considering the user's value
                negative        = this.prt.negative;
                
                % In this case not variate W
                W_initial       = this.prt.W_initial;
                % In this case not variate W
                W_final         = this.prt.W_final;
                % Step W
                if W_initial == 1 && W_final == 10
                    stepW = 1;
                elseif W_initial == 100 && W_final == 1000
                    stepW = 100;
                end
                
                % ------------------------------------------------------- %
                
                for j = 1 : NW
                    
                    % Initial parameters
                    Z = 5;
                    % Initial parameters
                    N = 100;                % Number of steps
                    stepZ = (40 - Z) / N;   % Step Z
                    
                    % Calculating the curve
                    
                    for i = 1 : N
                        
                        % Create a new object adv
                        adv = Class_AdvAnalysis(nonlinear, adv_parameter, ...
                            Z, W_initial, W_final, N, negative);
                        
                        % Create object to avaliate parameters
                        prt = Class_Parameters(tnt, analysis, adv);
                        
                        % Create object blast with characteristics about
                        % objects adv and prt
                        blast = Class_Blast(tnt, analysis, adv, prt);
                        
                        % Create object k1k3 with characteristics about
                        % objects adv and prt
                        k1k3 = Class_K1K3(plate, analysis, adv, prt);
                        
                        % Create object disp with characteristics about
                        % object adv and prt
                        disp = Class_Disp(tnt, plate, analysis, blast, k1k3, ...
                            adv, prt);
                        major = disp.major;
                        
                        this.matrix_adv(i,1) = Z;
                        this.matrix_adv(i,j+1) = major / h;
                        
                        % This case we do not use the value Z implemented by the
                        % user. We use a static initial value of Z and for each
                        % loop this value needs to change a step determinated by
                        % stepZ. So, in this case, we have to send a parameter to
                        % the system and its needs to interpretate that an advaced
                        % analysis. In this case, the parameter for this function
                        % is n = 1, i.e, the last parameter in Major_Value.
                        Z = Z + stepZ;
                        
                    end
                    
                    % Create a polynomial function and determinate their
                    % coefficients
                    x_axis          = this.matrix_adv(:,1);
                    y_axis          = this.matrix_adv(:,j+1);
                    this.p          = polyfit(x_axis, y_axis, 5);
                    
                    % Completing all spaces in coef matrix
                    coef(1,j)   = this.p(1); % Coeff A of x^5
                    coef(2,j)   = this.p(2); % Coeff B of x^4
                    coef(3,j)   = this.p(3); % Coeff C of x^3
                    coef(4,j)   = this.p(4); % Coeff D of x^2
                    coef(5,j)   = this.p(5); % Coeff E of x^1
                    coef(6,j)   = this.p(6); % Coeff F of x^0
                    coef(7,j)   = W_initial; 
                    
                    W_initial = W_initial + stepW;
                    
                end
                
                % Create a polynomial function about coefficient's behavior 
                
                this.A = polyfit(coef(7,:), coef(1,:), 6);
                this.B = polyfit(coef(7,:), coef(2,:), 6);
                this.C = polyfit(coef(7,:), coef(3,:), 6);
                this.D = polyfit(coef(7,:), coef(4,:), 6); 
                this.E = polyfit(coef(7,:), coef(5,:), 6);
                this.F = polyfit(coef(7,:), coef(6,:), 6);
                
            end
            
        end
        
    end
    
end