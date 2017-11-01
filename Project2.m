clear all
clc

% Read Excel File
[NUM, TXT, RAW] = xlsread('Project2_TireCharacteristics.xls');
Fz = [2 4 6 8 10];
index = 1:201;

% Extract Data Into Suitable Variables
Slip = NUM(index, 1);
Fx = zeros(201, 5);
Fy = zeros(201, 5);
Mz = zeros(201, 5);
for i = 1:5
   Fx(index, i) = NUM(index, i+1); 
   Fy(index, i) = NUM(index, i+7);
   Mz(index, i) = NUM(index, i+13);
end

% Evaluate Longitudinal Force Coefficient
ux = zeros(201, 5);
for i = 1:5
   for j = 1:201
      ux(j, i) = Fx(j, i)/(Fz(i)*10^3); 
   end
end

% Evaluate The Maximum Longitudinal Slip Coefficients
uxp(1:5) = max(ux);

% Plot ux vs Slip
figure; hold on;
for i = 1:5
   plot(Slip, ux(index, i)); 
end
legend('ux [2kN]', 'ux [4kN]', 'ux [6kN]', 'ux [8kN]', 'ux [10kN]');
xlabel('Slip [-]');
ylabel('ux [-]');
title('ux vs Slip');

% Longitudinal Coefficients
b = [2.37272 -9.46 1490 130 276 0.0886 0.00402 -0.0615 1.2 0.0299 -0.176];

% Calculate BCDslip in Magic Formula
BCDslip = (b(4).*Fz.^2 + b(5).*Fz).*exp(-b(6).*Fz);

% Lateral Coefficients
a = [1.65 -34 1250 3036 12.8 0.00501 -0.02103 0.77394 0.0022890 0.013442 0.003709 19.1656 1.21356 6.26206];

% Calculate BCDsideSlip in Magic Formula
BCDsideSlip = a(4).*sind(2*atand(Fz./a(5)));

% Evaluate Lateral Force Coefficient
uy = zeros(201, 5);
for i = 1:5
    for j = 1:201
       uy(j, i) =  Fy(j, i)/(Fz(i)*10^3);
    end
end

% Evaluate The Maximum Lateral Force Coefficients
uyp = max(uy);

% Evaluate BCDcamber
gamma = -20:20;
BCDcamber = a(4)*sind(2*atand(5/a(5))).*(1-a(6).*abs(gamma));

% Plot BCDcamber vs gamma
figure; hold on;
plot(gamma, BCDcamber);
xlabel('Camber [deg]');
ylabel('Side Slip Stiffness [-]');
title('Side Slip Stiffness vs Camber');

% Aligning Coefficient
c = [2.34 1.495 6.416654 -3.57403 -0.087737 0.098410 0.0027699 -0.0001151 0.1 -1.33329 0.025501 -0.02357 0.03027 -0.0647 0.0211329 0.89469 -0.099443];

% Calculate BCDaligning
BCDaligning = (c(4).*Fz.^3 + c(5).*Fz).*exp(-c(6).*Fz);

% Calculate BCDaligningCamber
BCDaligningCamber = (c(4)*5^3 + c(5)*5)*exp(-c(6)*5).*(1-c(7).*abs(gamma));

% Plot BCDaligningCamber vs gamma
figure; hold on;
plot(gamma, BCDaligningCamber);
title('Self-Aligning Sitffness vs Camber');
xlabel('Camber [deg]');
ylabel('Self-Aligning Stiffness [-]');