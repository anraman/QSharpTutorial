namespace Teleportation.Reference
{
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Extensions.Testing;

	operation TeleportClassicalFlagSimple (flag : Bool) : () {
		body {
			using (register = Qubit[3]) {
				let msg   = register [0];
				let here  = register [1];
				let there = register [2];

				if (flag) {
					X(msg);
				}

                // Create some entanglement that we can use to send our message.
				H(here);
				CNOT(here, there);

                // Move our message into the entangled pair.
				CNOT(msg, here);
				H (msg);

                // Measure out the entanglement.
				if (M(here) == One) { X(there); }
				if (M(msg)  == One) { Z(there); }

                // Fail if the Assert does not hold.
				if (flag) {
					AssertQubit(One,  there);
				} else {
					AssertQubit(Zero, there);
				}

				Message ($"Teleported {flag} successfully!");
				ApplyToEach(Reset, register);
			}
		}
	}
    
	operation PrepareEntangledPair(left : Qubit, right : Qubit) : () {
		body {
			H(left);
			CNOT(left, right);
		}

		adjoint {
			(Adjoint CNOT) (left, right);
			(Adjoint H) (left);
		};
	}

    operation TeleportMessage(msg : Qubit, there : Qubit) : () {
        body {
            using (register = Qubit[1]) {
                let here = register[0];
            
                // Create some entanglement that we can use to send our message.
                PrepareEntangledPair(here, there);
            
                // Move our message into the entangled pair.
                CNOT(msg, here);
                H(msg);

                // Measure out the entanglement.
                if (M(msg)  == One) { Z(there); }
                if (M(here) == One) { X(there); }

                // Reset our "here" qubit before releasing it.
                Reset(here);
            }
        }
    }

	operation TeleportClassicalFlag (flag : Bool) : () {
		body {
			using (register = Qubit[2]) {
				let msg   = register [0];
				let there = register [1];

				if (flag) { X(msg); }

				TeleportMessage (msg, there);

                // Fail if the Assert does not hold.
				if (flag) {
					AssertQubit(One,  there);
				} else {
					AssertQubit(Zero, there);
				}

				Message ($"Teleported {flag} successfully!");
				ApplyToEach(Reset, register);
			}
		}
	}

	operation TeleportArbitraryState (u : (Qubit => () : Adjoint)) : () {
		body {
			using (register = Qubit[2]) {
				let msg   = register [0];
				let there = register [1];

				// apply the unitary to prepare state on the message qubit
				u (msg);

				TeleportMessage (msg, there);

				// apply the inverse of the unitary on the target qubit
				(Adjoint u)(there);

				AssertQubit(Zero, there);

				Message ("The anthropic principle says we teleported a prepared state successfully! :) ");
				ApplyToEach(Reset, register);
			}
		}
	}

	operation TeleportEntangledQubit() : () {
		body {
			using (register = Qubit[1]) {
				// a reference qubit
				let reference = register[0];
				
				// partially apply the reference argument to PrepareEntanglePair,
				// which results in an operation that takes a qubit 
				// and entangles it with the reference qubit
				let entangleQubit = PrepareEntangledPair(reference, _);

				// provide this operation to TeleportArbitraryState
				// It is unitary because PrepareEntangledPair is a unitary
				TeleportArbitraryState(entangleQubit);

				// Choi-Jamilkowski Isomorphism 
				// Proves the channel is equal to the identity channel
				ApplyToEach(AssertQubit(Zero, _), register);
			}
		}
	}		
}
