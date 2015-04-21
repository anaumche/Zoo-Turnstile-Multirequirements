note
	description: "Jackson-Zave zoo model: turnstile concretization"
	author: "Alexandr Naumchev"
	date: "4/2/2015"
	revision: "multirequirements"

class
	TURNSTILE_CONCRETE

inherit
	TURNSTILE_ABSTRACT
		redefine
			barrier,
			coinslot
		end

create
	make

feature	-- Inherited

	barrier: BARRIER_CONCRETE

	coinslot: COINSLOT_CONCRETE

	lock
			-- The turnstile receives a locking signal	
	require else
		opt3: not is_locked
		opt5: barrier.pushes_count = coinslot.coins_count
	do
		last_lock := get_time
		is_locked := True
	ensure then
		history_growth:		locks ~ old locks.extended (last_lock)
		time_monotonicity:	last_lock > old last_lock
		opt3:				is_locked
	end

	unlock
			-- The turnstile receives an unlocking signal	
	require else
		opt3: is_locked
		opt4: barrier.pushes_count < coinslot.coins_count
	do
		last_unlock := get_time
		is_locked := False
	ensure then
		history_growth:		unlocks ~ old unlocks.extended (last_unlock)
		time_monotonicity:	last_unlock > old last_unlock
		opt3: 				not is_locked
	end

feature	-- Extended

	is_locked: BOOLEAN

	last_lock: INTEGER_64

	last_unlock: INTEGER_64

	launch_time: DATE_TIME

	get_time: INTEGER_64
			-- Utility feature for getting current time
	local
		moment: DATE_TIME
	do
		create moment.make_now_utc
		Result := (moment.relative_duration (launch_time).fine_seconds_count * 1_000).truncated_to_integer_64
	ensure
		Result > 0
	end

	make
	do
		is_locked := True
		last_lock := 0
		last_unlock := 0
		create launch_time.make_now_utc
	ensure
		opt3:	is_locked = True
				last_lock = 0
				last_unlock = 0
	end

invariant
	linking_invariant:	locks.last = last_lock
	linking_invariant:	unlocks.last = last_unlock
	linking_invariant:	is_locked = (locks.last > unlocks.last)
	opt1a:				barrier.pushes_count <= coinslot.coins_count
end
