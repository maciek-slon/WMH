function [ddd, aaa, best_round, shortest_tab] = main(filename, type='euc', stink_fade = 0.95, stink_power = 0.1) 
	
	fprintf(2, "Loading cities and computing distances...\n");
	[d, s, n, c] = load_cities(filename, type);
	
	number_of_rounds_in_history_of_world = 1000;
	number_of_the_ants_in_our_universe = 5;
	
	shortest_tab = zeros(1, number_of_rounds_in_history_of_world);
	
	last_shortest = 0;
	
	shortest = 10000000000000000000;
	counter = 0;
	
	fprintf(2, "Job started...\n");
	
	total_time = 0;
	
	for round=1:number_of_rounds_in_history_of_world
		
		tic;
		
		current_dists = zeros(1, number_of_the_ants_in_our_universe);
		
		ants = prepare_ant(number_of_the_ants_in_our_universe, n);
		available_cities = repmat(1:n, number_of_the_ants_in_our_universe, 1);
		ants(:,end) = ants(:,1);
		
		% compute next step for every ant
		for step=2:n
			new_available_cities = zeros(number_of_the_ants_in_our_universe, n-step+1);
		
			for ant=1:number_of_the_ants_in_our_universe
				last_city = ants(ant,step-1);
				av_cities =	available_cities(ant,:);
				av_cities(av_cities == last_city) = [];
				
				stinks = s(last_city,av_cities);
				dists = d(last_city,av_cities);
				probs = cumsum(stinks./dists);
				x = rand * probs(end);
				index = find(probs>=x, 1);
				ants(ant,step) = av_cities(index);
				new_available_cities(ant,:) = av_cities;
				
				current_dists(ant) = current_dists(ant) + d(last_city, av_cities(index));
			end
			available_cities = new_available_cities;
		end
		
		local_shortest = 10000000000;
		local_ant = 0;
		for ant=1:number_of_the_ants_in_our_universe
			current_dists(ant) = current_dists(ant) + d(ants(ant, end), ants(ant, end-1));
			
			if current_dists(ant) < local_shortest
				local_shortest = current_dists(ant);
				local_ant = ant;
			end
		end
		
		s = s * 0.95;
		
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
			best_round = round;
		end
		
		
		
		if last_shortest == local_shortest
			count = count + 1;
		else
			count = 0;
		end
		
		last_shortest = local_shortest;
		
		total_time = total_time + toc;

		[mm, ss] = calculate_remaining(total_time, round, number_of_rounds_in_history_of_world);
		fprintf(2, "After round %d/%d. Shortest: %d (%d) %d Time remaining: %d:%02d [~%.2fs/rnd]      \r", round, number_of_rounds_in_history_of_world, shortest, local_shortest, count, mm, ss, total_time/round);
		
		shortest_tab(round) = local_shortest;
		
		if count > 40
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