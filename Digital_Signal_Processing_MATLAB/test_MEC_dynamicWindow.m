%% IN THE NAME OF ALLAH
% Project:Auto Test MEC

%Changes: No 1s interval

clear all
clc

filefolder = 'C:\SSVEP_datas\Masih_Pack\4.1.92\triplets\masih14_16_12\masih001';
% filefolder = 'C:\SSVEP_datas\Masih_Pack\4.1.92\triplets\masih6_8_10\masih001';
% filefolder = 'C:\SSVEP_datas\Masih_Pack\4.1.92\triplets\masih16_12_14\masih001';

filename = '\masihS001R01.dat';   %name of data which we are using
filename=strcat(filefolder,filename);

%% Paramaeters 
Fs=128;
expected_f = 12;
valid_start=10;
valid_end=1;
total_Block_length_max=4;
beta_begin=.26;
beta_end=0.44;

%% Loading from recorded file
[ signal, states, parameters] = load_bcidat( filename );

beta_vector=beta_begin:0.02:beta_end;
M=zeros(size(beta_vector,2),floor(size(signal,1)/128)+1+1-(valid_start-1)-(valid_end-1)); % ++ for storing percentage

N_Block=floor(size(signal,1)/128); %total 1Sec Blocks
block_start=valid_start;               %--- Some Initialization
block_end=valid_end;
valid_i=block_start:N_Block-block_end;
N_Block=length(valid_i);
total_results=zeros( size(beta_vector,2) , N_Block);

for row=1:size(beta_vector,2)
    
    beta=beta_vector(row);  
    results=zeros(1,N_Block);
    total_Block_length=1;
    i=1; % index of result of i classification
    start_block_index=valid_i(1);
    
    
    while(start_block_index + total_Block_length -1 <=valid_i(length(valid_i)))      %total signal should be classified in this for     % For Each Beta
        
        Block=signal((start_block_index + total_Block_length -1-1)*Fs+1:(start_block_index + total_Block_length -1)*Fs,:)'; %New Block Ny*Nt
        
        if (total_Block_length==1) %Beggining classification of this time  total_Block_length == 1
           total_Block=Block;
           results(i)=0; %change MEC_beta(total_Block,i,beta);
           if (results(i)==0) % BAD class.
               total_Block_length=total_Block_length+1;  % length ++  
               continue;
           end
           
           %Good Class.
           M(row,i+1)=total_Block_length;
           i=i+1;
           results(i)=-1;
           start_block_index=start_block_index+1;
           continue;
        end 
        
        if (total_Block_length > 1)% if total_Block_length ~= 1  Growing window or Saturated window
            total_Block=[total_Block      Block]; % added new block
            tB=size(total_Block,2)/Fs;
            
            if (tB >= total_Block_length_max)   % Saturated window
                total_Block = total_Block (:,(tB-total_Block_length_max)*Fs+1:tB*Fs); 
            end
            
            results(i)=MEC_beta(total_Block,i,beta);%Classify

            if (results(i)== 0)%BAD classify
                if (total_Block_length ==  total_Block_length_max)
                    start_block_index=start_block_index+1;% Saturated window
                else
                    total_Block_length=total_Block_length+1;  % length ++  
                end
                continue;% Next getting Block
            end

            %Good Classify
            M(row,i+1)=total_Block_length;
            i=i+1;
            results(i)=-1;
            start_block_index=start_block_index+total_Block_length;
            total_Block_length=1;
                       
        end
        
            
    end %Total 1 min data processed for 1 beta
    
    
    
    percentage=0;
    for j=1:i-1
        if (results(j)==expected_f)
           percentage=percentage+1; 
        end
    end
    percentage=percentage/(i-1)*100;
    %Percentage Done

    M(row,1)=percentage;
    total_results(row,:)=results;
end

delete('Percentage_betaThreshold_windowSizes.xlsx','total_results.xlsx');

M=[beta_vector' sum(M(:,2:size(M,2)),2)    M];
xlswrite('Percentage_betaThreshold_windowSizes.xlsx',M);

xlswrite('total_results.xlsx',total_results);

disp('Test Done !');
str=sprintf('Result: %d%%',round(percentage));
disp(str);





%% End








