function [ddd, aaa] = main(filename, type='euc') 
	
	fprintf(2, "Loading cities and computing distances...\n");
	[d, s, n, c] = load_cities(filename, type);
	
	number_of_rounds_in_history_of_world = 100;
	number_of_the_ants_in_our_universe = 5;
	
	shortest_tab = [];
	
	last_shortest = 0;
	
	shortest = 10000000000000000000;
	counter = 0;
	
	fprintf(2, "Job started...\n");
	
	for round=1:number_of_rounds_in_history_of_world
		
		ants = prepare_ant(number_of_the_ants_in_our_universe, n);
		available_cities = repmat(1:n, number_of_the_ants_in_our_universe, 1);
		ants(:,end) = ants(:,1);
		
		% compute next step for every ant
		for step=2:n
			new_available_cities = [];
		
			for ant=1:number_of_the_ants_in_our_universe
				last_city = ants(ant,step-1);
				av_cities =	available_cities(ant,:);
				av_cities(av_cities == last_city) = [];
				
				stinks = s(last_city,av_cities);
				dists = d(last_city,av_cities).^-1;
				probs = cumsum(stinks.*dists);
				x = rand * probs(end);
				index = find(probs>=x, 1);
				% if size(index) < 1
					% index
					% probs
					% x
				% end
				ants(ant,step) = av_cities(index);
				new_available_cities = [new_available_cities;av_cities];
			end
			available_cities = new_available_cities;
		end
		
		s = s * 0.95;
				
		local_shortest = 10000000000;
		local_ant = 0;
		for ant=1:number_of_the_ants_in_our_universe
			dist = 0;
			for i=2:n+1
				dist = dist + d(ants(ant,i-1), ants(ant,i));
			end	
			if dist < local_shortest
				local_shortest = dist;
				local_ant = ant;
			end
		end
		
		for i=2:n+1
			c1 = ants(local_ant, i-1);
			c2 = ants(local_ant, i);
			st = s(c1, c2);
			s(c1, c2) = st + 0.1;
			s(c2, c1) = st + 0.1;
		end
		
		if local_shortest < shortest
			aaa = ants(local_ant,:);
			shortest = local_shortest;
		end
		
		
		
		if last_shortest == local_shortest
			count = count + 1;
		else
			count = 0;
		end
		
		last_shortest = local_shortest;
		
		fprintf(2, "After round %d/%d. Shortest: %d (%d) %d\r", round, number_of_rounds_in_history_of_world, shortest, local_shortest, count);
		
		shortest_tab = [shortest_tab, local_shortest];
		
		if count > 10
			break
		end
		
	end
	
	ddd = shortest;
	
	plot(shortest_tab);
	
	fprintf(2, "\n\n");
end

% test_16.txt
% d =  6818
% a =  14    8    4    2    3    1   16   13   12    7   10    9   11    5    6   15   14