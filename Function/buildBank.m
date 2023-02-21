function xBank = buildBank(Tw, Fs, varargin)
    F = [262, 277, 294, 311, 330, 349, 370, 392, 415, 440, 466, 494, 523, 554, 587, 622, 659, 698, 740, 784, 831, 880, 932, 988, 1047];
    xBank = zeros(Tw*Fs,25);
    if nargin == 5
        file_list = ls(strcat(pwd, '/soundbank'));
        switch varargin{3}
            case '1', file_list = file_list(3:27,:);
            case '2', file_list = file_list(28:52,:);
            case '3', file_list = file_list(103:127,:);
            case '4', file_list = file_list(53:77,:);
            case '5', file_list = file_list(78:102,:);
        end
        for i = 1:25
            [x,Fs0] = audioread(strcat(pwd,'/soundbank/',file_list(i,:)));
            x1 = preProc(x,Fs0, Fs, varargin{1}, varargin{2}(1), varargin{2}(2));
            x2 = x1(floor((length(x1)/3)):floor((length(x1)/2)) + Tw*Fs);
            for j = 1:Tw*Fs
                xBank(j,i) = x2(j);
            end
        end
    elseif nargin == 3
        t=0:1/Fs:Tw;
        for i = 1:25
            x3=1*sin(2*pi*F(i)*t);
            for j=1:Tw*Fs
                xBank(j,i)= x3(j);
            end
        end  
    end
end