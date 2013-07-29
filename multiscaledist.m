
function dists = multiscaledist(spec,meanp)


dists = [ norm(spec.r0-meanp.r0);  norm(spec.r1-meanp.r1); ...
          norm(spec.r2-meanp.r2);  norm(spec.r3-meanp.r3); ...
          norm(spec.r4-meanp.r4)];


end