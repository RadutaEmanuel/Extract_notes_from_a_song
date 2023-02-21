function [x_frm] = framer(x, Tw, Fs)

  Length = length(x(:,1));                                                  % Aflam numarul de esantioane
  Nw = ceil(Length/(Tw*Fs));                                                % Calculam numarul intreg de cadre de 125ms cu rotunjire in sus
  [x_padded] = vertcat(x, zeros((Tw*Fs-mod(Length,Tw*Fs)),1));              % Vectorul coloana care contine un numar rotunjit de elemente pentru a completa ultimul cadru
  x_frm = zeros(Tw*Fs,Nw);                                                  % Preincarcam matricea cu zerouri
  x_frm(1:Tw*Fs,1) = x(1:Tw*Fs,1);                                          % Primul cadru pe prima coloana in matricea de cadre
  for i = 1:1:Nw-1                                                          % Cadrele vor fi coloanele matricii
        x_frm(1:Tw*Fs,i+1) = x_padded((Tw*Fs*i+1):(Tw*Fs*(i+1)),1);
  end

fprintf('-> The frames were made;\n');
fprintf('-> We have %d frames with %d values in each one;\n',Nw,Tw*Fs);

end