function [FFT_data_list, YfreqDomain_list] = RunFFT(y)

y_size=size(y);         % y 의 행과 열 갯수 파악

YfreqDomain_list=[];   % 변수 정의
FFT_data_list = [];  % 변수 정의

for i=1:y_size(1,2)         % 열 갯수만큼 반복

    y_each=y(:,i);          % 열 데이터 저장
    Fs = length(y_each); %sampling rate

[YfreqDomain,frequencyRange] = positiveFFT(y_each,Fs);

FFT_data=abs(YfreqDomain);
FFT_data_list=[FFT_data_list FFT_data];                 % 열별로 FFT 절대값 데이터 쌓기
YfreqDomain_list=[YfreqDomain_list YfreqDomain];        % 열별로 FFT 데이터 쌓기

end



