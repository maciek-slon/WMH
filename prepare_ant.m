function ants = prepare_ant(nr_ants, nr_cities)
	ants = [ceil(rand(nr_ants, 1)*nr_cities), zeros(nr_ants, nr_cities)];
end