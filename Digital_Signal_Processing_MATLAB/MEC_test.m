function freqResult=MEC_test(signal,current_n,beta)
% Input: signal Ny*Nt

signal=signal';
%% Functions Enabling 
CMA_filter=1;
FFT_HP_IFFT=1;
exp_transform=0;
mid_freqs=0;
consider_threshhold=1;

%% Defining Parameteres

f=[8 10 12 14 16];             %frequencies in concern
Fs = 128;           %Sampling frequency of Emotive
O1=7;               %| Name and number of channals 
O2=8;
T7=5;
T8=10;
Nh=2;               %#of Harmonics 
Ny=4;               %#of using Channals
alfa_energy_co=0.25;    %alfa as in the last section of paper#3
beta_classification=beta;    %beta as in the last section of paper#3
valid_channal=[1 2 3 4 6 9 11 12 13 14]; %Valid Channals except using channals (O1, O2, T7 , T8) to use in CMA
cutting_freq=5;  %freq at which HP filter work

%% Calculating Needed Parameteres 
if (mid_freqs)
    %freqs in concern (including mid Freqs)
    midFreq=diff(f)/2+f(1:length(f)-1);
    f=horzcat(f,midFreq);
    %--> f=[ freqs in concern + mid freqs]
end

Nf=length(f);

%Filtering CMA
if (CMA_filter)
left_signal = double (signal (:,valid_channal));
EEG_background_signal = mean(left_signal,2);
EEG_background_signal_all= repmat(EEG_background_signal,1,Ny);
end

%Deriving subSignals and Y
yO1= double (signal (:,O1)); %for DP floating point (e.g. SVM)
yO2= double (signal (:,O2)); %Subtracting EEG background signal
yT7= double (signal (:,T7));
yT8= double (signal (:,T8));

Nt=length(yO1);

Y=zeros(Nt,Ny);
Y(:,1)=yO1;
Y(:,2)=yO2;
Y(:,3)=yT7;
Y(:,4)=yT8;  %* Here add if you want to add real channals, Also change Ny in "paramateres" 

if (CMA_filter)
    Y=Y-EEG_background_signal_all;
end

if (FFT_HP_IFFT)
    fft_Y=fft(Y);
    m_start=floor(cutting_freq/Fs*Nt+1);  
    m_end=floor(Nt-cutting_freq/Fs*Nt); 
    fft_Y(1:m_start,:)=0;
    fft_Y(m_end:Nt,:)=0;
    Y=ifft(fft_Y);
end


%% Calculating X Matris
t=linspace(0,Nt/Fs,Nt);
X=zeros(Nf,Nt,2*Nh);
for j=1:Nf
    for i=1:Nh
        X(j,:,2*i-1)=sin(2*pi*i*f(j)*t);
        X(j,:,2*i)  =cos(2*pi*i*f(j)*t);
    end
end


% Calculating Ytild
Ytild=zeros(Nf,Nt,Ny);
for i=1:Nf
    X_this_freq= squeeze(X(i,:,:));  
    Ytild(i,:,:)=Y-X_this_freq*inv(( (X_this_freq')*X_this_freq))*(X_this_freq')*Y;
end

%% Calculating Ytild_trans*Ytild=Yeig  and eigs  and W eights

Yeig=zeros(Nf,Ny,Ny);
Ns=Ny;              %#of Artificial Channals
for i=1:Nf
   Yeig(i,:,:)=(squeeze(Ytild(i,:,:)))'*squeeze(Ytild(i,:,:));
end
W=zeros(Nf,Ny,Ns);
for i=1:Nf
    [V,D]=eig(squeeze(Yeig(i,:,:)));
    eigValues=diag(D)';
    sqrt_eigValues=sqrt(eigValues);
    [sorted_eigvalues,n]=sort(sqrt_eigValues);
    sorted_vectors=V(:,n);
    W(i,:,:)=sorted_vectors./repmat(sqrt_eigValues,Ny,1) ;   
end

%% Calculating S 

S=zeros(Nf,Nt,Ns);
for i=1:Nf
   W_this=squeeze(W(i,:,:));
   S(i,:,:)=Y*W_this;
end

%% Calculating P_hat & P & P_prim

P_hat=zeros(1,Nf);
for i=1:Nf
    % for each freq
    S_this=squeeze(S(i,:,:));
    X_this=squeeze(X(i,:,:));
    for l=1:Ns
       for k=1:Nh
          P_hat(i)=P_hat(i)+ norm(X_this(:,k)'*S_this(:,l))^2;
       end
    end
    
end

P_hat=P_hat/(Ns*Nh);
%P_hat Done 

P=P_hat/sum(P_hat);
P_prim=P;
if (exp_transform)
   P_prim=exp(alfa_energy_co*P)/sum(exp(alfa_energy_co*P));    
end

% name_str=sprintf('P_prim_data_%d.mat',current_n);% Just to save online datas
% save(name_str,'P_prim'); 

%% Classification

[maxP_prim argmax_P_prim]=max(P_prim);
if (argmax_P_prim<=Nf)
   if (P_prim(argmax_P_prim)>=beta_classification)
      freqResult=f (argmax_P_prim);   %print out result
      return;
   else
       if (consider_threshhold==0)
            freqResult=f (argmax_P_prim);   %print out result
            return;
       end
   end
end


%% 
freqResult=0;


end