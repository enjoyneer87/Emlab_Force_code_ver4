function FFT_Calculation_for_force(Input)

rpm=Input.RPM;                  % ������ rpm
T=Input.Torque;                 % ������ ��ũ
periodic=Input.Periodic ;           % ����� �ֱ� ����

for k=1:length(T)

    f_name_Torq = ['Torque/' ,num2str(T(k)),'Nm@',num2str(rpm(k)),'RPM_Torque','.csv'];  % Torque ���� �б�
    Torque_raw=xlsread(f_name_Torq);  % Step ���� ��ü ��ũ ������
    Torque=Torque_raw(:,2);           % ��ũ �����͸� ����
    
    f_name_Fr = ['Output/' ,num2str(T(k)),'Nm@',num2str(rpm(k)),'rpm_Radial_Force','.csv'];  % Fr ���� �б�
    Fr_ex=xlsread(f_name_Fr);  % angle ���� ������
    Fr_S=Fr_ex(:,2:end);          % force �����͸� ����
    
    [R1 R2]=max(Fr_S(:));                      % ��ü �������� �ִ밪 ���
    [R3 R4]=ind2sub(size(Fr_S), R2);           % �ִ밪
    
    Fr_T=Fr_S(R3, 2:end)';                    % Radial ������ �ð��� Force ����
    
    f_name_Ft = ['Output/' ,num2str(T(k)),'Nm@',num2str(rpm(k)),'rpm_Tangential_Force','.csv'];  % Ft ���� �б�
    Ft_ex=xlsread(f_name_Ft);    % angle ���� ������   
    Ft_S=Ft_ex(:,2:end);           % force �����͸� ����
    
    [T1 T2]=max(Ft_S(:));                      % ��ü �������� �ִ밪 ���
    [T3 T4]=ind2sub(size(Ft_S), T2);           % �ִ밪
    
     Ft_T=Ft_S(T3, 2:end)';                    % Tangential ������ �ð��� Force ����
    
    [FFT_data_list_T, YfreqDomain_list_T]=RunFFT(Torque);      % FFT ����
    [FFT_data_list_Fr_S, YfreqDomain_list_Fr_S]=RunFFT(Fr_S);   
    [FFT_data_list_Ft_S, YfreqDomain_list_Ft_S]=RunFFT(Ft_S);
    [FFT_data_list_Fr_T, YfreqDomain_list_Fr_T]=RunFFT(Fr_T);
    [FFT_data_list_Ft_T, YfreqDomain_list_Ft_T]=RunFFT(Ft_T);
    
%     Radial_FFT=[];                 %  Header ������ ���� �۾�
%     for z1=1:div*period+1
%     Radial_string_FFT=['Radial Force FFT' ,num2str(z1), 'Step'];
%     Radial_b=[Radial_FFT Radial_string_FFT];
%     Radial_FFT=cellstr(Radial_b);
%     end
%     
%     Tangential_FFT=[];             %  Header ������ ���� �۾�
%     for z2=1:div*period+1
%     Tangential_string_FFT=['Tangential Force FFT' ,num2str(z2), 'Step'];
%     Tangential_b=[Tangential_FFT Tangential_string_FFT];
%     Tangential_FFT=cellstr(Tangential_b);
%     end 
    
