function [resultString,total_Block_length,total_Block_length_max,total_Block,phone_number] = processSignal(signalProcessingBlock,n,total_Block_length,total_Block_length_max,total_Block,phone_number,Fs,beta)


%% Just save input data to check
% name_str=sprintf('fieldtripBuffer_data_%d.mat',n);% Just to save online datas
% save(name_str,'signalProcessingBlock'); 

%% Parameters
DWS=1;

%% Calculating results
display(sprintf('Block Length: %d',total_Block_length));



%% DWS begin
if (DWS)
    if (total_Block_length == 1) %Beggining classification of this time  total_Block_length == 1
       total_Block=signalProcessingBlock;
       result=-7;%change MEC_beta(signalProcessingBlock,n,beta);
       resultString=int2str(result);%Processing signals
       if (result == -7) % BAD class.
           total_Block_length=total_Block_length+1;  % length ++  
           return;
       end

       %Good Class.
       %phone_number=[phone_number result];  %1s Window is not valid for us
       return;
    end 

    if (total_Block_length > 1)% if total_Block_length ~= 1  Growing window or Saturated window
        total_Block=[total_Block      signalProcessingBlock]; % added new block   CONCAT
        tB=size(total_Block,2)/Fs;    %total Block 

        if (tB >= total_Block_length_max)   % Saturated window
            total_Block = total_Block (:,(tB-total_Block_length_max)*Fs+1:tB*Fs);  %choose the most updated ones
            total_Block_length=total_Block_length_max;  %limit the total length to max length
        end

        result=MEC_beta(signalProcessingBlock,n,beta);% Classify
        resultString=int2str(result);

        if (result == -7)%BAD classify
            total_Block_length=total_Block_length+1;  % length ++  
            return;% Next getting Block
        end

        %Good Classify
        total_Block_length=1;
        if (result==10)% if Backspace
            phone_number=phone_number(1:length(phone_number)-1);
        else                 % otherwise
            phone_number=[phone_number result];


            %Sound begin
            cd('audio-numbers');        
            sound_file_name=sprintf('%d.wav',result);
            [sound_signal,Freq_sound]=audioread(sound_file_name);
            player = audioplayer(sound_signal, Freq_sound);
            play(player)
            while( player.isplaying())
                pause(0.05);
            end
            cd('..\');
            %Sound end

        end
    end
else                        %if Fixed time window    
    result=MEC_beta(signalProcessingBlock,n,beta);% Classify
    resultString=int2str(result);
    %Good Classify
        
    if (result==10)% if Backspace
        phone_number=phone_number(1:length(phone_number)-1);
    else                 % otherwise
        phone_number=[phone_number result];


        %Sound begin
        cd('audio-numbers');        
        sound_file_name=sprintf('%d.wav',result);
        [sound_signal,Freq_sound]=audioread(sound_file_name);
        player = audioplayer(sound_signal, Freq_sound);
        play(player)
        while( player.isplaying())
            pause(0.05);
        end
        cd('..\');
        %Sound end

    end
end

end




