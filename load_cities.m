function [distances, stink, nr_cities, cities] = load_cities(filename, type='euc', initial_stink = 1)
	% load cities from data file
	cities = load('-ascii', filename);
	nr_cities = size(cities,1);

	% compute distance array
	distances = zeros(nr_cities, nr_cities);

	num_loops = nr_cities * (nr_cities-1) / 2;
	done_loops = 0;

	distances(1, 1) = 1;
	for x = 2:nr_cities
		fprintf(2, "Loading cities and computing distances [%2.0f%%]\r", 100 * done_loops / num_loops);
		for y = 1:x-1
			x_1 = cities(x, 2);
			y_1 = cities(x, 3);
			x_2 = cities(y, 2);
			y_2 = cities(y, 3);

			dist = 0;
			if type == 'geo'
				lat_1 = calculate(x_1);
				lon_1 = calculate(y_1);
				lat_2 = calculate(x_2);
				lon_2 = calculate(y_2);

				RRR = 6378.388;
				q1 = cos(lon_1 - lon_2);
				q2 = cos(lat_1 - lat_2);
				q3 = cos(lat_1 + lat_2);

				dist = round(RRR*acos(0.5 * ((1.0+q1)*q2 - (1.0-q1)*q3)) + 1.0);
				distances(x,y) = round(dist);
				distances(y,x) = round(dist);
			elseif type=='euc'
				dist = sqrt((x_2-x_1)^2 + (y_2-y_1)^2);
				distances(x,y) = round(dist);
				distances(y,x) = round(dist);
			end

		end
		distances(x, x) = 1;
		done_loops = done_loops + x - 1;
	end

	% initial feromone values
	if initial_stink < 0
		fprintf(2, "random stink\n");
		stink = rand(nr_cities, nr_cities);
	else
		fprintf(2, "stink: %f\n", initial_stink);
		stink = initial_stink * ones(nr_cities, nr_cities);
	end
end
