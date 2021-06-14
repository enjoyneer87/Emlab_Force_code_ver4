function brbt_calculation(Input)

u0=4*pi*(10^-7);
Lstk = Input.Lstk;

rpm=Input.RPM;                  % ������ rpm
T=Input.Torque;                 % ������ ��ũ
div = Input.Division;            % �ؼ��� division ���� ����
period=Input.Period;            % �ؼ��� ������ �ֱ� ����
periodic=Input.Periodic ;           % ����� �ֱ� ����
periodic_force=360/periodic;        % Force�� ��������� ��� �ݺ�����

radius = Input.radius;              % force ������ ������ ���� ����
circum_div = Input.circum_div;      % ���ֹ��� div ���� ����
slot=Input.Slot;


for k=1:length(T)
    
    f_name_Br = ['Br/' ,num2str(T(k)),'Nm@',num2str(rpm(k)),'rpm_br','.csv'];  % Br ���� �б�
    br_raw=xlsread(f_name_Br);
    
    f_name_Bt = ['Bt/' ,num2str(T(k)),'Nm@',num2str(rpm(k)),'rpm_bt','.csv'];  % Bt ���� �б�
    bt_raw=xlsread(f_name_Bt);
    
    angle_be=br_raw(:,1);                                  % Angle �����͸� ����
    
    rtheta=radius*2*pi()/periodic_force/circum_div;                    % Rtheta ���
    
    br=br_raw(:,2:end);                                 % Br ���� Angle �����ϰ� Br�� ����
    bt=bt_raw(:,2:end);                                 % Bt ���� Angle �����ϰ� Br�� ����                   
    
    fr_be = (br.*br - bt.*bt)/(2*u0)*rtheta*Lstk;              % Radial Force ���
    ft_be = (br.*bt)/u0*rtheta*Lstk;                           % Tangential Force ���
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
    
    before_calc_Torque=ft*radius;                           % Torque ����
    calc_Torque=sum(before_calc_Torque);                    % Torque ��� ���� ������ �� ���ϱ�
    steps_T=[1:1:div*period+1]';                             % Torque�� Step
    
    [R1 R2]=max(fr(:));                                 % ��ü �������� �ִ밪 ���
    [R3 R4]=ind2sub(size(fr), R2);                      % �ִ밪
    
    fr_T=fr(R3, 1:end)';                           % Radial ������ �ð��� Force ����
    fr_T_exp=[steps_T fr_T];
    
    [T1 T2]=max(ft(:));                      % ��ü �������� �ִ밪 ���
    [T3 T4]=ind2sub(size(ft), T2);           % �ִ밪
    
    ft_T=ft(T3, 1:end)';                    % Tangential ������ �ð��� Force ����
    ft_T_exp=[steps_T ft_T];
    
    fr_exp=[angle fr];                               % Angle���� ��ģ �����ͷ� export
    ft_exp=[angle ft];                               % Angle���� ��ģ �����ͷ� export
    Torque=[steps_T calc_Torque'];                    % Step���� ��ģ �����ͷ� ���� Torque Export
    
%     Radial=[];                       %  Header ������ ���� �۾�
%     for z1=1:div*period+1
%     Radial_string=['Radial Force' ,num2str(z1), 'Step'];
%     Radial_b=[Radial Radial_string];
%     Radial=cellstr(Radial_b);
%     end
%     
%     Tangential=[];                 %  Header ������ ���� �۾�
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

    fname_Fr=['Output\',num2str(T(k)),'Nm@',num2str(rpm(k)),'rpm_Radial_Force.csv'];   % csv write �� �̸�/��� ����. �̸��ؾ� �����ȳ�
    csvwrite(fname_Fr,fr_exp);
    
    fname_Ft=['Output\',num2str(T(k)),'Nm@',num2str(rpm(k)),'rpm_Tangential_Force.csv'];     % csv write �� �̸�/��� ����. �̸��ؾ� �����ȳ�
    csvwrite(fname_Ft,ft_exp);  
    
    fname_Fr_T=['Output\',num2str(T(k)),'Nm@',num2str(rpm(k)),'rpm_Radial_Force_Time.csv'];
    csvwrite(fname_Fr_T,fr_T_exp); 
    
    fname_Ft_T=['Output\',num2str(T(k)),'Nm@',num2str(rpm(k)),'rpm_Tangential_Force_Time.csv'];
    csvwrite(fname_Ft_T,ft_T_exp); 
    
    fname_T=['Output\',num2str(T(k)),'Nm@',num2str(rpm(k)),'rpm_calculated_Torque.csv'];     % csv write �� �̸�/��� ����. �̸��ؾ� �����ȳ�
    csvwrite(fname_T,Torque); 
    
    disp([num2str(T(k)),'Nm@',num2str(rpm(k)),'RPM_Force Calculation_�Ϸ�']);
    disp(' ');   
    
end

