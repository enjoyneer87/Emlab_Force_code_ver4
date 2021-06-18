function make_vbs_for_BrBt(Input)

rpm=Input.RPM;                  % ������ rpm
T=Input.Torque;                 % ������ ��ũ
current=Input.Current;          % ������ ����
phase=Input.PhaseAngle;         % ���� ����

skew=Input.skew;           % Skew On-Off ����
floor=Input.skew_floor;    % Skew �ܼ� ����
angle=Input.initial_angle; % Initial Angle ����
skew_angle=Input.skew_angle;  % Skew ������ ����
    
for k=1:length(T)
    if (skew == 0)
        
        if exist('Run_For_Get_BrBt.vbs', 'file')   % vbs���� ������ ����
            delete('Run_For_Get_BrBt.vbs');    
        end
     
        f_name=['Torque/',num2str(T(k)),'Nm@',num2str(rpm(k)),'RPM_Torque.csv'];    
        fid_T = fopen(f_name, 'r');       
        % ���� �����Ͱ� �ִ� �ؼ����� �ؼ��� �������� ����
        if fid_T>0
            disp([num2str(T(k)),'Nm@',num2str(rpm(k)),'RPM_Torque.csv','-����']);
            
            fclose(fid_T);
            continue;
        end 
         
        Run_For_Get_BrBt(Input, k);
        winopen('Run_For_Get_BrBt.vbs');
        while fid_T < 0
            pause(10);
            fid_T = fopen(f_name, 'r');
        end
        disp([num2str(T(k)),'Nm@',num2str(rpm(k)),'RPM_Torque.csv','-�Ϸ�']);
        fclose(fid_T);
        
    else
        
        interval=skew_angle/floor;
        total_angle=angle-(skew_angle-interval)/2;
        
        for f = 1:1:floor
            if exist('Run_For_Get_BrBt_skew.vbs', 'file')   % vbs���� ������ ����
                delete('Run_For_Get_BrBt_skew.vbs');    
            end
            
            f_name=['Torque/',num2str(T(k)),'Nm@',num2str(rpm(k)),'RPM_Torque_', num2str(f), 'th.csv'];    
            fid_T = fopen(f_name, 'r');       
            % ���� �����Ͱ� �ִ� �ؼ����� �ؼ��� �������� ����
            if fid_T>0
                disp([num2str(T(k)),'Nm@',num2str(rpm(k)),'RPM_Torque_', num2str(f), 'th.csv','-����']);
                total_angle = total_angle+interval;
                fclose(fid_T);
                continue;
            end 
         
            Run_For_Get_BrBt_skew(Input, k, f, total_angle);
            winopen('Run_For_Get_BrBt_skew.vbs');
            total_angle = total_angle+interval;
            while fid_T < 0
                pause(10);
                fid_T = fopen(f_name, 'r');
            end
            disp([num2str(T(k)),'Nm@',num2str(rpm(k)),'RPM_Torque_', num2str(f),'th.csv','-�Ϸ�']);
            fclose(fid_T);
        end
        
        skew_data_avg(Input, k, floor, T, rpm);
        
    end
end
      
disp('Vbs_Run_For_Get_BrBt End');
