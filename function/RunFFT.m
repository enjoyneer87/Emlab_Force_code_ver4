function [FFT_data_list, YfreqDomain_list] = RunFFT(y)

y_size=size(y);         % y �� ��� �� ���� �ľ�

YfreqDomain_list=[];   % ���� ����
FFT_data_list = [];  % ���� ����

for i=1:y_size(1,2)         % �� ������ŭ �ݺ�

    y_each=y(:,i);          % �� ������ ����
    Fs = length(y_each); %sampling rate

[YfreqDomain,frequencyRange] = positiveFFT(y_each,Fs);

FFT_data=abs(YfreqDomain);
FFT_data_list=[FFT_data_list FFT_data];                 % ������ FFT ���밪 ������ �ױ�
YfreqDomain_list=[YfreqDomain_list YfreqDomain];        % ������ FFT ������ �ױ�

end



