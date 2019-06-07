clear k;
for(i=16870:17500)
    k(i) = max(ch2(refsignal(16670:i),Acq_data(:,5),length(Acq_data(:,5))));
end
plot(k(16870:end))
