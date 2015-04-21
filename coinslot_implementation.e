note
	description: "Jackson-Zave zoo model: coinslot concretization"
	author: "Alexandr Naumchev"
	date: "4/2/2015"
	revision: "multirequirements"

class
	COINSLOT_CONCRETE

inherit
	COINSLOT_ABSTRACT
		redefine
			turnstile
		end

create
	make

feature	-- Inherited

	turnstile: TURNSTILE_CONCRETE

	coin
			-- A valid coin is inserted into the coin slot
	do
		last_coin := turnstile.get_time
		coins_count := coins_count + 1

		if ((coins_count > turnstile.barrier.pushes_count) and
			(turnstile.is_locked))
				then
			turnstile.unlock
		end
	ensure then
		history_growth:			coins ~ old coins.extended (last_coin)
		time_monotonicity:		last_coin > old last_coin
		counter_monotonicity:	coins_count = old coins_count + 1
		opt6:					(coins_count > turnstile.barrier.pushes_count) implies
									not (turnstile.is_locked and
									(turnstile.last_unlock - last_coin) < 250)
	end

feature	-- Extended

	last_coin: INTEGER_64

	coins_count: INTEGER

	make
	do
		coins_count := 0
		last_coin := 0
	ensure
		coins_count = 0
		last_coin = 0
	end

invariant
	linking_invariant: coins.last = last_coin
	linking_invariant: coins.count = coins_count
end
