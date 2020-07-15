/*
+-----------------------------------------------------------------------------+
| This code corresponds to the the paper "Reduction Modulo 2^{448}-2^{224}-1" |
| authored by	      							      |
| Kaushik Nath,  Indian Statistical Institute, Kolkata, India, and            |
| Palash Sarkar, Indian Statistical Institute, Kolkata, India.	              |
+-----------------------------------------------------------------------------+
| Copyright (c) 2020, Kaushik Nath and Palash Sarkar.                         |
|                                                                             |
| Permission to use this code is granted.                          	      |
|                                                                             |
| Redistribution and use in source and binary forms, with or without          |
| modification, are permitted provided that the following conditions are      |
| met:                                                                        |
|                                                                             |
| * Redistributions of source code must retain the above copyright notice,    |
|   this list of conditions and the following disclaimer.                     |
|                                                                             |
| * Redistributions in binary form must reproduce the above copyright         |
|   notice, this list of conditions and the following disclaimer in the       |
|   documentation and/or other materials provided with the distribution.      |
|                                                                             |
| * The names of the contributors may not be used to endorse or promote       |
|   products derived from this software without specific prior written        |
|   permission.                                                               |
+-----------------------------------------------------------------------------+
| THIS SOFTWARE IS PROVIDED BY THE AUTHORS ""AS IS"" AND ANY EXPRESS OR       |
| IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES   |
| OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.     |
| IN NO EVENT SHALL THE CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,      |
| INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT    |
| NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,   |
| DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY       |
| THEORY LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING |
| NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,| 
| EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.                          |
+-----------------------------------------------------------------------------+
*/

.p2align 5
.globl gfp4482241mul
gfp4482241mul:

movq 	%rsp, %r11
subq 	$160, %rsp

movq 	%r11,  0(%rsp)
movq 	%r12,  8(%rsp)
movq 	%r13, 16(%rsp)
movq 	%r14, 24(%rsp)
movq 	%r15, 32(%rsp)
movq 	%rbp, 40(%rsp)
movq 	%rbx, 48(%rsp)
movq 	%rdi, 56(%rsp)

movq    %rdx, %rbx
    
movq    0(%rbx), %rdx    

mulx    0(%rsi), %r8, %r9
mulx    8(%rsi), %rcx, %r10
addq    %rcx, %r9

mulx    16(%rsi), %rcx, %r11
adcq    %rcx, %r10

mulx    24(%rsi), %rcx, %r12
adcq    %rcx, %r11

mulx    32(%rsi), %rcx, %r13
adcq    %rcx, %r12

mulx    40(%rsi), %rcx, %r14
adcq    %rcx, %r13

mulx    48(%rsi), %rcx, %r15
adcq    %rcx, %r14
adcq    $0, %r15

movq    %r8, 64(%rsp)
movq    %r9, 72(%rsp)
movq    %r10, 80(%rsp)
movq    %r11, 88(%rsp)
movq    %r12, 96(%rsp)
movq    %r13, 104(%rsp)
movq    %r14, 112(%rsp)
movq    %r15, 120(%rsp)

movq    8(%rbx), %rdx

mulx    0(%rsi), %r8, %r9
mulx    8(%rsi), %rcx, %r10
addq    %rcx, %r9

mulx    16(%rsi), %rcx, %r11
adcq    %rcx, %r10

mulx    24(%rsi), %rcx, %r12
adcq    %rcx, %r11

mulx    32(%rsi), %rcx, %r13
adcq    %rcx, %r12

mulx    40(%rsi), %rcx, %r14
adcq    %rcx, %r13

mulx    48(%rsi), %rcx, %r15
adcq    %rcx, %r14
adcq    $0, %r15

addq    72(%rsp),  %r8
adcq    80(%rsp), %r9
adcq    88(%rsp), %r10
adcq    96(%rsp), %r11
adcq    104(%rsp), %r12
adcq    112(%rsp), %r13
adcq    120(%rsp), %r14
adcq    $0, %r15

movq    %r8,  72(%rsp)
movq    %r9,  80(%rsp)
movq    %r10, 88(%rsp)
movq    %r11, 96(%rsp)
movq    %r12, 104(%rsp)
movq    %r13, 112(%rsp)
movq    %r14, 120(%rsp)
movq    %r15, 128(%rsp)

movq    16(%rbx), %rdx

mulx    0(%rsi), %r8, %r9
mulx    8(%rsi), %rcx, %r10
addq    %rcx, %r9

mulx    16(%rsi), %rcx, %r11
adcq    %rcx, %r10

mulx    24(%rsi), %rcx, %r12
adcq    %rcx, %r11

mulx    32(%rsi), %rcx, %r13
adcq    %rcx, %r12

mulx    40(%rsi), %rcx, %r14
adcq    %rcx, %r13

mulx    48(%rsi), %rcx, %r15
adcq    %rcx, %r14
adcq    $0, %r15

addq    80(%rsp), %r8
adcq    88(%rsp), %r9
adcq    96(%rsp), %r10
adcq    104(%rsp), %r11
adcq    112(%rsp), %r12
adcq    120(%rsp), %r13
adcq    128(%rsp), %r14
adcq    $0, %r15

movq    %r8,  80(%rsp)
movq    %r9,  88(%rsp)
movq    %r10, 96(%rsp)
movq    %r11, 104(%rsp)
movq    %r12, 112(%rsp)
movq    %r13, 120(%rsp)
movq    %r14, 128(%rsp)
movq    %r15, 136(%rsp)

movq    24(%rbx), %rdx

mulx    0(%rsi), %r8, %r9
mulx    8(%rsi), %rcx, %r10
addq    %rcx, %r9

mulx    16(%rsi), %rcx, %r11
adcq    %rcx, %r10

mulx    24(%rsi), %rcx, %r12
adcq    %rcx, %r11

mulx    32(%rsi), %rcx, %r13
adcq    %rcx, %r12

mulx    40(%rsi), %rcx, %r14
adcq    %rcx, %r13

mulx    48(%rsi), %rcx, %r15
adcq    %rcx, %r14
adcq    $0, %r15

addq    88(%rsp), %r8
adcq    96(%rsp), %r9
adcq    104(%rsp), %r10
adcq    112(%rsp), %r11
adcq    120(%rsp), %r12
adcq    128(%rsp), %r13
adcq    136(%rsp), %r14
adcq    $0, %r15

movq    %r8,  88(%rsp)
movq    %r9,  96(%rsp)
movq    %r10, 104(%rsp)
movq    %r11, 112(%rsp)
movq    %r12, 120(%rsp)
movq    %r13, 128(%rsp)
movq    %r14, 136(%rsp)
movq    %r15, 144(%rsp)


movq    32(%rbx), %rdx

mulx    0(%rsi), %r8, %r9
mulx    8(%rsi), %rcx, %r10
addq    %rcx, %r9

mulx    16(%rsi), %rcx, %r11
adcq    %rcx, %r10

mulx    24(%rsi), %rcx, %r12
adcq    %rcx, %r11

mulx    32(%rsi), %rcx, %r13
adcq    %rcx, %r12

mulx    40(%rsi), %rcx, %r14
adcq    %rcx, %r13

mulx    48(%rsi), %rcx, %r15
adcq    %rcx, %r14
adcq    $0, %r15

addq    96(%rsp), %r8
adcq    104(%rsp), %r9
adcq    112(%rsp), %r10
adcq    120(%rsp), %r11
adcq    128(%rsp), %r12
adcq    136(%rsp), %r13
adcq    144(%rsp), %r14
adcq    $0, %r15

movq    %r8,  96(%rsp)
movq    %r9,  104(%rsp)
movq    %r10, 112(%rsp)
movq    %r11, 120(%rsp)
movq    %r12, 128(%rsp)
movq    %r13, 136(%rsp)
movq    %r14, 144(%rsp)
movq    %r15, 152(%rsp)

movq    40(%rbx), %rdx

mulx    0(%rsi), %r8, %r9
mulx    8(%rsi), %rcx, %r10
addq    %rcx, %r9

mulx    16(%rsi), %rcx, %r11
adcq    %rcx, %r10

mulx    24(%rsi), %rcx, %r12
adcq    %rcx, %r11

