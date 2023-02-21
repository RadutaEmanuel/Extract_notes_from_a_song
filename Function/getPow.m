function P = getPow(x) % primeste la intrare semnal mono
P=0;
for i=1:1:length(x) 
  P=P+10*log10((abs(x(i,1)))^2);
end
P = P/length(x);
end

