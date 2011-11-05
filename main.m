function main(filename) 
	
	[d, s, n, c] = load_cities(filename);
	
	for step=1:10
	
		ant = prepare_ant(n);
		available_cities = 1:n;
		
		for i=2:n
			available_cities(available_cities == ant(i-1)) = [];
			stinks = s(i,available_cities);
			dists = d(i,available_cities);
			probs = cumsum(stinks.*dists);
			x = rand * probs(end);
			index = find(probs>x, 1);
			ant(i) = next_city = available_cities(index);
		end
		ant(end) = ant(1);
		
		s = s * 0.9;
		
		for i=2:n+1
			st = s(ant(i-1), ant(i));
			s(ant(i-1), ant(i)) = st + 0.2;
			s(ant(i), ant(i-1)) = st + 0.2;
		end
	
		ant
		s
	end
	
end