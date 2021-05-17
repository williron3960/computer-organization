main:
    addi $a0, $zero, 19654 # a0= 19654
    addi $a1, $zero, 100654  # a1=100654
    addi $a2, $zero, 10065  # a2= 10065
    jal average     # call average
    j exit

average:
    addi $sp, $sp, -4
    sw $ra, 0x0($sp)    # Save $ra register into stack.

    #--------------------------------------#
    add $t0, $a0, $a1  # t0 = 19,654 + 100,654 = 120,308.
    add $t1, $t0, $a2  # t1 = 120,308 + 10,065 = 130,373.
    add  $t2, $0, $0  # $t2 = 0.
    divloop:
    subi $t1, $t1, 3 # $t1 = $t1 - 3.
    addi $t2, $t2, 1 # $t2 = $t2 + 1.
    slt $t3, $t1, $0 # $t3 = 1 if ($t1<$zero); 0 if ($t1 >= $zero ).
    beq $t3, $0, divloop  # if ($t1 == $zero) jump to divloop.
    subi $v0, $t2, 1  # $v0 = $t2 -1 # for last round cause of over addition.
    #--------------------------------------#

    lw $ra, 0x0($sp)    # Load $ra register from stack
    addi $sp, $sp, 4
    jr $ra

exit:
