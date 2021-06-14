function brbt_calculation(Input)

u0=4*pi*(10^-7);
Lstk = Input.Lstk;

rpm=Input.RPM;                  % 운전점 rpm
T=Input.Torque;                 % 운전점 토크
div = Input.Division;            % 해석할 division 갯수 설정
period=Input.Period;            % 해석할 전기적 주기 설정
periodic=Input.Periodic ;           % 기계적 주기 설정
periodic_force=360/periodic;        % Force가 기계적으로 몇번 반복인지

radius = Input.radius;              % force 추출할 반지름 길이 설정
circum_div = Input.circum_div;      % 원주방향 div 갯수 설정
slot=Input.Slot;


for k=1:length(T)
    
    f_name_Br = ['Br/' ,num2str(T(k)),'Nm@',num2str(rpm(k)),'rpm_br','.csv'];  % Br 파일 읽기
    br_raw=xlsread(f_name_Br);
    
    f_name_Bt = ['Bt/' ,num2str(T(k)),'Nm@',num2str(rpm(k)),'rpm_bt','.csv'];  % Bt 파일 읽기
    bt_raw=xlsread(f_name_Bt);
    
    angle_be=br_raw(:,1);                                  % Angle 데이터만 추출
    
    rtheta=radius*2*pi()/periodic_force/circum_div;                    % Rtheta 계산
    
    br=br_raw(:,2:end);                                 % Br 에서 Angle 제외하고 Br만 추출
    bt=bt_raw(:,2:end);                                 % Bt 에서 Angle 제외하고 Br만 추출                   
    
    fr_be = (br.*br - bt.*bt)/(2*u0)*rtheta*Lstk;              % Radial Force 계산
    ft_be = (br.*bt)/u0*rtheta*Lstk;                           % Tangential Force 계산
    fr=fr_be;
    ft=ft_be;
    angle=angle_be;   
    
    if (periodic_force~=1)
        for z=1:(periodic_force-1)
            fr=[fr; fr_be];
            ft=[ft; ft_be];
            angle=[angle; angle_be+360/periodic_force*z];
        end
    end
    
    before_calc_Torque=ft*radius;                           % Torque 검증
    calc_Torque=sum(before_calc_Torque);                    % Torque 계산 위해 열별로 합 구하기
    steps_T=[1:1:div*period+1]';                             % Torque의 Step
    
    [R1 R2]=max(fr(:));                                 % 전체 데이터의 최대값 계산
    [R3 R4]=ind2sub(size(fr), R2);                      % 최대값
    
    fr_T=fr(R3, 1:end)';                           % Radial 방향의 시간적 Force 추출
    fr_T_exp=[steps_T fr_T];
    
    [T1 T2]=max(ft(:));                      % 전체 데이터의 최대값 계산
    [T3 T4]=ind2sub(size(ft), T2);           % 최대값
    
    ft_T=ft(T3, 1:end)';                    % Tangential 방향의 시간적 Force 추출
    ft_T_exp=[steps_T ft_T];
    
    fr_exp=[angle fr];                               % Angle까지 합친 데이터로 export
    ft_exp=[angle ft];                               % Angle까지 합친 데이터로 export
    Torque=[steps_T calc_Torque'];                    % Step까지 합친 데이터로 계산된 Torque Export
    
%     Radial=[];                       %  Header 생성을 위한 작업
%     for z1=1:div*period+1
%     Radial_string=['Radial Force' ,num2str(z1), 'Step'];
%     Radial_b=[Radial Radial_string];
%     Radial=cellstr(Radial_b);
%     end
%     
%     Tangential=[];                 %  Header 생성을 위한 작업
%     for z2=1:div*period+1
%     Tangential_string=['Tangential Force' ,num2str(z2), 'Step'];
%     Tangential_b=[Tangential Tangential_string];
%     Tangential=cellstr(Tangential_b);
%     end   
    
%     headers = cellstr(['Angle', Radial]);
%     csvwrite_with_headers('Output\',num2str(T(k)),'Nm@',num2str(rpm(k)),'rpm_Radial_Force.csv',fr_exp,headers);
%     headers = ['Angle',Tangential];
%     csvwrite_with_headers('Output\',num2str(T(k)),'Nm@',num2str(rpm(k)),'rpm_Tangential_Force.csv',ft_exp,headers);    
    
%     headers = ['Step','Calculated Torque'];
%     csvwrite_with_headers('Output\',num2str(T(k)),'Nm@',num2str(rpm(k)),'rpm_calculated_Torque.csv',Torque,headers);    

    fname_Fr=['Output\',num2str(T(k)),'Nm@',num2str(rpm(k)),'rpm_Radial_Force.csv'];   % csv write 할 이름/경로 설정. 미리해야 에러안남
    csvwrite(fname_Fr,fr_exp);
    
    fname_Ft=['Output\',num2str(T(k)),'Nm@',num2str(rpm(k)),'rpm_Tangential_Force.csv'];     % csv write 할 이름/경로 설정. 미리해야 에러안남
    csvwrite(fname_Ft,ft_exp);  
    
    fname_Fr_T=['Output\',num2str(T(k)),'Nm@',num2str(rpm(k)),'rpm_Radial_Force_Time.csv'];
    csvwrite(fname_Fr_T,fr_T_exp); 
    
    fname_Ft_T=['Output\',num2str(T(k)),'Nm@',num2str(rpm(k)),'rpm_Tangential_Force_Time.csv'];
    csvwrite(fname_Ft_T,ft_T_exp); 
    
    fname_T=['Output\',num2str(T(k)),'Nm@',num2str(rpm(k)),'rpm_calculated_Torque.csv'];     % csv write 할 이름/경로 설정. 미리해야 에러안남
    csvwrite(fname_T,Torque); 
    
    disp([num2str(T(k)),'Nm@',num2str(rpm(k)),'RPM_Force Calculation_완료']);
    disp(' ');   
    
end

