function Run_For_Get_BrBt_skew(Input, k, f, total_angle)

current_path = [pwd '/'];
current_path = strrep(current_path,'\','/');

p=Input.Pole;                       % �ؼ� ����
circum_div = Input.circum_div;      % ���ֹ��� div ���� ����
radius = Input.radius*1000;              % force ������ ������ ���� ���� /  �տ��� m�� �ٽ� mm�� �ٲ��־�� ��
div = Input.Division;                  % �ؼ��� division ���� ����

motion=Input.Motion_Condi;                    % Motion Condition �̸� ����

rpm=Input.RPM;                  % ������ rpm
T=Input.Torque;                 % ������ ��ũ
current=Input.Current;          % ������ ����
phase=Input.PhaseAngle;         % ���� ����
period=Input.Period(k);            % �ؼ��� ������ �ֱ� ����
e_step=div*period+1;                % �ֱ⿡ ���� ������ stpe�� ����

freq=rpm(k)*p/120;
freq_str=num2str(freq,'%10.8f');
time=1/freq;
time_str=num2str(time,'%10.8f');
current_str=num2str(current(k),'%10.8f');
phase_str=num2str(phase(k),'%10.8f');
total_angle_str=num2str(total_angle,'%10.8f');

fid = fopen('Run_For_Get_BrBt_skew.vbs','w');

fprintf(fid, '\nSet study = designer');    
fprintf(fid, ['\nCall study.Load("' current_path Input.JMAG_name_for_ForceCalculation '")']);

if (k>1 && f==1)
   fprintf(fid, ['\nCall study.SetCurrentStudy(',num2str(k-2),')']);
   fprintf(fid, ['\nCall study.GetModel(0).DuplicateStudyName("Torque:',num2str(T(k-1)),'Nm@',num2str(rpm(k-1)),'", "Torque:',num2str(T(k)),'Nm@',num2str(rpm(k)),'")']);  % Study �����ϴ� ��
end

if f > 1
    fprintf(fid, ['\nCall study.GetModel(0).GetStudy(',num2str(k-1),').DeleteResult()']);
end


fprintf(fid, ['\nCall study.GetModel(0).GetStudy(',num2str(k-1),').SetName("Torque:',num2str(T(k)),'Nm@',num2str(rpm(k)),'")']);
fprintf(fid, ['\nCall study.GetModel(0).GetStudy(',num2str(k-1),').GetStep().SetValue("EndPoint",',time_str,')']);                             %�ؼ��ð�
fprintf(fid, ['\nCall study.GetModel(0).GetStudy(',num2str(k-1),').GetStep().SetValue("Step", ',num2str(e_step),')']);                           %step
fprintf(fid, ['\nCall study.GetModel(0).GetStudy(',num2str(k-1),').GetStep().SetValue("StepDivision",',num2str(div),')']);                  %division
fprintf(fid, ['\nCall study.GetModel(0).GetStudy(',num2str(k-1),').GetCondition("' ,motion, '").SetValue("AngularVelocity",',num2str(rpm(k)),')']);            %ȸ���ӵ�
fprintf(fid, ['\nCall study.GetModel(0).GetStudy(',num2str(k-1),').GetCondition("' ,motion, '").SetValue("InitialRotationAngle", ',total_angle_str,')']);   %Initial angle
fprintf(fid, ['\nCall study.GetModel(0).GetStudy(',num2str(k-1),').GetCircuit().GetComponent("CS1").SetValue("Amplitude",',current_str,')']);  %����ũ��
fprintf(fid, ['\nCall study.GetModel(0).GetStudy(',num2str(k-1),').GetCircuit().GetComponent("CS1").SetValue("Frequency",',freq_str,')']);     %���ļ�
fprintf(fid, ['\nCall study.GetModel(0).GetStudy(',num2str(k-1),').GetCircuit().GetComponent("CS1").SetValue("PhaseU",',phase_str,')']);       %����
   
fprintf(fid, ['\nCall study.GetModel(0).GetStudy(',num2str(k-1),').Run()']);        

 %Br ����
fprintf(fid, '\nSet study = designer');    
fprintf(fid, ['\nCall study.SetCurrentStudy(',num2str(k-1),')']);
fprintf(fid, ['\nSet sectiongraph1 = study.GetModel(0).GetStudy(',num2str(k-1),').CreateSectionGraph("',num2str(T(k)),'Nm@',num2str(rpm(k)),'rpm_br")']);    
fprintf(fid, ['\nCall sectiongraph1.SetName("',num2str(T(k)),'Nm@',num2str(rpm(k)),'rpm_br")']);
fprintf(fid, ['\nCall sectiongraph1.SetResultType("MagneticFluxDensity", "")']);
fprintf(fid, ['\nCall sectiongraph1.SetStepsByString("1-',num2str(e_step),'")']);
fprintf(fid, ['\nCall sectiongraph1.SetAirRegionFlag(1)']);    
fprintf(fid, ['\nCall sectiongraph1.SetAirRegionSectionGraph(',num2str(circum_div),')']);
fprintf(fid, ['\nCall sectiongraph1.SetSeparateLines(0)']);    
fprintf(fid, ['\nCall sectiongraph1.SetAbscissa("angle")']);        
fprintf(fid, ['\nCall sectiongraph1.SetArcExpression("0", "0", "0", "0", "0", "1", "',num2str(radius),'", "0", "0", "',num2str(Input.Periodic),'")']);    
fprintf(fid, ['\nCall sectiongraph1.SetArcOffset(0)']);    
fprintf(fid, ['\nCall sectiongraph1.SetResultCoordinate("Cylindrical")']);    
fprintf(fid, ['\nCall sectiongraph1.SetComponent("Radial")']);    
fprintf(fid, ['\nCall sectiongraph1.SetBoundaryCoordinate("Global Rectangular")']);    
fprintf(fid, ['\nCall sectiongraph1.Build()']);    
fprintf(fid, ['\nCall study.GetDataManager().GetGraphModel("',num2str(T(k)),'Nm@',num2str(rpm(k)),'rpm_br").WriteTable("',current_path 'Br/' ,num2str(T(k)),'Nm@',num2str(rpm(k)),'rpm_br_', num2str(f),'th.csv")']);    
    
 %Bt ����
fprintf(fid, '\nSet study = designer');    
fprintf(fid, ['\nCall study.SetCurrentStudy(',num2str(k-1),')']);
fprintf(fid, ['\nSet sectiongraph2 = study.GetModel(0).GetStudy(',num2str(k-1),').CreateSectionGraph("',num2str(T(k)),'Nm@',num2str(rpm(k)),'rpm_bt")']);    
fprintf(fid, ['\nCall sectiongraph2.SetName("',num2str(T(k)),'Nm@',num2str(rpm(k)),'rpm_bt")']);
fprintf(fid, ['\nCall sectiongraph2.SetResultType("MagneticFluxDensity", "")']);
fprintf(fid, ['\nCall sectiongraph2.SetStepsByString("1-',num2str(e_step),'")']);
fprintf(fid, ['\nCall sectiongraph2.SetAirRegionFlag(1)']);    
fprintf(fid, ['\nCall sectiongraph2.SetAirRegionSectionGraph(',num2str(circum_div),')']);
fprintf(fid, ['\nCall sectiongraph2.SetSeparateLines(0)']);    
fprintf(fid, ['\nCall sectiongraph2.SetAbscissa("angle")']);        
fprintf(fid, ['\nCall sectiongraph2.SetArcExpression("0", "0", "0", "0", "0", "1", "',num2str(radius),'", "0", "0", "',num2str(Input.Periodic),'")']);    
fprintf(fid, ['\nCall sectiongraph2.SetArcOffset(0)']);    
fprintf(fid, ['\nCall sectiongraph2.SetResultCoordinate("Cylindrical")']);    
fprintf(fid, ['\nCall sectiongraph2.SetComponent("Theta")']);    
fprintf(fid, ['\nCall sectiongraph2.SetBoundaryCoordinate("Global Rectangular")']);    
fprintf(fid, ['\nCall sectiongraph2.Build()']);    
fprintf(fid, ['\nCall study.GetDataManager().GetGraphModel("',num2str(T(k)),'Nm@',num2str(rpm(k)),'rpm_bt").WriteTable("',current_path 'Bt/' ,num2str(T(k)),'Nm@',num2str(rpm(k)),'rpm_bt_', num2str(f),'th.csv")']); 

fprintf(fid, ['\nSet tabledata = study.GetModel(0).GetStudy(',num2str(k-1),').GetResultTable().GetData("Torque")']);
fprintf(fid, ['\nCall tabledata.WriteTable("',current_path,'Torque/',num2str(T(k)),'Nm@',num2str(rpm(k)),'RPM_Torque_', num2str(f),'th.csv", "Time")']);    

fprintf(fid, ['\nCall study.GetModel(0).GetStudy(',num2str(k-1),').DeleteSectionGraph("',num2str(T(k)),'Nm@',num2str(rpm(k)),'rpm_br")']);
fprintf(fid, ['\nCall study.GetModel(0).GetStudy(',num2str(k-1),').DeleteSectionGraph("',num2str(T(k)),'Nm@',num2str(rpm(k)),'rpm_bt")']);

fprintf(fid,'\nCall study.Save()');
fprintf(fid,'\nCall study.quit');

fclose(fid);   

end