% function [F_vect,D_vect] = inferMus(F_peaks,A_peaks,REP_THRESH)
% 
% % Declaration of the variables to be used
% k = 1;                                              % 
% 
% 
% % The repeating check
% F_vect(1,1) = F_peaks(1,1);                         % Primul frecventa din primul cadru va fi primul element in noul vector linie
% D_vect(1,1) = 1;                                    % Numarul de repetari al frecventei din primul cadru va fi initial 1                                  
% 
% for i = 1:1:(length(F_peaks(1,:))-1)
%     if  (F_peaks(1,i) ~= F_peaks(1,i+1))
%         k = k + 1;                                  % Marim indexul pentru pozitia in noul vector de frecvente si repetitii
%         F_vect(1,k) = F_peaks(1,i+1);               % Daca frecventa curenta este diferita de cea urmatoare in vectorul de frecvente este adaugata frecventa urmatoare
%         D_vect(1,k) = 1;                            % Initializam numarul de repetitie al frecventei noi adaugate in vector de frecvente ca 1
%     elseif (A_peaks(1,i) == A_peaks(1,i+1))         
%         D_vect(1,k) = D_vect(1,k) + 1;              % Pe cate cadre la rand a fost repetata o nota
%     end
% end
% 
% 
% end

function [F_vect, D_vect] = inferMus(F_peaks, A_peaks, REP_THRESH)
    F_vect = [];
    D_vect = [];
    
    prev_F = 0;
    prev_A = 0;
    prev_D = 0;
    
    for i = 1:length(F_peaks)
        if F_peaks(i) == prev_F
            if A_peaks(i) >= REP_THRESH * prev_A
                F_vect = [F_vect F_peaks(i)];
                D_vect = [D_vect 1];
            else
                D_vect(end) = D_vect(end) + 1;
            end
        else
            F_vect = [F_vect F_peaks(i)];
            D_vect = [D_vect 1];
        end
        
        prev_F = F_peaks(i);
        prev_A = A_peaks(i);
    end
end
