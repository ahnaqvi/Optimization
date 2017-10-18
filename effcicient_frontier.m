function [Y, rates, sigs] = efficient_frontier(r, Sig, num)
clear
clc
[X, dates, names] = load_stocks('data', '2012-01-03', '2012-12-31');

%[r, Sig] = meancov(X);

%num = 5;

n = length(r);
[rrange] = return_range(r, Sig, num);

Y = zeros(n, num);
for i = 1:num
    cvx_begin quiet

        R = chol(Sig);
        newSig = R' * R;
        variable x(19)
        %minimize(quad_form(x,newSig));
        minimize( norm(R * x, 2) );
        subject to
        ones(1,19)*x == 1,
        r'*x >= rrange(i)
        x >= 0;
    cvx_end
    Y(:,i) = x;
    rates(i) = r'*x;
    sigs(i) = sqrt(x'*Sig*x);
end

rates = rates'
sigs = sigs'

end