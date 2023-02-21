function [Fr] = rounder(Fx)
% Keep in mind that the only frequencies used are listed below
% The endopint aproximation for 262 is [250, 270] and for 1047 is [1014,1100]
% The other frequencies are rounded based on which half between the lower
% and higher frequency the measured one is located
F = [262, 277, 294, 311, 330, 349, 370, 392, 415, 440, 466, 494, 523, 554, 587, 622, 659, 698, 740, 784, 831, 880, 932, 988, 1047];
for i = 1:1:length(Fx(1,:))
    if (Fx(1,i) >= 250) && (Fx(1,i) <= 270)
       Fr(1,i) = 262;
    elseif (Fx(1,i) >= 271) && (Fx(1,i) <= 285)
       Fr(1,i) = 277;
    elseif (Fx(1,i) >= 286) && (Fx(1,i) <= 302)
       Fr(1,i) = 294;
    elseif (Fx(1,i) >= 303) && (Fx(1,i) <= 320)
       Fr(1,i) = 311;
    elseif (Fx(1,i) >= 321) && (Fx(1,i) <= 340)
       Fr(1,i) = 330;
    elseif (Fx(1,i) >= 341) && (Fx(1,i) <= 360)
       Fr(1,i) = 349;
    elseif (Fx(1,i) >= 361) && (Fx(1,i) <= 380)
       Fr(1,i) = 370;
    elseif (Fx(1,i) >= 381) && (Fx(1,i) <= 402)
       Fr(1,i) = 392;
    elseif (Fx(1,i) >= 403) && (Fx(1,i) <= 427)
       Fr(1,i) = 415;
    elseif (Fx(1,i) >= 428) && (Fx(1,i) <= 453)
       Fr(1,i) = 440;
    elseif (Fx(1,i) >= 454) && (Fx(1,i) <= 480)
       Fr(1,i) = 466;
    elseif (Fx(1,i) >= 481) && (Fx(1,i) <= 508)
       Fr(1,i) = 494;
    elseif (Fx(1,i) >= 509) && (Fx(1,i) <= 538)
       Fr(1,i) = 523;
    elseif (Fx(1,i) >= 539) && (Fx(1,i) <= 570)
       Fr(1,i) = 554;
    elseif (Fx(1,i) >= 571) && (Fx(1,i) <= 604)
       Fr(1,i) = 587;
    elseif (Fx(1,i) >= 605) && (Fx(1,i) <= 640)
       Fr(1,i) = 622;
    elseif (Fx(1,i) >= 641) && (Fx(1,i) <= 678)
       Fr(1,i) = 659;
    elseif (Fx(1,i) >= 679) && (Fx(1,i) <= 719)
       Fr(1,i) = 698;
    elseif (Fx(1,i) >= 720) && (Fx(1,i) <= 762)
       Fr(1,i) = 740;
    elseif (Fx(1,i) >= 763) && (Fx(1,i) <= 808)
       Fr(1,i) = 784;
    elseif (Fx(1,i) >= 809) && (Fx(1,i) <= 856)
       Fr(1,i) = 831;
    elseif (Fx(1,i) >= 857) && (Fx(1,i) <= 906)
       Fr(1,i) = 880;
    elseif (Fx(1,i) >= 907) && (Fx(1,i) <= 960)
       Fr(1,i) = 932;
    elseif (Fx(1,i) >= 961) && (Fx(1,i) <= 1013)
       Fr(1,i) = 988;
    elseif (Fx(1,i) >= 1014) && (Fx(1,i) <= 1100)
       Fr(1,i) = 1047;
    else
       Fr(1,i) = 0;
    end
end
    
    
end