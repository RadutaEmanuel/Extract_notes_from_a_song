function [F_peaks, A_peaks] = transSound(x_frm, ENGINE, Fs, F, SIL_THRESH_2, PEAK_THRESH)
switch(ENGINE)
    case 'PSD'
    for i = 1:1:length(x_frm(1,:))                                  %parcurgem toate coloanele cadrele
        frame_power = getPow(x_frm(:,i));                           %verificam daca avem de aface cu o pauza
        if(frame_power < SIL_THRESH_2)                              %daca avem atunci o eliminam (intensitate 0 si frecventa 0)                      
            A_peaks(1,i) = 0;                               
            F_peaks(1,i) = 0;                              
        else
            [Pxx,Frecv] = periodogram(x_frm(:,i),[],[],Fs);         %daca nu e pauza calculam densitatea spectrala a cadrului
            [PKS,LOCS] = findpeaks(Pxx,"MinPeakHeight",0.00001);    %ne intereseaza primul varf relevant de aceea in cazul melodiei 2.1 am ales varfurile mai mari de 0.00001
            if(length(PKS)~=0 && PKS(1) < PEAK_THRESH)              %verificam data daca a fost gasita o nota si daca nu cumva este o pauza
                A_peaks(1,i) = PKS(1);                              %completam vectorii cu intensitati si frecvente
                F_peaks(1,i) = Frecv(LOCS(1));                
            else                                         
                A_peaks(1,i) = 0;
                F_peaks(1,i) = 0;
            end
        end
    end
    [F_peaks] = rounder(F_peaks);                                   %rotunjim frecventele gasite utilizand rounder
    case 'autoCorr'
        density_power = 0;
        %Rxx = zeros(2*length(x_frm(:,1)),1);
        %n   = zeros(1,2*length(x_frm(:,1)));

n_frm = 4096;
X_FRM = zeros(n_frm,1);
y_frm = zeros(length(x_frm(:,1)),1);
%Ryy = zeros(2*length(y_frm(:,1)),1);
%w = zeros(1,2*length(y_frm(:,1)));
k = 0;
j = 0;

for i = 1:1:length(x_frm(1,:))
    density_power = getPow(x_frm(:,i));
    if density_power < SIL_THRESH_2 
        F_peaks(1,i) = 0;
        A_peaks(1,i) = 0;
    else
        [Rxx, n] = xcorr(x_frm(:,i),'unbiased');
        [PEAKS,LOCS] = findpeaks(Rxx((((length(Rxx)+1)/2)+5):(((length(Rxx)+1)/2)+160)),"MinPeakHeight",0.01);
        if (length(PEAKS)~=0) & (length(LOCS)~=0)
            F_peaks(1,i) = Fs/LOCS(1,1);
            A_peaks(1,i) = PEAKS(1,1);
        else
            F_peaks(1,i) = 0;
            A_peaks(1,i) = 0;
        end
        if k==0
            X_FRM = fft(x_frm(:,i),n_frm);
            X_FRM = abs(X_FRM);
            y_frm = x_frm;
            k = 1;
            j = i;
        end
    end          
    fprintf('density %d este %d\n',i,density_power);
end

[F_peaks] = rounder(F_peaks);

[Ryy, w] = xcorr(y_frm(:,1),'unbiased');
Ryy = Ryy((((length(Ryy)+1)/2)+10):(((length(Ryy)+1)/2)+100));
w = w((length(w)+1)/2+10:(length(w)+1)/2+100);
[D_peaks,esantioane] = findpeaks(Ryy,"MinPeakWidth",10);
fprintf('lenght x_frm %d length X_FRM %d fereastra %d\n',length(x_frm(:,1)),length(X_FRM(:,1)),j);
fprintf('peaks amp %d at %d\n',D_peaks(1,1),esantioane(1,1));
figure()
plot((1:n_frm)*Fs/n_frm,X_FRM);
figure()
plot(w, Ryy);
end

% function [F_peaks, A_peaks] = transSound(x_frm, ENGINE, Fs, F, SIL_THRESH_2,PEAK_THRESH, xBank)
% 	    for i = 1:1:length(x_frm(1,:))                          
%             frame_power = getPow(x_frm(:,i));                  
%             if(frame_power < SIL_THRESH_2)                                                     
%                 F_peaks(1,i) = 0;
%             else
%                 for j=1:1:25
%                     [Rxx, n] = xcorr(x_frm(:,i),xBank(:,j),'unbiased');
%                     A_peaks(1,j) = max(Rxx);
%                 end
%                 if(max(A_peaks)<PEAK_THRESH)
%                     F_peaks(1,i) = Fs/max(A_peaks);
%                 else
%                     F_peaks(1,i) = 0;
%                 end
%             end
% end

end