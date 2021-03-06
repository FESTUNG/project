
function ret = laguerrePol(i, X, beta)
switch i
  case 1,  ret = ones(size(X));
  case 2,  ret = 1 - beta*X;
  case 3,  ret = 1 - 2*beta*X + 1/2*(beta*X).^2;
  case 4,  ret = 1 - 3*beta*X + 3/2*(beta*X).^2 - 1/6*(beta*X).^3;  
  case 5,  ret = 1 - 4*beta*X + 3*(beta*X).^2 - 2/3*(beta*X).^3 + 1/24*(beta*X).^4;
  case 6,  ret = 1 - 5*beta*X + 5*(beta*X).^2 - 5/3*(beta*X).^3 + 5/24*(beta*X).^4 - 1/120*(beta*X).^5;
  otherwise
        ret = zeros(size(X));
        for k = (0:1:(i-1))
            ret = ret + ((-beta).^k)./factorial(k).*nchoosek((i-1),k).* X.^k;
        end
end % switch
end % function
