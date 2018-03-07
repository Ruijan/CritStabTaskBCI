iterations = 100000;
times = zeros(iterations,1);
for i = 1: iterations
    tic;
    pos = get(0, 'PointerLocation');
    times(i) = toc;
end