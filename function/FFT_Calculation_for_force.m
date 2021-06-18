function FFT_Calculation_for_force(Input)

rpm=Input.RPM;                  % ������ rpm
T=Input.Torque;                 % ������ ��ũ
periodic=Input.Periodic ;           % ����� �ֱ� ����

for k=1:length(T)
% 
    f_name_Torq = ['Torque/' ,num2str(T(k)),'Nm@',num2str(rpm(k)),'RPM_Torque','.csv'];  % Torque ���� �б�
    Torque_raw=xlsread(f_name_Torq);  % Step ���� ��ü ��ũ ������
    Torque=Torque_raw(:,2);           % ��ũ �����͸� ����
 

%%Radial Force ����
    f_name_Fr = ['Output/' ,num2str(T(k)),'Nm@',num2str(rpm(k)),'rpm_Radial_Force','.csv'];  % Fr ���� �б�
    Fr_ex=xlsread(f_name_Fr);  % angle ���� ������
    Fr_S=Fr_ex(:,2:end);          % force �����͸� ����

 %% Tangential Force ����   
    f_name_Ft = ['Output/' ,num2str(T(k)),'Nm@',num2str(rpm(k)),'rpm_Tangential_Force','.csv'];  % Ft ���� �б�
    Ft_ex=xlsread(f_name_Ft);    % angle ���� ������   
    Ft_S=Ft_ex(:,2:end);           % force �����͸� ����


%% Spatial FFT ���� (�ļ� ����)
    [FFT_data_list_T, YfreqDomain_list_T]=RunFFT(Torque);      % ��ũ FFT
    [FFT_data_list_Fr_Spatial, YfreqDomain_list_Fr_S]=RunFFT(Fr_S);    %Radial 
    [FFT_data_list_Ft_Spatial, YfreqDomain_list_Ft_S]=RunFFT(Ft_S);    % Tangential


%% SPATIAL DOMAIN FFT data�� csv�� ��������

    order_T = [0:1:size(FFT_data_list_T,1)-1]';                            % Order ���� Torque
    T_FFT=[order_T FFT_data_list_T];                                       % Order�� FFT ������ ����
    fname_T_FFT=['Output\',num2str(T(k)),'Nm@',num2str(rpm(k)),'rpm_Torque_FFT.csv'];   % csv write �� �̸�/��� ����. �̸��ؾ� �����ȳ�
    csvwrite(fname_T_FFT,T_FFT);
    disp([num2str(T(k)),'Nm@',num2str(rpm(k)),'RPM_Torque FFT Calculation_�Ϸ�']);
    
    order_Fr_Spatial = [0:1:size(FFT_data_list_Fr_Spatial,1)-1]';                % Order ���� Radial Force
    Fr_S_FFT=[order_Fr_Spatial FFT_data_list_Fr_Spatial];                          % Order�� FFT ������ ����
    fname_Fr_S_FFT=['Output\',num2str(T(k)),'Nm@',num2str(rpm(k)),'rpm_Radial_Force_Spatial_FFT.csv'];   % csv write �� �̸�/��� ����. �̸��ؾ� �����ȳ�
    csvwrite(fname_Fr_S_FFT,Fr_S_FFT);      
    disp([num2str(T(k)),'Nm@',num2str(rpm(k)),'RPM_Radial Force Spatial FFT Calculation_�Ϸ�']);    
    
    order_Ft_Spatial = [0:1:size(FFT_data_list_Ft_Spatial,1)-1]';                % Order ���� Tangential Force
    Ft_S_FFT=[order_Ft_Spatial FFT_data_list_Ft_Spatial];                          % Order�� FFT ������ ����
    fname_Ft_S_FFT=['Output\',num2str(T(k)),'Nm@',num2str(rpm(k)),'rpm_Tangential_Force_Spatial_FFT.csv'];   % csv write �� �̸�/��� ����. �̸��ؾ� �����ȳ�
    csvwrite(fname_Ft_S_FFT,Ft_S_FFT);
    disp([num2str(T(k)),'Nm@',num2str(rpm(k)),'RPM_Tangential Force Spatial FFT Calculation_�Ϸ�']);       

    
%% TIME DOMAIN FFT(VER. 5)  -������ ������ Spatial FFT ��� ������(time step�� �ļ� Amplitude)�� ���� ����
                   
    %Raidal Force                
    Fr_Spatial_FFT_temp=(FFT_data_list_Fr_Spatial)';
    [FFT_data_list_Fr_Time_SFFT, YfreqDomain_list_Fr_T_SFFT]=RunFFT(Fr_Spatial_FFT_temp);
    order_Fr_Time = [0:1:size(FFT_data_list_Fr_Time_SFFT,1)-1]';   
   
   
    %������ ���� �� CSV  
    Fr_Time_FFT_from_Spatial_FFT=[order_Fr_Time FFT_data_list_Fr_Time_SFFT];                          % Order�� FFT ������ ����
    fname_Fr_T_FFT=['Output\',num2str(T(k)),'Nm@',num2str(rpm(k)),'rpm_Radial_Force_combined_FFT.csv'];   % csv write �� �̸�/��� ����. �̸��ؾ� �����ȳ�
    csvwrite(fname_Fr_T_FFT,Fr_Time_FFT_from_Spatial_FFT);    
    
    % Tangential Force
    Ft_Spatial_FFT_temp=(FFT_data_list_Ft_Spatial)';
    [FFT_data_list_Ft_Time_SFFT, YfreqDomain_list_Ft_T_SFFT]=RunFFT(Ft_Spatial_FFT_temp);
    order_Ft_Time = [0:1:size(FFT_data_list_Ft_Time_SFFT,1)-1]';   
   
     %������ ���� �� CSV  
    Ft_Time_FFT_from_Spatial_FFT=[order_Ft_Time FFT_data_list_Ft_Time_SFFT];                          % Order�� FFT ������ ����
    fname_Ft_T_FFT=['Output\',num2str(T(k)),'Nm@',num2str(rpm(k)),'rpm_Tangential_Force_combined_FFT.csv'];   % csv write �� �̸�/��� ����. �̸��ؾ� �����ȳ�
    csvwrite(fname_Ft_T_FFT,Ft_Time_FFT_from_Spatial_FFT);    
    
    disp([num2str(T(k)),'Nm@',num2str(rpm(k)),'RPM_������ �ð����������� FFT Calculation_�Ϸ�']);     
       
end