mulx    32(%rsi), %rcx, %rax
adcq    %rcx, %r12

mulx    40(%rsi), %rcx, %rbp
adcq    %rcx, %rax

mulx    48(%rsi), %rcx, %rdi
adcq    %rcx, %rbp
adcq    $0, %rdi

addq    104(%rsp), %r8
adcq    112(%rsp), %r9
adcq    120(%rsp), %r10
adcq    128(%rsp), %r11
adcq    136(%rsp), %r12
adcq    144(%rsp), %rax
adcq    152(%rsp), %rbp
adcq    $0, %rdi

movq    %r8,  104(%rsp)
movq    %r9,  112(%rsp)
movq    %r10, 120(%rsp)
movq    %r11, 128(%rsp)
movq    %r12, 136(%rsp)

movq    48(%rbx), %rdx

mulx    0(%rsi), %r8, %r9
mulx    8(%rsi), %rcx, %r10
addq    %rcx, %r9

mulx    16(%rsi), %rcx, %r11
adcq    %rcx, %r10

mulx    24(%rsi), %rcx, %r12
adcq    %rcx, %r11

mulx    32(%rsi), %rcx, %r13
adcq    %rcx, %r12

mulx    40(%rsi), %rcx, %r14
adcq    %rcx, %r13

mulx    48(%rsi), %rcx, %r15
adcq    %rcx, %r14
adcq    $0, %r15

addq    112(%rsp), %r8
adcq    120(%rsp), %r9
adcq    128(%rsp), %r10
adcq    136(%rsp), %r11
adcq    %rax, %r12
adcq    %rbp, %r13
adcq    %rdi, %r14
adcq    $0, %r15

movq    64(%rsp), %rax
movq    72(%rsp), %rbx
movq    80(%rsp), %rcx
movq    88(%rsp), %rdx
movq    96(%rsp), %rbp
movq    104(%rsp), %rsi
  
xorq    %rdi, %rdi
addq    %r9, %rax
adcq    %r10, %rbx
adcq    %r11, %rcx
adcq    %r12, %rdx
adcq    %r13, %rbp
adcq    %r14, %rsi
adcq    %r15, %r8
adcq    $0, %rdi
    
movq    %rax, 64(%rsp)

movq    %r12, %rax
andq    mask32h, %rax

addq    %rax, %rdx
adcq    %r13, %rbp
adcq    %r14, %rsi
adcq    %r15, %r8
adcq    $0, %rdi

movq    %r12,  %rax
shrd    $32, %r13, %r12
shrd    $32, %r14, %r13
shrd    $32, %r15, %r14
shrd    $32, %r9,  %r15
shrd    $32, %r10, %r9
shrd    $32, %r11, %r10
shrd    $32, %rax, %r11

addq    64(%rsp), %r12
adcq    %r13, %rbx
adcq    %r14, %rcx
adcq    %r15, %rdx
adcq    %r9,  %rbp
adcq    %r10, %rsi
adcq    %r11, %r8
adcq    $0, %rdi

movq    %rdi, %r13
shlq    $32, %r13
    
xorq    %r14, %r14
addq    %rdi, %r12
adcq    $0, %rbx
adcq    $0, %rcx
adcq    %r13, %rdx
adcq    $0, %rbp
adcq    $0, %rsi
adcq    $0, %r8
adcq    $0, %r14

movq    %r14, %r13
shlq    $32, %r13

addq    %r14, %r12
adcq    $0, %rbx
adcq    $0, %rcx
adcq    %r13, %rdx
  
movq    56(%rsp), %rdi

movq    %r12,  0(%rdi)
movq    %rbx,  8(%rdi)
movq    %rcx, 16(%rdi)
movq    %rdx, 24(%rdi)
movq    %rbp, 32(%rdi)
movq    %rsi, 40(%rdi)
movq    %r8,  48(%rdi)

movq    0(%rsp), %r11
movq    8(%rsp), %r12
movq    16(%rsp), %r13
movq    24(%rsp), %r14
movq    32(%rsp), %r15
movq    40(%rsp), %rbp
movq    48(%rsp), %rbx

movq    %r11, %rsp
 
ret
