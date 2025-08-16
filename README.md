# Dynablast Version 1.0

## Introduction

DYNAblast is a software developed in MATLAB language, designed to obtain the behavior of a thin plate when it is subjected to blast load, considering the membrane effect. By evaluating this type of structure when subjected to explosive loads, the engineer can understand its behavior and design a structure that would be resistant to a possible collapse. Other applications correspond to military, aeronautics, marine, and platform structures, for which impact loads, such as explosions, are usually considered. Because of this, Dynablast was developed to facilitate the analysis of displacements, strain, stress, and frequency content in the midpoint of a given plate. Furthermore, parametric analyses are also possible, such as DAF (Dynamic Amplification Factor), variation of the TNT mass and scaled distance.

### News!
There is a new update! You can read more about [DYNAblast 2.0](https://github.com/AnaWaldila/dynablast2.0). This new update is about laminated composite plates subjected to blast loads!
Also, it is possible to read our publications on SoftwareX, for [SoftwareX - DYNAblast 1.1](https://www.sciencedirect.com/science/article/pii/S2352711024002243) and [SoftwareX - DYNAblast 2.0](https://www.sciencedirect.com/science/article/pii/S2352711025002328)

## Methodology

All explanations and methodology about blast wave (definitions and formulations), theory of thin plates, and the mathematical solution are available in Reis (2019) and Reis et al. (2022). Reis (2019) is a Master's thesis and this study covers the dynamic behavior in plates considering the membrane effect (i.e, nonlinearity), subjected to blast loads. The second one is an article published in the Latin American Journal of Solids and Structures. DYNAblast uses several theories of thin plates and blast wave formulations.

## Software

When executed, the software opens a window, as shown in Figure 1, with some input data about the structure and the loading. 

<div>
<img src="Figures/DYNA - 01.png" width="80%">
</div>
<p>
 <b>Figure 1:</b> DYNAblast - Input Data
</p>

<b>Input Data</b>
About the plate structure, some pieces of information are important:

PLATE

* Boundary conditions of the plate: simply supported or fully clamped;
* Boundary conditions of the membrane: immovable, movable, or stress-free;
* Length in x-axis (m);
* Rate <i>&beta;</i> between length in x-axis and y-axis;
* Thickness (m);
* Poisson's ratio;
* Young's Modulus (N/m²);
* Material density (kg/m³).

In addition, the user also needs to know the plate, in this software, is a linear elastic material. All methodology about the mechanic of structures (plates) is presented in Reis (2019) and Reis et al. (2022).

TNT
* Data Base: experimental data, Reis's calibration, or Rigby's calibration;
* Type of Explosion: Spherical or Hemispherical;
* Characteristics: total mass (kg), scalar distance (kg/m1/3), maximum overpressure (Pa), maximum underpressure (Pa), positive phase time (s), positive phase impulse (Pa.s), negative phase impulse (Pa.s). It is important to understand, based on which database is chosen by the user, some pieces of information about the blast wave's characteristics are not necessary.

In addition, about “Data Base”: if the user chooses the option “experimental data”, the labels “Total Mass (kg)” and “Scaled Distance Z (kg/m1/3)” are unable for edit, because the equation is based on the curve by Friendlader + Granstrom (see Rigby et al. (2013), Reis (2019), Reis et al (2022)). Naturally, if the user chooses Reis’s calibration and Rigby’s calibrations, other TNT characteristics are not editable, and “Total Mass (kg)” and “Scalar Distance Z (kg/m1/3)” are enabled.
Reis’s calibration and Rigby’s calibration are developed by Reis (2019) and Rigby et al. (2013), respectively, which is a characterization of all curves in the abacus presented in the US Department of Defense (2007).
Finally, the algorithm used in “Rigby’s calibration” is from Rigby and Tyas (2014). 

ANALYSIS
* Nonlinear Analysis: Yes or No. If the user chooses "No", the boundary condition of the membrane is not considered in the code;
* Negative Phase: Yes or No. If the user chooses "No", the negative phase of the blast load is not considered in the code;
* Time of Analysis: history time of the analysis. In this case, “Time of Analysis” needs to be bigger than the total time of the pressure, i.e., positive phase time + negative phase time (if exists). If the user chooses a time that is smaller than those two, the program will show a message with the total time of the load pressure;
* Advanced Analysis: In parametric analysis, the user can choose some cases to analyze in "Case of Analysis":
  1. “Case 1 – Z x uz/h”: Analysis of the behavior of uz/h in comparison to the variation of Z, where the main step in Z; 
  2. “Case 2 – W x uz/h”: Analysis of the behavior of uz/h in comparison to the variation of W, where the main step in W. In this case, the user needs to complete the “Final TNT’s mass (kg)” and the “Number of intervals”. Naturally, in this case, is looping and the TNT’s mass to start this is completed in “Total mass (kg)” (in characteristics, TNT);
  3. “Case 3 – td/TL x FAD – Variating W”: A specific case to analyze the behavior of uz / h when DAF (Dynamic Amplification Factor) is variating. The main step is in W. In this case, the user needs to complete the “Final TNT’s mass (kg)” and the “Number of intervals”. Naturally, in this case, is looping and the TNT’s mass to start this is completed in “Total mass (kg)” (in characteristics, TNT);
  4. “Case 4 – td / TL x uz / h”: A specific case to analyze the behavior of uz / h  when td / TL is variating. The main step is in Z;
  5. “Case 5 – td / TNL x uz / h”: A specific case to analyze the behavior of uz / h  when td / TNL is variating. The main step is in Z;
  6. “Case 6 – uz / h x stress”: A specific case to analyze the behavior of uz / h  when stress is variating. The main step is in Z;
  7. “Case 7 – td/TL x FAD – Variating Z”: A specific case to analyze the behavior of uz / h when DAF (Dynamic Amplification Factor) is variating. The main step is in Z;
  8. “Case 8 – General Equation”: A specific case to calculate the same graph of “Case 1”, but also show an equation that characterizes the structure, i.e., a relation of uz/h, Z, and W.

All cases are presented in Figure 2.

<div>
<img src="Figures/DYNA - 02.png" width="50%">
</div>
<p>
 <b>Figure 2:</b> DYNAblast - Input Data Cases of Analysis
</p>

BUTTONS
* Dynamic Analysis: In this case, output data presented are displacement, strain, and stress in the midpoint of the plate. The pressure of the loading and the Fast Fourier Transforms (FFT) are also calculated.
* Advanced Analysis: Parametric analysis is calculated and graphics are plotted based on the pieces of information of the "Advanced Analysis", in "Analysis". 

<b>Output Data</b>
After introducing all input data, as shown in Figure 1, the user can press the button “Dynamic Analysis” or “Advanced Analysis”. The first one opens a new window, as presented in Figure 3, with the output data, i.e., tables with all displacements, stress, and strain per time, pressure, and the FFT. Also, some parameters are presented: K1, K3, u<sub>z</sub> (m), maximum static displacement (m), linear period - T<sub>L</sub> (s), nonlinear period - T<sub>NL</sub> (s), T<sub>NL</sub> / (T<sub>L</sub> + T<sub>NL</sub>), t<sub>d</sub> (s), t<sub>m</sub> (s), p<sub>max</sub> (Pa), p<sub>min</sub> (Pa), i<sub>d</sub> (Pa.m), i<sub>m</sub> (Pa.m), decay coefficient. Some of those graphics are shown in Figure 4.

<div>
<img src="Figures/DYNA - 03.png" width="80%">
</div>
<p>
 <b>Figure 3:</b> DYNAblast - Results
</p>

<div>
<img src="Figures/DYNA - 04.png" width="80%">
</div>
<p>
 <b>Figure 4:</b> DYNAblast - Graphic Results
</p>

Clicking on the "Advanced Analysis" button, based on which case the user chose, as shown in Figure 2, one curve is plotted. Next, Figure 5 to 11 present the graphics of parametric analysis based on the input data presented in Figure 1.

<div>
<img src="Figures/DYNA - 05.png" width="50%">
</div>
<p>
 <b>Figure 5:</b> DYNAblast - Advanced Analysis. Case 1: Z x u<sub>z</sub> / h
</p>

<div>
<img src="Figures/DYNA - 06.png" width="50%">
</div>
<p>
 <b>Figure 6:</b> DYNAblast - Advanced Analysis. Case 2: W<sub>TNT</sub> x u<sub>L</sub> / u<sub>z</sub>
</p>

<div>
<img src="Figures/DYNA - 07.png" width="50%">
</div>
<p>
 <b>Figure 7:</b> DYNAblast - Advanced Analysis. Case 3: t<sub>d</sub> / T<sub>L</sub> x DAF
</p>

<div>
<img src="Figures/DYNA - 08.png" width="50%">
</div>
<p>
 <b>Figure 8:</b> DYNAblast - Advanced Analysis. Case 4: t<sub>d</sub> / T<sub>L</sub> x u<sub>z</sub> / h
</p>

<div>
<img src="Figures/DYNA - 09.png" width="50%">
</div>
<p>
 <b>Figure 9:</b> DYNAblast - Advanced Analysis. Case 5: t<sub>d</sub> / T<sub>NL</sub> x u<sub>z</sub> / h
</p>

<div>
<img src="Figures/DYNA - 10.png" width="50%">
</div>
<p>
 <b>Figure 10:</b> DYNAblast - Advanced Analysis. Case 6: u<sub>z</sub> / h x &sigma;<sub>m</sub> / (&sigma;<sub>m</sub> + &sigma;<sub>b</sub>)
</p>

<div>
<img src="Figures/DYNA - 11.png" width="50%">
</div>
<p>
 <b>Figure 11:</b> DYNAblast - Advanced Analysis. Case 7: t<sub>d</sub> / T<sub>NL</sub> x DAF
</p>

All these examples considered the membrane’s boundary condition as immovable. The users can generate their own analysis with another type of boundary condition.

<b>Files</b>

All those pieces of information can be imported or exported to Excel or .txt file. Figure 1 shows, on the left top, a menu button called “File” which enables to save a new or import a txt file. The users can create a txt file with their own pieces of information about the plate, blast wave, and analysis. For this case, there is an order to follow:
1.	Plate boundary condition (1 for simple supported or 2 for fully clamped);
2.	Membrane boundary condition (1 for immovable, 2 for movable, and 3 for stress-free);
3.	Length in x-axis (m);
4.	<i>&beta;</i>;
5.	Thickness (m);
6.	Poisson’s ratio;
7.	Young’s Modulus E (N/m²);
8.	Material density (kg/m³);
9.	Total Mass (kg);
10.	Scaled Distance Z (kg/m^1/3);
11.	Type of explosion (1 for Hemispherical and 2 for Spherical)
12.	Data type (2 for “Abaco - Rigby Calibration”, 3 for “Abaco - Ana Calibration” and 4 for “Experimental Data”)
13.	Max Overpressure (Pa);
14.	Max Underpressure (Pa);
15.	Positive time (s);
16.	Positive impulse (Pa.s);
17.	Negative impulse (Pa.s);
18.	Nonlinear analyses (1 for yes and 2 for no);
19.	Negative phase (1 for yes and 2 for no);
20.	Time of analysis.

It is possible to observe all those pieces of information in Figure 12.

<div>
<img src="Figures/DYNA - 12.png" width="20%">
</div>
<p>
 <b>Figure 12:</b> DYNAblast - .txt file
</p>

For the graphics presented in Figures 3 to 11, it is possible to click the button on the top-left called “Save” and, naturally, save all output data in Excel.

<b>About</b>
This software was developed by Ana W. Q. R. Reis and with the supervision of Rodrigo B. Burgos and Maria F. F. Oliveira, at Rio de Janeiro State University, as shown in Figure 13.

<div>
<img src="Figures/DYNA - 13.png" width="50%">
</div>
<p>
 <b>Figure 13:</b> DYNAblast - About the software
</p>

## References

Friedlander, F.G. The diffraction of sound pulses I. Diffraction by a semi-infinite plane. Communicated by G. I. Taylor, F.R.S., 1940.

Granström, S.A. Loading characteristics of fair blasts from detonating charges. Technical Report 100, Transactions of the Royal Institute of Technology, Stockholm, 1956

Reis, A.W.Q.R. Dynamic analysis of plates subjected to blast load. M. Sc. Dissertation (in Portuguese), Rio de Janeiro State University, Brazil, 2019.

Reis, A.W.Q.R., Burgos, R.B., Oliveira, M.F.F. Nonlinear Dynamic Analysis of Plates Subjected to Explosive Loads. Latin American Journal of Solids and Structures, v. 19, 2022.

Rigby, S.E. and Tyas, A. (2014) Blast.m. CMD Group, University of Sheffield.

Rigby, S. E., Andrew, T., Bennett, T., Clarke, S. D., Fay, S. D. The Negative Phase of the Blast Load. International Journal of Protective Structures 5(1):1-19, 2013.


## Information about the Software

Rio de Janeiro State University

Faculty of Engineering

Developer: Ana Waldila de Queiroz Ramiro Reis

Professors: Rodrigo Bird Burgos and Maria Fernanda Figueiredo de Oliveira

Contact: anawaldila@hotmail.com

