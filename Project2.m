clear all
clc

% Read Excel File
[NUM, TXT, RAW] = xlsread('Project2_TireCharacteristics.xls');

index = 1:201;

% Extract Data Into Suitable Variables
Slip = NUM(index, 1);
Fx2 = NUM(index, 2);
Fx4 = NUM(index, 3);
Fx6 = NUM(index, 4);
Fx8 = NUM(index, 5);
Fx10 = NUM(index, 6);

SideSlip = NUM(index, 7);
Fy2 = NUM(index, 8);
Fy4 = NUM(index, 9);
Fy6 = NUM(index, 10);
Fy8 = NUM(index, 11);
Fy10 = NUM(index, 12);

Mz2 = NUM(index, 14);
Mz4 = NUM(index, 15);
Mz6 = NUM(index, 16);
Mz8 = NUM(index, 17);
Mz10 = NUM(index, 18);