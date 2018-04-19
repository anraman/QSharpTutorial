using Microsoft.Quantum.Primitive;
using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.Simulation.Simulators;

namespace Teleportation
{
    class Driver
    {
        static void Main(string[] args)
        {
            using (var sim = new QuantumSimulator())
            {
                System.Console.WriteLine("BEGIN Running Teleportation - Simple");
                TeleportClassicalFlagSimple.Run(sim, true).Wait();
                TeleportClassicalFlagSimple.Run(sim, false).Wait();
                System.Console.WriteLine("END Running Teleportation - Simple\n\n");

                System.Console.WriteLine("BEGIN Running Teleportation - Clean");
                TeleportClassicalFlag.Run(sim, true).Wait();
                TeleportClassicalFlag.Run(sim, false).Wait();
                System.Console.WriteLine("END Running Teleportation - Clean\n\n");

                System.Console.WriteLine("BEGIN Running Teleportation - Arbitrary Unitary");
                TeleportArbitraryState.Run(sim, sim.Get<H, H> ()).Wait();
                System.Console.WriteLine("END Running Teleportation - Arbitrary Unitary\n\n");

                System.Console.WriteLine("BEGIN Teleport Half an Entangled Pair");
                TeleportEntangledQubit.Run(sim).Wait();
                System.Console.WriteLine("END Teleport Half an Entangled Pair\n\n");
            }
        }
    }
}
