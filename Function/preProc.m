function [y, Fs0] = preProc(x0,Fs0, Fs, Tseg, SIL_THRESH_11, SIL_THRESH_12)

x(1:length(x0),1) = 0;
for i=1:1:length(x0)
    x(i,1) = (x0(i,1) + x0(i,2));
end

x_resampled = resample(x,Fs,Fs0);
minim = min(x_resampled);
maxim = max(x_resampled);

if -minim > maxim
    x_resampled = x_resampled * (-1/minim); % daca valoarea minima in modul este mai mare decat valoarea maxima scalam cu -1/minim pentru ca limita valorilor sa fie intre 1 si -1
elseif -minim < maxim
    x_resampled = x_resampled * (1/maxim);  % daca valoarea maxima mai mare decat valoarea minima in modul scalam cu 1/maxim pentru ca limita valorilor sa fie intre 1 si -1
else 
    x_resampled = x_resampled * (1/maxim);  % daca valoarea minima in modul si valoarea maxima sunt egale, scalam cu 1/maxim
end
fprintf('\n-> The fitting is done;\n');

% Facem spectrul de putere al semnalului

signal_power = zeros(80,1); % initialize the power density vector as 80 of 0
cnt_start = 0;              % retains the index of the first good value in the first 5ms frame
cnt_stop = 0;               % retains the index of the last good value in the last 5ms frame

for i = 1:1:length(x_resampled(:,1))
    signal_power = getPow(x_resampled(i:(i+80),1));             % in each 5ms frame compute the mean power of the frame
    if(signal_power < SIL_THRESH_11) x_resampled(i,1) = 0;      % search for the first 5ms frame that has the mean density power higher than the SIL_TRESH_11
                                     cnt_start = cnt_start+1;   % increase the index of the first good value for the first 5ms frame with the mean power density over SIL_TRESH_11
    else cnt_start = cnt_start+1;                               % the first value in the first 5ms frame that we will retain
         break;
    end
end
for i = length(x_resampled(:,1)):-1:1                           % starting from the last element search for the last frame that has the mean power density over SIL_TRESH_12
    signal_power = getPow(x_resampled((i-80):i,1));             % in each 5ms frame compute the mean power of the frame
    if(signal_power < SIL_THRESH_12) x_resampled(i,1) = 0;      
                                     cnt_stop = cnt_stop+1;
    else cnt_stop = cnt_stop+1;                                 % the last value of the last 5ms frame we retain       
         break;
    end
end

% Scapam de elementele de la inceput daca sunt mai mici decat SIL_THRESH_11 sau de elementele de la sfarsit daca sunt mai mici decat SIL_THRESH_12

Nr_esantioane_utile = length(x_resampled) - cnt_start - cnt_stop + 2;                       % the number of usefull values that we kept
y(1:Nr_esantioane_utile,1) = x_resampled(cnt_start:(length(x_resampled) - cnt_stop + 1),1); % the final vector with only the usefull values

fprintf('-> The silence frames were analyzed;\n');
end
