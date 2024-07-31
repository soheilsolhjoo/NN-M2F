# Converting MATLAB's shallow NN to Fortran 90
NN-M2F  Copyright (C) 2018  Soheil Solhjoo,  
This program comes with ABSOLUTELY NO WARRANTY.  
This is free software, and I publish it under CC BY-NC-SA 4.0.

This code is to train a NN in Matlab and convert it into Fortran 90 to be used in relevant software packages, such as MARC (a FEM solver).

## Table of Contents
1. [Introduction](#a-very-short-note-on-files-and-how-to-use-the-code)
2. [Note](#notes-on-other-files)
3. [Other dimensions](#other-dimensions)

## A very short note on files and how to use the code
1. **1_NN_1D.m** defines stress as a function of strain, and trains a network with a [hiddenSizes](https://mathworks.com/help/deeplearning/ref/feedforwardnet.html#mw_c6e1d17d-b711-42ec-81cf-1a0eb4271932) of [4 3]. It then saves the trained network as *netFcn.m*.
2. **2_netFcn_2_Fortran.m** converts the saved network to Fortran 90 and saves it as *NN_mat.f*.
3. One can use this file now in MARC easily by including it in a subroutine. For example, if used with *wkslp*, *include NN_mat* can be added to the first line. Then the following can be used to calculate stress and slope:
```
real ∗8 deps, nextyld
deps = 0.01
call NN_mat(stryt,ebarp)
call NN_mat(nextyld,ebarp + deps)
slope = (stryt − nextyld ) / deps
```
## Notes on other files
To run the Matlab converter, *read_data.m*, and to run the Fortran code, *NN_funcs.f* are required.

## Other dimensions
The model can be easily extended to higher dimensions. Files **1_NN_2D.m** and **1_NN_3D.m** define stress as functions of (strain and strain-rate) and (strain, strain-rate, and temperature), respectively. The trained networks can be used as mentioned above.
