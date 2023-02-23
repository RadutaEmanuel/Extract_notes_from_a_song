function [y, Fs0] = preProc(x0,Fs0, Fs, Tseg, SIL_THRESH_11, SIL_THRESH_12)

x(1:length(x0),1) = 0;
for i=1:1:length(x0)
    x(i,1) = (x0(i,1) + x0(i,2));
end

x_resampled = resample(x,Fs,Fs0);
minim = min(x_resampled);
maxim = max(x_resampled);

if -minim > maxim
    x_resampled = x_resampled * (-1/minim);
elseif -minim < maxim
    x_resampled = x_resampled * (1/maxim); 
else 
    x_resampled = x_resampled * (1/maxim);  
end
fprintf('\n-> The fitting is done;\n');



signal_power = zeros(80,1); 
cnt_start = 0;              
cnt_stop = 0;               

for i = 1:1:length(x_resampled(:,1))
    signal_power = getPow(x_resampled(i:(i+80),1));            
    if(signal_power < SIL_THRESH_11) x_resampled(i,1) = 0;      
                                     cnt_start = cnt_start+1;  
    else cnt_start = cnt_start+1;                               
         break;
    end
end
for i = length(x_resampled(:,1)):-1:1                          
    signal_power = getPow(x_resampled((i-80):i,1));            
    if(signal_power < SIL_THRESH_12) x_resampled(i,1) = 0;      
                                     cnt_stop = cnt_stop+1;
    else cnt_stop = cnt_stop+1;                                       
         break;
    end
end



Nr_esantioane_utile = length(x_resampled) - cnt_start - cnt_stop + 2;                       
y(1:Nr_esantioane_utile,1) = x_resampled(cnt_start:(length(x_resampled) - cnt_stop + 1),1); 

fprintf('-> The silence frames were analyzed;\n');
end
