note
	description: "Jackson-Zave zoo model: barrier concretization"
	author: "Alexandr Naumchev"
	date: "4/2/2015"
	revision: "multirequirements"

class
	BARRIER_CONCRETE

inherit
	BARRIER_ABSTRACT
		redefine
			turnstile
		end

create
	make

feature	-- Inherited

	turnstile: TURNSTILE_CONCRETE

	push
			-- A visitor pushes the barrier to its intermediate position
	require else
		ind2: not turnstile.is_locked
	do
		last_push := turnstile.get_time
		pushes_count := pushes_count + 1

		if 	((pushes_count = turnstile.coinslot.coins_count) and
			 (not turnstile.is_locked))
				then
			turnstile.lock
		end
	ensure then
		history_growth:			pushes ~ old pushes.extended (last_push)
		time_monotonicity:		last_push > old last_push
		counter_monotonicity:	pushes_count = old pushes_count + 1
		opt7:					pushes_count = turnstile.coinslot.coins_count implies
									(turnstile.is_locked and
									(turnstile.last_lock - last_push) < 760)
	end

feature	-- Extended

	last_push: INTEGER_64

	pushes_count: INTEGER

	make
	do
		pushes_count := 0
		last_push := 0
	ensure
		pushes_count = 0
		last_push = 0
	end

invariant
	linking_invariant: pushes.last = last_push
	linking_invariant: pushes.count = pushes_count
end

