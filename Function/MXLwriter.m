function MXLwriter(crt_file, data, F)

% Parameters:
meas_dur = 16;       % Tempo: Q = 120; Time: 4/4.

% Pitch LUT:
q = nthroot(2, 12);
F_ = round(27.5*q.^(0:87));
pitchLUT_ = {'A0 ', 'B0b', 'B0 ', 'C1 ', 'D1b', 'D1 ', 'E1b', 'E1 ', ...
    'F1 ', 'G1b', 'G1 ', 'A1b', 'A1 ', 'B1b', 'B1 ', 'C2 ', 'D2b', ...
    'D2 ', 'E2b', 'E2 ', 'F2 ', 'G2b', 'G2 ', 'A2b', 'A2 ', 'B2b', ...
    'B2 ', 'C3 ', 'D3b', 'D3 ', 'E3b', 'E3 ', 'F3 ', 'G3b', 'G3 ', ...
    'A3b', 'A3 ', 'B3b', 'B3 ', 'C4 ', 'D4b', 'D4 ', 'E4b', 'E4 ', ...
    'F4 ', 'G4b', 'G4 ', 'A4b', 'A4 ', 'B4b', 'B4 ', 'C5 ', 'D5b', ...
    'D5 ', 'E5b', 'E5 ', 'F5 ', 'G5b', 'G5 ', 'A5b', 'A5 ', 'B5b', ...
    'B5 ', 'C6 ', 'D6b', 'D6 ', 'E6b', 'E6 ', 'F6 ', 'G6b', 'G6 ', ...
    'A6b', 'A6 ', 'B6b', 'B6 ', 'C7 ', 'D7b', 'D7 ', 'E7b', 'E7 ', ...
    'F7 ', 'G7b', 'G7 ', 'A7b', 'A7 ', 'B7b', 'B7 ', 'C8 '};
pitchLUT = pitchLUT_(find(F_ == F(1)):find(F_ == F(end)));
durLUT = {'16th', 'eighth', 'eighth', 'quarter', {'quarter', '16th'}, ...
    'quarter', {'quarter', 'eighth'}, 'half', {'half', '16th'}, ...
    {'half', 'eighth'}, {'half', 'eighth'}, 'half', ...
    {'half', 'quarter', '16th'}, {'half', 'quarter'}, ...
    {'half', 'quarter', 'eighth'}, 'whole'};

% Extracting data:
F_vect = data{1};
D_vect = data{2};

% Formatting data:
N = length(D_vect);
% Constructing pitches:
P_vect = {};
for i = 1:N
    if F_vect(i) == 0
        P_vect = [P_vect, 0];
    else
        P_vect = [P_vect, pitchLUT{F == F_vect(i)}];
    end
end
% Constructing measures vs. notes:
meas_vect = [];
crt_meas_notes = 0;
crt_meas_dur = 0;
i = 1;
while i <= N
    if crt_meas_dur < meas_dur
        crt_meas_notes = crt_meas_notes + 1;
        crt_meas_dur = crt_meas_dur + D_vect(i);
        if crt_meas_dur >= meas_dur
            extra_dur = crt_meas_dur - meas_dur;
            meas_vect = [meas_vect, crt_meas_notes];
            crt_meas_notes = 0;
            crt_meas_dur = 0;
            if extra_dur > 0
                P_vect = [P_vect(1:i), P_vect(i), P_vect(i+1:end)];
                D_vect = [D_vect(1:i-1), D_vect(i)-extra_dur, ...
                    extra_dur, D_vect(i+1:end)];
                N = N + 1;
            end
        end
    end
    i = i + 1;
end
if crt_meas_dur > 0
    meas_vect = [meas_vect, crt_meas_notes+1];
    P_vect = [P_vect, 0];
    D_vect = [D_vect, meas_dur-crt_meas_dur];
end
Nmeas = length(meas_vect);

% Opening target file:
fid = fopen(crt_file, 'w');

