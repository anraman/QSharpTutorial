namespace Entanglement
{
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Primitive;


    operation PutInGHZState (numberOfQubits : Int) : Result[]
    {
        body
        {
            mutable result = new Result[numberOfQubits];

            for (i in 0..(numberOfQubits - 1))
            {
                set result[i] = Zero; // fix me!
            }

            return result;
        } 
    }
}
