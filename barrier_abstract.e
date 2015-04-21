note
	description: "Jackson-Zave zoo model: barrier abstraction"
	author: "Alexandr Naumchev"
	date: "4/2/2015"
	revision: "multirequirements"
	model: pushes

deferred class
	BARRIER_ABSTRACT

feature

	turnstile: TURNSTILE_ABSTRACT

	push
			-- A visitor pushes the barrier to its intermediate position
	require
		ind2: not turnstile.unlocks.is_empty
		ind2: (not turnstile.locks.is_empty) implies
				turnstile.unlocks.last > turnstile.locks.last
	deferred
	ensure
		history_growth:		pushes.but_last ~ old pushes
		time_monotonicity:	pushes.last > old pushes.last

		opt7:				((old turnstile.unlocks.last > old turnstile.locks.last) and
							(pushes.count = turnstile.coinslot.coins.count)) implies
								(turnstile.locks.last > pushes.last and
								(turnstile.locks.last - pushes.last) < 760)
	end

	pushes: MML_SEQUENCE[INTEGER_64]

invariant
	consistency: turnstile.barrier = Current
end
