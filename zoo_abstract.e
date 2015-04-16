note
	description: "Jackson-Zave zoo model: zoo abstraction"
	author: "Alexandr Naumchev"
	date: "4/2/2015"
	revision: "multirequirements"
	model: enters

deferred class
	ZOO_ABSTRACT

feature

	turnstile: TURNSTILE_ABSTRACT

	enter
			-- A visitor pushes the barrier fully home and so gains entry to the zoo
	deferred
	ensure
		history_growth:		enters.but_last ~ old enters
		time_monotonicity:	enters.last > old enters.last
	end

	enters: MML_SEQUENCE[INTEGER_64]

invariant
	ind1: turnstile.barrier.pushes.last > enters.last implies
			turnstile.barrier.pushes.count = enters.count + 1
	ind1: turnstile.barrier.pushes.last < enters.last implies
			turnstile.barrier.pushes.count = enters.count
	ind3: (turnstile.barrier.pushes.count - 1) <= enters.count and enters.count <= turnstile.barrier.pushes.count
	opt1: enters.count <= turnstile.coinslot.coins.count
	opt2: turnstile.coinslot.coins.count > enters.count implies
			(agent enter).precondition
	ind4: enters.last > turnstile.barrier.pushes.last implies
			(enters.last - turnstile.barrier.pushes.last) >= 750
	ind4: turnstile.barrier.pushes.last > enters.last implies
			(turnstile.barrier.pushes.last - enters.count) >= 10
end
