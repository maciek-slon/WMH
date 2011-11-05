function [ddd, aaa] = main(filename) 
	
	[d, s, n, c] = load_cities(filename);
	
	shortest = 10000000000000000000;
	for step=1:1000
	
		ant = prepare_ant(n);
		available_cities = 1:n;
		
		for i=2:n
			available_cities(available_cities == ant(i-1)) = [];
			stinks = s(i,available_cities);
			dists = d(i,available_cities);
			probs = cumsum(stinks.*dists);
			x = rand * probs(end);
			index = find(probs>=x, 1);
			if size(index) < 1
				index
				probs
				x
			end
			ant(i) = available_cities(index);
		end
		ant(end) = ant(1);
		
		s = s * 0.9;
		
		dist = 0;
		for i=2:n+1
			st = s(ant(i-1), ant(i));
			s(ant(i-1), ant(i)) = st + 0.2;
			s(ant(i), ant(i-1)) = st + 0.2;
			
			dist = dist + d(ant(i-1), ant(i));
		end
		
		if dist < shortest
			aaa = ant;
			shortest = dist;
		end
		
	end
	
	ddd = shortest;
	
end