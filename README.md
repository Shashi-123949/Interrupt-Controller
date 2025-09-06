# Interrupt-Controller

An Interrupt Controller (IC) is a digital logic block that manages multiple interrupt requests from peripherals and decides which interrupt should be serviced by the processor. It reduces the complexity of the CPU by prioritizing and handling interrupts efficiently.

In Verilog-based design, the Interrupt Controller DUT (Design Under Test) and its testbench are implemented to validate correct functionality.

# DUT (Design Under Test) – Interrupt Controller

The DUT represents the hardware logic of the interrupt controller. Its key features include:

Inputs:

Multiple interrupt request signals from peripherals.

Clock (clk) and Reset (rst) signals.

Acknowledge (ack) signal from CPU once interrupt is serviced.

Outputs:

Interrupt Request to CPU.

Encoded Interrupt Vector indicating which device raised the interrupt.

Optional priority levels or masking capability.

Functionality:

1.Monitors multiple interrupt request lines.

2.Applies priority logic (fixed or programmable).

3.Outputs the highest-priority pending interrupt to the CPU.

4.Waits for CPU acknowledgment (ack) before clearing the interrupt.

5.Supports both overlapping and non-overlapping interrupt requests depending on design.

# Testbench – Verification Environment

The testbench is used to simulate and validate the functionality of the DUT. It typically includes:

Clock & Reset Generation: Provides timing reference and initializes DUT.

Stimulus Generation: Generates different interrupt request patterns:

Single interrupt request.

Multiple simultaneous requests.

Sequential interrupts with varying priorities.

CPU Acknowledgment Simulation: Sends ack after servicing, to test proper interrupt clearing.

# Monitors & Checkers:

Check that the correct highest-priority interrupt is signaled.

Ensure no interrupts are lost or serviced twice.

Validate int_vector output matches the correct source.

# Example Applications

Microcontroller or processor-based SoCs.

Peripheral-rich designs (UART, Timer, GPIO, etc.).

Real-time systems requiring priority-based interrupt servicing.

The Verilog DUT implements the interrupt arbitration and vector generation logic, while the testbench verifies correctness by applying different interrupt scenarios, checking responses, and ensuring reliable CPU interaction.
