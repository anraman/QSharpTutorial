namespace Teleportation
{
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Extensions.Testing;

	operation TeleportClassicalFlagSimple (flag : Bool) : () {
		body {
			using (register = Qubit[3]) {
				Message ($"When I am fixed, we will have teleported {flag} successfully!");
				ApplyToEach(Reset, register);
			}
		}
	}
    
	operation PrepareEntangledPair(left : Qubit, right : Qubit) : () {
		body {
			H(left);
			CNOT(left, right);
		}

		adjoint auto;
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
				Message ($"When I am fixed, we will have teleported {flag} successfully!");
				ApplyToEach(Reset, register);
			}
		}
	}

	operation TeleportArbitraryState (u : (Qubit => () : Adjoint)) : () {
		body {
			using (register = Qubit[2]) {
				Message ($"When I am fixed, we will have teleported an arbitrary state successfully!");
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
