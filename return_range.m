function [rrange] = return_range(r, Sig, num) % x is portfolio
%clear
clc


cvx_begin quiet

    R = chol(Sig);
    newSig = R' * R;
    variable x(19)
    %minimize(quad_form(x,newSig));
    minimize( norm(R * x, 2) );

    subject to
    ones(1,19)*x == 1,
    x >= 0;
cvx_end


sig = sqrt(x' * Sig * x);
mu = r' * x;

disp('Minimum risk portfolio:');
disp(x)

disp('Expected rate of return min portfolio:')
disp(mu)

disp('Standard deviation min portfolio:')
disp(sig)

cvx_begin quiet
    variable x(19)
    maximize(r' * x);
    subject to
    ones(1,19)*x == 1,
    x >= 0;
cvx_end

maxMu = cvx_optval;
disp('Max return portfolio:')
disp(x);
rrange = linspace(mu, maxMu, num)


end