%     headers = ['Order','Torque_FFT'];
%     order_T = [0:1:length(FFT_data_list_T)-1]';
%     csvwrite_with_headers('Output\',num2str(T(k)),'Nm@',num2str(rpm(k)),'rpm_Torque_FFT.csv',[order_T FFT_data_list_T],headers);
%     
%     headers = ['Angle',Radial_FFT];
%     order_Fr = [0:1:length(FFT_data_list_Fr)-1]';
%     csvwrite_with_headers('Output\',num2str(T(k)),'Nm@',num2str(rpm(k)),'rpm_Spatial_Fr_FFT.csv',[order_Fr FFT_data_list_Fr],headers);
%     
%     headers = ['Order',Tangential_FFT];
%     order_Ft = [0:1:length(FFT_data_list_Ft)-1]';
%     csvwrite_with_headers('Output\',num2str(T(k)),'Nm@',num2str(rpm(k)),'rpm_Spatial_Ft_FFT.csv',[order_Ft FFT_data_list_Ft],headers);
    
    order_T = [0:1:size(FFT_data_list_T,1)-1]';                            % Order ����
    T_FFT=[order_T FFT_data_list_T];                                       % Order�� FFT ������ ����
    fname_T_FFT=['Output\',num2str(T(k)),'Nm@',num2str(rpm(k)),'rpm_Torque_FFT.csv'];   % csv write �� �̸�/��� ����. �̸��ؾ� �����ȳ�
    csvwrite(fname_T_FFT,T_FFT);

    disp([num2str(T(k)),'Nm@',num2str(rpm(k)),'RPM_Torque FFT Calculation_�Ϸ�']);
    
    order_Fr_Spatial = [0:1:size(FFT_data_list_Fr_S,1)-1]';                % Order ����
    Fr_S_FFT=[order_Fr_Spatial FFT_data_list_Fr_S];                          % Order�� FFT ������ ����
    fname_Fr_S_FFT=['Output\',num2str(T(k)),'Nm@',num2str(rpm(k)),'rpm_Radial_Force_Spatial_FFT.csv'];   % csv write �� �̸�/��� ����. �̸��ؾ� �����ȳ�
    csvwrite(fname_Fr_S_FFT,Fr_S_FFT);
    
    disp([num2str(T(k)),'Nm@',num2str(rpm(k)),'RPM_Radial Force Spatial FFT Calculation_�Ϸ�']);    
    
    order_Ft_Spatial = [0:1:size(FFT_data_list_Ft_S,1)-1]';                % Order ����
    Ft_S_FFT=[order_Ft_Spatial FFT_data_list_Ft_S];                          % Order�� FFT ������ ����
    fname_Ft_S_FFT=['Output\',num2str(T(k)),'Nm@',num2str(rpm(k)),'rpm_Tangential_Force_Spatial_FFT.csv'];   % csv write �� �̸�/��� ����. �̸��ؾ� �����ȳ�
    csvwrite(fname_Ft_S_FFT,Ft_S_FFT);

    disp([num2str(T(k)),'Nm@',num2str(rpm(k)),'RPM_Tangential Force Spatial FFT Calculation_�Ϸ�']);      
    
    order_Fr_Time = [0:1:size(FFT_data_list_Fr_T,1)-1]';                % Order ����
    Fr_T_FFT=[order_Fr_Time FFT_data_list_Fr_T];                          % Order�� FFT ������ ����
    fname_Fr_T_FFT=['Output\',num2str(T(k)),'Nm@',num2str(rpm(k)),'rpm_Radial_Force_Time_FFT.csv'];   % csv write �� �̸�/��� ����. �̸��ؾ� �����ȳ�
    csvwrite(fname_Fr_T_FFT,Fr_T_FFT);    
 
    disp([num2str(T(k)),'Nm@',num2str(rpm(k)),'RPM_Radial Force Time FFT Calculation_�Ϸ�']);      
    
    order_Ft_Time = [0:1:size(FFT_data_list_Ft_T,1)-1]';                % Order ����
    Ft_T_FFT=[order_Ft_Time FFT_data_list_Ft_T];                          % Order�� FFT ������ ����
    fname_Ft_T_FFT=['Output\',num2str(T(k)),'Nm@',num2str(rpm(k)),'rpm_Tangential_Force_Time_FFT.csv'];   % csv write �� �̸�/��� ����. �̸��ؾ� �����ȳ�
    csvwrite(fname_Ft_T_FFT,Ft_T_FFT);
    
    disp([num2str(T(k)),'Nm@',num2str(rpm(k)),'RPM_Tangential Force Time FFT Calculation_�Ϸ�']);        
    disp(' ');      
    disp([num2str(T(k)),'Nm@',num2str(rpm(k)),'RPM_������ ������ FFT Calculation_�Ϸ�']);     
    
end