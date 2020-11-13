# Dynablast Version 1.0

## Introduction

Dynablast, Dynamic Analysis of Plates Submitted to Blast Load,  is a software developed in computational language MATLAB. The program can calculates the plate's behavior when it is submitted to blast load, considered tha membrane effect. Avaliating the structure when is submitted a explosion will be possible the engineer to protect this structure to possible colapse. Another applications is in military structures, aeronautic and platforms structures, where solicitations like explosion are a reality.
Because of this, Dynablast was developed to facilitate the analysis in displacements, strain and stress in the middle of the plate (common analysis) and DAF (dynamic amplification factor), variation of the TNT mass and distance can be possible like advanced analysis.

## Software

The software opens a window with some input data about the structure and the solicitation in plate. It is importante to explanate that in this program, the structure considered is a linear elastic plate. About the load, is necessaire to know the TNT's characteristics or informations about the experimental data. Finally, which type of analysis the user choose. Based on this, all the informations that are necessaire:

<b>Plate</b>

* Boundary conditions of the plate: simple support or campled
* Boundary conditions of the membrane: immovable, movable or stress free
* Length at x axis (m)
* rate <i>&beta;</i> between length at x axis and y axis 
* Tickness (m)
* Poisson's coefficient
* Young's Module (N/m²)
* Material's density (kg/m³)

<b>TNT</b>
* Data Base: experimental data, Ana's calibration or Rigby's calibration
* Type of Explosion: Spherical or Hemispherical
* Characteristics: total mass (kg), scalar distance (kg/m^1/3), maximum sobrepressure (Pa), maximum underpressure (Pa), time's positive phase (s), positive phase's impulse (Pa.s), negative phase's impulse (Pa.s). It is important to understand, based on which data base are choosed by the user, some informations about the blast wave's characteristics are not necessaire.

<b>Analysis</b>
* Nonlinear Analysis: Yes or No. If the user chooses "No", boundary condition of the membrane are not considered in code.
* Negative Phase: Yes or No. I the user chooses "No", the negative phase of the blast load are not considered in code.
* Time of Analysis: history time of the analysis
* Advanced Analysis: The user can choose some cases to analysis in "Case of Analysis". Cases 1, 4, 5, 6 and 7 are calculated with all the informations above presented. Cases 2 and 3 are necessaire to input one interval of mass and number of steps. 

<b>Buttons</b>
* Dynamic Analysis: In this case, output data presented are displacement, strain and stress in the middle of the plate. However, fourier transformation (FFT) are calculated too.
* Advanced Analysis: In this case, is calculated and ploted graphics based on the informations of the "Adavanced Analysis", in "Analysis". Only one graphic are ploted, because more calculus are necessaire and more time to processing.

All of those informations are presented in Figure 1.

<div>
<img src="Figures/Dyna - 01.png" width="80%">
</div>
<p>
 <b>Figure 1:</b> Dynablast - Input Data 
</p>

When the user choose to click in button "Dynamic Analysis", a input data is presented, like: graphics about displacement, stress and strain in both axis, load per time and FFT. Plate's parameters are presented too and other informations, like: maximum displacement in history time, period linear and nonlinear (if nonlinearity is checked), experimental data about the blast load. All of those informations can be exported to an Excel software (tables) or a Notepad (parameters). It can be see in Figure 2.

<div>
<img src="Figures/Dyna - 02.png" width="100%">
</div>

<div>
<img src="Figures/Dyna - 03.png" width="100%">
</div>
<p>
 <b>Figure 2:</b> Dynablast - Results
</p>

Using "Advanced Analysis" button, based on which case the user choosed, a one type is ploted. Next, all cases ploted with the input data show in Figure 1.

<div>
<img src="Figures/Dyna - 04.png" width="50%">
</div>
<p>
 <b>Figure 3:</b> Dynablast - Advanced Analysis. Case 1: Z x u<sub>z</sub> / h
</p>

<div>
<img src="Figures/Dyna - 05.png" width="50%">
</div>
<p>
 <b>Figure 4:</b> Dynablast - Advanced Analysis. Case 2: W<sub>TNT</sub> x u<sub>L</sub> / u<sub>z</sub>
</p>

<div>
<img src="Figures/Dyna - 06.png" width="50%">
</div>
<p>
 <b>Figure 5:</b> Dynablast - Advanced Analysis. Case 3: t<sub>d</sub> / T<sub>L</sub> x DAF
</p>

<div>
<img src="Figures/Dyna - 07.png" width="50%">
</div>
<p>
 <b>Figure 6:</b> Dynablast - Advanced Analysis. Case 4: t<sub>d</sub> / T<sub>L</sub> x u<sub>z</sub> / h
</p>

<div>
<img src="Figures/Dyna - 08.png" width="50%">
</div>
<p>
 <b>Figure 7:</b> Dynablast - Advanced Analysis. Case 5: t<sub>d</sub> / T<sub>NL</sub> x u<sub>z</sub> / h
</p>

<div>
<img src="Figures/Dyna - 09.png" width="50%">
</div>
<p>
 <b>Figure 8:</b> Dynablast - Advanced Analysis. Case 6: u<sub>z</sub> / h x &sigma;<sub>m</sub> / (&sigma;<sub>m</sub> + &sigma;<sub>b</sub>)
</p>

<div>
<img src="Figures/Dyna - 10.png" width="50%">
</div>
<p>
 <b>Figure 9:</b> Dynablast - Advanced Analysis. Case 6: t<sub>d</sub> / T<sub>NL</sub> x DAF
</p>
