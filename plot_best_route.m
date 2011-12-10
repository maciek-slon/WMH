function plot_best_route(route, cities)
	nn = size(cities, 1);
	A = zeros(nn);
	
	for i=1:nn
		c1 = route(i);
		c2 = route(i+1);
		A(c1,c2) = 1;
		A(c2,c1) = 1;
	end
	
	gplot(A, cities);
	
	replot;
end