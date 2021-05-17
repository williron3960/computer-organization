main:
    addi $a0, $zero, 10 # n = 10
    addi $a1, $zero, 5  # m = 5
    jal pascal          # call pascal(10, 5)
    j exit
    #--------------------------------------#
pascal:
    addi $sp, $sp, -12 # 製造STACK.
    sw $ra, 8($sp)     # 儲存 Return 位置.
    sw $a0, 4($sp)     # 儲存參數 n.
    sw $a1, 0($sp)     # 儲存參數 m.

    beq $a1, $0, result  # 如果測試結果為 m == 0, 跳至 result.
    beq $a1, $a0, result # m == n , 跳至 result.
    j L1

    result:
    addi $v0, $v0, 1   # Else 回傳值等於 1.
    addi $sp, $sp, 12  # 清除STACK.
    jr $ra # 跳回位置.

L1: #call Recursive
    addi $a0, $a0, -1  # n = n - 1.
    jal pascal         # Recursive P(n - 1, m)
    addi $a1, $a1, -1  # m = m - 1
    jal pascal         # Recrusive P(n - 1, m - 1)
    lw  $a1, 0($sp)
    lw  $a0, 4($sp)
    lw  $ra, 8($sp)
    addi $sp, $sp, 12  # 清除STACK
    jr $ra
    #--------------------------------------#

exit:
