function FFT_Calculation_for_force(Input)

rpm=Input.RPM;                  % 운전점 rpm
T=Input.Torque;                 % 운전점 토크
periodic=Input.Periodic ;           % 기계적 주기 설정

for k=1:length(T)
% 
    f_name_Torq = ['Torque/' ,num2str(T(k)),'Nm@',num2str(rpm(k)),'RPM_Torque','.csv'];  % Torque 파일 읽기
    Torque_raw=xlsread(f_name_Torq);  % Step 포함 전체 토크 데이터
    Torque=Torque_raw(:,2);           % 토크 데이터만 추출
 

%%Radial Force 추출
    f_name_Fr = ['Output/' ,num2str(T(k)),'Nm@',num2str(rpm(k)),'rpm_Radial_Force','.csv'];  % Fr 파일 읽기
    Fr_ex=xlsread(f_name_Fr);  % angle 포함 데이터
    Fr_S=Fr_ex(:,2:end);          % force 데이터만 추출

 %% Tangential Force 추출   
    f_name_Ft = ['Output/' ,num2str(T(k)),'Nm@',num2str(rpm(k)),'rpm_Tangential_Force','.csv'];  % Ft 파일 읽기
    Ft_ex=xlsread(f_name_Ft);    % angle 포함 데이터   
    Ft_S=Ft_ex(:,2:end);           % force 데이터만 추출


%% Spatial FFT 수행 (파수 추출)
    [FFT_data_list_T, YfreqDomain_list_T]=RunFFT(Torque);      % 토크 FFT
    [FFT_data_list_Fr_Spatial, YfreqDomain_list_Fr_S]=RunFFT(Fr_S);    %Radial 
    [FFT_data_list_Ft_Spatial, YfreqDomain_list_Ft_S]=RunFFT(Ft_S);    % Tangential


%% SPATIAL DOMAIN FFT data를 csv로 내보내기

    order_T = [0:1:size(FFT_data_list_T,1)-1]';                            % Order 정리 Torque
    T_FFT=[order_T FFT_data_list_T];                                       % Order과 FFT 데이터 모음
    fname_T_FFT=['Output\',num2str(T(k)),'Nm@',num2str(rpm(k)),'rpm_Torque_FFT.csv'];   % csv write 할 이름/경로 설정. 미리해야 에러안남
    csvwrite(fname_T_FFT,T_FFT);
    disp([num2str(T(k)),'Nm@',num2str(rpm(k)),'RPM_Torque FFT Calculation_완료']);
    
    order_Fr_Spatial = [0:1:size(FFT_data_list_Fr_Spatial,1)-1]';                % Order 정리 Radial Force
    Fr_S_FFT=[order_Fr_Spatial FFT_data_list_Fr_Spatial];                          % Order과 FFT 데이터 모음
    fname_Fr_S_FFT=['Output\',num2str(T(k)),'Nm@',num2str(rpm(k)),'rpm_Radial_Force_Spatial_FFT.csv'];   % csv write 할 이름/경로 설정. 미리해야 에러안남
    csvwrite(fname_Fr_S_FFT,Fr_S_FFT);      
    disp([num2str(T(k)),'Nm@',num2str(rpm(k)),'RPM_Radial Force Spatial FFT Calculation_완료']);    
    
    order_Ft_Spatial = [0:1:size(FFT_data_list_Ft_Spatial,1)-1]';                % Order 정리 Tangential Force
    Ft_S_FFT=[order_Ft_Spatial FFT_data_list_Ft_Spatial];                          % Order과 FFT 데이터 모음
    fname_Ft_S_FFT=['Output\',num2str(T(k)),'Nm@',num2str(rpm(k)),'rpm_Tangential_Force_Spatial_FFT.csv'];   % csv write 할 이름/경로 설정. 미리해야 에러안남
    csvwrite(fname_Ft_S_FFT,Ft_S_FFT);
    disp([num2str(T(k)),'Nm@',num2str(rpm(k)),'RPM_Tangential Force Spatial FFT Calculation_완료']);       

    
%% TIME DOMAIN FFT(VER. 5)  -위에서 수행한 Spatial FFT 기반 데이터(time step별 파수 Amplitude)로 차수 산출
                   
    %Raidal Force                
    Fr_Spatial_FFT_temp=(FFT_data_list_Fr_Spatial)';
    [FFT_data_list_Fr_Time_SFFT, YfreqDomain_list_Fr_T_SFFT]=RunFFT(Fr_Spatial_FFT_temp);
    order_Fr_Time = [0:1:size(FFT_data_list_Fr_Time_SFFT,1)-1]';   
   
   
    %데이터 취합 및 CSV  
    Fr_Time_FFT_from_Spatial_FFT=[order_Fr_Time FFT_data_list_Fr_Time_SFFT];                          % Order과 FFT 데이터 모음
    fname_Fr_T_FFT=['Output\',num2str(T(k)),'Nm@',num2str(rpm(k)),'rpm_Radial_Force_combined_FFT.csv'];   % csv write 할 이름/경로 설정. 미리해야 에러안남
    csvwrite(fname_Fr_T_FFT,Fr_Time_FFT_from_Spatial_FFT);    
    
    % Tangential Force
    Ft_Spatial_FFT_temp=(FFT_data_list_Ft_Spatial)';
    [FFT_data_list_Ft_Time_SFFT, YfreqDomain_list_Ft_T_SFFT]=RunFFT(Ft_Spatial_FFT_temp);
    order_Ft_Time = [0:1:size(FFT_data_list_Ft_Time_SFFT,1)-1]';   
   
     %데이터 취합 및 CSV  
    Ft_Time_FFT_from_Spatial_FFT=[order_Ft_Time FFT_data_list_Ft_Time_SFFT];                          % Order과 FFT 데이터 모음
    fname_Ft_T_FFT=['Output\',num2str(T(k)),'Nm@',num2str(rpm(k)),'rpm_Tangential_Force_combined_FFT.csv'];   % csv write 할 이름/경로 설정. 미리해야 에러안남
    csvwrite(fname_Ft_T_FFT,Ft_Time_FFT_from_Spatial_FFT);    
    
    disp([num2str(T(k)),'Nm@',num2str(rpm(k)),'RPM_운전점 시간공간가진력 FFT Calculation_완료']);     
       
end
