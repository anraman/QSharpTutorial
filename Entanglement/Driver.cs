using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.Simulation.Simulators;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Entanglement
{
    #region Hidden
    internal static class Utilities
    {
        private static string ResultToString (this Result qr) => qr == Result.Zero ? "0" : "1";

        private static string RunManyTimes<T>(this QuantumSimulator sim, Func<QuantumSimulator, Task<T>> op, int count, Func<T, string> format)
        {
            var results = 
                from i in Enumerable.Range(0, count)
                let result = op(sim).Result
                let pattern = format (result)
                group pattern by pattern into g
                select new { Ket = $"|{g.Key}>", Count = g.Count() };

            return ($"[\n\t{String.Join(",\n\t", results)}\n]");
        }

        public static string RunManyTimes(this QuantumSimulator sim, Func<QuantumSimulator, Task<Result>> op, int count)
        {
            return sim.RunManyTimes(op, count, ResultToString);
        }

        public static string RunManyTimesN(this QuantumSimulator sim, Func<QuantumSimulator, Task<QArray<Result>>> op, int count)
        {
            string ResultArrayToString (QArray<Result> result) => result.Select(ResultToString).Aggregate((r, c) => r + c);
            return sim.RunManyTimes(op, count, ResultArrayToString);
        }
    }
#endregion

    class Driver
    {
        static void Main(string[] args)
        {
            using (var sim = new QuantumSimulator())
            {
                var message = sim.RunManyTimesN(BuildBellPair.Run, 10);
                System.Console.WriteLine($"The result of building a bell state was {message}");
                
                var ghz_count = 4;
                message = sim.RunManyTimesN(s => PutInGHZState.Run(s, ghz_count), 100);
                System.Console.WriteLine($"The result of putting {ghz_count} qubits in the GHZ state was {message}");
            }
        }
    }
}