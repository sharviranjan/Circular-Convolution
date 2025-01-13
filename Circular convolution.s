# Circular Convolution Using Linear Convolution
# Input: Arrays A and B of size N
# Output: Array C of size N (result of circular convolution)

.data
N:      .word 4                 # Length of the arrays
A:      .word 1, 2, 3, 4        # Input array A
B:      .word 1, 0, -1, 0       # Input array B
C:      .word 0, 0, 0, 0        # Output array C (initialized to 0)

.text
.global _start

_start:
    la s0, A                   # Load address of array A
    la s1, B                   # Load address of array B
    la s2, C                   # Load address of output array C
    lw s3, N                   # Load size of the arrays N into s3 (N = 4)

    mv s4, zero                # Outer loop index i = 0

outer_loop:
    beq s4, s3, end_outer_loop # If i == N, end loop

    mv s5, zero                # Reset sum = 0
    mv t0, zero                # Inner loop index j = 0

inner_loop:
    beq t0, s3, end_inner_loop # If j == N, end loop

    # Calculate k = (i - j + N) % N
    sub t1, s4, t0             # t1 = i - j
    add t1, t1, s3             # t1 = (i - j + N)
    rem t1, t1, s3             # t1 = (i - j + N) % N (this is k)

    # Perform multiplication and accumulate
    slli t2, t0, 2              # t2 = j * 4 (word offset for B[j])
    add t3, s1, t2             # t3 = Address of B[j]
    lw t4, 0(t3)               # Load B[j] into t4

    slli t2, t1, 2              # t2 = k * 4 (word offset for A[k])
    add t3, s0, t2             # t3 = Address of A[k]
    lw t5, 0(t3)               # Load A[k] into t5

    mul t6, t4, t5             # t6 = A[k] * B[j]
    add s5, s5, t6             # sum += A[k] * B[j]

    addi t0, t0, 1             # Increment j
    j inner_loop

end_inner_loop:
    # Store sum in C[i]
    slli t2, s4, 2              # t2 = i * 4 (word offset for C[i])
    add t3, s2, t2             # t3 = Address of C[i]
    sw s5, 0(t3)               # Store sum at C[i]

    addi s4, s4, 1             # Increment i
    j outer_loop

end_outer_loop:
    # End of program
    li a7, 10                  # Exit system call
    ecall