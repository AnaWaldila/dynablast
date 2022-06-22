classdef Class_Result
    
    % =================================================================== %
    % DESCRIPTION
    
    % This class presents a matrix with displacement, stress, strain and
    % pressure per time.
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
    
    % REFERENCES:
    % [1] Reis, A. W. Q. R. Análise dinâmica de placas considerando efeito
    % de membrana submetidas a carregamentos explosivos. Master's thesis.
    % (Master of Science in Civil Engineering) - Engineering Faculty, Rio
    % de Janeiro State University, Rio de Janeiro, 2019.
    % =================================================================== %
    
    %% Public attributes
    properties (SetAccess = public, GetAccess = public)
        
        tnt         Class_TNT       % TNT's properties
        plate       Class_Plate     % Plate's properties
        analysis    Class_Analysis	% Type Analysis propertie
        blast       Class_Blast     % Blast's load parameters
        k1k3        Class_K1K3      % Plate's parameters
        disp        Class_Disp      % Structure's displacement
        strain      Class_Strain    % Structure's strain
        stress      Class_Stress    % Structure's stress
        ft          Class_FFT       % FFT Analysis
       
        table       = [];       % Matrix with results displacement, stress, 
                        % strain and pressure
        table_fft   = [];       % Matrix with FFT results
        
    end
    
    %% Constructor Mode
    methods
        
        function this = Class_Result(tnt, plate, analysis, blast, ...
                k1k3, disp, strain, stress, ft)
            
            if (nargin > 0)
                
                this = this.Result(tnt, plate, analysis, blast, ...
                    k1k3, disp, strain, stress, ft);
                
            end
            
        end
        
    end
    
    
    %% Public methods
    methods
       
        function this = Result...
                (this, tnt, plate, analysis, blast, k1k3, disp, ...
                strain, stress, ft)
            
            syms x y Y
            
            this.tnt      = tnt;
            this.plate    = plate;
            this.analysis = analysis;
            this.blast    = blast;
            this.k1k3     = k1k3;
            this.stress   = stress;
            this.strain   = strain;
            this.disp     = disp;
            this.ft       = ft;
            
            h             = this.plate.h;
            negative      = this.tnt.negative;
            td            = this.blast.td;
            eq_p1         = this.blast.eq_p1;
            eq_p2         = this.blast.eq_p2;
            tm            = this.blast.tm;      
            S             = this.disp.S;
                        
            % ----------------------------------------------------------- %
            
            % Solution of displacement (time historical)
            
            Amp = cat(2, S(:,1), S(:,2) / h);
            
            % ----------------------------------------------------------- %
            
            % Function to calculate the pressure (avaliating if exist or
            % not the negative phase)
            
            % Positive phase always exists
            pp = this.blast.Positive_Pressure...
                (eq_p1, S(S(:,1)<= td, 1));
            
            switch negative
                case 0
                    % Free Vibration
                    fv = double(zeros(size(S(S(:,1)> td, 1),1),1));
                    
                    % Concatenating the positive pressure with the free
                    % vibration
                    pressure = cat(1, pp, fv);
                    
                case 1
                    negative_time = S(S(:,1) <= td + tm, 1);
                    negative_time(negative_time <= td)=[];
                    
                    % Negative phase
                    np = this.blast.Negative_Pressure(eq_p2, negative_time);
                    
                    % Free Vibration
                    fv = double(zeros(size(S(S(:,1)> td + tm, 1),1),1));
                    
                    % Concatenating the positive pressure, negative pressure
                    % and free vibration
                    pressure = cat(1, pp, np, fv);
            end
            
            % ----------------------------------------------------------- %
            
            % Function to calculate the strain 
            
            ex = this.strain.et(1);
            ey = this.strain.et(2);
            
            strainxx = double(subs(ex, {x,y,Y},{0,0, Amp(:,2)}));
            strainyy = double(subs(ey, {x,y,Y},{0,0, Amp(:,2)}));
            
            % ----------------------------------------------------------- %
            
            % Function to calculate the stress
            
            sx = this.stress.st(1);
            sy = this.stress.st(2);
            
            stressxx = double(subs(sx, Y, Amp(:,2)));
            stressyy = double(subs(sy, Y, Amp(:,2)));
            
            % ----------------------------------------------------------- %
            
            % FFT analysis 
            
            fft_pressure = this.ft.table;
            
            % ----------------------------------------------------------- %
            
            % This array is composed by: time, displacement, strain xx,
            % strain yy, stress xx, stress yy and pressure
            
            
            this.table = cat(2, S(:,1), S(:,2), strainxx, strainyy, ...
                stressxx, stressyy, pressure);
            
            this.table_fft = fft_pressure;
            
        end
        
    end
    
end