% Building template:
fprintf(fid, '<score-partwise version="3.1">\n');
fprintf(fid, '\t<part-list>\n');
fprintf(fid, '\t\t<score-part id="P1">\n');
fprintf(fid, '\t\t\t<part-name>Score</part-name>\n');
fprintf(fid, '\t\t</score-part>\n');
fprintf(fid, '\t</part-list>\n');
fprintf(fid, '\t<part id="P1">\n');
for m = 1:Nmeas
    fprintf(fid, '\t\t<measure number="%d">\n', m);
    if m == 1
        fprintf(fid, '\t\t\t<attributes>\n');
        fprintf(fid, '\t\t\t\t<divisions>4</divisions>\n');
        fprintf(fid, '\t\t\t\t<key>\n');
        fprintf(fid, '\t\t\t\t\t<fifths>-2</fifths>\n');
        fprintf(fid, '\t\t\t\t</key>\n');
        fprintf(fid, '\t\t\t\t<time>\n');
        fprintf(fid, '\t\t\t\t\t<beats>4</beats>\n');
        fprintf(fid, '\t\t\t\t\t<beat-type>4</beat-type>\n');
        fprintf(fid, '\t\t\t\t</time>\n');
        fprintf(fid, '\t\t\t\t<clef>\n');
        fprintf(fid, '\t\t\t\t\t<sign>G</sign>\n');
        fprintf(fid, '\t\t\t\t\t<line>2</line>\n');
        fprintf(fid, '\t\t\t\t</clef>\n');
        fprintf(fid, '\t\t\t</attributes>\n');
    end
    % Inserting notes:
    for i = 1+sum(meas_vect(1:m-1)):sum(meas_vect(1:m))
        crt_P = P_vect{i};
        crt_D = D_vect(i);
        Dtype = durLUT(crt_D);
        if iscell(Dtype{1})
            Dtype = Dtype{1};
        end
        N_Dtype = length(Dtype);
        for j = 1:N_Dtype
            crt_dur = find(strcmp(durLUT, Dtype{j}), 1);
            fprintf(fid, '\t\t\t<note>\n');
            % Rests:
            if crt_P == 0
                fprintf(fid, '\t\t\t\t<rest/>\n');
            % Pitched notes:
            else
                fprintf(fid, '\t\t\t\t<pitch>\n');
                fprintf(fid, ['\t\t\t\t\t<step>', crt_P(1), '</step>\n']);
                fprintf(fid, ['\t\t\t\t\t<octave>', crt_P(2), ...
                    '</octave>\n']);
                if crt_P(3) == 'b'
                    fprintf(fid, '\t\t\t\t\t<alter>-1</alter>\n');
                end
                fprintf(fid, '\t\t\t\t</pitch>\n');
                if j == 1 && j < N_Dtype
                    fprintf(fid, '\t\t\t\t<tie type="start"/>\n');
                elseif j > 1 && j < N_Dtype
                    fprintf(fid, '\t\t\t\t<tie type="stop"/>\n');
                    fprintf(fid, '\t\t\t\t<tie type="start"/>\n');
                elseif j == N_Dtype
                    if j > 1
                        fprintf(fid, '\t\t\t\t<tie type="stop"/>\n');
                    end
                    if ~isempty(find([3, 6, 7, 11, 12, 14, 15] == ...
                            crt_D, 1))
                        crt_dur = 1.5 * crt_dur;
                        fprintf(fid, '\t\t\t\t<dot/>\n');
                    end
                end
            end
            fprintf(fid, ['\t\t\t\t<type>', Dtype{j}, '</type>\n']);
            fprintf(fid, '\t\t\t\t<duration>%d</duration>\n', crt_dur);
            fprintf(fid, '\t\t\t</note>\n');
        end
    end
    fprintf(fid, '\t\t</measure>\n');
end
fprintf(fid, '\t</part>\n');
fprintf(fid, '</score-partwise>\n');

% Closing target file:
fclose(fid);

end
