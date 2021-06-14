format long
fclose all;
u0=4*pi*(10^-7); 
%% -------------------------�ʱ�ȭ-------------------------
clear; 
clc;
addpath('function\');
%%
delete('Output/*.csv');

%% --------------------------�Է�--------------------------
Input.skew = 1;                         % Skew ����� 1, ������� 0
Input.skew_floor=2;                     % Skew ���� �ܼ�
Input.skew_angle=7.5;                     % Skew ���� ����

Input.Lstk = 117.2*10^-3;                 % �������� : m����

Input.Pole=8;                           % �ؼ� ����
Input.circum_div = 121;                 % Br �� Bt ����� ���ֹ��� division
Input.radius = 81.34*10^-3 ;            % Br �� Bt ����� ���ؿ����� ���� ������ : m����
Input.Periodic = 45;                  % �ؼ� �� ����(Ǯ�� : 360)
Input.Slot=48;                          % ���� ����

Input.Division = 120;                       % Force �ؼ� ���� �� ���Ⱒ 1�ֱ��� Division

Input.JMAG_name_for_ForceCalculation =  '200407_250pi_3Layer_Model.jproj';        % Force ������ ���� JMag���� �̸�

Input.initial_angle=52.5;                % Motion �ʱⰢ�� ����
Input.Motion_Condi='Motion';             % Motion Condition �̸� ����

Input.Analysis_Point = xlsread('Operation_Information.xlsx');
Input.RPM=Input.Analysis_Point(:,1);
Input.Torque=Input.Analysis_Point(:,2);
Input.Current=Input.Analysis_Point(:,3);
Input.PhaseAngle=Input.Analysis_Point(:,4);
Input.Period=Input.Analysis_Point(:,5);                    % ���������� ���ֱ� �ؼ����� ����

Input
%% --------------------------Br, Bt ����(JMAG script ���� �� JMAG����)

make_vbs_for_BrBt(Input);     %Br, Bt����

%% --------------------------Fr, Ft ���(Maxwell Stress Tensor)

brbt_calculation(Input);

%% --------------------------Fr, FT �� FFT ���� (Fourier Transform)

FFT_Calculation_for_force(Input)
