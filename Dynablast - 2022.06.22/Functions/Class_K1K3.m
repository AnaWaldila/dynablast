classdef Class_K1K3
    
    % =================================================================== %
    % DESCRIPTION
    
    % This class calculate analysiss about the blast load. Here are
    % calculating these analysiss: linear cofficient (K1), nonlinear
    % coefficient (K3) and Airy's function. In this case, only plate's
    % characteristics are considering.
    % The concept of K1 and K3 was developed by Yamaki [3] for calculating
    % Duffint Differential Equation. Also that, was presented by Feldgun
    % [1], when its needs to calculating a differential equation with
    % external load in structure. In this case, the positive phase
    % equation. Finally, Reis [2] presented the study with this
    % differential equation considering the negative phase.
    
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
    % time: time of analisys (s)
    % nonlinear: nonlinear effect (0 for not and 1 for yes)
    
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
        
        plate           Class_Plate            % Plate's properties
        analysis        Class_Analysis         % Type Analysis propertie
        advanalysis     Class_AdvAnalysis      % Type of Advanced Analysis
        prt             Class_Parameters       % Advanced Considerations
        
        D           = 0;    % Flexural stiffness
        px          = 0;    % analysis px
        py          = 0;    % analysis py
        matriz_fi   = [];   % Matrix fi (Yamaki, 1969)
        fiL         = 0;    % Expression by Yamaki (1969)
        k1          = 0;    % Value about plate's linear behavior
        k3          = 0;    % Value about plate's nonlinear behavior
        airy        = 0;    % Value about Airy's function
        
    end
    
    %% Constructor Mode
    methods
        
        function this = Class_K1K3(plate, analysis, advanalysis, prt)
            if (nargin > 0)
                
                % Functions
                this = this.Flexural_Stiffness(plate);
                this = this.PX(plate, analysis, advanalysis, prt);
                this = this.PY(plate, analysis, advanalysis, prt);
                this = this.Matrix_fi(plate, analysis, advanalysis, prt);
                this = this.Fi_linha(plate, analysis, advanalysis, prt);
                this = this.K1(plate);
                this = this.K3(plate, analysis, advanalysis, prt);
                this = this.Airy(plate, analysis, advanalysis, prt);
                
            else
                this.plate = Class_Plate();   % Empty constructor
            end
            
        end
        
    end
    
    %% Public Methods
    methods
        
        % =============================================================== %
        
        % Function to calculate the flexural stiffness. S.I.: Pa.m
        function this = Flexural_Stiffness(this, plate)
            
            this.plate = plate;
            
            E          = this.plate.E;
            h          = this.plate.h;
            nu         = this.plate.nu;
            
            this.D = E * h^3 / 12 / (1 - nu^2);
            
        end
        
        % =============================================================== %
        
        % Function to calculate analysiss px and py
        function this = PX(this, plate, analysis, advanalysis, prt)
            
            this.plate          = plate;
            this.analysis       = analysis;
            this.advanalysis    = advanalysis;
            this.prt            = prt;
            
            a                   = this.plate.a;
            beta                = this.plate.beta;
            h                   = this.plate.h;
            E                   = this.plate.E;
            nu                  = this.plate.nu;
            sup                 = this.plate.sup;
            nonlinear           = this.prt.nonlinear;
                        
            switch nonlinear
                case 0
                    this.px = 0;
                case 1
                    switch sup
                        case 0
                            coef = 1/8;
                        case 1
                            coef = 3/32;
                    end
                    this.px = coef * (pi^2 * E * h^2) * ...
                        (1 + nu * beta^2) / a^2 / (1 - nu^2);
            end
                
        end
        
        % =============================================================== %
        
        % Function to calculate analysiss px and py
        function this = PY(this, plate, analysis, advanalysis, prt)
            
            this.plate          = plate;
            this.analysis       = analysis;
            this.advanalysis    = advanalysis;
            this.prt            = prt;
            
            a                   = this.plate.a;
            beta                = this.plate.beta;
            h                   = this.plate.h;
            E                   = this.plate.E;
            nu                  = this.plate.nu;
            sup                 = this.plate.sup;
            nonlinear           = this.prt.nonlinear;
                        
            switch nonlinear
                case 0
                    this.py = 0;
                case 1
                    switch sup
                        case 0
                            coef = 1/8;
                        case 1
                            coef = 3/32;
                    end
                    
                    this.py = coef * (pi^2 * E * h^2) * ...
                        (nu + beta^2) / a^2 / (1 - nu^2);
            end
                        
        end
        
        % =============================================================== %
        
        % Function to calculate matrix fi
        function this = Matrix_fi(this, plate, analysis, advanalysis, prt)
            
            this.plate          = plate;
            this.analysis       = analysis;
            this.advanalysis    = advanalysis;
            this.prt            = prt;
            
            beta                = this.plate.beta;
            sup                 = this.plate.sup;
            nonlinear           = this.prt.nonlinear;
                             
            this.matriz_fi = 0;
            
            if nonlinear == 1
                
                switch sup
                    
                    case 0
                        
                        this.matriz_fi = zeros(2,2);
                        this.matriz_fi(1,2) = -1 / 32 / beta^2;
                        this.matriz_fi(2,1) = -beta^2 / 32;
                        
                    case 1
                        
                        this.matriz_fi = zeros(3,3);
                        this.matriz_fi(1,2) = -1 / 32 / beta^2;
                        this.matriz_fi(1,3) = -1 / 512 / beta^2;
                        this.matriz_fi(2,1) = -beta^2 / 32;
                        this.matriz_fi(2,2) = -beta^2 / 16 / (beta^2 + 1)^2;
                        this.matriz_fi(2,3) = -beta^2 / 32 / ...
                            (4 * beta^2 + 1)^2;
                        this.matriz_fi(3,1) = -beta^2 / 512;
                        this.matriz_fi(3,2) = -beta^2 / 32 / (beta^2 + 4)^2;
                        
                end
                
            end
            
        end
        
        % =============================================================== %
        
        % Function to calculate fi'
        function this = Fi_linha(this, plate, analysis, advanalysis, prt)
            
            this.plate          = plate;
            this.analysis       = analysis;
            this.advanalysis    = advanalysis;
            this.prt            = prt;
            
            beta                = this.plate.beta;
            type_sup            = this.plate.type_sup;
            nonlinear           = this.prt.nonlinear;
                                    
            if nonlinear == 1 && type_sup == 3
                
                syms p q epsilon_q epsilon_p A_p B_q gama
                
                func(gama) = (sinh(gama)).^2 / (sinh(gama) .* ...
                    cosh(gama) + gama);
                
                this.fiL = (4 .* beta ./ pi ./ ...
                    (p.^2 + beta.^2 * q.^2).^2) .* ...
                    (p .* (-1).^q * epsilon_q .* A_p .* ...
                    func(p .* pi ./ beta) + q .* (-1).^p .* ...
                    epsilon_p .* B_q .* func(q .* pi .* beta));
                
            else
                this.fiL = 0;
            end
            
        end
        
        % =============================================================== %
        
        % Function to calculate plate's linear behavior: K1
        function this = K1(this, plate)
            
            this.plate = plate;
            
            a          = this.plate.a;
            beta       = this.plate.beta;
            h          = this.plate.h;
            rho        = this.plate.rho;
            sup        = this.plate.sup;
            
            switch sup
                case 0
                    this.k1 = pi^4 * this.D * ...
                        h * (1 + beta^2)^2 / a^4 / rho / h^2;
                case 1
                    this.k1 = 16 * pi^4 * this.D...
                        * h * (3 + 2 * beta^2 + 3 * beta^4) / 9 / a^4 / ...
                        rho / h^2;
            end
            
        end
        
        % =============================================================== %
        
        % Function to calculate plate's nonlinear behavior: K3
        function this = K3(this, plate, analysis, advanalysis, prt)
            
            syms Amp y x 
            
            this.plate          = plate;
            this.analysis       = analysis;
            this.advanalysis    = advanalysis;
            this.prt            = prt;
            
            sup             = this.plate.sup;
            type_sup        = this.plate.type_sup;
            a               = this.plate.a;
            beta            = this.plate.beta;
            h               = this.plate.h;
            E               = this.plate.E;
            rho             = this.plate.rho;
            nonlinear       = this.prt.nonlinear;
                       
            % Default K3 = 0 (in this case the analysis nonlinear is 0)
            
            this.k3 = 0;
            
            % ----------------------------------------------------------- %
            
            % Avaliating: Nonlinear behavior "on" and Support is Simple
            if (nonlinear == 1 && sup == 0 )
                
                switch type_sup
                    
                    case 1 % ------------------- Type of Support: Immovable
                        
                        this.k3 = (pi^2 * h^2 * (this.px + ...
                            beta^2 * this.py) / a^2 / rho / h^2)...
                            - 2 * pi^4 * E * h^4 * ...
                            (this.matriz_fi(1,2) + this.matriz_fi(2,1)) ...
                            / a^2 / (a / beta)^2 / rho / h^2;
                        
                    case 2 % --------------------- Type of Support: Movable
                        
                        this.k3 = - 2 * pi^4 * E * h^4 * ...
                            (this.matriz_fi(1,2) + this.matriz_fi(2,1)) ...
                            / a^2 / (a / beta)^2 / rho / h^2;
                        
                    case 3 % ----------------- Type of Support: Stress Free
                        
                        syms p q epsilon_p epsilon_q
                        syms Ap1 Bq1 Ap2 Bq2 A_p B_q
                        
                        fK3 = 0;
                        
                        for i = 0: 1
                            
                            for j = 0: 1
                                
                                if (i == 0 && j > 0)
                                    
                                    fK3 = fK3 + subs(limit(this.fiL,p,0) + ...
                                        this.matriz_fi(1,2), ...
                                        [p, q, epsilon_p, ...
                                        epsilon_q, A_p, B_q], ...
                                        [i, j, 0.5, 1, Ap1, Bq1] );
                                    
                                elseif (i > 0 && j == 0)
                                    
                                    fK3 = fK3 + subs(limit(this.fiL,q,0) + ...
                                        this.matriz_fi(2,1), ...
                                        [p, q, epsilon_p, ...
                                        epsilon_q, A_p, B_q], ...
                                        [i, j, 1, 0.5, Ap1, Bq1] );
                                    
                                else
                                    
                                    fK3 = fK3 + 0;
                                    
                                end
                                
                            end
                            
                        end
                        
                        [A,B] = Class_AB.Coeficients_AB(beta, 5, sup);
                        
                        this.k3 = - 2 * pi^4 * E * h^4 * ...
                            subs(fK3, {Ap1,Bq1},{A(1),B(1)}) ...
                            / a^2 / (a / beta)^2 / rho / h^2;
                        
                end
                
                % Avaliating: Nonlinear behavior "on" and Support is Campled
            elseif (nonlinear == 1 && sup == 1)
                
                switch type_sup
                    
                    case 1 % ------------------- Type of Support: Immovable
                        
                        eq = (this.matriz_fi(1,2) + this.matriz_fi(2,1) + ...
                            this.matriz_fi(2,2) + ...
                            (1/2) * this.matriz_fi(2,3) + ...
                            (1/2) * this.matriz_fi(3,2) ...
                            + this.matriz_fi(1,3) + this.matriz_fi(3,1));
                        
                        this.k3 = (4 * pi^2 * h^2 * ...
                            (this.px + beta^2 * this.py)...
                            / 3 / a^2 / rho / h^2) - ...
                            32 * pi^4 * E * h^4 * eq ...
                            / 9 / a^2 / (a / beta)^2 / rho / h^2;
                        
                    case 2 % --------------------- Type of Support: Movable
                        
                        eq = (this.matriz_fi(1,2) + this.matriz_fi(2,1) + ...
                            this.matriz_fi(2,2) + ...
                            (1/2) * this.matriz_fi(2,3) + ...
                            (1/2) * this.matriz_fi(3,2) ...
                            + this.matriz_fi(1,3) + this.matriz_fi(3,1));
                        
                        this.k3 = - 32 * pi^4 * E * h^4 * eq ...
                             / 9 / a^2 / (a / beta)^2 / rho / h^2;
                        
                    case 3 % ----------------- Type of Support: Stress Free
                        
                        syms p q epsilon_p epsilon_q
                        syms Ap1 Bq1 Ap2 Bq2 A_p B_q
                        
                        fK3 = 0;
                        
                        for i = 0: 2
                            
                            for j = 0: 2
                                
                                if (i == 0 && j == 0)
                                    
                                    fK3 = fK3 + 0;
                                    
                                elseif (i == 0 && j > 0)
                                    
                                    fK3 = fK3 + subs(limit(this.fiL,p,0) + ...
                                        this.matriz_fi(i + 1,j + 1),...
                                        [p, q, epsilon_p, epsilon_q], ...
                                        [i, j, 0.5, 1] );
                                    
                                    switch j
                                        case 1
                                            fK3 = subs(fK3, B_q, Bq1);
                                        case 2
                                            fK3 = subs(fK3, B_q, Bq2);
                                    end
                                    
                                elseif (i > 0 && j == 0)
                                    
                                    fK3 = fK3 + subs(limit(this.fiL,q,0) + ...
                                        this.matriz_fi(i + 1,j + 1),...
                                        [p, q, epsilon_p, epsilon_q], ...
                                        [i, j, 1, 0.5] );
                                    
                                    switch i
                                        case 1
                                            fK3 = subs(fK3, A_p, Ap1);
                                        case 2
                                            fK3 = subs(fK3, A_p, Ap2);
                                    end
                                    
                                elseif (i > 0 && j > 0)
                                    
                                    if (i == 1 && j == 2) || ...
                                            (i == 2 && j == 1)
                                        
                                        fK3 = fK3 + (1/2) * ...
                                            subs(this.fiL + ...
                                            this.matriz_fi(i + 1,j + 1),...
                                            [p, q, epsilon_p, epsilon_q],...
                                            [i, j, 1, 1] );
                                        
                                    elseif (i == 2 && j == 2)
                                        
                                        fK3 = fK3 + 0;
                                        
                                    else
                                        
                                        fK3 = fK3 + subs(this.fiL + ...
                                            this.matriz_fi(i + 1,j + 1),...
                                            [p, q, epsilon_p, epsilon_q],...
                                            [i, j, 1, 1] );
                                        
                                    end
                                    
                                    switch i
                                        case 1
                                            fK3 = subs(fK3, A_p, Ap1);
                                        case 2
                                            fK3 = subs(fK3, A_p, Ap2);
                                    end
                                    
                                    switch j
                                        case 1
                                            fK3 = subs(fK3, B_q, Bq1);
                                        case 2
                                            fK3 = subs(fK3, B_q, Bq2);
                                    end
                                    
                                end
                                
                            end
                            
                        end
                        
                        [A,B] = Class_AB.Coeficients_AB(beta, 5, sup);
                        
                        this.k3 = -32 * pi^4 * E * h^4 * ...
                            subs(fK3, {Ap1,Bq1,Ap2,Bq2},...
                            {A(1),B(1),A(2),B(2)})...
                            / a^2 / (a / beta)^2 / rho / h^2 / 9;
                        
                end
                
            end
            
        end
        
        % =============================================================== %
        
        % Function to calculate Airy's function
        function this = Airy(this, plate, analysis, advanalysis, prt)
            
            syms y x Y 
                        
            this.plate          = plate;
            this.analysis       = analysis;
            this.advanalysis    = advanalysis;
            this.prt            = prt;
            
            sup             = this.plate.sup;
            type_sup        = this.plate.type_sup;
            a               = this.plate.a;
            beta            = this.plate.beta;
            h               = this.plate.h;
            E               = this.plate.E;
            nonlinear       = this.prt.nonlinear;
            
            b = a / beta;
                        
            Amp = Y;              % Yamaki's Equation
            
            % ----------------------------------------------------------- %
            
            % Default Airy = 0 (in this case the analysis nonlinear is 0)
            
            this.airy = 0;
            
            % ----------------------------------------------------------- %
            
            if (nonlinear == 1 && sup == 0 )
                
                % Avaliating: Nonlinear behavior "on" and Support is Simple
                
                switch type_sup
                    
                    case 1 % ------------------- Type of Support: Immovable
                        
                        this.airy = (Amp).^2 * ((1/2).* this.px ...
                            .* y.^2 + (1/2) .* this.py .* x.^2);
                        
                        for i = 0 : 1
                            for j = 0 : 1
                                this.airy = this.airy + ...
                                    E .* h.^2 * (Amp)^2 * ...
                                    cos(2 .* pi .* i .* x ./ a) .* ...
                                    cos(2 .* pi .* j .* y ./ (a / beta))...
                                    .* this.matriz_fi(i+1,j+1);
                            end
                        end
                        
                    case 2 % --------------------- Type of Support: Movable
                        
                        this.airy = 0;
                        
                        for i = 0 : 1
                            for j = 0 : 1
                                this.airy = this.airy + ...
                                    E .* h.^2 .* (Amp).^2 * ...
                                    cos(2 .* pi .* i .* x ./ a) .* ...
                                    cos(2 .* pi .* j .* y ./ b) .* ...
                                    this.matriz_fi(i+1,j+1);
                            end
                        end
                        
                    case 3 % ----------------- Type of Support: Stress Free
                        
                        syms Ap1 Bq1 Ap2 Bq2 A_p B_q
                        syms p q epsilon_q epsilon_p
                        
                        fAiry = 0;
                        
                        for i = 0: 1
                            
                            for j = 0: 1
                                
                                if (i == 0 && j > 0)
                                    
                                    fAiry =  fAiry + ...
                                        subs( ( limit(this.fiL,p,0) + ...
                                        this.matriz_fi(i + 1, j + 1) ) .* ...
                                        cos(2 .* pi .* p .* x ./ a) .* ...
                                        cos(2 .* pi .* q .* y ./ b) , ...
                                        [p, q, epsilon_p, epsilon_q, ...
                                        A_p, B_q], [i, j, 0.5, 1, Ap1, Bq1]);
                                    
                                elseif (i > 0 && j == 0)
                                    
                                    fAiry =  fAiry + ...
                                        subs( ( limit(this.fiL,q,0) + ...
                                        this.matriz_fi(i + 1, j + 1) ) .* ...
                                        cos(2 .* pi .* p .* x ./ a) .* ...
                                        cos(2 .* pi .* q .* y ./ b), ...
                                        [p, q, epsilon_p, epsilon_q, ...
                                        A_p, B_q], [i, j, 1, 0.5, Ap1, Bq1]);
                                    
                                end
                                
                            end
                            
                        end
                        
                        [A,B] = Class_AB.Coeficients_AB(beta, 5, sup);
                        
                        this.airy = E .* h.^2 .* (Amp).^2 .* ...
                            subs(fAiry, {Ap1,Bq1},{A(1),B(1)});
                        
                end
                
            elseif (nonlinear == 1 && sup == 1)
                
                % Avaliating: Nonlinear behavior "on" and Support is Campled
                
                switch type_sup
                    
                    case 1 % ------------------- Type of Support: Immovable
                        
                        this.airy = (Amp).^2 .* ((1/2).* ...
                            this.px .* y.^2 + (1./2) .* this.py .* x.^2);
                        
                        for i = 0 : 2
                            for j = 0 : 2
                                this.airy = this.airy + ...
                                    E .* h.^2 .* (Amp).^2 .* ...
                                    cos(2 .* pi .* i .* x ./ a) .* ...
                                    cos(2 .* pi .* j .* y ./ (a / beta))...
                                    .* this.matriz_fi(i+1,j+1);
                            end
                        end
                        
                    case 2 % --------------------- Type of Support: Movable
                        
                        this.airy = 0;
                        
                        for i = 0 : 2
                            for j = 0 : 2
                                this.airy = this.airy + ...
                                    E .* h.^2 .* (Amp).^2 .* ...
                                    cos(2 .* pi .* i .* x ./ a) .* ...
                                    cos(2 .* pi .* j .* y ./ (a / beta))...
                                    .* this.matriz_fi(i+1,j+1);
                            end
                        end
                        
                    case 3 % ----------------- Type of Support: Stress Free
                        
                        syms p q epsilon_p epsilon_q
                        syms Ap1 Bq1 Ap2 Bq2 A_p B_q
                        
                        fAiry = 0;
                        
                        for i = 0: 2
                            
                            for j = 0: 2
                                
                                if (i == 0 && j == 0)
                                    
                                    fAiry = fAiry + 0;
                                    
                                elseif (i == 0 && j > 0)
                                    
                                    fAiry =  fAiry + ...
                                        subs( ( limit(this.fiL,p,0) + ...
                                        this.matriz_fi(i + 1,j + 1) ) .* ...
                                        cos(2 .* pi .* p .* x ./ a) .* ...
                                        cos(2 .* pi .* q .* y ./ (a / beta)) , ...
                                        [p, q, epsilon_p, epsilon_q], ...
                                        [i, j, 0.5, 1] );
                                    
                                    switch j
                                        case 1
                                            fAiry = subs(fAiry, B_q, Bq1);
                                        case 2
                                            fAiry = subs(fAiry, B_q, Bq2);
                                    end
                                    
                                elseif (i > 0 && j == 0)
                                    
                                    fAiry =  fAiry + ...
                                        subs( ( limit(this.fiL,q,0) + ...
                                        this.matriz_fi(i + 1,j + 1) ) .* ...
                                        cos(2 .* pi .* p .* x ./ a) .* ...
                                        cos(2 .* pi .* q .* y / (a / beta)), ...
                                        [p, q, epsilon_p, epsilon_q], ...
                                        [i, j, 1, 0.5] );
                                    
                                    switch i
                                        case 1
                                            fAiry = subs(fAiry, A_p, Ap1);
                                        case 2
                                            fAiry = subs(fAiry, A_p, Ap2);
                                    end
                                    
                                elseif (i > 0 && j > 0)
                                    
                                    if (i == 2 && j == 2)
                                        fAiry = fAiry + 0;
                                    else
                                        fAiry =  fAiry + ...
                                            subs( ( this.fiL + ...
                                            this.matriz_fi(i + 1,j + 1) ) .* ...
                                            cos(2 .* pi .* p .* x ./ a)...
                                            .* cos(2 .* pi .* q .* y ./ (a / beta)), ...
                                            [p, q, epsilon_p, epsilon_q], ...
                                            [i, j, 1, 1] );
                                    end
                                    
                                    switch i
                                        case 1
                                            fAiry = subs(fAiry, A_p, Ap1);
                                        case 2
                                            fAiry = subs(fAiry, A_p, Ap2);
                                    end
                                    
                                    switch j
                                        case 1
                                            fAiry = subs(fAiry, B_q, Bq1);
                                        case 2
                                            fAiry = subs(fAiry, B_q, Bq2);
                                    end
                                    
                                end
                                
                            end
                            
                        end
                        
                        [A,B] = Class_AB.Coeficients_AB(beta, 5, sup);
                        
                        this.airy = E .* h.^2 .* (Amp).^2 .* ...
                            subs(fAiry, {Ap1,Bq1,Ap2,Bq2},...
                            {A(1),B(1),A(2),B(2)});
                        
                end
                
            end
            
        end
        
    end
    
end
