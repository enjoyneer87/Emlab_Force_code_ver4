function make_vbs_for_BrBt(Input)

rpm=Input.RPM;                  % 운전점 rpm
T=Input.Torque;                 % 운전점 토크
current=Input.Current;          % 운전점 전류
phase=Input.PhaseAngle;         % 위상각 설정

skew=Input.skew;           % Skew On-Off 정의
floor=Input.skew_floor;    % Skew 단수 정의
angle=Input.initial_angle; % Initial Angle 정의
skew_angle=Input.skew_angle;  % Skew 적용할 각도
    
for k=1:length(T)
    if (skew == 0)
        
        if exist('Run_For_Get_BrBt.vbs', 'file')   % vbs파일 있으면 삭제
            delete('Run_For_Get_BrBt.vbs');    
        end
     
        f_name=['Torque/',num2str(T(k)),'Nm@',num2str(rpm(k)),'RPM_Torque.csv'];    
        fid_T = fopen(f_name, 'r');       
        % 기존 데이터가 있는 해석점은 해석을 수행하지 않음
        if fid_T>0
            disp([num2str(T(k)),'Nm@',num2str(rpm(k)),'RPM_Torque.csv','-존재']);
            
            fclose(fid_T);
            continue;
        end 
         
        Run_For_Get_BrBt(Input, k);
        winopen('Run_For_Get_BrBt.vbs');
        while fid_T < 0
            pause(10);
            fid_T = fopen(f_name, 'r');
        end
        disp([num2str(T(k)),'Nm@',num2str(rpm(k)),'RPM_Torque.csv','-완료']);
        fclose(fid_T);
        
    else
        
        interval=skew_angle/floor;
        total_angle=angle-(skew_angle-interval)/2;
        
        for f = 1:1:floor
            if exist('Run_For_Get_BrBt_skew.vbs', 'file')   % vbs파일 있으면 삭제
                delete('Run_For_Get_BrBt_skew.vbs');    
            end
            
            f_name=['Torque/',num2str(T(k)),'Nm@',num2str(rpm(k)),'RPM_Torque_', num2str(f), 'th.csv'];    
            fid_T = fopen(f_name, 'r');       
            % 기존 데이터가 있는 해석점은 해석을 수행하지 않음
            if fid_T>0
                disp([num2str(T(k)),'Nm@',num2str(rpm(k)),'RPM_Torque_', num2str(f), 'th.csv','-존재']);
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
            disp([num2str(T(k)),'Nm@',num2str(rpm(k)),'RPM_Torque_', num2str(f),'th.csv','-완료']);
            fclose(fid_T);
        end
        
        skew_data_avg(Input, k, floor, T, rpm);
        
    end
end
      
disp('Vbs_Run_For_Get_BrBt End');
