function [mins, seks] = calculate_remaining(total_time, rounds_passed, total_rounds)
	avg_time = total_time / rounds_passed;
	rem = avg_time*(total_rounds-rounds_passed);
	mins = floor(rem / 60);
	seks = rem - mins * 60;
end