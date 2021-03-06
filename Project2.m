clear all
clc

% SLOPE IN THE ORIGIN OF Fx-? CURVE
% Vertical Force
Fz = [2 4 6 8 10]; %[kN]

% Longitudinal Coefficients
b = [2.37272 -9.46 1490 130 276 0.0886 0.00402 -0.0615 1.2 0.0299 -0.176];

% Calculate Maximum Longitudinal Force Coefficients
uxp = b(2).*Fz + b(3);

% Calculate Slip Stiffness BCDlong
BCDlong = (b(4).*Fz.^2 + b(5).*Fz).*exp(-b(6).*Fz);

figure; hold on;
plot(Fz, uxp);
title('uxp vs Fz');
xlabel('Fz [kN]');
ylabel('uxp [-]');

figure; hold on;
plot(Fz, BCDlong);
title('BCD vs Fz');
xlabel('Fz [kN]');
ylabel('BCD [-]');

% SIDE SLIP STIFFNESS
% Lateral Coefficients
a = [1.65 -34 1250 3036 12.8 0.00501 -0.02103 0.77394 0.0022890 0.013442 0.003709 19.1656 1.21356 6.26206];

% Calculate Side Slip Stiffness BCDside
BCDside = a(4).*sind(2*atand(Fz./a(5)));

% Calculate Maximum Lateral Force Coefficients
uyp = a(2).*Fz + a(3);

% Calculate Side Slip Stiffness with Camber Angle Effect BCDcamber
gamma = -20:20;
BCDcamber = a(4)*sind(2*atand(5/a(5))).*(1-a(6).*abs(gamma));

figure; hold on;
plot(Fz, BCDside);
title('BCDside vs Fz');
xlabel('Fz [kN]');
ylabel('BCDside [-]');

figure; hold on;
plot(Fz, uyp);
title('uyp vs Fz');
xlabel('Fz [kN]');
ylabel('uyp [-]');

figure; hold on;
plot(gamma, BCDcamber);
title('BCDcamber vs gamma at Fz=5kN');
xlabel('gamma [deg]');
ylabel('BCDcamber [-]');

% SELF-ALIGNMENT TORQUE STIFFNESS
% Aligning Coefficients
c = [2.34 1.495 6.416654 -3.57403 -0.087737 0.098410 0.0027699 -0.0001151 0.1 -1.33329 0.025501 -0.02357 0.03027 -0.0647 0.0211329 0.89469 -0.099443];

% Calculate self-alignment stiffness BCDalign
BCDalign = (c(4).*Fz.^3 + c(5).*Fz).*exp(-c(6).*Fz);

% Calculate Self-Aligning Stiffness with Camber Angle Effect BCDalignCamber
BCDalignCamber = (c(4)*5^3 + c(5)*5)*exp(-c(6)*5).*(1-c(7).*abs(gamma));

figure; hold on;
plot(Fz, BCDalign);
title('BCDalign vs Fz');
xlabel('Fz [kN]');
ylabel('BCDalign [-]');

figure; hold on;
plot(gamma, BCDalignCamber);
title('BCDalignCamber vs gamma at Fz=5kN');
xlabel('gamma [deg]');
ylabel('BCDalignCamber [-]');

% TIRE NON-LINEAR MODEL
% Read Excel File
[NUM, TXT, RAW] = xlsread('Project2_TireCharacteristics.xls');
index = 1:201;

% Extract Data Into Suitable Variables
Slip = NUM(index, 1);
SideSlip = NUM(index, 7);
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

% Plot ux vs Slip
figure; hold on;
for i = 1:5
   plot(Slip, ux(index, i)); 
end
legend('ux [2kN]', 'ux [4kN]', 'ux [6kN]', 'ux [8kN]', 'ux [10kN]');
xlabel('Slip [-]');
ylabel('ux [-]');
title('ux vs Slip for a range of Fz');

% Evaluate Lateral Force Coefficient
uy = zeros(201, 5);
for i = 1:5
    for j = 1:201
       uy(j, i) =  Fy(j, i)/(Fz(i)*10^3);
    end
end

% Plot uy vs Side Slip
figure; hold on;
for i = 1:5
   plot(SideSlip, uy(index, i)); 
end
legend('uy [2kN]', 'uy [4kN]', 'uy [6kN]', 'uy [8kN]', 'uy [10kN]');
xlabel('SideSlip [-]');
ylabel('uy [-]');
title('uy vs Slip for a range of Fz');

% Calculate and Plot Lever Arm t[mm] at Fz=4kN
t = -Mz(index, 2)./Fy(index, 2)*10^3;

figure; hold on;
plot(SideSlip, t);
title('Lever Arm vs SideSlip at Fz=4kN');
xlabel('SideSlip [-]');
ylabel('t[mm]');

% Plot Gough Diagram
figure; hold on;
for i = 1:5
    plot(Mz(index, i), Fy(index, i));
end

for i = index
   plot(Mz(i, 1:5), Fy(i, 1:5)); 
end
grid on;
title('Fy vs Mz in ranges of Fz and alpha');
xlabel('Mz [Nm]');
ylabel('Fy [N]');

% INTERACTION OF TIRE-ROAD FORCES IN LONGITUDINAL AND LATERAL DIRECTIONS
% Evaluate and Plot Fy as a function of Fx at Fz = 4kN and Camber = 0 for different
% side slip
indeces = [111 121 131 141 151];
Fy0 = Fy(indeces(1:5), 2); % [N]
Fx0 = Fz(2)*uxp(2); % [N]
Fyn = zeros(201, 5);
for i = 1:5
    for j = index
        Fyn(j, i) = Fy0(i).*sqrt(1-(Fx(j, 2)/Fx0)^2); 
    end
end

figure; hold on;
for i = 1:5
   plot(Fx(index, 2), Fyn(index, i)); 
end
legend('alpha = 2', 'alpha = 4', 'alpha = 6', 'alpha = 8', 'alpha = 10');
title('Fy vs Fx for a range of alpha');
xlabel('Fx [N]');
ylabel('Fy [N]');

% Evaluate and Plot Side Slip Stiffness as a function of Fx at different values of
% Fz

C = zeros(201, 5);
for i = 1:5
   for j = index
       if (Fx(j, i) < uxp(i)*Fz(i))
           C(j, i) = BCDside(i)*sqrt(1-(Fx(j, i)/(uxp(i)*Fz(i)))^2);
       else
           C(j, i) = 0;
       end
   end
end

figure; hold on;
for i = 1:5
   plot(Fx(index, i), C(index, i)); 
end
legend('Fz = 2kN', 'Fz = 4kN', 'Fz = 6kN', 'Fz = 8kN', 'Fz = 10kN');
title('C vs Fx for a range of Fz');
xlabel('Fx [N]');
ylabel('C [N/deg]');

% Evaluate and Plot Lateral Force Coefficient uy as a function of ux at Fz=4kN
uyn = zeros(201, 1);

for i = index
   uyn(i) = max(uy(index, 2))*sqrt(1-(ux(i, 2)/uxp(2))^2); 
end

figure; hold on;
plot(ux(index, 2), uyn(index));
title('uy vs ux at Fz = 4kN');
xlabel('ux [-]');
ylabel('uy [-]');