%% IN THE NAME OF ALLAH

% Project: Test

clear all
clc

filefolder = 'C:\SSVEP_datas\Masih_Pack\4.1.92\triplets\masih14_16_12\masih001';
% filefolder = 'C:\SSVEP_datas\Masih_Pack\4.1.92\triplets\masih6_8_10\masih001';
% filefolder = 'C:\SSVEP_datas\Masih_Pack\4.1.92\triplets\masih16_12_14\masih001';

filename = '\masihS001R01.dat';   %name of data which we are using
filename=strcat(filefolder,filename);

%% Paramaeters 
Fs=128;
time_interval=4;
expected_f = 12;
valid_start=15;
valid_end=5;

%% Loading from recorded file
[ signal, states, parameters] = load_bcidat( filename );


beta_vector=0.28:0.02:0.36;
time_interval_vector=1:5;
M=zeros(size(beta_vector,2),size(time_interval_vector,2));

for row=1:size(beta_vector,2)
    for col=1:size(time_interval_vector,2)
        
        beta=beta_vector(row);
        time_interval=time_interval_vector(col);
        
        N_Block=floor(size(signal,1)/128/time_interval);
        results=zeros(1,N_Block);
        block_start=ceil(valid_start/time_interval)+1;
        block_end=ceil(valid_end/time_interval);
        valid_i=block_start:N_Block-block_end;
        N_Block=length(valid_i);
        
        for i=valid_i
            Block=signal((i-1)*Fs*time_interval+1:i*Fs*time_interval ,:)';
            results(i)=MEC_test(Block,i,beta);    
        end
        
        results=results(valid_i);
        percentage=0;
        for i=1:N_Block
            if (results(i)==expected_f)
               percentage=percentage+1; 
            end
        end
        percentage=percentage/N_Block*100;
        %Percentage Done

        M(row,col)=percentage;

    end
end

xlswrite('Percentage_betaThreshold_timeInterval.xlsx',M);

disp('Test Done !');
str=sprintf('Result: %d%%',round(percentage));
disp(str);





%% End








