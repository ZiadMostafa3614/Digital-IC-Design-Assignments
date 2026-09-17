# **Motivation** 

As we discussed in the ALU assignment, we can design the ALU to perform the required operations such as addition, subtraction, multiplication, and division using operators like +, -, *, and /. 

In this case, we let the synthesis tool decide how to implement these operators in order to meet our design constraints. 

But what happens when we need to achieve a higher operating frequency? 

Using the operators directly does not always give us the best architecture for our specific timing, area, or power requirements. Therefore, we can use specific arithmetic architectures that are designed to provide different trade-offs between area, power, and frequency. 

For example, there are several architectures such as: 

- Ripple Carry Adder (RCA) 

- Carry Look-Ahead Adder (CLA) 

- Kogge-Stone Adder 

- Brent-Kung Adder 

These architectures are implemented at the gate level, and each one provides a different trade-off between speed, area, and power. 

The same idea applies to multiplication. There are several multiplier architectures, such as: 

- Booth Multiplier 

- Wallace Tree Multiplier 

- Baugh-Wooley Multiplier 

- Shift-and-Add Multiplier 

Each architecture has its own advantages depending on the required design constraints. 

For simplicity, in this assignment, we will focus on the Shift-and-Add Multiplier and study how its architecture affects the design performance. 

# **Shift-and-Add Multiplier** 

Shift-and-Add multiplier is a simple way to perform multiplication using shifting and addition instead of directly using the * operator. 

The idea is to check each bit of the multiplier. If the bit is 1, we add a shifted version of the multiplicand to the result. The amount of shifting depends on the bit position. 

For example: 

A×B=(A×b0)+((A×b1)<<1)+...+((A×b7)<<7) 

So, the multiplication is basically converted into a number of shift and add operations. 

The main advantage is that it is simple and area efficient, but the multiple additions can increase the critical path, which limits the maximum frequency compared with more advanced multiplier architectures. 

## **8-bit Example: 31 × 42** 

Represent both numbers using 8 bits: 

A = 31= 000111112 B = 42 = 001010102 

## Partial Product Generation: 

PP [0] = A & B [0] = 000000002 PP [1] = A & B [1] = 000111112 PP [2] = A & B [2] = 000000002 PP [3] = A & B [3] = 000111112 PP [4] = A & B [4] = 000000002 PP [5] = A & B [5] = 000111112 PP [6] = A & B [6] = 000000002 PP [7] = A & B [7] = 000000002 

## Align, Shift and Accumulate: 

<mark>00000000 00000000</mark> 2 <mark>(PP [0] << 0)</mark> + 00000000 001111102, (PP [1] << 1) + 00000000 000000002, (PP [2] << 2) + 00000000 111110002, (PP [3] <<3) + 00000000 000000002, (PP [4] << 4) + 00000011 111000002, (PP [5] << 5) + 00000000 000000002, (PP [6] << 6) + 00000000 000000002, (PP [7] << 7) 

______________________ 00000101 000101102 



<!-- Start of picture text -->
a [7:0]<br><!-- End of picture text -->



<!-- Start of picture text -->
b [7:0]<br><!-- End of picture text -->



<!-- Start of picture text -->
a [7:0] b [7:0]<br>a_reg[7:0] b_reg[7:0]<br>a_reg[7]| b_reg[7:0] a_reg[6] b_reg[7:0] a_reg[5] b_reg[7:0] a_reg[4] b_reg[7:0] a_reg[3] b_reg[7:0] a_reg[2] b_reg[7:0] a_reg[I] b_reg[7:0] a_reg[0] b_reg[7:0]|<br>PP[7|[7:0] PP|6][7:0] PP[5][7:0] PP|4][7:0] PP|3][7:0] PP[2][7:0] PP{[1][7:0] PP|[0][7:0]<br>Level_0<br>[15:0]<br>Level_1 (I><br>[15:0] LT<br>Level_2 LI<br>[15:0] LT<br>Level_3 LI<br>[15:0] LT<br>Level_4 Ae<br>[15:0] LL<br>Level_S (I><br>[15:0] wa<br>Level_6 (I><br>[15:0] LL<br>Level_7<br>[15:0]<br>Out[15:0]<br><!-- End of picture text -->

# **Design Overview** 

The alu8_top module is an 8-bit Arithmetic Logic Unit (ALU) that supports addition and multiplication. The design follows a 2-stage pipelined architecture, to stabilize signals and handle clock boundary timing 

(Input Flip-Flops → Combinational Logic → Output Flip-Flops) 













_Figure 2: Design overview_ 

- **alu8_top (Top Wrapper):** Routes inputs a and b to both sub-modules and multiplexes the final output based on mode (0 for Addition, 1 for Multiplication). 

- **Adder Unit:** An 8-bit Adder that latches input operands on the clock edge, calculates the sum and carry-out combinationally, and registers the final 9-bit result on the next clock edge. 

- **Mult_unit:** Generates partial products using an 8 × 8 AND array and accumulates them through combinational shift-add logic. The final 16-bit product is registered on the output stage. 



<!-- Start of picture text -->
aa<br>tck tho | |<br># stn tho {<br>@/ Input | (input<br>mt a s'do 19 D 100 255 1G 20 255<br>Bt b s'do 19 2 55 i el 30 255<br>@’Lt mode tho 0 i i oo<br>Adder case<br>ie4 add_enadd_sum 's'dotho {0 T I I fFTL {30 | assLS| jo 1 I I I I<br>a SS = i a i<br>ae Mu (Mul<br>”4 mul_en tho ) | | | | |<br>4 mul_productmi_vaid 16'd0tho 0 | | | || | | | imc | Yeoo | Y6s025l |<br>&’ out | (out)<br>6-4 result 16'do 0 {30 (ass (256 {o {42 {600 (65025<br>L4. valid tho | I I<br><!-- End of picture text -->



<!-- Start of picture text -->
20 sssssssssss5555555555555555555 5555555555555 55=5===<br>= ALUS TOP TESTBENCH<br>§ x=2-=-5===5-=--=5=55-55555555555555555555=5=5==5=====<br>=<br># ---------------- ADD TESTS ----------------------<br># [ 85000] PASS | ADD a=10 b=20 | result=30<br>2 [105000] PASS | ADD a=100 b=55 | result=155<br>= [125000] PASS | ADD a=255 b=1 | result=256<br>=<br>$ ---------------- MUL TESTS ----------------------<br>2 [165000] PASS | MUL a=6 b=7 | result=42<br>2 [185000] PASS | MUL a=20 b=30 | result=600<br># [205000] PASS | MUL a=255 be255 | result=65025<br>#<br>2 ssssssssssSsSsSS555 5555555555555 5555555555555 5=55<br>2 SUMMARY<br>+ — ee ss es ss<br>a Total tests : 6<br>= Passed : &<br>= Failed : 0<br># RESULT: ALL TESTS PASSED<br>FY<br>§ meena anena nee aanaasasaaeaaasaasaeseesassese=s====<br><!-- End of picture text -->

# **Requirements:** 

1. Run synthesis on the given design starting with a 10 ns clock period, then gradually decrease the clock period to find the maximum frequency achievable without any timing violations. No constraints should be changed except the clock period. 

2. After synthesis, identify the critical path and determine which design unit contributes the most to the critical delay. 

3. Modify the critical unit by adding a pipeline register to the critical path. This increases the maximum latency of that unit from 2 cycles to 3 cycles. 

4. Run synthesis again with the modified design and repeat the clock-period sweep until finding the new maximum frequency without timing violations. 

