namespace SuperPosition
{
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Primitive;

    operation AllocateAndMeasureSingleQubit () : String
    {
        body
        {
            return "***** Fix Me *****";
        } 
    }

    operation PutInOneState () : String
    {
        body
        {
            return "***** Fix Me *****";
        } 
    }

    operation PutInPlusState () : Result
    {
        body
        {
            return Zero;
        } 
    }

    operation SuperPositionOverAllBasisVectors (numberOfQubits : Int) : Result[]
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