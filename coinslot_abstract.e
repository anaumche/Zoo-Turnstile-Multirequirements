note
	description: "Jackson-Zave zoo model: coinslot abstraction"
	author: "Alexandr Naumchev"
	date: "4/2/2015"
	revision: "multirequirements"
	model: coins

deferred class
	COINSLOT_ABSTRACT

feature

	turnstile: TURNSTILE_ABSTRACT

	coin
			-- A valid coin is inserted into the coin slot
	deferred
	ensure
		history_growth:		coins.but_last ~ old coins
		time_monotonicity:	coins.last > old coins.last

		opt6: 				((old turnstile.locks.last > old turnstile.unlocks.last) and (coins.count > turnstile.barrier.pushes.count)) implies
								turnstile.unlocks.last > coins.last
	end

	coins: MML_SEQUENCE[INTEGER_64]

invariant
	consistency: turnstile.coinslot = Current
end
