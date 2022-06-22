classdef Class_FFT
    
    % =================================================================== %
    % DESCRIPTION
    
    % This class calculates the FFT process of the load
    % This calculus is only for general button.
    % All process can be see in Reis [1].
    
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
    
    % td: time of positive phase
    % dtp: time's step of positive phase
    % tp: time's vector of positive phase
    % eq_p1: symbolic equation of positive phase
    % cp: value of pressure in positive phase
    % tm: time of negative phase
    % dtm: time's step of negative phase
    % tn: time's vector of negative phase
    % eq_p2: symbolic equation of negative phase
    % cn: value of pressure in negative phase
    % dtf: time's step of free vibration
    % tr: tim's vector of free vibration
    % cr: value of pressure in free vibration
    % tt: total time vector
    % cr: pressure per time vector
    % TNL: plate's nonlinear period
    % wt: angular velocity
    % ft: frequency
    
    % REFERENCES:
    % [1] Reis, A. W. Q. R. Análise dinâmica de placas considerando efeito
    % de membrana submetidas a carregamentos explosivos. Master's thesis.
    % (Master of Science in Civil Engineering) - Engineering Faculty, Rio
    % de Janeiro State University, Rio de Janeiro, 2019.
    % =================================================================== %
    
    %% Public attributes
    properties (SetAccess = public, GetAccess = public)
        
        analysis    Class_Analysis          % Type Analysis propertie
        blast       Class_Blast             % Blast's load parameters
        disp        Class_Disp              % Structure's displacement
        period      Class_Period            % Structure's period
        prt         Class_Parameters        % Advanced Considerations
        
        table = [];     % Matrix with results displacement, stress,
        % strain and pressure
        harm  = [];     % Table nonlinear periods
        
    end
    
    %% Constructor Mode
    methods
        
        function this = Class_FFT(blast, disp, period, prt)
            if (nargin > 0)
                
                % Functions
                this = this.FFT(blast, disp, period, prt);
                
            end
            
        end
        
    end
    
    %% Public Methods
    methods
        
        function this = FFT(this, blast, disp, period, prt)
            
            syms t
            
            this.blast      = blast;
            this.disp       = disp;
            this.period     = period;
            this.prt        = prt;
                        
            % ----------------------------------------------------------- %
            
            % Function to positive phase (this phase always exists)
            
            dt          = 1e-6;
            td          = this.blast.td;
            tp          = 0:dt:td;
            
            eq_p1       = this.blast.eq_p1;
            cp          = double(subs(eq_p1, t, tp));
                        
            % ----------------------------------------------------------- %
            
            % Avaliating negative phase and free vibration
            
            negative    = this.prt.negative;
            
            switch negative
                
                case 0
                    
                    % Free Vibration
                    tr          = td:dt:10*td;
                    cr          = zeros(size(tr));
                    
                    % Total Time vector
                    tt          = [tp tr(2:end)];
                    
                    % Pressure vector
                    ct          = [cp cr(2:end)];
                    
                case 1
                    
                    % Negative phase
                    tm          = this.blast.tm;
                    tn          = td:dt:(td+tm);
                    
                    eq_p2       = this.blast.eq_p2;
                    cn          = double(subs(eq_p2, t, tn));
                    
                    % Free Vibration
                    tr          = (td+tm):dt:10*tm; 
                    cr          = zeros(size(tr));
                    
                    % Total Time vector
                    tt          = [tp tn(2:end) tr(2:end)];
                    
                    % Pressure vector
                    ct          = [cp cn(2:end) cr(2:end)];
                    
            end
            
            % ----------------------------------------------------------- %
            
            % Plate's nonlinear period
            
            TNL         = this.period.TNL;
                        
            % ----------------------------------------------------------- %
            
            % Calculating frequency
            [wt,ft]     = Class_FFT.frequency(tt,ct);
            wt          = transpose(wt);
            ft          = transpose(ft);
            
            % ----------------------------------------------------------- &
            
            % Complete table
            
            this.table = cat(2, 1./(wt), ft);
            
            this.harm  = [TNL 2*TNL 3*TNL 4*TNL];
            
        end
        
    end
    
    %% Static Methods
    
    methods (Static)
        
        function [w,f] = frequency(t,s)
            
            % Function returns signal's FFT of s(t). Returning a vector
            % f(w).
            
            dt = t(2)-t(1);
            fs = 1/dt;
            L = length(s);
            p = nextpow2(L);
            Y = fft(s,2^p);
            Y = Y(1:(2^p/2));
            f = abs(2*Y/L);
            w = fs.*(0:(2^p/2-1))./(2^p);
            
        end
        
    end
    
end