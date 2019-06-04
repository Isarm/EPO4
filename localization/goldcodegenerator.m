%https://www.hindawi.com/journals/ijap/2015/956735/

clear all;

polynom1 = [0 1 0 0 1 1 0 1];
polynom2 = [0 0 0 1 0 1 0 1];
LFSR1=[0 0 0 0 1 0 0 1];
LFSR2=[0 1 0 0 0 1 0 1];
i = 1;
equal = 1;
while(i<=64)
    code1(i) = LFSR1(8)
    inter1 = mod(polynom1*LFSR1',2);
    for(k = 1:7)
       n = 9-k;
       LFSR1(n)= LFSR1(n-1);
    end
    LFSR1(1) = inter1;
    code2(i) = LFSR2(8);
    inter2 = mod(polynom2*LFSR2',2);
    for(k = 1:7)
       n = 9-k;
       LFSR2(n)= LFSR2(n-1);
    end
    LFSR2(1) = inter2;
    
    result(i) = mod(code1(i)+code2(i),2);    
    i=i+1;
end
figure;
autocorrelation = conv(result, fliplr(result));
autocorrelation = autocorrelation/max(autocorrelation);
plot(autocorrelation);
hold on;
result2 =0.5+0.5*sign(randn(1,64));
autocorrelation2 = conv(result2, fliplr(result2));
autocorrelation2 = autocorrelation2/max(autocorrelation2);
plot(autocorrelation2);
legend('goldcode','random');

%Results from the Gold code generator
%result = 146 205 197 15 247 177 230 36
%HEX = 92CDC50FF7B1E624

%Some good codes with random function
%DA94498E801C730A
%93C355A57640147C
%47C7684116D9DE06
