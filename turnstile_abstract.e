note
	description: "Jackson-Zave zoo model: turnstile abstraction"
	author: "Alexandr Naumchev"
	date: "4/2/2015"
	revision: "multirequirements"
	model: locks, unlocks

deferred class
	TURNSTILE_ABSTRACT

feature

	coinslot: COINSLOT_ABSTRACT

	barrier: BARRIER_ABSTRACT

	lock
			-- The turnstile receives a locking signal
	require
		opt3: (not (locks.is_empty or unlocks.is_empty)) implies unlocks.last > locks.last
		opt3: unlocks.count = locks.count + 1
		opt5: barrier.pushes.count = coinslot.coins.count
	deferred
	ensure
		history_growth:		locks.but_last ~ old locks
		time_monotonicity:	locks.last > old locks.last
		opt3: 				(not (locks.is_empty or unlocks.is_empty))
								implies locks.last > unlocks.last
		opt3:				unlocks.count = locks.count
	end

	locks: MML_SEQUENCE[INTEGER_64]

	unlock
			-- The turnstile receives an unlocking signal
	require
		opt3: (not (locks.is_empty or unlocks.is_empty)) implies locks.last > unlocks.last
		opt3: locks.count = unlocks.count
		opt4: barrier.pushes.count < coinslot.coins.count
	deferred
	ensure
		history_growth:		unlocks.but_last ~ old unlocks
		time_monotonicity:	unlocks.last > old unlocks.last
		opt3:				(not (locks.is_empty or unlocks.is_empty))
								implies unlocks.last > locks.last
		opt3:				locks.count + 1 = unlocks.count
	end

	unlocks: MML_SEQUENCE[INTEGER_64]

invariant
	consistency:	coinslot.turnstile = Current
	consistency:	barrier.turnstile = Current
	opt1a:			barrier.pushes.count <= coinslot.coins.count
end

