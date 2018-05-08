namespace Entanglement
{
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Primitive;

    operation BuildBellPair () : Result[]
    {
        body
        {
            return PutInGHZState(2);
        }
    }

    operation PutInGHZState (numberOfQubits : Int) : Result[]
    {
        body
        {
            mutable result = new Result[numberOfQubits];

            using (qs = Qubit[numberOfQubits])
            {
                let q0 = qs[0];

                H (q0);

                for (i in 1..(numberOfQubits - 1))
                {
                    CNOT (q0, qs[i]);
                }

                for (i in 0..(numberOfQubits - 1))
                {
                    set result[i] = M (qs[i]);
                }

                ResetAll (qs);
            }

            return result;
        }
    }
}
