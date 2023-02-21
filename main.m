clear all
close all
clc

%% INPUT PARAMETERS

fprintf('Initializing:\n');
fprintf('-> Assuming: Qnote = 120 BPM, G minor, 4/4 time signature\n');
F = [262, 277, 294, 311, 330, 349, 370, 392, 415, 440, 466, 494, 523, 554, 587, 622, 659, 698, 740, 784, 831, 880, 932, 988, 1047];
Fs = 16000;             % [Hz]
Tw = 0.125;             % [s]
Tseg = 0.005;           % [s]
ENGINE = 'PSD';
%   'autoCorr';              % METHOD I
%   'crossCorrSbank';   % METHOD II
%   'crossCorrWbank';	% METHOD III
%   'PSD';              % METHOD IV
SIL_THRESH_11 = -24;    % [dB]
SIL_THRESH_12 = -36;    % [dB]
SIL_THRESH_2 = -40;     % [dB]
PEAK_THRESH = 0.1;
REP_THRESH = 2; 
crt_file = './recordings/rec2_1.wav'; 
% crt_file = './recordings/rec2_2.wav'; 
% crt_file = './recordings/rec2_3.wav'; 
% crt_file = './recordings/rec2_4.wav'; 
% crt_file = './recordings/rec2_5.wav'; 
msg = '-> Transcription engine: ';
switch ENGINE
    case 'autoCorr', msg = [msg, 'I - Auto-correlation\n'];
    case 'crossCorrSbank', msg = [msg, ...
            'II - Cross-correlation with soundbank\n'];
    case 'crossCorrWbank', msg = [msg, ...
            'III - Cross-correlation with wavebank\n'];
    case 'PSD', msg = [msg, 'IV - Power spectral density\n'];
    otherwise
        msg = [msg, 'ERROR.\n'];
        fprintf(msg)
        return
end
fprintf(msg);
fprintf('-> Parameters:\n');
fprintf('--> Silence removal segment duration: %d ms\n', 1000*Tseg);
fprintf('--> Leading silence threshold: %d dB\n', SIL_THRESH_11);
fprintf('--> Trailing silence threshold: %d dB\n', SIL_THRESH_12);
fprintf('--> Rest silence threshold: %d dB\n', SIL_THRESH_2);
fprintf('--> Peak threshold: %.2f\n', PEAK_THRESH);
fprintf('--> Repeated notes threshold: %d\n', REP_THRESH);
fprintf(['-> Current file: ', crt_file, '\n']);

%% INPUT CONDITIONING

fprintf('Conditioning input:\n')
% Importing audio file:
fprintf('-> Importing audio file: ');
[x0, Fs0] = audioread(crt_file); % x0 a matrix m lines by n columns, m values for x0, n columns for channels(stereo -> 2 channels, more values) 
fprintf('done.\n');
% Preprocessing:
tic
fprintf('-> Preprocessing: ');
[x, Fs0 ] = preProc(x0, Fs0, Fs, Tseg, SIL_THRESH_11, SIL_THRESH_12);
minim = min(x);
maxim = max(x);
audiowrite('mono.wav', x, Fs);
fprintf('-> Done preprocessing.\n');
toc
% Framing:

fprintf('-> Framing: ');
x_frm = framer(x, Tw, Fs);
fprintf('-> Done framing.\n');

% Autocorelatia semnalului
fprintf('-> Autocorrelation: ');
[Rxx, n] = xcorr(x,x);
figure();
plot(n, Rxx);
fprintf('-> Done doing autcorrelation.\n');

%% BANK CONSTRUCTION

% Building soundbank:
if strcmp(ENGINE, 'crossCorrSbank') == true
    fprintf('Constructing soundbank: ');
    xBank = buildBank(Tw, Fs, Tseg, [SIL_THRESH_11, SIL_THRESH_12], ...
        crt_file(end-4));
    fprintf('done.\n');
% Building wavebank:
elseif strcmp(ENGINE, 'crossCorrWbank') == true
    fprintf('Construcing wavebank: ');
    xBank = buildBank(Tw, Fs, F);
    fprintf('done.\n');
end
%% SOUND TRANSCRIPTION

fprintf('Transcribing sounds: ');
% Computing frame fundamental frequencies and amplitudes:
if strcmp(ENGINE, 'crossCorrSbank') == true || ...
        strcmp(ENGINE, 'crossCorrWbank') == true
    [F_peaks, A_peaks] = transSound(x_frm, ENGINE, Fs, F, SIL_THRESH_2, ...
        PEAK_THRESH, xBank);
elseif strcmp(ENGINE, 'autoCorr') == true || strcmp(ENGINE, 'PSD') == true
    [F_peaks, A_peaks] = transSound(x_frm, ENGINE, Fs, F, SIL_THRESH_2, ...
        PEAK_THRESH);
end
fprintf('done.\n');


%% MUSIC INFERENCE

fprintf('Running music inference: ');
% Infering note pitches and durations:
[F_vect, D_vect] = inferMus(F_peaks, A_peaks, REP_THRESH);
fprintf('done.\n');

%% MusicXML (MXL) FILE GENERATION

fprintf('Generating MXL file: ');
% Saving to disk:
crt_MXL = ['./MXL files', crt_file(end-10:end-4), '.mxl'];
MXLwriter(crt_MXL, {F_vect, D_vect}, F)
fprintf('done.\n');
fprintf(['-> Current MXL file: ', crt_MXL, '\n']);
msg = ['-> You can visit https://www.soundslice.com/musicxml-viewer/ ', ...
    'to view the MusicXML file.\n'];
fprintf(msg);
