format long
fclose all;
u0=4*pi*(10^-7); 
%% -------------------------초기화-------------------------
clear; 
clc;
addpath('function\');
%%
delete('Output/*.csv');

%% --------------------------입력--------------------------
Input.skew = 1;                         % Skew 적용시 1, 미적용시 0
Input.skew_floor=2;                     % Skew 적용 단수
Input.skew_angle=7.5;                     % Skew 적용 각도

Input.Lstk = 117.2*10^-3;                 % 적층길이 : m단위

Input.Pole=8;                           % 극수 설정
Input.circum_div = 121;                 % Br 및 Bt 추출시 원주방향 division
Input.radius = 81.34*10^-3 ;            % Br 및 Bt 추출시 공극에서의 추출 반지름 : m단위
Input.Periodic = 45;                  % 해석 모델 각도(풀모델 : 360)
Input.Slot=48;                          % 슬롯 개수

Input.Division = 120;                       % Force 해석 수행 시 전기각 1주기의 Division

Input.JMAG_name_for_ForceCalculation =  '200407_250pi_3Layer_Model.jproj';        % Force 추출을 위한 JMag파일 이름

Input.initial_angle=52.5;                % Motion 초기각도 설정
Input.Motion_Condi='Motion';             % Motion Condition 이름 설정

Input.Analysis_Point = xlsread('Operation_Information.xlsx');
Input.RPM=Input.Analysis_Point(:,1);
Input.Torque=Input.Analysis_Point(:,2);
Input.Current=Input.Analysis_Point(:,3);
Input.PhaseAngle=Input.Analysis_Point(:,4);
Input.Period=Input.Analysis_Point(:,5);                    % 전기적으로 몇주기 해석할지 설정

Input
%% --------------------------Br, Bt 추출(JMAG script 생성 후 JMAG실행)

make_vbs_for_BrBt(Input);     %Br, Bt추출

%% --------------------------Fr, Ft 계산(Maxwell Stress Tensor)

brbt_calculation(Input);

%% --------------------------Fr, FT 의 FFT 수행 (Fourier Transform)

FFT_Calculation_for_force(Input)
