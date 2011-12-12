function [ret_distance, ret_route, best_round, shortest_tab] = main(filename, type='euc', total_ants = 50, stink_fade = 0.95, stink_power = 0.1, total_rounds = 1000, initial_stink = 1, headless = 0)

	[d, s, n, c] = load_cities(filename, type, initial_stink);

	number_of_rounds_in_history_of_world = total_rounds;
	number_of_the_ants_in_our_universe = total_ants;

	shortest_tab = zeros(1, number_of_rounds_in_history_of_world);
	longest_tab = zeros(1, number_of_rounds_in_history_of_world);

	last_shortest = 0;

	shortest = 10000000000000000000;
	counter = 0;





	nazwa = sprintf("%s-fade-%.2f-power-%.2f-ants-%d", filename, stink_fade, stink_power, total_ants)
	tries = 1;
	nazwa_folderu = nazwa;
	while (exist(nazwa_folderu) > 0)
		printf("%s istnieje\n", nazwa_folderu);
		nazwa_folderu = sprintf("%s-%d", nazwa, tries);
		tries = tries + 1;
	end

	mkdir(nazwa_folderu);





	fprintf(2, "%d ants started...\n", number_of_the_ants_in_our_universe);

	total_time = 0;

	clf;

	offset = 0;

	t1 = 0;
	t2 = 0;
	t3 = 0;
	t4 = 0;
	
	for round=1:number_of_rounds_in_history_of_world

		tic;

		current_dists = zeros(1, number_of_the_ants_in_our_universe);

		
		ants = prepare_ant(number_of_the_ants_in_our_universe, n);
		%%% available_cities = repmat(1:n, number_of_the_ants_in_our_universe, 1);
		available_cities = ones(number_of_the_ants_in_our_universe, n);
		ants(:,end) = ants(:,1);

		t1 = t1 + toc;
		
		global_probs = s./d;
		pr = global_probs(1, :);
		probs = pr;
		
		t2 = t2 + toc;

		
		% compute next step for every ant
		for step=2:n
			%%% new_available_cities = zeros(number_of_the_ants_in_our_universe, n-step+1);

			for ant=1:number_of_the_ants_in_our_universe
	
				last_city = ants(ant,step-1);
				%%% av_cities =	available_cities(ant,:);
				%%% av_cities(av_cities == last_city) = [];
				available_cities(ant,last_city) = 0;

				%stinks = s(last_city,av_cities);
				%dists = d(last_city,av_cities);
				%probs = cumsum(stinks./dists);
				
				pr = global_probs(last_city, :) .* available_cities(ant, :);
				%%% probs = cumsum(global_probs(last_city, av_cities));
				probs = cumsum(pr);
				x = rand * probs(end);
				index = find(probs>=x, 1);
				%%% ants(ant,step) = av_cities(index);
				ants(ant,step) = index;
				%%% new_available_cities(ant,:) = av_cities;

				current_dists(ant) = current_dists(ant) + d(last_city, index);
			end
			%%% available_cities = new_available_cities;
		end

		t3 = t3 + toc;
		
		local_shortest = 10000000000;
		local_longest = 0;
		local_ant = 0;
		for ant=1:number_of_the_ants_in_our_universe
			current_dists(ant) = current_dists(ant) + d(ants(ant, end), ants(ant, end-1));

			if current_dists(ant) < local_shortest
				local_shortest = current_dists(ant);
				local_ant = ant;
			end

			if current_dists(ant) > local_longest
				local_longest = current_dists(ant);
			end
		end

		s = s * stink_fade;

		for i=2:n+1
			c1 = ants(local_ant, i-1);
			c2 = ants(local_ant, i);
			st = s(c1, c2);
			s(c1, c2) = st + stink_power;
			s(c2, c1) = st + stink_power;
		end

		t4 = t4 + toc;
		
		if local_shortest < shortest
			ret_route = ants(local_ant,:);
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
		
		tt1 = t1 / round;
		tt2 = t2 / round - tt1;
		tt3 = t3 / round - tt1 - tt2;
		tt4 = t4 / round - tt1 - tt2 - tt3;

		[mm, ss] = calculate_remaining(total_time, round, number_of_rounds_in_history_of_world);
		fprintf(2, "After round %d/%d. Shortest: %d (%d) %d Time remaining: %d:%02d [~%.2fs/rnd] %.2f %.2f %.2f %.2f     \r", round, number_of_rounds_in_history_of_world, shortest, local_shortest, count, mm, ss, total_time/round, tt1, tt2, tt3, tt4);

		shortest_tab(round) = local_shortest;
		longest_tab(round) = local_longest;

		if count > 40
			break
		end

		% rr = floor(round/50);
		% if mod(round, 50) == 0
			% f = rr*50 - 49 - offset;
			% t = rr*50;
			% hold on;
			% plot( f:t, shortest_tab(f:t), "g");
			% plot( f:t, longest_tab(f:t), "r");
			% drawnow;

			% offset = 1;
		% end

		if headless == 0
			nazwa_pliku = "";
			if mod(round, 20) == 0
				clf;
				plot_stink(s, c(:,2:3));
				drawnow;

				nazwa_pliku = sprintf("%s/%d.png", nazwa_folderu, round);
				print(nazwa_pliku);
				replot;
			end;
		end

	end

	ret_distance = shortest;

	if headless == 0
		plot_best_route(ret_route, c(:,2:3));

		nazwa_pliku = sprintf("%s/best.png", nazwa_folderu);
		print(nazwa_pliku);
		replot;

		figure;
		plot(shortest_tab, "g");
		hold on;
		plot(longest_tab, "r");
	end

	fprintf(2, "\n%d rounds in %f seconds\n\n", round, total_time);

	cd(nazwa_folderu);

	save('total.txt', 'ret_route', 'shortest_tab', 'longest_tab', 'total_time', 'round');
	cd("../..");


end

% test_16.txt
% d =  6818
% a =  14    8    4    2    3    1   16   13   12    7   10    9   11    5    6   15   14
