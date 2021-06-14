function FFT_Calculation_for_force(Input)

rpm=Input.RPM;                  % 운전점 rpm
T=Input.Torque;                 % 운전점 토크
periodic=Input.Periodic ;           % 기계적 주기 설정

for k=1:length(T)

    f_name_Torq = ['Torque/' ,num2str(T(k)),'Nm@',num2str(rpm(k)),'RPM_Torque','.csv'];  % Torque 파일 읽기
    Torque_raw=xlsread(f_name_Torq);  % Step 포함 전체 토크 데이터
    Torque=Torque_raw(:,2);           % 토크 데이터만 추출
    
    f_name_Fr = ['Output/' ,num2str(T(k)),'Nm@',num2str(rpm(k)),'rpm_Radial_Force','.csv'];  % Fr 파일 읽기
    Fr_ex=xlsread(f_name_Fr);  % angle 포함 데이터
    Fr_S=Fr_ex(:,2:end);          % force 데이터만 추출
    
    [R1 R2]=max(Fr_S(:));                      % 전체 데이터의 최대값 계산
    [R3 R4]=ind2sub(size(Fr_S), R2);           % 최대값
    
    Fr_T=Fr_S(R3, 2:end)';                    % Radial 방향의 시간적 Force 추출
    
    f_name_Ft = ['Output/' ,num2str(T(k)),'Nm@',num2str(rpm(k)),'rpm_Tangential_Force','.csv'];  % Ft 파일 읽기
    Ft_ex=xlsread(f_name_Ft);    % angle 포함 데이터   
    Ft_S=Ft_ex(:,2:end);           % force 데이터만 추출
    
    [T1 T2]=max(Ft_S(:));                      % 전체 데이터의 최대값 계산
    [T3 T4]=ind2sub(size(Ft_S), T2);           % 최대값
    
     Ft_T=Ft_S(T3, 2:end)';                    % Tangential 방향의 시간적 Force 추출
    
    [FFT_data_list_T, YfreqDomain_list_T]=RunFFT(Torque);      % FFT 수행
    [FFT_data_list_Fr_S, YfreqDomain_list_Fr_S]=RunFFT(Fr_S);   
    [FFT_data_list_Ft_S, YfreqDomain_list_Ft_S]=RunFFT(Ft_S);
    [FFT_data_list_Fr_T, YfreqDomain_list_Fr_T]=RunFFT(Fr_T);
    [FFT_data_list_Ft_T, YfreqDomain_list_Ft_T]=RunFFT(Ft_T);
    
%     Radial_FFT=[];                 %  Header 생성을 위한 작업
%     for z1=1:div*period+1
%     Radial_string_FFT=['Radial Force FFT' ,num2str(z1), 'Step'];
%     Radial_b=[Radial_FFT Radial_string_FFT];
%     Radial_FFT=cellstr(Radial_b);
%     end
%     
%     Tangential_FFT=[];             %  Header 생성을 위한 작업
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
    
    order_T = [0:1:size(FFT_data_list_T,1)-1]';                            % Order 정리
    T_FFT=[order_T FFT_data_list_T];                                       % Order과 FFT 데이터 모음
    fname_T_FFT=['Output\',num2str(T(k)),'Nm@',num2str(rpm(k)),'rpm_Torque_FFT.csv'];   % csv write 할 이름/경로 설정. 미리해야 에러안남
    csvwrite(fname_T_FFT,T_FFT);

    disp([num2str(T(k)),'Nm@',num2str(rpm(k)),'RPM_Torque FFT Calculation_완료']);
    
    order_Fr_Spatial = [0:1:size(FFT_data_list_Fr_S,1)-1]';                % Order 정리
    Fr_S_FFT=[order_Fr_Spatial FFT_data_list_Fr_S];                          % Order과 FFT 데이터 모음
    fname_Fr_S_FFT=['Output\',num2str(T(k)),'Nm@',num2str(rpm(k)),'rpm_Radial_Force_Spatial_FFT.csv'];   % csv write 할 이름/경로 설정. 미리해야 에러안남
    csvwrite(fname_Fr_S_FFT,Fr_S_FFT);
    
    disp([num2str(T(k)),'Nm@',num2str(rpm(k)),'RPM_Radial Force Spatial FFT Calculation_완료']);    
    
    order_Ft_Spatial = [0:1:size(FFT_data_list_Ft_S,1)-1]';                % Order 정리
    Ft_S_FFT=[order_Ft_Spatial FFT_data_list_Ft_S];                          % Order과 FFT 데이터 모음
    fname_Ft_S_FFT=['Output\',num2str(T(k)),'Nm@',num2str(rpm(k)),'rpm_Tangential_Force_Spatial_FFT.csv'];   % csv write 할 이름/경로 설정. 미리해야 에러안남
    csvwrite(fname_Ft_S_FFT,Ft_S_FFT);

    disp([num2str(T(k)),'Nm@',num2str(rpm(k)),'RPM_Tangential Force Spatial FFT Calculation_완료']);      
    
    order_Fr_Time = [0:1:size(FFT_data_list_Fr_T,1)-1]';                % Order 정리
    Fr_T_FFT=[order_Fr_Time FFT_data_list_Fr_T];                          % Order과 FFT 데이터 모음
    fname_Fr_T_FFT=['Output\',num2str(T(k)),'Nm@',num2str(rpm(k)),'rpm_Radial_Force_Time_FFT.csv'];   % csv write 할 이름/경로 설정. 미리해야 에러안남
    csvwrite(fname_Fr_T_FFT,Fr_T_FFT);    
 
    disp([num2str(T(k)),'Nm@',num2str(rpm(k)),'RPM_Radial Force Time FFT Calculation_완료']);      
    
    order_Ft_Time = [0:1:size(FFT_data_list_Ft_T,1)-1]';                % Order 정리
    Ft_T_FFT=[order_Ft_Time FFT_data_list_Ft_T];                          % Order과 FFT 데이터 모음
    fname_Ft_T_FFT=['Output\',num2str(T(k)),'Nm@',num2str(rpm(k)),'rpm_Tangential_Force_Time_FFT.csv'];   % csv write 할 이름/경로 설정. 미리해야 에러안남
    csvwrite(fname_Ft_T_FFT,Ft_T_FFT);
    
    disp([num2str(T(k)),'Nm@',num2str(rpm(k)),'RPM_Tangential Force Time FFT Calculation_완료']);        
    disp(' ');      
    disp([num2str(T(k)),'Nm@',num2str(rpm(k)),'RPM_운전점 가진력 FFT Calculation_완료']);     
    
end