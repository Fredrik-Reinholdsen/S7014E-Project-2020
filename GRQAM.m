function points = GRPSK(k)
    k = 1:k;
    GR = (1+sqrt(5))/2;
    theta_k = 2*pi/GR^2*k;
    r_k = sqrt(k);
    points = r_k.*exp(1i*theta_k);
    plot(real(points), imag(points), 'r*')
    

end