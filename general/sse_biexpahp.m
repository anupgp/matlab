function sse = sse_biexpahp(params,t,v1)
[~, v2] = biexpahp(params,t);
sse = sqrt(sum((v1-v2).^2));