function skew_data_avg(Input, k, floor, T, rpm)

Torque = zeros(Input.Division+1, 2);
Br = zeros(Input.circum_div, Input.Division+2);
Bt = zeros(Input.circum_div, Input.Division+2);

Torque_file = ['Torque/',num2str(T(k)),'Nm@',num2str(rpm(k)),'RPM_Torque.csv'];
Br_file = ['Br/',num2str(T(k)),'Nm@',num2str(rpm(k)),'rpm_br.csv'];
Bt_file = ['Bt/',num2str(T(k)),'Nm@',num2str(rpm(k)),'rpm_bt.csv'];

fid_T = fopen(Torque_file, 'r');
if fid_T > 0
    disp([num2str(T(k)),'Nm@',num2str(rpm(k)),'rpm 결과 파일 존재']);
    fclose(fid_T);
    return;
end

for f = 1:1:floor
    
    f_name = ['Torque/',num2str(T(k)),'Nm@',num2str(rpm(k)),'RPM_Torque_', num2str(f), 'th.csv'];
    Torque_data = xlsread(f_name);
%     Torque_data = Torque_data(:, 2);
    Torque = Torque + Torque_data/floor;
    
    f_name = ['Br/',num2str(T(k)),'Nm@',num2str(rpm(k)),'rpm_br_', num2str(f), 'th.csv'];
    Br_data = xlsread(f_name);
    Br = Br + Br_data/floor;
    
    f_name = ['Bt/',num2str(T(k)),'Nm@',num2str(rpm(k)),'rpm_bt_', num2str(f), 'th.csv'];
    Bt_data = xlsread(f_name);
    Bt = Bt + Bt_data/floor;
    
end


csvwrite(Torque_file, Torque);
csvwrite(Br_file, Br);
csvwrite(Bt_file, Bt);