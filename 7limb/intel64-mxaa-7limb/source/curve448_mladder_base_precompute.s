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
.globl curve448_mladder_base_precompute
curve448_mladder_base_precompute:

movq 	%rsp, %r11
subq 	$608, %rsp

movq 	%r11,  0(%rsp)
movq 	%r12,  8(%rsp)
movq 	%r13, 16(%rsp)
movq 	%r14, 24(%rsp)
movq 	%r15, 32(%rsp)
movq 	%rbx, 40(%rsp)
movq 	%rbp, 48(%rsp)
movq 	%rdi, 56(%rsp)

// X2 ← X(s)
movq	$0xFFFFFFFFFFFFFFFE, %r8
movq	$0xFFFFFFFFFFFFFFFF, %r9
movq	$0xFFFFFFFFFFFFFFFF, %r10
movq	$0xFFFFFFFEFFFFFFFF, %r11
movq	$0xFFFFFFFFFFFFFFFF, %r12
movq	$0xFFFFFFFFFFFFFFFF, %r13
movq	$0xFFFFFFFFFFFFFFFF, %r14

movq    %r8, 72(%rsp)
movq    %r9, 80(%rsp)
movq    %r10, 88(%rsp)
movq    %r11, 96(%rsp)
movq    %r12, 104(%rsp)
movq    %r13, 112(%rsp)
movq    %r14, 120(%rsp)

// Z2 ← 1
movq	$1, 128(%rsp)
movq	$0, 136(%rsp)
movq	$0, 144(%rsp)
movq	$0, 152(%rsp)
movq	$0, 160(%rsp)
movq	$0, 168(%rsp)
movq	$0, 176(%rsp)  

// X3 ← X(p-s)
movq	$0xACB1197DC99D2720, %r8
movq	$0x23AC33FF1C69BAF8, %r9
movq	$0xF1BD65643ACE1B51, %r10
movq	$0x2954459D84C1F823, %r11
movq	$0xDACDD1031C81B967, %r12
movq	$0x3ACF03881AFFEB7B, %r13
movq	$0xF0FAB72501324442, %r14

movq    %r8, 184(%rsp)
movq    %r9, 192(%rsp)
movq    %r10, 200(%rsp)
movq    %r11, 208(%rsp)
movq    %r12, 216(%rsp)
movq    %r13, 224(%rsp)
movq    %r14, 232(%rsp)

// Z3 ← 1
movq	$1, 240(%rsp)
movq	$0, 248(%rsp)
movq	$0, 256(%rsp)
movq	$0, 264(%rsp)
movq	$0, 272(%rsp)
movq	$0, 280(%rsp)
movq	$0, 288(%rsp)

movq    $table448, %rbx
movq    %rbx, 600(%rsp) 

movq    $0, 304(%rsp)
movb	$2, 296(%rsp)
movb    $1, 298(%rsp)
movq    %rdx, 64(%rsp)

movq    %rdx, %rax

.L1:

addq    304(%rsp), %rax
movb    0(%rax), %r14b
movb    %r14b, 300(%rsp)

.L2:

/* 
 * Addition steps
 *
 * bit ← n[i]
 * swap ← bit ⊕ prevbit
 * prevbit ← bit
 * CSwap(X2,X3,swap)
 * CSwap(Z2,Z3,swap)
 *
 * T2 ← X2 - Z2
 * T1 ← X2 + Z2
 * T3 ← μ[i] · T2
 * T2 ← T1 - T3
 * T1 ← T1 + T3
 * T1 ← T1^2
 * T2 ← T2^2
 * X2 ← Z3 · T1
 * Z2 ← X3 · T2
 */

movb	296(%rsp), %cl
movb	300(%rsp), %bl
shrb    %cl, %bl
andb    $1, %bl
movb    %bl, %cl
xorb    298(%rsp), %bl
movb    %cl, 298(%rsp)

cmpb    $1, %bl

// CSwap(X2,X3,swap)
movq    72(%rsp), %r8
movq    80(%rsp), %r9
movq    88(%rsp), %r10
movq    96(%rsp), %r11
movq    104(%rsp), %r12
movq    112(%rsp), %r13
movq    120(%rsp), %r14

movq    184(%rsp), %r15
movq    192(%rsp), %rax
movq    200(%rsp), %rbx
movq    208(%rsp), %rcx
movq    216(%rsp), %rdx
movq    224(%rsp), %rbp
movq    232(%rsp), %rsi

movq    %r8, %rdi
cmove   %r15, %r8
cmove   %rdi, %r15

movq    %r9, %rdi
cmove   %rax, %r9
cmove   %rdi, %rax

movq    %r10, %rdi
cmove   %rbx, %r10
cmove   %rdi, %rbx

movq    %r11, %rdi
cmove   %rcx, %r11
cmove   %rdi, %rcx

movq    %r12, %rdi
cmove   %rdx, %r12
cmove   %rdi, %rdx

movq    %r13, %rdi
cmove   %rbp, %r13
cmove   %rdi, %rbp

movq    %r14, %rdi
cmove   %rsi, %r14
cmove   %rdi, %rsi

movq    %r8,  72(%rsp)
movq    %r9,  80(%rsp)
movq    %r10, 88(%rsp)
movq    %r11, 96(%rsp)
movq    %r12, 104(%rsp)
movq    %r13, 112(%rsp)
movq    %r14, 120(%rsp)

movq    %r15 ,184(%rsp)
movq    %rax, 192(%rsp)
movq    %rbx, 200(%rsp)
movq    %rcx, 208(%rsp)
movq    %rdx, 216(%rsp)
movq    %rbp, 224(%rsp)
movq    %rsi, 232(%rsp)

// CSwap(Z2,Z3,swap)
movq    128(%rsp), %r8
movq    136(%rsp), %r9
movq    144(%rsp), %r10
movq    152(%rsp), %r11
movq    160(%rsp), %r12
movq    168(%rsp), %r13
movq    176(%rsp), %r14

movq    240(%rsp), %r15
movq    248(%rsp), %rax
movq    256(%rsp), %rbx
movq    264(%rsp), %rcx
movq    272(%rsp), %rdx
movq    280(%rsp), %rbp
movq    288(%rsp), %rsi

movq    %r8, %rdi
cmove   %r15, %r8
cmove   %rdi, %r15

movq    %r9, %rdi
cmove   %rax, %r9
cmove   %rdi, %rax

movq    %r10, %rdi
cmove   %rbx, %r10
cmove   %rdi, %rbx

movq    %r11, %rdi
cmove   %rcx, %r11
cmove   %rdi, %rcx

movq    %r12, %rdi
cmove   %rdx, %r12
cmove   %rdi, %rdx

movq    %r13, %rdi
cmove   %rbp, %r13
cmove   %rdi, %rbp

movq    %r14, %rdi
cmove   %rsi, %r14
cmove   %rdi, %rsi

movq    %r14, 176(%rsp)

movq    %r15, 240(%rsp)
movq    %rax, 248(%rsp)
movq    %rbx, 256(%rsp)
movq    %rcx, 264(%rsp)
movq    %rdx, 272(%rsp)
movq    %rbp, 280(%rsp)
movq    %rsi, 288(%rsp)

// X2
movq    72(%rsp), %r15
movq    80(%rsp), %rax
movq    88(%rsp), %rbx
movq    96(%rsp), %rcx
movq    104(%rsp), %rdx
movq    112(%rsp), %rbp
movq    120(%rsp), %rsi

// T2 ← X2 - Z2
subq    %r8, %r15
sbbq    %r9, %rax
sbbq    %r10, %rbx
sbbq    %r11, %rcx
sbbq    %r12, %rdx
sbbq    %r13, %rbp
sbbq    %r14, %rsi
movq    $0, %rdi
adcq    $0, %rdi

movq    %rdi, %r14
shlq    $32,  %r14

subq    %rdi, %r15
sbbq    $0, %rax
sbbq    $0, %rbx
sbbq    %r14, %rcx
sbbq    $0, %rdx
sbbq    $0, %rbp
sbbq    $0, %rsi
movq    $0, %rdi
adcq    $0, %rdi

movq    %rdi, %r14
shlq    $32, %r14

subq    %rdi, %r15
sbbq    $0, %rax
sbbq    $0, %rbx
sbbq    %r14, %rcx

movq    %r15, 368(%rsp)
movq    %rax, 376(%rsp)
movq    %rbx, 384(%rsp)
movq    %rcx, 392(%rsp)
movq    %rdx, 400(%rsp)
movq    %rbp, 408(%rsp)
movq    %rsi, 416(%rsp)

movq    176(%rsp), %r14

// T1 ← X2 + Z2
addq    72(%rsp), %r8
adcq    80(%rsp), %r9
adcq    88(%rsp), %r10
adcq    96(%rsp), %r11
adcq    104(%rsp), %r12
adcq    112(%rsp), %r13
adcq    120(%rsp), %r14
movq    $0, %rcx
adcq    $0, %rcx

movq    %rcx, %r15
shlq    $32,  %r15

addq    %rcx, %r8
adcq    $0, %r9
adcq    $0, %r10
adcq    %r15, %r11
adcq    $0, %r12
adcq    $0, %r13
adcq    $0, %r14
movq    $0, %rcx
adcq    $0, %rcx

movq    %rcx, %r15
shlq    $32, %r15

addq    %rcx, %r8
adcq    $0, %r9
adcq    $0, %r10
adcq    %r15, %r11

movq    %r8,  312(%rsp)
movq    %r9,  320(%rsp)
movq    %r10, 328(%rsp)
movq    %r11, 336(%rsp)
movq    %r12, 344(%rsp)
movq    %r13, 352(%rsp)
movq    %r14, 360(%rsp)

// T3 ← μ[i] · T2
movq	600(%rsp), %rbx

movq    0(%rbx), %rdx

mulx    368(%rsp), %r8, %r9
mulx    376(%rsp), %rcx, %r10
addq    %rcx, %r9

mulx    384(%rsp), %rcx, %r11
adcq    %rcx, %r10

mulx    392(%rsp), %rcx, %r12
adcq    %rcx, %r11

mulx    400(%rsp), %rcx, %r13
adcq    %rcx, %r12

mulx    408(%rsp), %rcx, %r14
adcq    %rcx, %r13

mulx    416(%rsp), %rcx, %r15
adcq    %rcx, %r14
adcq    $0, %r15

movq    %r8, 536(%rsp)
movq    %r9, 544(%rsp)
movq    %r10, 552(%rsp)

movq    8(%rbx), %rdx

mulx    368(%rsp), %r8, %r9
mulx    376(%rsp), %rcx, %r10
addq    %rcx, %r9

mulx    384(%rsp), %rcx, %rax
adcq    %rcx, %r10

mulx    392(%rsp), %rcx, %rbp
adcq    %rcx, %rax

mulx    400(%rsp), %rcx, %rsi
adcq    %rcx, %rbp

mulx    408(%rsp), %rcx, %rdi
adcq    %rcx, %rsi

mulx    416(%rsp), %rdx, %rcx
adcq    %rdx, %rdi
adcq    $0, %rcx

addq    544(%rsp), %r8
adcq    552(%rsp), %r9
adcq    %r11, %r10
adcq    %rax, %r12
adcq    %rbp, %r13
adcq    %rsi, %r14
adcq    %rdi, %r15
adcq    $0,   %rcx

movq    %r8, 544(%rsp)
movq    %r9, 552(%rsp)
movq    %r10, 560(%rsp)

movq    16(%rbx), %rdx

mulx    368(%rsp), %r8, %r9
mulx    376(%rsp), %r11, %r10
addq    %r11, %r9

mulx    384(%rsp), %r11, %rax
adcq    %r11, %r10

mulx    392(%rsp), %r11, %rbp
adcq    %r11, %rax

mulx    400(%rsp), %r11, %rsi
adcq    %r11, %rbp

mulx    408(%rsp), %r11, %rdi
adcq    %r11, %rsi

mulx    416(%rsp), %rdx, %r11
adcq    %rdx, %rdi
adcq    $0, %r11

addq    552(%rsp), %r8
adcq    560(%rsp), %r9
adcq    %r12, %r10
adcq    %rax, %r13
adcq    %rbp, %r14
adcq    %rsi, %r15
adcq    %rdi, %rcx
adcq    $0,   %r11

movq    %r8, 552(%rsp)
movq    %r9, 560(%rsp)
movq    %r10, 568(%rsp)

movq    24(%rbx), %rdx

mulx    368(%rsp), %r8, %r9
mulx    376(%rsp), %r12, %r10
addq    %r12, %r9

mulx    384(%rsp), %r12, %rax
adcq    %r12, %r10

mulx    392(%rsp), %r12, %rbp
adcq    %r12, %rax

mulx    400(%rsp), %r12, %rsi
adcq    %r12, %rbp

mulx    408(%rsp), %r12, %rdi
adcq    %r12, %rsi

mulx    416(%rsp), %rdx, %r12
adcq    %rdx, %rdi
adcq    $0, %r12

addq    560(%rsp), %r8
adcq    568(%rsp), %r9
adcq    %r13, %r10
adcq    %rax, %r14
adcq    %rbp, %r15
adcq    %rsi, %rcx
adcq    %rdi, %r11
adcq    $0,   %r12

movq    %r8, 560(%rsp)
movq    %r9, 568(%rsp)
movq    %r10, 576(%rsp)

movq    32(%rbx), %rdx

mulx    368(%rsp), %r8, %r9
mulx    376(%rsp), %r13, %r10
addq    %r13, %r9

mulx    384(%rsp), %r13, %rax
adcq    %r13, %r10

mulx    392(%rsp), %r13, %rbp
adcq    %r13, %rax

mulx    400(%rsp), %r13, %rsi
adcq    %r13, %rbp

mulx    408(%rsp), %r13, %rdi
adcq    %r13, %rsi

mulx    416(%rsp), %rdx, %r13
adcq    %rdx, %rdi
adcq    $0, %r13

addq    568(%rsp), %r8
adcq    576(%rsp), %r9
adcq    %r14, %r10
adcq    %rax, %r15
adcq    %rbp, %rcx
adcq    %rsi, %r11
adcq    %rdi, %r12
adcq    $0,   %r13

movq    %r8, 568(%rsp)
movq    %r9, 576(%rsp)
movq    %r10, 584(%rsp)

movq    40(%rbx), %rdx

mulx    368(%rsp), %r8, %r9
mulx    376(%rsp), %r14, %r10
addq    %r14, %r9

mulx    384(%rsp), %r14, %rax
adcq    %r14, %r10

mulx    392(%rsp), %r14, %rbp
adcq    %r14, %rax

mulx    400(%rsp), %r14, %rsi
adcq    %r14, %rbp

mulx    408(%rsp), %r14, %rdi
adcq    %r14, %rsi

mulx    416(%rsp), %rdx, %r14
adcq    %rdx, %rdi
adcq    $0, %r14

addq    576(%rsp), %r8
adcq    584(%rsp), %r9
adcq    %r15, %r10
adcq    %rax, %rcx
adcq    %rbp, %r11
adcq    %rsi, %r12
adcq    %rdi, %r13
adcq    $0,   %r14

movq    %r8, 576(%rsp)
movq    %r9, 584(%rsp)
movq    %r10, 592(%rsp)

movq    48(%rbx), %rdx

mulx    368(%rsp), %r8, %r9
mulx    376(%rsp), %r15, %r10
addq    %r15, %r9

mulx    384(%rsp), %r15, %rax
adcq    %r15, %r10

mulx    392(%rsp), %r15, %rbp
adcq    %r15, %rax

mulx    400(%rsp), %r15, %rsi
adcq    %r15, %rbp

mulx    408(%rsp), %r15, %rdi
adcq    %r15, %rsi

mulx    416(%rsp), %rdx, %r15
adcq    %rdx, %rdi
adcq    $0, %r15

addq    584(%rsp), %r8
adcq    592(%rsp), %r9
adcq    %rcx, %r10
adcq    %rax, %r11
adcq    %rbp, %r12
adcq    %rsi, %r13
adcq    %rdi, %r14
adcq    $0,   %r15

movq    536(%rsp), %rax
movq    544(%rsp), %rbx
movq    552(%rsp), %rcx
movq    560(%rsp), %rdx
movq    568(%rsp), %rbp
movq    576(%rsp), %rsi
  
xorq    %rdi,%rdi
addq    %r9, %rax
adcq    %r10, %rbx
adcq    %r11, %rcx
adcq    %r12, %rdx
adcq    %r13, %rbp
adcq    %r14, %rsi
adcq    %r15, %r8
adcq    $0, %rdi
  
movq    %rax, 536(%rsp)

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

addq    536(%rsp), %r12
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

movq    %r8,  472(%rsp)

// T1
movq    312(%rsp), %r9
movq    320(%rsp), %r10
movq    328(%rsp), %r11
movq    336(%rsp), %r13
movq    344(%rsp), %r14
movq    352(%rsp), %r15
movq    360(%rsp), %rax

// T2 ← T1 - T3
subq    %r12, %r9
sbbq    %rbx, %r10
sbbq    %rcx, %r11
sbbq    %rdx, %r13
sbbq    %rbp, %r14
sbbq    %rsi, %r15
sbbq    %r8, %rax
movq    $0, %rdi
adcq    $0, %rdi

movq    %rdi, %r8
shlq    $32,  %r8

subq    %rdi, %r9
sbbq    $0, %r10
sbbq    $0, %r11
sbbq    %r8, %r13
sbbq    $0, %r14
sbbq    $0, %r15
sbbq    $0, %rax
movq    $0, %rdi
adcq    $0, %rdi

movq    %rdi, %r8
shlq    $32, %r8

subq    %rdi, %r9
sbbq    $0, %r10
sbbq    $0, %r11
sbbq    %r8, %r13

movq    %r9,  368(%rsp)
movq    %r10, 376(%rsp)
movq    %r11, 384(%rsp)
movq    %r13, 392(%rsp)
movq    %r14, 400(%rsp)
movq    %r15, 408(%rsp)
movq    %rax, 416(%rsp)

movq    472(%rsp), %r8

// T1 ← T1 + T3
addq    312(%rsp), %r12
adcq    320(%rsp), %rbx
adcq    328(%rsp), %rcx
adcq    336(%rsp), %rdx
adcq    344(%rsp), %rbp
adcq    352(%rsp), %rsi
adcq    360(%rsp), %r8
movq    $0, %rdi
adcq    $0, %rdi

movq    %rdi, %r15
shlq    $32,  %r15

addq    %rdi, %r12
adcq    $0, %rbx
adcq    $0, %rcx
adcq    %r15, %rdx
adcq    $0, %rbp
adcq    $0, %rsi
adcq    $0, %r8
movq    $0, %rdi
adcq    $0, %rdi

movq    %rdi, %r15
shlq    $32, %r15

addq    %rdi, %r12
adcq    $0, %rbx
adcq    $0, %rcx
adcq    %r15, %rdx

movq    %r12, 312(%rsp)
movq    %rbx, 320(%rsp)
movq    %rcx, 328(%rsp)
movq    %rdx, 336(%rsp)
movq    %rbp, 344(%rsp)
movq    %rsi, 352(%rsp)
movq    %r8,  360(%rsp)

// T1 ← T1^2
movq    312(%rsp), %rdx
    
mulx    320(%rsp), %r9, %r10
mulx    328(%rsp), %rcx, %r11
addq    %rcx, %r10

mulx    336(%rsp), %rcx, %r12
adcq    %rcx, %r11

mulx    344(%rsp), %rcx, %r13
adcq    %rcx, %r12

mulx    352(%rsp), %rcx, %r14
adcq    %rcx, %r13

mulx    360(%rsp), %rcx, %r15
adcq    %rcx, %r14
adcq    $0, %r15

movq    320(%rsp), %rdx
mulx    328(%rsp), %rax, %rbx

mulx    336(%rsp), %rcx, %rbp
addq    %rcx, %rbx

mulx    344(%rsp), %rcx, %rsi
adcq    %rcx, %rbp

mulx    352(%rsp), %rcx, %r8
adcq    %rcx, %rsi

mulx    360(%rsp), %rdx, %rcx
adcq    %rdx, %r8
adcq    $0, %rcx

addq    %rax, %r11
adcq    %rbx, %r12
adcq    %rbp, %r13
adcq    %rsi, %r14
adcq    %r8,  %r15
adcq    $0,   %rcx

movq    328(%rsp), %rdx
mulx    336(%rsp), %rax, %rbx

mulx    344(%rsp), %r8, %rbp
addq    %r8, %rbx

mulx    352(%rsp), %r8, %rsi
adcq    %r8, %rbp

mulx    360(%rsp), %rdx, %r8
adcq    %rdx, %rsi
adcq    $0, %r8

addq    %rax, %r13
adcq    %rbx, %r14
adcq    %rbp, %r15
adcq    %rsi, %rcx
adcq    $0,    %r8

movq    336(%rsp), %rdx
mulx    344(%rsp), %rax, %rbx

mulx    352(%rsp), %rsi, %rbp
addq    %rsi, %rbx

mulx    360(%rsp), %rdx, %rsi
adcq    %rdx, %rbp
adcq    $0, %rsi

addq    %rax, %r15
adcq    %rbx, %rcx
adcq    %rbp,  %r8
adcq    $0,   %rsi

movq    344(%rsp), %rdx
mulx    352(%rsp), %rax, %rbx

mulx    360(%rsp), %rdx, %rbp
addq    %rdx, %rbx
adcq    $0, %rbp

addq    %rax,  %r8
adcq    %rbx, %rsi
adcq    $0,   %rbp

movq    352(%rsp), %rdx
mulx    360(%rsp), %rax, %rbx

addq    %rax, %rbp
adcq    $0,   %rbx

movq    $0, %rax
shld    $1, %rbx, %rax
shld    $1, %rbp, %rbx
shld    $1, %rsi, %rbp
shld    $1, %r8,  %rsi
shld    $1, %rcx, %r8
shld    $1, %r15, %rcx
shld    $1, %r14, %r15
shld    $1, %r13, %r14
shld    $1, %r12, %r13
shld    $1, %r11, %r12
shld    $1, %r10, %r11
shld    $1, %r9,  %r10
shlq    $1, %r9

movq    %r9,  536(%rsp)
movq    %r10, 544(%rsp)
movq    %r11, 552(%rsp)

movq    312(%rsp), %rdx
mulx    %rdx, %r11, %r10
addq    536(%rsp), %r10
movq    %r10, 536(%rsp)

movq    320(%rsp), %rdx
mulx    %rdx, %r9, %r10
adcq    544(%rsp), %r9
adcq    552(%rsp), %r10
movq    %r9,  544(%rsp)
movq    %r10, 552(%rsp)

movq    328(%rsp), %rdx
mulx    %rdx, %r9, %r10
adcq    %r9, %r12
adcq    %r10, %r13

movq    336(%rsp), %rdx
mulx    %rdx, %r9, %r10
adcq    %r9, %r14
adcq    %r10, %r15

movq    344(%rsp), %rdx
mulx    %rdx, %r9, %r10
adcq    %r9, %rcx
adcq    %r10, %r8

movq    352(%rsp), %rdx
mulx    %rdx, %r9, %r10
adcq    %r9, %rsi
adcq    %r10, %rbp

movq    360(%rsp), %rdx
mulx    %rdx, %r9, %r10
adcq    %r9, %rbx
adcq    %r10, %rax

movq    536(%rsp), %r9
movq    544(%rsp), %rdx
movq    552(%rsp), %r10

xorq    %rdi, %rdi
addq    %r15, %r11
adcq    %rcx, %r9
adcq    %r8,  %rdx
adcq    %rsi, %r10
adcq    %rbp, %r12
adcq    %rbx, %r13
adcq    %rax, %r14
adcq    $0, %rdi
    
movq    %r11, 536(%rsp)

movq    %rsi, %r11
andq    mask32h, %r11

addq    %r11, %r10
adcq    %rbp, %r12
adcq    %rbx, %r13
adcq    %rax, %r14
adcq    $0, %rdi

movq    %rsi,  %r11
shrd    $32, %rbp, %rsi
shrd    $32, %rbx, %rbp
shrd    $32, %rax, %rbx
shrd    $32, %r15, %rax
shrd    $32, %rcx, %r15
shrd    $32, %r8,  %rcx
shrd    $32, %r11, %r8

addq    536(%rsp), %rsi
adcq    %rbp, %r9
adcq    %rbx, %rdx
adcq    %rax, %r10
adcq    %r15, %r12
adcq    %rcx, %r13
adcq    %r8,  %r14
adcq    $0, %rdi

movq    %rdi, %rax
shlq    $32, %rax
    
xorq    %rcx, %rcx
addq    %rdi, %rsi
adcq    $0, %r9
adcq    $0, %rdx
adcq    %rax, %r10
adcq    $0, %r12
adcq    $0, %r13
adcq    $0, %r14
adcq    $0, %rcx

movq    %rcx, %rax
shlq    $32, %rax

addq    %rcx, %rsi
adcq    $0, %r9
adcq    $0, %rdx
adcq    %rax, %r10

movq    %rsi, 312(%rsp)
movq    %r9,  320(%rsp)
movq    %rdx, 328(%rsp)
movq    %r10, 336(%rsp)
movq    %r12, 344(%rsp)
movq    %r13, 352(%rsp)
movq    %r14, 360(%rsp)

// T2 ← T2^2
movq    368(%rsp), %rdx
    
mulx    376(%rsp), %r9, %r10
mulx    384(%rsp), %rcx, %r11
addq    %rcx, %r10

mulx    392(%rsp), %rcx, %r12
adcq    %rcx, %r11

mulx    400(%rsp), %rcx, %r13
adcq    %rcx, %r12

mulx    408(%rsp), %rcx, %r14
adcq    %rcx, %r13

mulx    416(%rsp), %rcx, %r15
adcq    %rcx, %r14
adcq    $0, %r15

movq    376(%rsp), %rdx
mulx    384(%rsp), %rax, %rbx

mulx    392(%rsp), %rcx, %rbp
addq    %rcx, %rbx

mulx    400(%rsp), %rcx, %rsi
adcq    %rcx, %rbp

mulx    408(%rsp), %rcx, %r8
adcq    %rcx, %rsi

mulx    416(%rsp), %rdx, %rcx
adcq    %rdx, %r8
adcq    $0, %rcx

addq    %rax, %r11
adcq    %rbx, %r12
adcq    %rbp, %r13
adcq    %rsi, %r14
adcq    %r8,  %r15
adcq    $0,   %rcx

movq    384(%rsp), %rdx
mulx    392(%rsp), %rax, %rbx

mulx    400(%rsp), %r8, %rbp
addq    %r8, %rbx

mulx    408(%rsp), %r8, %rsi
adcq    %r8, %rbp

mulx    416(%rsp), %rdx, %r8
adcq    %rdx, %rsi
adcq    $0, %r8

addq    %rax, %r13
adcq    %rbx, %r14
adcq    %rbp, %r15
adcq    %rsi, %rcx
adcq    $0,    %r8

movq    392(%rsp), %rdx
mulx    400(%rsp), %rax, %rbx

mulx    408(%rsp), %rsi, %rbp
addq    %rsi, %rbx

mulx    416(%rsp), %rdx, %rsi
adcq    %rdx, %rbp
adcq    $0, %rsi

addq    %rax, %r15
adcq    %rbx, %rcx
adcq    %rbp,  %r8
adcq    $0,   %rsi

movq    400(%rsp), %rdx
mulx    408(%rsp), %rax, %rbx

mulx    416(%rsp), %rdx, %rbp
addq    %rdx, %rbx
adcq    $0, %rbp

addq    %rax,  %r8
adcq    %rbx, %rsi
adcq    $0,   %rbp

movq    408(%rsp), %rdx
mulx    416(%rsp), %rax, %rbx

addq    %rax, %rbp
adcq    $0,   %rbx

movq    $0, %rax
shld    $1, %rbx, %rax
shld    $1, %rbp, %rbx
shld    $1, %rsi, %rbp
shld    $1, %r8,  %rsi
shld    $1, %rcx, %r8
shld    $1, %r15, %rcx
shld    $1, %r14, %r15
shld    $1, %r13, %r14
shld    $1, %r12, %r13
shld    $1, %r11, %r12
shld    $1, %r10, %r11
shld    $1, %r9,  %r10
shlq    $1, %r9

movq    %r9,  536(%rsp)
movq    %r10, 544(%rsp)
movq    %r11, 552(%rsp)

movq    368(%rsp), %rdx
mulx    %rdx, %r11, %r10
addq    536(%rsp), %r10
movq    %r10, 536(%rsp)

movq    376(%rsp), %rdx
mulx    %rdx, %r9, %r10
adcq    544(%rsp), %r9
adcq    552(%rsp), %r10
movq    %r9,  544(%rsp)
movq    %r10, 552(%rsp)

movq    384(%rsp), %rdx
mulx    %rdx, %r9, %r10
adcq    %r9, %r12
adcq    %r10, %r13

movq    392(%rsp), %rdx
mulx    %rdx, %r9, %r10
adcq    %r9, %r14
adcq    %r10, %r15

movq    400(%rsp), %rdx
mulx    %rdx, %r9, %r10
adcq    %r9, %rcx
adcq    %r10, %r8

movq    408(%rsp), %rdx
mulx    %rdx, %r9, %r10
adcq    %r9, %rsi
adcq    %r10, %rbp

movq    416(%rsp), %rdx
mulx    %rdx, %r9, %r10
adcq    %r9, %rbx
adcq    %r10, %rax

movq    536(%rsp), %r9
movq    544(%rsp), %rdx
movq    552(%rsp), %r10

xorq    %rdi, %rdi
addq    %r15, %r11
adcq    %rcx, %r9
adcq    %r8,  %rdx
adcq    %rsi, %r10
adcq    %rbp, %r12
adcq    %rbx, %r13
adcq    %rax, %r14
adcq    $0, %rdi
    
movq    %r11, 536(%rsp)

movq    %rsi, %r11
andq    mask32h, %r11

addq    %r11, %r10
adcq    %rbp, %r12
adcq    %rbx, %r13
adcq    %rax, %r14
adcq    $0, %rdi

movq    %rsi,  %r11
shrd    $32, %rbp, %rsi
shrd    $32, %rbx, %rbp
shrd    $32, %rax, %rbx
shrd    $32, %r15, %rax
shrd    $32, %rcx, %r15
shrd    $32, %r8,  %rcx
shrd    $32, %r11, %r8

addq    536(%rsp), %rsi
adcq    %rbp, %r9
adcq    %rbx, %rdx
adcq    %rax, %r10
adcq    %r15, %r12
adcq    %rcx, %r13
adcq    %r8,  %r14
adcq    $0, %rdi

movq    %rdi, %rax
shlq    $32, %rax
    
xorq    %rcx, %rcx
addq    %rdi, %rsi
adcq    $0, %r9
adcq    $0, %rdx
adcq    %rax, %r10
adcq    $0, %r12
adcq    $0, %r13
adcq    $0, %r14
adcq    $0, %rcx

movq    %rcx, %rax
shlq    $32, %rax

addq    %rcx, %rsi
adcq    $0, %r9
adcq    $0, %rdx
adcq    %rax, %r10

movq    %rsi, 368(%rsp)
movq    %r9,  376(%rsp)
movq    %rdx, 384(%rsp)
movq    %r10, 392(%rsp)
movq    %r12, 400(%rsp)
movq    %r13, 408(%rsp)
movq    %r14, 416(%rsp)

// X2 ← Z3 · T1
movq    312(%rsp), %rdx    

mulx    240(%rsp), %r8, %r9
mulx    248(%rsp), %rcx, %r10
addq    %rcx, %r9

mulx    256(%rsp), %rcx, %r11
adcq    %rcx, %r10

mulx    264(%rsp), %rcx, %r12
adcq    %rcx, %r11

mulx    272(%rsp), %rcx, %r13
adcq    %rcx, %r12

mulx    280(%rsp), %rcx, %r14
adcq    %rcx, %r13

mulx    288(%rsp), %rcx, %r15
adcq    %rcx, %r14
adcq    $0, %r15

movq    %r8, 536(%rsp)
movq    %r9, 544(%rsp)

movq    320(%rsp), %rdx

mulx    240(%rsp), %r8, %r9
mulx    248(%rsp), %rcx, %rax
addq    %rcx, %r9

mulx    256(%rsp), %rcx, %rbx
adcq    %rcx, %rax

mulx    264(%rsp), %rcx, %rbp
adcq    %rcx, %rbx

mulx    272(%rsp), %rcx, %rsi
adcq    %rcx, %rbp

mulx    280(%rsp), %rcx, %rdi
adcq    %rcx, %rsi

mulx    288(%rsp), %rdx, %rcx
adcq    %rdx, %rdi
adcq    $0, %rcx

addq    544(%rsp), %r8
adcq    %r10, %r9
adcq    %rax, %r11
adcq    %rbx, %r12
adcq    %rbp, %r13
adcq    %rsi, %r14
adcq    %rdi, %r15
adcq    $0,   %rcx

movq    %r8, 544(%rsp)
movq    %r9, 552(%rsp)

movq    328(%rsp), %rdx

mulx    240(%rsp), %r8, %r9
mulx    248(%rsp), %r10, %rax
addq    %r10, %r9

mulx    256(%rsp), %r10, %rbx
adcq    %r10, %rax

mulx    264(%rsp), %r10, %rbp
adcq    %r10, %rbx

mulx    272(%rsp), %r10, %rsi
adcq    %r10, %rbp

mulx    280(%rsp), %r10, %rdi
adcq    %r10, %rsi

mulx    288(%rsp), %rdx, %r10
adcq    %rdx, %rdi
adcq    $0, %r10

addq    552(%rsp), %r8
adcq    %r11,  %r9
adcq    %rax, %r12
adcq    %rbx, %r13
adcq    %rbp, %r14
adcq    %rsi, %r15
adcq    %rdi, %rcx
adcq    $0,   %r10

movq    %r8, 552(%rsp)
movq    %r9, 560(%rsp)

movq    336(%rsp), %rdx

mulx    240(%rsp), %r8, %r9
mulx    248(%rsp), %r11, %rax
addq    %r11, %r9

mulx    256(%rsp), %r11, %rbx
adcq    %r11, %rax

mulx    264(%rsp), %r11, %rbp
adcq    %r11, %rbx

mulx    272(%rsp), %r11, %rsi
adcq    %r11, %rbp

mulx    280(%rsp), %r11, %rdi
adcq    %r11, %rsi

mulx    288(%rsp), %rdx, %r11
adcq    %rdx, %rdi
adcq    $0, %r11

addq    560(%rsp), %r8
adcq    %r12,  %r9
adcq    %rax, %r13
adcq    %rbx, %r14
adcq    %rbp, %r15
adcq    %rsi, %rcx
adcq    %rdi, %r10
adcq    $0,   %r11

movq    %r8, 560(%rsp)
movq    %r9, 568(%rsp)

movq    344(%rsp), %rdx

mulx    240(%rsp), %r8, %r9
mulx    248(%rsp), %r12, %rax
addq    %r12, %r9

mulx    256(%rsp), %r12, %rbx
adcq    %r12, %rax

mulx    264(%rsp), %r12, %rbp
adcq    %r12, %rbx

mulx    272(%rsp), %r12, %rsi
adcq    %r12, %rbp

mulx    280(%rsp), %r12, %rdi
adcq    %r12, %rsi

mulx    288(%rsp), %rdx, %r12
adcq    %rdx, %rdi
adcq    $0, %r12

addq    568(%rsp), %r8
adcq    %r13,  %r9
adcq    %rax, %r14
adcq    %rbx, %r15
adcq    %rbp, %rcx
adcq    %rsi, %r10
adcq    %rdi, %r11
adcq    $0,   %r12

movq    %r8, 568(%rsp)
movq    %r9, 576(%rsp)

movq    352(%rsp), %rdx

mulx    240(%rsp), %r8, %r9
mulx    248(%rsp), %r13, %rax
addq    %r13, %r9

mulx    256(%rsp), %r13, %rbx
adcq    %r13, %rax

mulx    264(%rsp), %r13, %rbp
adcq    %r13, %rbx

mulx    272(%rsp), %r13, %rsi
adcq    %r13, %rbp

mulx    280(%rsp), %r13, %rdi
adcq    %r13, %rsi

mulx    288(%rsp), %rdx, %r13
adcq    %rdx, %rdi
adcq    $0, %r13

addq    576(%rsp), %r8
adcq    %r14,  %r9
adcq    %rax, %r15
adcq    %rbx, %rcx
adcq    %rbp, %r10
adcq    %rsi, %r11
adcq    %rdi, %r12
adcq    $0,   %r13

movq    %r8, 576(%rsp)
movq    %r9, 584(%rsp)

movq    360(%rsp), %rdx

mulx    240(%rsp), %r8, %r9
mulx    248(%rsp), %r14, %rax
addq    %r14, %r9

mulx    256(%rsp), %r14, %rbx
adcq    %r14, %rax

mulx    264(%rsp), %r14, %rbp
adcq    %r14, %rbx

mulx    272(%rsp), %r14, %rsi
adcq    %r14, %rbp

mulx    280(%rsp), %r14, %rdi
adcq    %r14, %rsi

mulx    288(%rsp), %rdx, %r14
adcq    %rdx, %rdi
adcq    $0, %r14

addq    584(%rsp), %r8
adcq    %r15,  %r9
adcq    %rax, %rcx
adcq    %rbx, %r10
adcq    %rbp, %r11
adcq    %rsi, %r12
adcq    %rdi, %r13
adcq    $0,   %r14

movq    536(%rsp), %rax
movq    544(%rsp), %rbx
movq    552(%rsp), %r15
movq    560(%rsp), %rdx
movq    568(%rsp), %rbp
movq    576(%rsp), %rsi
  
xorq    %rdi,%rdi
addq    %r9, %rax
adcq    %rcx, %rbx
adcq    %r10, %r15
adcq    %r11, %rdx
adcq    %r12, %rbp
adcq    %r13, %rsi
adcq    %r14, %r8
adcq    $0, %rdi
  
movq    %rax, 536(%rsp)

movq    %r11, %rax
andq    mask32h, %rax

addq    %rax, %rdx
adcq    %r12, %rbp
adcq    %r13, %rsi
adcq    %r14, %r8
adcq    $0, %rdi

movq    %r11,  %rax
shrd    $32, %r12, %r11
shrd    $32, %r13, %r12
shrd    $32, %r14, %r13
shrd    $32, %r9,  %r14
shrd    $32, %rcx, %r9
shrd    $32, %r10, %rcx
shrd    $32, %rax, %r10

addq    536(%rsp), %r11
adcq    %r12, %rbx
adcq    %r13, %r15
adcq    %r14, %rdx
adcq    %r9,  %rbp
adcq    %rcx, %rsi
adcq    %r10, %r8
adcq    $0, %rdi

movq    %rdi, %r13
shlq    $32, %r13
    
xorq    %r14, %r14
addq    %rdi, %r11
adcq    $0, %rbx
adcq    $0, %r15
adcq    %r13, %rdx
adcq    $0, %rbp
adcq    $0, %rsi
adcq    $0, %r8
adcq    $0, %r14

movq    %r14, %r13
shlq    $32, %r13

addq    %r14, %r11
adcq    $0, %rbx
adcq    $0, %r15
adcq    %r13, %rdx

movq    %r11, 72(%rsp) 
movq    %rbx, 80(%rsp)
movq    %r15, 88(%rsp)
movq    %rdx, 96(%rsp)
movq    %rbp, 104(%rsp)
movq    %rsi, 112(%rsp)
movq    %r8,  120(%rsp)

// Z2 ← X3 · T2
movq    184(%rsp), %rdx    

mulx    368(%rsp), %r8, %r9
mulx    376(%rsp), %rcx, %r10
addq    %rcx, %r9

mulx    384(%rsp), %rcx, %r11
adcq    %rcx, %r10

mulx    392(%rsp), %rcx, %r12
adcq    %rcx, %r11

mulx    400(%rsp), %rcx, %r13
adcq    %rcx, %r12

mulx    408(%rsp), %rcx, %r14
adcq    %rcx, %r13

mulx    416(%rsp), %rcx, %r15
adcq    %rcx, %r14
adcq    $0, %r15

movq    %r8, 536(%rsp)
movq    %r9, 544(%rsp)

movq    192(%rsp), %rdx

mulx    368(%rsp), %r8, %r9
mulx    376(%rsp), %rcx, %rax
addq    %rcx, %r9

mulx    384(%rsp), %rcx, %rbx
adcq    %rcx, %rax

mulx    392(%rsp), %rcx, %rbp
adcq    %rcx, %rbx

mulx    400(%rsp), %rcx, %rsi
adcq    %rcx, %rbp

mulx    408(%rsp), %rcx, %rdi
adcq    %rcx, %rsi

mulx    416(%rsp), %rdx, %rcx
adcq    %rdx, %rdi
adcq    $0, %rcx

addq    544(%rsp), %r8
adcq    %r10, %r9
adcq    %rax, %r11
adcq    %rbx, %r12
adcq    %rbp, %r13
adcq    %rsi, %r14
adcq    %rdi, %r15
adcq    $0,   %rcx

movq    %r8, 544(%rsp)
movq    %r9, 552(%rsp)

movq    200(%rsp), %rdx

mulx    368(%rsp), %r8, %r9
mulx    376(%rsp), %r10, %rax
addq    %r10, %r9

mulx    384(%rsp), %r10, %rbx
adcq    %r10, %rax

mulx    392(%rsp), %r10, %rbp
adcq    %r10, %rbx

mulx    400(%rsp), %r10, %rsi
adcq    %r10, %rbp

mulx    408(%rsp), %r10, %rdi
adcq    %r10, %rsi

mulx    416(%rsp), %rdx, %r10
adcq    %rdx, %rdi
adcq    $0, %r10

addq    552(%rsp), %r8
adcq    %r11,  %r9
adcq    %rax, %r12
adcq    %rbx, %r13
adcq    %rbp, %r14
adcq    %rsi, %r15
adcq    %rdi, %rcx
adcq    $0,   %r10

movq    %r8, 552(%rsp)
movq    %r9, 560(%rsp)

movq    208(%rsp), %rdx

mulx    368(%rsp), %r8, %r9
mulx    376(%rsp), %r11, %rax
addq    %r11, %r9

mulx    384(%rsp), %r11, %rbx
adcq    %r11, %rax

mulx    392(%rsp), %r11, %rbp
adcq    %r11, %rbx

mulx    400(%rsp), %r11, %rsi
adcq    %r11, %rbp

mulx    408(%rsp), %r11, %rdi
adcq    %r11, %rsi

mulx    416(%rsp), %rdx, %r11
adcq    %rdx, %rdi
adcq    $0, %r11

addq    560(%rsp), %r8
adcq    %r12,  %r9
adcq    %rax, %r13
adcq    %rbx, %r14
adcq    %rbp, %r15
adcq    %rsi, %rcx
adcq    %rdi, %r10
adcq    $0,   %r11

movq    %r8, 560(%rsp)
movq    %r9, 568(%rsp)

movq    216(%rsp), %rdx

mulx    368(%rsp), %r8, %r9
mulx    376(%rsp), %r12, %rax
addq    %r12, %r9

mulx    384(%rsp), %r12, %rbx
adcq    %r12, %rax

mulx    392(%rsp), %r12, %rbp
adcq    %r12, %rbx

mulx    400(%rsp), %r12, %rsi
adcq    %r12, %rbp

mulx    408(%rsp), %r12, %rdi
adcq    %r12, %rsi

mulx    416(%rsp), %rdx, %r12
adcq    %rdx, %rdi
adcq    $0, %r12

addq    568(%rsp), %r8
adcq    %r13,  %r9
adcq    %rax, %r14
adcq    %rbx, %r15
adcq    %rbp, %rcx
adcq    %rsi, %r10
adcq    %rdi, %r11
adcq    $0,   %r12

movq    %r8, 568(%rsp)
movq    %r9, 576(%rsp)

movq    224(%rsp), %rdx

mulx    368(%rsp), %r8, %r9
mulx    376(%rsp), %r13, %rax
addq    %r13, %r9

mulx    384(%rsp), %r13, %rbx
adcq    %r13, %rax

mulx    392(%rsp), %r13, %rbp
adcq    %r13, %rbx

mulx    400(%rsp), %r13, %rsi
adcq    %r13, %rbp

mulx    408(%rsp), %r13, %rdi
adcq    %r13, %rsi

mulx    416(%rsp), %rdx, %r13
adcq    %rdx, %rdi
adcq    $0, %r13

addq    576(%rsp), %r8
adcq    %r14,  %r9
adcq    %rax, %r15
adcq    %rbx, %rcx
adcq    %rbp, %r10
adcq    %rsi, %r11
adcq    %rdi, %r12
adcq    $0,   %r13

movq    %r8, 576(%rsp)
movq    %r9, 584(%rsp)

movq    232(%rsp), %rdx

mulx    368(%rsp), %r8, %r9
mulx    376(%rsp), %r14, %rax
addq    %r14, %r9

mulx    384(%rsp), %r14, %rbx
adcq    %r14, %rax

mulx    392(%rsp), %r14, %rbp
adcq    %r14, %rbx

mulx    400(%rsp), %r14, %rsi
adcq    %r14, %rbp

mulx    408(%rsp), %r14, %rdi
adcq    %r14, %rsi

mulx    416(%rsp), %rdx, %r14
adcq    %rdx, %rdi
adcq    $0, %r14

addq    584(%rsp), %r8
adcq    %r15,  %r9
adcq    %rax, %rcx
adcq    %rbx, %r10
adcq    %rbp, %r11
adcq    %rsi, %r12
adcq    %rdi, %r13
adcq    $0,   %r14

movq    536(%rsp), %rax
movq    544(%rsp), %rbx
movq    552(%rsp), %r15
movq    560(%rsp), %rdx
movq    568(%rsp), %rbp
movq    576(%rsp), %rsi
  
xorq    %rdi,%rdi
addq    %r9, %rax
adcq    %rcx, %rbx
adcq    %r10, %r15
adcq    %r11, %rdx
adcq    %r12, %rbp
adcq    %r13, %rsi
adcq    %r14, %r8
adcq    $0, %rdi
  
movq    %rax, 536(%rsp)

movq    %r11, %rax
andq    mask32h, %rax

addq    %rax, %rdx
adcq    %r12, %rbp
adcq    %r13, %rsi
adcq    %r14, %r8
adcq    $0, %rdi

movq    %r11,  %rax
shrd    $32, %r12, %r11
shrd    $32, %r13, %r12
shrd    $32, %r14, %r13
shrd    $32, %r9,  %r14
shrd    $32, %rcx, %r9
shrd    $32, %r10, %rcx
shrd    $32, %rax, %r10

addq    536(%rsp), %r11
adcq    %r12, %rbx
adcq    %r13, %r15
adcq    %r14, %rdx
adcq    %r9,  %rbp
adcq    %rcx, %rsi
adcq    %r10, %r8
adcq    $0, %rdi

movq    %rdi, %r13
shlq    $32, %r13
    
xorq    %r14, %r14
addq    %rdi, %r11
adcq    $0, %rbx
adcq    $0, %r15
adcq    %r13, %rdx
adcq    $0, %rbp
adcq    $0, %rsi
adcq    $0, %r8
adcq    $0, %r14

movq    %r14, %r13
shlq    $32, %r13

addq    %r14, %r11
adcq    $0, %rbx
adcq    $0, %r15
adcq    %r13, %rdx

movq    %r11, 128(%rsp) 
movq    %rbx, 136(%rsp)
movq    %r15, 144(%rsp)
movq    %rdx, 152(%rsp)
movq    %rbp, 160(%rsp)
movq    %rsi, 168(%rsp)
movq    %r8,  176(%rsp)

movq    600(%rsp), %rbx
addq    $56, %rbx
movq    %rbx, 600(%rsp)
movb    296(%rsp), %cl
addb    $1, %cl
movb    %cl, 296(%rsp)
cmpb	$7, %cl
jle     .L2

movb    $0, 296(%rsp)
movq    64(%rsp), %rax
movq    304(%rsp), %r15
addq    $1, %r15
movq    %r15, 304(%rsp)
cmpq	$55, %r15
jle     .L1

/*
 * Doubling steps
 *
 * T1 ← X2 + Z2
 * T2 ← X2 - Z2
 * T1 ← T1^2
 * T3 ← T2^2
 * T2 ← T1 - T3
 * T4 ← ((A + 2)/4) · T2
 * T4 ← T4 + T3
 * X2 ← T1 · T3
 * Z2 ← T2 · T4
 *
 */

// X2
movq    72(%rsp), %r8
movq    80(%rsp), %r9
movq    88(%rsp), %r10
movq    96(%rsp), %r11
movq    104(%rsp), %r12
movq    112(%rsp), %r13
movq    120(%rsp), %r14

// copy X2
movq    %r8,  %rax
movq    %r9,  %rbx
movq    %r10, %rbp
movq    %r11, %rsi
movq    %r12, %rdi
movq    %r13, %rdx

// T1 ← X2 + Z2
addq    128(%rsp), %r8
adcq    136(%rsp), %r9
adcq    144(%rsp), %r10
adcq    152(%rsp), %r11
adcq    160(%rsp), %r12
adcq    168(%rsp), %r13
adcq    176(%rsp), %r14
movq    $0, %rcx
adcq    $0, %rcx

movq    %rcx, %r15
shlq    $32,  %r15

addq    %rcx, %r8
adcq    $0, %r9
adcq    $0, %r10
adcq    %r15, %r11
adcq    $0, %r12
adcq    $0, %r13
adcq    $0, %r14
movq    $0, %rcx
adcq    $0, %rcx

movq    %rcx, %r15
shlq    $32, %r15

addq    %rcx, %r8
adcq    $0, %r9
adcq    $0, %r10
adcq    %r15, %r11

movq    %r8,  312(%rsp)
movq    %r9,  320(%rsp)
movq    %r10, 328(%rsp)
movq    %r11, 336(%rsp)
movq    %r12, 344(%rsp)
movq    %r13, 352(%rsp)
movq    %r14, 360(%rsp)

movq    120(%rsp), %r8

// T2 ← X2 - Z2
subq    128(%rsp), %rax
sbbq    136(%rsp), %rbx
sbbq    144(%rsp), %rbp
sbbq    152(%rsp), %rsi
sbbq    160(%rsp), %rdi
sbbq    168(%rsp), %rdx
sbbq    176(%rsp), %r8
movq    $0, %rcx
adcq    $0, %rcx

movq    %rcx, %r15
shlq    $32,  %r15

subq    %rcx, %rax
sbbq    $0, %rbx
sbbq    $0, %rbp
sbbq    %r15, %rsi
sbbq    $0, %rdi
sbbq    $0, %rdx
sbbq    $0, %r8
movq    $0, %rcx
adcq    $0, %rcx

movq    %rcx, %r15
shlq    $32, %r15

subq    %rcx, %rax
sbbq    $0, %rbx
sbbq    $0, %rbp
sbbq    %r15, %rsi

movq    %rax, 368(%rsp)
movq    %rbx, 376(%rsp)
movq    %rbp, 384(%rsp)
movq    %rsi, 392(%rsp)
movq    %rdi, 400(%rsp)
movq    %rdx, 408(%rsp)
movq    %r8,  416(%rsp)

// T1 ← T1^2
movq    312(%rsp), %rdx
    
mulx    320(%rsp), %r9, %r10
mulx    328(%rsp), %rcx, %r11
addq    %rcx, %r10

mulx    336(%rsp), %rcx, %r12
adcq    %rcx, %r11

mulx    344(%rsp), %rcx, %r13
adcq    %rcx, %r12

mulx    352(%rsp), %rcx, %r14
adcq    %rcx, %r13

mulx    360(%rsp), %rcx, %r15
adcq    %rcx, %r14
adcq    $0, %r15

movq    320(%rsp), %rdx
mulx    328(%rsp), %rax, %rbx

mulx    336(%rsp), %rcx, %rbp
addq    %rcx, %rbx

mulx    344(%rsp), %rcx, %rsi
adcq    %rcx, %rbp

mulx    352(%rsp), %rcx, %r8
adcq    %rcx, %rsi

mulx    360(%rsp), %rdx, %rcx
adcq    %rdx, %r8
adcq    $0, %rcx

addq    %rax, %r11
adcq    %rbx, %r12
adcq    %rbp, %r13
adcq    %rsi, %r14
adcq    %r8,  %r15
adcq    $0,   %rcx

movq    328(%rsp), %rdx
mulx    336(%rsp), %rax, %rbx

mulx    344(%rsp), %r8, %rbp
addq    %r8, %rbx

mulx    352(%rsp), %r8, %rsi
adcq    %r8, %rbp

mulx    360(%rsp), %rdx, %r8
adcq    %rdx, %rsi
adcq    $0, %r8

addq    %rax, %r13
adcq    %rbx, %r14
adcq    %rbp, %r15
adcq    %rsi, %rcx
adcq    $0,    %r8

movq    336(%rsp), %rdx
mulx    344(%rsp), %rax, %rbx

mulx    352(%rsp), %rsi, %rbp
addq    %rsi, %rbx

mulx    360(%rsp), %rdx, %rsi
adcq    %rdx, %rbp
adcq    $0, %rsi

addq    %rax, %r15
adcq    %rbx, %rcx
adcq    %rbp,  %r8
adcq    $0,   %rsi

movq    344(%rsp), %rdx
mulx    352(%rsp), %rax, %rbx

mulx    360(%rsp), %rdx, %rbp
addq    %rdx, %rbx
adcq    $0, %rbp

addq    %rax,  %r8
adcq    %rbx, %rsi
adcq    $0,   %rbp

movq    352(%rsp), %rdx
mulx    360(%rsp), %rax, %rbx

addq    %rax, %rbp
adcq    $0,   %rbx

movq    $0, %rax
shld    $1, %rbx, %rax
shld    $1, %rbp, %rbx
shld    $1, %rsi, %rbp
shld    $1, %r8,  %rsi
shld    $1, %rcx, %r8
shld    $1, %r15, %rcx
shld    $1, %r14, %r15
shld    $1, %r13, %r14
shld    $1, %r12, %r13
shld    $1, %r11, %r12
shld    $1, %r10, %r11
shld    $1, %r9,  %r10
shlq    $1, %r9

movq    %r9,  536(%rsp)
movq    %r10, 544(%rsp)
movq    %r11, 552(%rsp)

movq    312(%rsp), %rdx
mulx    %rdx, %r11, %r10
addq    536(%rsp), %r10
movq    %r10, 536(%rsp)

movq    320(%rsp), %rdx
mulx    %rdx, %r9, %r10
adcq    544(%rsp), %r9
adcq    552(%rsp), %r10
movq    %r9,  544(%rsp)
movq    %r10, 552(%rsp)

movq    328(%rsp), %rdx
mulx    %rdx, %r9, %r10
adcq    %r9, %r12
adcq    %r10, %r13

movq    336(%rsp), %rdx
mulx    %rdx, %r9, %r10
adcq    %r9, %r14
adcq    %r10, %r15

movq    344(%rsp), %rdx
mulx    %rdx, %r9, %r10
adcq    %r9, %rcx
adcq    %r10, %r8

movq    352(%rsp), %rdx
mulx    %rdx, %r9, %r10
adcq    %r9, %rsi
adcq    %r10, %rbp

movq    360(%rsp), %rdx
mulx    %rdx, %r9, %r10
adcq    %r9, %rbx
adcq    %r10, %rax

movq    536(%rsp), %r9
movq    544(%rsp), %rdx
movq    552(%rsp), %r10

xorq    %rdi, %rdi
addq    %r15, %r11
adcq    %rcx, %r9
adcq    %r8,  %rdx
adcq    %rsi, %r10
adcq    %rbp, %r12
adcq    %rbx, %r13
adcq    %rax, %r14
adcq    $0, %rdi
    
movq    %r11, 536(%rsp)

movq    %rsi, %r11
andq    mask32h, %r11

addq    %r11, %r10
adcq    %rbp, %r12
adcq    %rbx, %r13
adcq    %rax, %r14
adcq    $0, %rdi

movq    %rsi,  %r11
shrd    $32, %rbp, %rsi
shrd    $32, %rbx, %rbp
shrd    $32, %rax, %rbx
shrd    $32, %r15, %rax
shrd    $32, %rcx, %r15
shrd    $32, %r8,  %rcx
shrd    $32, %r11, %r8

addq    536(%rsp), %rsi
adcq    %rbp, %r9
adcq    %rbx, %rdx
adcq    %rax, %r10
adcq    %r15, %r12
adcq    %rcx, %r13
adcq    %r8,  %r14
adcq    $0, %rdi

movq    %rdi, %rax
shlq    $32, %rax
    
xorq    %rcx, %rcx
addq    %rdi, %rsi
adcq    $0, %r9
adcq    $0, %rdx
adcq    %rax, %r10
adcq    $0, %r12
adcq    $0, %r13
adcq    $0, %r14
adcq    $0, %rcx

movq    %rcx, %rax
shlq    $32, %rax

addq    %rcx, %rsi
adcq    $0, %r9
adcq    $0, %rdx
adcq    %rax, %r10

movq    %rsi, 312(%rsp)
movq    %r9,  320(%rsp)
movq    %rdx, 328(%rsp)
movq    %r10, 336(%rsp)
movq    %r12, 344(%rsp)
movq    %r13, 352(%rsp)
movq    %r14, 360(%rsp)

// T3 ← T2^2
movq    368(%rsp), %rdx
    
mulx    376(%rsp), %r9, %r10
mulx    384(%rsp), %rcx, %r11
addq    %rcx, %r10

mulx    392(%rsp), %rcx, %r12
adcq    %rcx, %r11

mulx    400(%rsp), %rcx, %r13
adcq    %rcx, %r12

mulx    408(%rsp), %rcx, %r14
adcq    %rcx, %r13

mulx    416(%rsp), %rcx, %r15
adcq    %rcx, %r14
adcq    $0, %r15

movq    376(%rsp), %rdx
mulx    384(%rsp), %rax, %rbx

mulx    392(%rsp), %rcx, %rbp
addq    %rcx, %rbx

mulx    400(%rsp), %rcx, %rsi
adcq    %rcx, %rbp

mulx    408(%rsp), %rcx, %r8
adcq    %rcx, %rsi

mulx    416(%rsp), %rdx, %rcx
adcq    %rdx, %r8
adcq    $0, %rcx

addq    %rax, %r11
adcq    %rbx, %r12
adcq    %rbp, %r13
adcq    %rsi, %r14
adcq    %r8,  %r15
adcq    $0,   %rcx

movq    384(%rsp), %rdx
mulx    392(%rsp), %rax, %rbx

mulx    400(%rsp), %r8, %rbp
addq    %r8, %rbx

mulx    408(%rsp), %r8, %rsi
adcq    %r8, %rbp

mulx    416(%rsp), %rdx, %r8
adcq    %rdx, %rsi
adcq    $0, %r8

addq    %rax, %r13
adcq    %rbx, %r14
adcq    %rbp, %r15
adcq    %rsi, %rcx
adcq    $0,    %r8

movq    392(%rsp), %rdx
mulx    400(%rsp), %rax, %rbx

mulx    408(%rsp), %rsi, %rbp
addq    %rsi, %rbx

mulx    416(%rsp), %rdx, %rsi
adcq    %rdx, %rbp
adcq    $0, %rsi

addq    %rax, %r15
adcq    %rbx, %rcx
adcq    %rbp,  %r8
adcq    $0,   %rsi

movq    400(%rsp), %rdx
mulx    408(%rsp), %rax, %rbx

mulx    416(%rsp), %rdx, %rbp
addq    %rdx, %rbx
adcq    $0, %rbp

addq    %rax,  %r8
adcq    %rbx, %rsi
adcq    $0,   %rbp

movq    408(%rsp), %rdx
mulx    416(%rsp), %rax, %rbx

addq    %rax, %rbp
adcq    $0,   %rbx

movq    $0, %rax
shld    $1, %rbx, %rax
shld    $1, %rbp, %rbx
shld    $1, %rsi, %rbp
shld    $1, %r8,  %rsi
shld    $1, %rcx, %r8
shld    $1, %r15, %rcx
shld    $1, %r14, %r15
shld    $1, %r13, %r14
shld    $1, %r12, %r13
shld    $1, %r11, %r12
shld    $1, %r10, %r11
shld    $1, %r9,  %r10
shlq    $1, %r9

movq    %r9,  536(%rsp)
movq    %r10, 544(%rsp)
movq    %r11, 552(%rsp)

movq    368(%rsp), %rdx
mulx    %rdx, %r11, %r10
addq    536(%rsp), %r10
movq    %r10, 536(%rsp)

movq    376(%rsp), %rdx
mulx    %rdx, %r9, %r10
adcq    544(%rsp), %r9
adcq    552(%rsp), %r10
movq    %r9,  544(%rsp)
movq    %r10, 552(%rsp)

movq    384(%rsp), %rdx
mulx    %rdx, %r9, %r10
adcq    %r9, %r12
adcq    %r10, %r13

movq    392(%rsp), %rdx
mulx    %rdx, %r9, %r10
adcq    %r9, %r14
adcq    %r10, %r15

movq    400(%rsp), %rdx
mulx    %rdx, %r9, %r10
adcq    %r9, %rcx
adcq    %r10, %r8

movq    408(%rsp), %rdx
mulx    %rdx, %r9, %r10
adcq    %r9, %rsi
adcq    %r10, %rbp

movq    416(%rsp), %rdx
mulx    %rdx, %r9, %r10
adcq    %r9, %rbx
adcq    %r10, %rax

movq    536(%rsp), %r9
movq    544(%rsp), %rdx
movq    552(%rsp), %r10

xorq    %rdi, %rdi
addq    %r15, %r11
adcq    %rcx, %r9
adcq    %r8,  %rdx
adcq    %rsi, %r10
adcq    %rbp, %r12
adcq    %rbx, %r13
adcq    %rax, %r14
adcq    $0, %rdi
    
movq    %r11, 536(%rsp)

movq    %rsi, %r11
andq    mask32h, %r11

addq    %r11, %r10
adcq    %rbp, %r12
adcq    %rbx, %r13
adcq    %rax, %r14
adcq    $0, %rdi

movq    %rsi,  %r11
shrd    $32, %rbp, %rsi
shrd    $32, %rbx, %rbp
shrd    $32, %rax, %rbx
shrd    $32, %r15, %rax
shrd    $32, %rcx, %r15
shrd    $32, %r8,  %rcx
shrd    $32, %r11, %r8

addq    536(%rsp), %rsi
adcq    %rbp, %r9
adcq    %rbx, %rdx
adcq    %rax, %r10
adcq    %r15, %r12
adcq    %rcx, %r13
adcq    %r8,  %r14
adcq    $0, %rdi

movq    %rdi, %rax
shlq    $32, %rax
    
xorq    %rcx, %rcx
addq    %rdi, %rsi
adcq    $0, %r9
adcq    $0, %rdx
adcq    %rax, %r10
adcq    $0, %r12
adcq    $0, %r13
adcq    $0, %r14
adcq    $0, %rcx

movq    %rcx, %rax
shlq    $32, %rax

addq    %rcx, %rsi
adcq    $0, %r9
adcq    $0, %rdx
adcq    %rax, %r10

movq    %rsi, 424(%rsp)
movq    %r9,  432(%rsp)
movq    %rdx, 440(%rsp)
movq    %r10, 448(%rsp)
movq    %r12, 456(%rsp)
movq    %r13, 464(%rsp)
movq    %r14, 472(%rsp)

// T1
movq    312(%rsp), %r8
movq    320(%rsp), %r9
movq    328(%rsp), %r10
movq    336(%rsp), %r11
movq    344(%rsp), %r12
movq    352(%rsp), %r13
movq    360(%rsp), %r14

// T2 ← T1 - T3
subq    424(%rsp), %r8
sbbq    432(%rsp), %r9
sbbq    440(%rsp), %r10
sbbq    448(%rsp), %r11
sbbq    456(%rsp), %r12
sbbq    464(%rsp), %r13
sbbq    472(%rsp), %r14
movq    $0, %rcx
adcq    $0, %rcx

movq    %rcx, %r15
shlq    $32,  %r15

subq    %rcx, %r8
sbbq    $0, %r9
sbbq    $0, %r10
sbbq    %r15, %r11
sbbq    $0, %r12
sbbq    $0, %r13
sbbq    $0, %r14
movq    $0, %rcx
adcq    $0, %rcx

movq    %rcx, %r15
shlq    $32, %r15

subq    %rcx, %r8
sbbq    $0, %r9
sbbq    $0, %r10
sbbq    %r15, %r11

movq    %r8,  368(%rsp)
movq    %r9,  376(%rsp)
movq    %r10, 384(%rsp)
movq    %r11, 392(%rsp)
movq    %r12, 400(%rsp)
movq    %r13, 408(%rsp)
movq    %r14, 416(%rsp)

// T4 ← ((A + 2)/4) · T2
movq    a24, %rdx

mulx    %r8, %r8, %rcx
mulx    %r9, %r9, %rax
addq    %rcx, %r9

mulx    %r10, %r10, %rcx
adcq    %rax, %r10

mulx    %r11, %r11, %rax
adcq    %rcx, %r11

mulx    %r12, %r12, %rcx
adcq    %rax, %r12

mulx    %r13, %r13, %rax
adcq    %rcx, %r13

mulx    %r14, %r14, %r15
adcq    %rax, %r14
adcq    $0, %r15

movq    %r15, %rax
shlq    $32, %rax

addq    %r15, %r8
adcq    $0, %r9
adcq    $0, %r10
adcq    %rax, %r11
adcq    $0, %r12
adcq    $0, %r13
adcq    $0, %r14
movq    $0, %r15
adcq    $0, %r15

movq    %r15, %rax
shlq    $32,  %rax

addq    %r15, %r8
adcq    $0, %r9
adcq    $0, %r10
adcq    %rax, %r11

// T4 ← T4 + T3
addq    424(%rsp), %r8
adcq    432(%rsp), %r9
adcq    440(%rsp), %r10
adcq    448(%rsp), %r11
adcq    456(%rsp), %r12
adcq    464(%rsp), %r13
adcq    472(%rsp), %r14
movq    $0, %r15
adcq    $0, %r15

movq    %r15, %rax
shlq    $32,  %rax

addq    %r15, %r8
adcq    $0, %r9
adcq    $0, %r10
adcq    %rax, %r11
adcq    $0, %r12
adcq    $0, %r13
adcq    $0, %r14
movq    $0, %r15
adcq    $0, %r15

movq    %r15, %rax
shlq    $32, %rax

addq    %r15, %r8
adcq    $0, %r9
adcq    $0, %r10
adcq    %rax, %r11

movq    %r8,  480(%rsp) 
movq    %r9,  488(%rsp)
movq    %r10, 496(%rsp)
movq    %r11, 504(%rsp)
movq    %r12, 512(%rsp)
movq    %r13, 520(%rsp)
movq    %r14, 528(%rsp)

// X2 ← T1 · T3
movq    312(%rsp), %rdx    

mulx    424(%rsp), %r8, %r9
mulx    432(%rsp), %rcx, %r10
addq    %rcx, %r9

mulx    440(%rsp), %rcx, %r11
adcq    %rcx, %r10

mulx    448(%rsp), %rcx, %r12
adcq    %rcx, %r11

mulx    456(%rsp), %rcx, %r13
adcq    %rcx, %r12

mulx    464(%rsp), %rcx, %r14
adcq    %rcx, %r13

mulx    472(%rsp), %rcx, %r15
adcq    %rcx, %r14
adcq    $0, %r15

movq    %r8, 536(%rsp)
movq    %r9, 544(%rsp)

movq    320(%rsp), %rdx

mulx    424(%rsp), %r8, %r9
mulx    432(%rsp), %rcx, %rax
addq    %rcx, %r9

mulx    440(%rsp), %rcx, %rbx
adcq    %rcx, %rax

mulx    448(%rsp), %rcx, %rbp
adcq    %rcx, %rbx

mulx    456(%rsp), %rcx, %rsi
adcq    %rcx, %rbp

mulx    464(%rsp), %rcx, %rdi
adcq    %rcx, %rsi

mulx    472(%rsp), %rdx, %rcx
adcq    %rdx, %rdi
adcq    $0, %rcx

addq    544(%rsp), %r8
adcq    %r10, %r9
adcq    %rax, %r11
adcq    %rbx, %r12
adcq    %rbp, %r13
adcq    %rsi, %r14
adcq    %rdi, %r15
adcq    $0,   %rcx

movq    %r8, 544(%rsp)
movq    %r9, 552(%rsp)

movq    328(%rsp), %rdx

mulx    424(%rsp), %r8, %r9
mulx    432(%rsp), %r10, %rax
addq    %r10, %r9

mulx    440(%rsp), %r10, %rbx
adcq    %r10, %rax

mulx    448(%rsp), %r10, %rbp
adcq    %r10, %rbx

mulx    456(%rsp), %r10, %rsi
adcq    %r10, %rbp

mulx    464(%rsp), %r10, %rdi
adcq    %r10, %rsi

mulx    472(%rsp), %rdx, %r10
adcq    %rdx, %rdi
adcq    $0, %r10

addq    552(%rsp), %r8
adcq    %r11,  %r9
adcq    %rax, %r12
adcq    %rbx, %r13
adcq    %rbp, %r14
adcq    %rsi, %r15
adcq    %rdi, %rcx
adcq    $0,   %r10

movq    %r8, 552(%rsp)
movq    %r9, 560(%rsp)

movq    336(%rsp), %rdx

mulx    424(%rsp), %r8, %r9
mulx    432(%rsp), %r11, %rax
addq    %r11, %r9

mulx    440(%rsp), %r11, %rbx
adcq    %r11, %rax

mulx    448(%rsp), %r11, %rbp
adcq    %r11, %rbx

mulx    456(%rsp), %r11, %rsi
adcq    %r11, %rbp

mulx    464(%rsp), %r11, %rdi
adcq    %r11, %rsi

mulx    472(%rsp), %rdx, %r11
adcq    %rdx, %rdi
adcq    $0, %r11

addq    560(%rsp), %r8
adcq    %r12,  %r9
adcq    %rax, %r13
adcq    %rbx, %r14
adcq    %rbp, %r15
adcq    %rsi, %rcx
adcq    %rdi, %r10
adcq    $0,   %r11

movq    %r8, 560(%rsp)
movq    %r9, 568(%rsp)

movq    344(%rsp), %rdx

mulx    424(%rsp), %r8, %r9
mulx    432(%rsp), %r12, %rax
addq    %r12, %r9

mulx    440(%rsp), %r12, %rbx
adcq    %r12, %rax

mulx    448(%rsp), %r12, %rbp
adcq    %r12, %rbx

mulx    456(%rsp), %r12, %rsi
adcq    %r12, %rbp

mulx    464(%rsp), %r12, %rdi
adcq    %r12, %rsi

mulx    472(%rsp), %rdx, %r12
adcq    %rdx, %rdi
adcq    $0, %r12

addq    568(%rsp), %r8
adcq    %r13,  %r9
adcq    %rax, %r14
adcq    %rbx, %r15
adcq    %rbp, %rcx
adcq    %rsi, %r10
adcq    %rdi, %r11
adcq    $0,   %r12

movq    %r8, 568(%rsp)
movq    %r9, 576(%rsp)

movq    352(%rsp), %rdx

mulx    424(%rsp), %r8, %r9
mulx    432(%rsp), %r13, %rax
addq    %r13, %r9

mulx    440(%rsp), %r13, %rbx
adcq    %r13, %rax

mulx    448(%rsp), %r13, %rbp
adcq    %r13, %rbx

mulx    456(%rsp), %r13, %rsi
adcq    %r13, %rbp

mulx    464(%rsp), %r13, %rdi
adcq    %r13, %rsi

mulx    472(%rsp), %rdx, %r13
adcq    %rdx, %rdi
adcq    $0, %r13

addq    576(%rsp), %r8
adcq    %r14,  %r9
adcq    %rax, %r15
adcq    %rbx, %rcx
adcq    %rbp, %r10
adcq    %rsi, %r11
adcq    %rdi, %r12
adcq    $0,   %r13

movq    %r8, 576(%rsp)
movq    %r9, 584(%rsp)

movq    360(%rsp), %rdx

mulx    424(%rsp), %r8, %r9
mulx    432(%rsp), %r14, %rax
addq    %r14, %r9

mulx    440(%rsp), %r14, %rbx
adcq    %r14, %rax

mulx    448(%rsp), %r14, %rbp
adcq    %r14, %rbx

mulx    456(%rsp), %r14, %rsi
adcq    %r14, %rbp

mulx    464(%rsp), %r14, %rdi
adcq    %r14, %rsi

mulx    472(%rsp), %rdx, %r14
adcq    %rdx, %rdi
adcq    $0, %r14

addq    584(%rsp), %r8
adcq    %r15,  %r9
adcq    %rax, %rcx
adcq    %rbx, %r10
adcq    %rbp, %r11
adcq    %rsi, %r12
adcq    %rdi, %r13
adcq    $0,   %r14

movq    536(%rsp), %rax
movq    544(%rsp), %rbx
movq    552(%rsp), %r15
movq    560(%rsp), %rdx
movq    568(%rsp), %rbp
movq    576(%rsp), %rsi
  
xorq    %rdi,%rdi
addq    %r9, %rax
adcq    %rcx, %rbx
adcq    %r10, %r15
adcq    %r11, %rdx
adcq    %r12, %rbp
adcq    %r13, %rsi
adcq    %r14, %r8
adcq    $0, %rdi
  
movq    %rax, 536(%rsp)

movq    %r11, %rax
andq    mask32h, %rax

addq    %rax, %rdx
adcq    %r12, %rbp
adcq    %r13, %rsi
adcq    %r14, %r8
adcq    $0, %rdi

movq    %r11,  %rax
shrd    $32, %r12, %r11
shrd    $32, %r13, %r12
shrd    $32, %r14, %r13
shrd    $32, %r9,  %r14
shrd    $32, %rcx, %r9
shrd    $32, %r10, %rcx
shrd    $32, %rax, %r10

addq    536(%rsp), %r11
adcq    %r12, %rbx
adcq    %r13, %r15
adcq    %r14, %rdx
adcq    %r9,  %rbp
adcq    %rcx, %rsi
adcq    %r10, %r8
adcq    $0, %rdi

movq    %rdi, %r13
shlq    $32, %r13
    
xorq    %r14, %r14
addq    %rdi, %r11
adcq    $0, %rbx
adcq    $0, %r15
adcq    %r13, %rdx
adcq    $0, %rbp
adcq    $0, %rsi
adcq    $0, %r8
adcq    $0, %r14

movq    %r14, %r13
shlq    $32, %r13

addq    %r14, %r11
adcq    $0, %rbx
adcq    $0, %r15
adcq    %r13, %rdx

movq    %r11, 72(%rsp) 
movq    %rbx, 80(%rsp)
movq    %r15, 88(%rsp)
movq    %rdx, 96(%rsp)
movq    %rbp, 104(%rsp)
movq    %rsi, 112(%rsp)
movq    %r8,  120(%rsp)

// Z2 ← T2 · T4
movq    480(%rsp), %rdx    

mulx    368(%rsp), %r8, %r9
mulx    376(%rsp), %rcx, %r10
addq    %rcx, %r9

mulx    384(%rsp), %rcx, %r11
adcq    %rcx, %r10

mulx    392(%rsp), %rcx, %r12
adcq    %rcx, %r11

mulx    400(%rsp), %rcx, %r13
adcq    %rcx, %r12

mulx    408(%rsp), %rcx, %r14
adcq    %rcx, %r13

mulx    416(%rsp), %rcx, %r15
adcq    %rcx, %r14
adcq    $0, %r15

movq    %r8, 536(%rsp)
movq    %r9, 544(%rsp)

movq    488(%rsp), %rdx

mulx    368(%rsp), %r8, %r9
mulx    376(%rsp), %rcx, %rax
addq    %rcx, %r9

mulx    384(%rsp), %rcx, %rbx
adcq    %rcx, %rax

mulx    392(%rsp), %rcx, %rbp
adcq    %rcx, %rbx

mulx    400(%rsp), %rcx, %rsi
adcq    %rcx, %rbp

mulx    408(%rsp), %rcx, %rdi
adcq    %rcx, %rsi

mulx    416(%rsp), %rdx, %rcx
adcq    %rdx, %rdi
adcq    $0, %rcx

addq    544(%rsp), %r8
adcq    %r10, %r9
adcq    %rax, %r11
adcq    %rbx, %r12
adcq    %rbp, %r13
adcq    %rsi, %r14
adcq    %rdi, %r15
adcq    $0,   %rcx

movq    %r8, 544(%rsp)
movq    %r9, 552(%rsp)

movq    496(%rsp), %rdx

mulx    368(%rsp), %r8, %r9
mulx    376(%rsp), %r10, %rax
addq    %r10, %r9

mulx    384(%rsp), %r10, %rbx
adcq    %r10, %rax

mulx    392(%rsp), %r10, %rbp
adcq    %r10, %rbx

mulx    400(%rsp), %r10, %rsi
adcq    %r10, %rbp

mulx    408(%rsp), %r10, %rdi
adcq    %r10, %rsi

mulx    416(%rsp), %rdx, %r10
adcq    %rdx, %rdi
adcq    $0, %r10

addq    552(%rsp), %r8
adcq    %r11,  %r9
adcq    %rax, %r12
adcq    %rbx, %r13
adcq    %rbp, %r14
adcq    %rsi, %r15
adcq    %rdi, %rcx
adcq    $0,   %r10

movq    %r8, 552(%rsp)
movq    %r9, 560(%rsp)

movq    504(%rsp), %rdx

mulx    368(%rsp), %r8, %r9
mulx    376(%rsp), %r11, %rax
addq    %r11, %r9

mulx    384(%rsp), %r11, %rbx
adcq    %r11, %rax

mulx    392(%rsp), %r11, %rbp
adcq    %r11, %rbx

mulx    400(%rsp), %r11, %rsi
adcq    %r11, %rbp

mulx    408(%rsp), %r11, %rdi
adcq    %r11, %rsi

mulx    416(%rsp), %rdx, %r11
adcq    %rdx, %rdi
adcq    $0, %r11

addq    560(%rsp), %r8
adcq    %r12,  %r9
adcq    %rax, %r13
adcq    %rbx, %r14
adcq    %rbp, %r15
adcq    %rsi, %rcx
adcq    %rdi, %r10
adcq    $0,   %r11

movq    %r8, 560(%rsp)
movq    %r9, 568(%rsp)

movq    512(%rsp), %rdx

mulx    368(%rsp), %r8, %r9
mulx    376(%rsp), %r12, %rax
addq    %r12, %r9

mulx    384(%rsp), %r12, %rbx
adcq    %r12, %rax

mulx    392(%rsp), %r12, %rbp
adcq    %r12, %rbx

mulx    400(%rsp), %r12, %rsi
adcq    %r12, %rbp

mulx    408(%rsp), %r12, %rdi
adcq    %r12, %rsi

mulx    416(%rsp), %rdx, %r12
adcq    %rdx, %rdi
adcq    $0, %r12

addq    568(%rsp), %r8
adcq    %r13,  %r9
adcq    %rax, %r14
adcq    %rbx, %r15
adcq    %rbp, %rcx
adcq    %rsi, %r10
adcq    %rdi, %r11
adcq    $0,   %r12

movq    %r8, 568(%rsp)
movq    %r9, 576(%rsp)

movq    520(%rsp), %rdx

mulx    368(%rsp), %r8, %r9
mulx    376(%rsp), %r13, %rax
addq    %r13, %r9

mulx    384(%rsp), %r13, %rbx
adcq    %r13, %rax

mulx    392(%rsp), %r13, %rbp
adcq    %r13, %rbx

mulx    400(%rsp), %r13, %rsi
adcq    %r13, %rbp

mulx    408(%rsp), %r13, %rdi
adcq    %r13, %rsi

mulx    416(%rsp), %rdx, %r13
adcq    %rdx, %rdi
adcq    $0, %r13

addq    576(%rsp), %r8
adcq    %r14,  %r9
adcq    %rax, %r15
adcq    %rbx, %rcx
adcq    %rbp, %r10
adcq    %rsi, %r11
adcq    %rdi, %r12
adcq    $0,   %r13

movq    %r8, 576(%rsp)
movq    %r9, 584(%rsp)

movq    528(%rsp), %rdx

mulx    368(%rsp), %r8, %r9
mulx    376(%rsp), %r14, %rax
addq    %r14, %r9

mulx    384(%rsp), %r14, %rbx
adcq    %r14, %rax

mulx    392(%rsp), %r14, %rbp
adcq    %r14, %rbx

mulx    400(%rsp), %r14, %rsi
adcq    %r14, %rbp

mulx    408(%rsp), %r14, %rdi
adcq    %r14, %rsi

mulx    416(%rsp), %rdx, %r14
adcq    %rdx, %rdi
adcq    $0, %r14

addq    584(%rsp), %r8
adcq    %r15,  %r9
adcq    %rax, %rcx
adcq    %rbx, %r10
adcq    %rbp, %r11
adcq    %rsi, %r12
adcq    %rdi, %r13
adcq    $0,   %r14

movq    536(%rsp), %rax
movq    544(%rsp), %rbx
movq    552(%rsp), %r15
movq    560(%rsp), %rdx
movq    568(%rsp), %rbp
movq    576(%rsp), %rsi
  
xorq    %rdi,%rdi
addq    %r9, %rax
adcq    %rcx, %rbx
adcq    %r10, %r15
adcq    %r11, %rdx
adcq    %r12, %rbp
adcq    %r13, %rsi
adcq    %r14, %r8
adcq    $0, %rdi
  
movq    %rax, 536(%rsp)

movq    %r11, %rax
andq    mask32h, %rax

addq    %rax, %rdx
adcq    %r12, %rbp
adcq    %r13, %rsi
adcq    %r14, %r8
adcq    $0, %rdi

movq    %r11,  %rax
shrd    $32, %r12, %r11
shrd    $32, %r13, %r12
shrd    $32, %r14, %r13
shrd    $32, %r9,  %r14
shrd    $32, %rcx, %r9
shrd    $32, %r10, %rcx
shrd    $32, %rax, %r10

addq    536(%rsp), %r11
adcq    %r12, %rbx
adcq    %r13, %r15
adcq    %r14, %rdx
adcq    %r9,  %rbp
adcq    %rcx, %rsi
adcq    %r10, %r8
adcq    $0, %rdi

movq    %rdi, %r13
shlq    $32, %r13
    
xorq    %r14, %r14
addq    %rdi, %r11
adcq    $0, %rbx
adcq    $0, %r15
adcq    %r13, %rdx
adcq    $0, %rbp
adcq    $0, %rsi
adcq    $0, %r8
adcq    $0, %r14

movq    %r14, %r13
shlq    $32, %r13

addq    %r14, %r11
adcq    $0, %rbx
adcq    $0, %r15
adcq    %r13, %rdx

movq    %r11, 128(%rsp) 
movq    %rbx, 136(%rsp)
movq    %r15, 144(%rsp)
movq    %rdx, 152(%rsp)
movq    %rbp, 160(%rsp)
movq    %rsi, 168(%rsp)
movq    %r8,  176(%rsp)

// X2
movq    72(%rsp), %r8
movq    80(%rsp), %r9
movq    88(%rsp), %r10
movq    96(%rsp), %r11
movq    104(%rsp), %r12
movq    112(%rsp), %r13
movq    120(%rsp), %r14

// copy X2
movq    %r8,  %rax
movq    %r9,  %rbx
movq    %r10, %rbp
movq    %r11, %rsi
movq    %r12, %rdi
movq    %r13, %rdx

// T1 ← X2 + Z2
addq    128(%rsp), %r8
adcq    136(%rsp), %r9
adcq    144(%rsp), %r10
adcq    152(%rsp), %r11
adcq    160(%rsp), %r12
adcq    168(%rsp), %r13
adcq    176(%rsp), %r14
movq    $0, %rcx
adcq    $0, %rcx

movq    %rcx, %r15
shlq    $32,  %r15

addq    %rcx, %r8
adcq    $0, %r9
adcq    $0, %r10
adcq    %r15, %r11
adcq    $0, %r12
adcq    $0, %r13
adcq    $0, %r14
movq    $0, %rcx
adcq    $0, %rcx

movq    %rcx, %r15
shlq    $32, %r15

addq    %rcx, %r8
adcq    $0, %r9
adcq    $0, %r10
adcq    %r15, %r11

movq    %r8,  312(%rsp)
movq    %r9,  320(%rsp)
movq    %r10, 328(%rsp)
movq    %r11, 336(%rsp)
movq    %r12, 344(%rsp)
movq    %r13, 352(%rsp)
movq    %r14, 360(%rsp)

movq    120(%rsp), %r8

// T2 ← X2 - Z2
subq    128(%rsp), %rax
sbbq    136(%rsp), %rbx
sbbq    144(%rsp), %rbp
sbbq    152(%rsp), %rsi
sbbq    160(%rsp), %rdi
sbbq    168(%rsp), %rdx
sbbq    176(%rsp), %r8
movq    $0, %rcx
adcq    $0, %rcx

movq    %rcx, %r15
shlq    $32,  %r15

subq    %rcx, %rax
sbbq    $0, %rbx
sbbq    $0, %rbp
sbbq    %r15, %rsi
sbbq    $0, %rdi
sbbq    $0, %rdx
sbbq    $0, %r8
movq    $0, %rcx
adcq    $0, %rcx

movq    %rcx, %r15
shlq    $32, %r15

subq    %rcx, %rax
sbbq    $0, %rbx
sbbq    $0, %rbp
sbbq    %r15, %rsi

movq    %rax, 368(%rsp)
movq    %rbx, 376(%rsp)
movq    %rbp, 384(%rsp)
movq    %rsi, 392(%rsp)
movq    %rdi, 400(%rsp)
movq    %rdx, 408(%rsp)
movq    %r8,  416(%rsp)

// T1 ← T1^2
movq    312(%rsp), %rdx
    
mulx    320(%rsp), %r9, %r10
mulx    328(%rsp), %rcx, %r11
addq    %rcx, %r10

mulx    336(%rsp), %rcx, %r12
adcq    %rcx, %r11

mulx    344(%rsp), %rcx, %r13
adcq    %rcx, %r12

mulx    352(%rsp), %rcx, %r14
adcq    %rcx, %r13

mulx    360(%rsp), %rcx, %r15
adcq    %rcx, %r14
adcq    $0, %r15

movq    320(%rsp), %rdx
mulx    328(%rsp), %rax, %rbx

mulx    336(%rsp), %rcx, %rbp
addq    %rcx, %rbx

mulx    344(%rsp), %rcx, %rsi
adcq    %rcx, %rbp

mulx    352(%rsp), %rcx, %r8
adcq    %rcx, %rsi

mulx    360(%rsp), %rdx, %rcx
adcq    %rdx, %r8
adcq    $0, %rcx

addq    %rax, %r11
adcq    %rbx, %r12
adcq    %rbp, %r13
adcq    %rsi, %r14
adcq    %r8,  %r15
adcq    $0,   %rcx

movq    328(%rsp), %rdx
mulx    336(%rsp), %rax, %rbx

mulx    344(%rsp), %r8, %rbp
addq    %r8, %rbx

mulx    352(%rsp), %r8, %rsi
adcq    %r8, %rbp

mulx    360(%rsp), %rdx, %r8
adcq    %rdx, %rsi
adcq    $0, %r8

addq    %rax, %r13
adcq    %rbx, %r14
adcq    %rbp, %r15
adcq    %rsi, %rcx
adcq    $0,    %r8

movq    336(%rsp), %rdx
mulx    344(%rsp), %rax, %rbx

mulx    352(%rsp), %rsi, %rbp
addq    %rsi, %rbx

mulx    360(%rsp), %rdx, %rsi
adcq    %rdx, %rbp
adcq    $0, %rsi

addq    %rax, %r15
adcq    %rbx, %rcx
adcq    %rbp,  %r8
adcq    $0,   %rsi

movq    344(%rsp), %rdx
mulx    352(%rsp), %rax, %rbx

mulx    360(%rsp), %rdx, %rbp
addq    %rdx, %rbx
adcq    $0, %rbp

addq    %rax,  %r8
adcq    %rbx, %rsi
adcq    $0,   %rbp

movq    352(%rsp), %rdx
mulx    360(%rsp), %rax, %rbx

addq    %rax, %rbp
adcq    $0,   %rbx

movq    $0, %rax
shld    $1, %rbx, %rax
shld    $1, %rbp, %rbx
shld    $1, %rsi, %rbp
shld    $1, %r8,  %rsi
shld    $1, %rcx, %r8
shld    $1, %r15, %rcx
shld    $1, %r14, %r15
shld    $1, %r13, %r14
shld    $1, %r12, %r13
shld    $1, %r11, %r12
shld    $1, %r10, %r11
shld    $1, %r9,  %r10
shlq    $1, %r9

movq    %r9,  536(%rsp)
movq    %r10, 544(%rsp)
movq    %r11, 552(%rsp)

movq    312(%rsp), %rdx
mulx    %rdx, %r11, %r10
addq    536(%rsp), %r10
movq    %r10, 536(%rsp)

movq    320(%rsp), %rdx
mulx    %rdx, %r9, %r10
adcq    544(%rsp), %r9
adcq    552(%rsp), %r10
movq    %r9,  544(%rsp)
movq    %r10, 552(%rsp)

movq    328(%rsp), %rdx
mulx    %rdx, %r9, %r10
adcq    %r9, %r12
adcq    %r10, %r13

movq    336(%rsp), %rdx
mulx    %rdx, %r9, %r10
adcq    %r9, %r14
adcq    %r10, %r15

movq    344(%rsp), %rdx
mulx    %rdx, %r9, %r10
adcq    %r9, %rcx
adcq    %r10, %r8

movq    352(%rsp), %rdx
mulx    %rdx, %r9, %r10
adcq    %r9, %rsi
adcq    %r10, %rbp

movq    360(%rsp), %rdx
mulx    %rdx, %r9, %r10
adcq    %r9, %rbx
adcq    %r10, %rax

movq    536(%rsp), %r9
movq    544(%rsp), %rdx
movq    552(%rsp), %r10

xorq    %rdi, %rdi
addq    %r15, %r11
adcq    %rcx, %r9
adcq    %r8,  %rdx
adcq    %rsi, %r10
adcq    %rbp, %r12
adcq    %rbx, %r13
adcq    %rax, %r14
adcq    $0, %rdi
    
movq    %r11, 536(%rsp)

movq    %rsi, %r11
andq    mask32h, %r11

addq    %r11, %r10
adcq    %rbp, %r12
adcq    %rbx, %r13
adcq    %rax, %r14
adcq    $0, %rdi

movq    %rsi,  %r11
shrd    $32, %rbp, %rsi
shrd    $32, %rbx, %rbp
shrd    $32, %rax, %rbx
shrd    $32, %r15, %rax
shrd    $32, %rcx, %r15
shrd    $32, %r8,  %rcx
shrd    $32, %r11, %r8

addq    536(%rsp), %rsi
adcq    %rbp, %r9
adcq    %rbx, %rdx
adcq    %rax, %r10
adcq    %r15, %r12
adcq    %rcx, %r13
adcq    %r8,  %r14
adcq    $0, %rdi

movq    %rdi, %rax
shlq    $32, %rax
    
xorq    %rcx, %rcx
addq    %rdi, %rsi
adcq    $0, %r9
adcq    $0, %rdx
adcq    %rax, %r10
adcq    $0, %r12
adcq    $0, %r13
adcq    $0, %r14
adcq    $0, %rcx

movq    %rcx, %rax
shlq    $32, %rax

addq    %rcx, %rsi
adcq    $0, %r9
adcq    $0, %rdx
adcq    %rax, %r10

movq    %rsi, 312(%rsp)
movq    %r9,  320(%rsp)
movq    %rdx, 328(%rsp)
movq    %r10, 336(%rsp)
movq    %r12, 344(%rsp)
movq    %r13, 352(%rsp)
movq    %r14, 360(%rsp)

// T3 ← T2^2
movq    368(%rsp), %rdx
    
mulx    376(%rsp), %r9, %r10
mulx    384(%rsp), %rcx, %r11
addq    %rcx, %r10

mulx    392(%rsp), %rcx, %r12
adcq    %rcx, %r11

mulx    400(%rsp), %rcx, %r13
adcq    %rcx, %r12

mulx    408(%rsp), %rcx, %r14
adcq    %rcx, %r13

mulx    416(%rsp), %rcx, %r15
adcq    %rcx, %r14
adcq    $0, %r15

movq    376(%rsp), %rdx
mulx    384(%rsp), %rax, %rbx

mulx    392(%rsp), %rcx, %rbp
addq    %rcx, %rbx

mulx    400(%rsp), %rcx, %rsi
adcq    %rcx, %rbp

mulx    408(%rsp), %rcx, %r8
adcq    %rcx, %rsi

mulx    416(%rsp), %rdx, %rcx
adcq    %rdx, %r8
adcq    $0, %rcx

addq    %rax, %r11
adcq    %rbx, %r12
adcq    %rbp, %r13
adcq    %rsi, %r14
adcq    %r8,  %r15
adcq    $0,   %rcx

movq    384(%rsp), %rdx
mulx    392(%rsp), %rax, %rbx

mulx    400(%rsp), %r8, %rbp
addq    %r8, %rbx

mulx    408(%rsp), %r8, %rsi
adcq    %r8, %rbp

mulx    416(%rsp), %rdx, %r8
adcq    %rdx, %rsi
adcq    $0, %r8

addq    %rax, %r13
adcq    %rbx, %r14
adcq    %rbp, %r15
adcq    %rsi, %rcx
adcq    $0,    %r8

movq    392(%rsp), %rdx
mulx    400(%rsp), %rax, %rbx

mulx    408(%rsp), %rsi, %rbp
addq    %rsi, %rbx

mulx    416(%rsp), %rdx, %rsi
adcq    %rdx, %rbp
adcq    $0, %rsi

addq    %rax, %r15
adcq    %rbx, %rcx
adcq    %rbp,  %r8
adcq    $0,   %rsi

movq    400(%rsp), %rdx
mulx    408(%rsp), %rax, %rbx

mulx    416(%rsp), %rdx, %rbp
addq    %rdx, %rbx
adcq    $0, %rbp

addq    %rax,  %r8
adcq    %rbx, %rsi
adcq    $0,   %rbp

movq    408(%rsp), %rdx
mulx    416(%rsp), %rax, %rbx

addq    %rax, %rbp
adcq    $0,   %rbx

movq    $0, %rax
shld    $1, %rbx, %rax
shld    $1, %rbp, %rbx
shld    $1, %rsi, %rbp
shld    $1, %r8,  %rsi
shld    $1, %rcx, %r8
shld    $1, %r15, %rcx
shld    $1, %r14, %r15
shld    $1, %r13, %r14
shld    $1, %r12, %r13
shld    $1, %r11, %r12
shld    $1, %r10, %r11
shld    $1, %r9,  %r10
shlq    $1, %r9

movq    %r9,  536(%rsp)
movq    %r10, 544(%rsp)
movq    %r11, 552(%rsp)

movq    368(%rsp), %rdx
mulx    %rdx, %r11, %r10
addq    536(%rsp), %r10
movq    %r10, 536(%rsp)

movq    376(%rsp), %rdx
mulx    %rdx, %r9, %r10
adcq    544(%rsp), %r9
adcq    552(%rsp), %r10
movq    %r9,  544(%rsp)
movq    %r10, 552(%rsp)

movq    384(%rsp), %rdx
mulx    %rdx, %r9, %r10
adcq    %r9, %r12
adcq    %r10, %r13

movq    392(%rsp), %rdx
mulx    %rdx, %r9, %r10
adcq    %r9, %r14
adcq    %r10, %r15

movq    400(%rsp), %rdx
mulx    %rdx, %r9, %r10
adcq    %r9, %rcx
adcq    %r10, %r8

movq    408(%rsp), %rdx
mulx    %rdx, %r9, %r10
adcq    %r9, %rsi
adcq    %r10, %rbp

movq    416(%rsp), %rdx
mulx    %rdx, %r9, %r10
adcq    %r9, %rbx
adcq    %r10, %rax

movq    536(%rsp), %r9
movq    544(%rsp), %rdx
movq    552(%rsp), %r10

xorq    %rdi, %rdi
addq    %r15, %r11
adcq    %rcx, %r9
adcq    %r8,  %rdx
adcq    %rsi, %r10
adcq    %rbp, %r12
adcq    %rbx, %r13
adcq    %rax, %r14
adcq    $0, %rdi
    
movq    %r11, 536(%rsp)

movq    %rsi, %r11
andq    mask32h, %r11

addq    %r11, %r10
adcq    %rbp, %r12
adcq    %rbx, %r13
adcq    %rax, %r14
adcq    $0, %rdi

movq    %rsi,  %r11
shrd    $32, %rbp, %rsi
shrd    $32, %rbx, %rbp
shrd    $32, %rax, %rbx
shrd    $32, %r15, %rax
shrd    $32, %rcx, %r15
shrd    $32, %r8,  %rcx
shrd    $32, %r11, %r8

addq    536(%rsp), %rsi
adcq    %rbp, %r9
adcq    %rbx, %rdx
adcq    %rax, %r10
adcq    %r15, %r12
adcq    %rcx, %r13
adcq    %r8,  %r14
adcq    $0, %rdi

movq    %rdi, %rax
shlq    $32, %rax
    
xorq    %rcx, %rcx
addq    %rdi, %rsi
adcq    $0, %r9
adcq    $0, %rdx
adcq    %rax, %r10
adcq    $0, %r12
adcq    $0, %r13
adcq    $0, %r14
adcq    $0, %rcx

movq    %rcx, %rax
shlq    $32, %rax

addq    %rcx, %rsi
adcq    $0, %r9
adcq    $0, %rdx
adcq    %rax, %r10

movq    %rsi, 424(%rsp)
movq    %r9,  432(%rsp)
movq    %rdx, 440(%rsp)
movq    %r10, 448(%rsp)
movq    %r12, 456(%rsp)
movq    %r13, 464(%rsp)
movq    %r14, 472(%rsp)

// T1
movq    312(%rsp), %r8
movq    320(%rsp), %r9
movq    328(%rsp), %r10
movq    336(%rsp), %r11
movq    344(%rsp), %r12
movq    352(%rsp), %r13
movq    360(%rsp), %r14

// T2 ← T1 - T3
subq    424(%rsp), %r8
sbbq    432(%rsp), %r9
sbbq    440(%rsp), %r10
sbbq    448(%rsp), %r11
sbbq    456(%rsp), %r12
sbbq    464(%rsp), %r13
sbbq    472(%rsp), %r14
movq    $0, %rcx
adcq    $0, %rcx

movq    %rcx, %r15
shlq    $32,  %r15

subq    %rcx, %r8
sbbq    $0, %r9
sbbq    $0, %r10
sbbq    %r15, %r11
sbbq    $0, %r12
sbbq    $0, %r13
sbbq    $0, %r14
movq    $0, %rcx
adcq    $0, %rcx

movq    %rcx, %r15
shlq    $32, %r15

subq    %rcx, %r8
sbbq    $0, %r9
sbbq    $0, %r10
sbbq    %r15, %r11

movq    %r8,  368(%rsp)
movq    %r9,  376(%rsp)
movq    %r10, 384(%rsp)
movq    %r11, 392(%rsp)
movq    %r12, 400(%rsp)
movq    %r13, 408(%rsp)
movq    %r14, 416(%rsp)

// T4 ← ((A + 2)/4) · T2
movq    a24, %rdx

mulx    %r8, %r8, %rcx
mulx    %r9, %r9, %rax
addq    %rcx, %r9

mulx    %r10, %r10, %rcx
adcq    %rax, %r10

mulx    %r11, %r11, %rax
adcq    %rcx, %r11

mulx    %r12, %r12, %rcx
adcq    %rax, %r12

mulx    %r13, %r13, %rax
adcq    %rcx, %r13

mulx    %r14, %r14, %r15
adcq    %rax, %r14
adcq    $0, %r15

movq    %r15, %rax
shlq    $32, %rax

addq    %r15, %r8
adcq    $0, %r9
adcq    $0, %r10
adcq    %rax, %r11
adcq    $0, %r12
adcq    $0, %r13
adcq    $0, %r14
movq    $0, %r15
adcq    $0, %r15

movq    %r15, %rax
shlq    $32,  %rax

addq    %r15, %r8
adcq    $0, %r9
adcq    $0, %r10
adcq    %rax, %r11

// T4 ← T4 + T3
addq    424(%rsp), %r8
adcq    432(%rsp), %r9
adcq    440(%rsp), %r10
adcq    448(%rsp), %r11
adcq    456(%rsp), %r12
adcq    464(%rsp), %r13
adcq    472(%rsp), %r14
movq    $0, %r15
adcq    $0, %r15

movq    %r15, %rax
shlq    $32,  %rax

addq    %r15, %r8
adcq    $0, %r9
adcq    $0, %r10
adcq    %rax, %r11
adcq    $0, %r12
adcq    $0, %r13
adcq    $0, %r14
movq    $0, %r15
adcq    $0, %r15

movq    %r15, %rax
shlq    $32, %rax

addq    %r15, %r8
adcq    $0, %r9
adcq    $0, %r10
adcq    %rax, %r11

movq    %r8,  480(%rsp) 
movq    %r9,  488(%rsp)
movq    %r10, 496(%rsp)
movq    %r11, 504(%rsp)
movq    %r12, 512(%rsp)
movq    %r13, 520(%rsp)
movq    %r14, 528(%rsp)

// X2 ← T1 · T3
movq    312(%rsp), %rdx    

mulx    424(%rsp), %r8, %r9
mulx    432(%rsp), %rcx, %r10
addq    %rcx, %r9

mulx    440(%rsp), %rcx, %r11
adcq    %rcx, %r10

mulx    448(%rsp), %rcx, %r12
adcq    %rcx, %r11

mulx    456(%rsp), %rcx, %r13
adcq    %rcx, %r12

mulx    464(%rsp), %rcx, %r14
adcq    %rcx, %r13

mulx    472(%rsp), %rcx, %r15
adcq    %rcx, %r14
adcq    $0, %r15

movq    %r8, 536(%rsp)
movq    %r9, 544(%rsp)

movq    320(%rsp), %rdx

mulx    424(%rsp), %r8, %r9
mulx    432(%rsp), %rcx, %rax
addq    %rcx, %r9

mulx    440(%rsp), %rcx, %rbx
adcq    %rcx, %rax

mulx    448(%rsp), %rcx, %rbp
adcq    %rcx, %rbx

mulx    456(%rsp), %rcx, %rsi
adcq    %rcx, %rbp

mulx    464(%rsp), %rcx, %rdi
adcq    %rcx, %rsi

mulx    472(%rsp), %rdx, %rcx
adcq    %rdx, %rdi
adcq    $0, %rcx

addq    544(%rsp), %r8
adcq    %r10, %r9
adcq    %rax, %r11
adcq    %rbx, %r12
adcq    %rbp, %r13
adcq    %rsi, %r14
adcq    %rdi, %r15
adcq    $0,   %rcx

movq    %r8, 544(%rsp)
movq    %r9, 552(%rsp)

movq    328(%rsp), %rdx

mulx    424(%rsp), %r8, %r9
mulx    432(%rsp), %r10, %rax
addq    %r10, %r9

mulx    440(%rsp), %r10, %rbx
adcq    %r10, %rax

mulx    448(%rsp), %r10, %rbp
adcq    %r10, %rbx

mulx    456(%rsp), %r10, %rsi
adcq    %r10, %rbp

mulx    464(%rsp), %r10, %rdi
adcq    %r10, %rsi

mulx    472(%rsp), %rdx, %r10
adcq    %rdx, %rdi
adcq    $0, %r10

addq    552(%rsp), %r8
adcq    %r11,  %r9
adcq    %rax, %r12
adcq    %rbx, %r13
adcq    %rbp, %r14
adcq    %rsi, %r15
adcq    %rdi, %rcx
adcq    $0,   %r10

movq    %r8, 552(%rsp)
movq    %r9, 560(%rsp)

movq    336(%rsp), %rdx

mulx    424(%rsp), %r8, %r9
mulx    432(%rsp), %r11, %rax
addq    %r11, %r9

mulx    440(%rsp), %r11, %rbx
adcq    %r11, %rax

mulx    448(%rsp), %r11, %rbp
adcq    %r11, %rbx

mulx    456(%rsp), %r11, %rsi
adcq    %r11, %rbp

mulx    464(%rsp), %r11, %rdi
adcq    %r11, %rsi

mulx    472(%rsp), %rdx, %r11
adcq    %rdx, %rdi
adcq    $0, %r11

addq    560(%rsp), %r8
adcq    %r12,  %r9
adcq    %rax, %r13
adcq    %rbx, %r14
adcq    %rbp, %r15
adcq    %rsi, %rcx
adcq    %rdi, %r10
adcq    $0,   %r11

movq    %r8, 560(%rsp)
movq    %r9, 568(%rsp)

movq    344(%rsp), %rdx

mulx    424(%rsp), %r8, %r9
mulx    432(%rsp), %r12, %rax
addq    %r12, %r9

mulx    440(%rsp), %r12, %rbx
adcq    %r12, %rax

mulx    448(%rsp), %r12, %rbp
adcq    %r12, %rbx

mulx    456(%rsp), %r12, %rsi
adcq    %r12, %rbp

mulx    464(%rsp), %r12, %rdi
adcq    %r12, %rsi

mulx    472(%rsp), %rdx, %r12
adcq    %rdx, %rdi
adcq    $0, %r12

addq    568(%rsp), %r8
adcq    %r13,  %r9
adcq    %rax, %r14
adcq    %rbx, %r15
adcq    %rbp, %rcx
adcq    %rsi, %r10
adcq    %rdi, %r11
adcq    $0,   %r12

movq    %r8, 568(%rsp)
movq    %r9, 576(%rsp)

movq    352(%rsp), %rdx

mulx    424(%rsp), %r8, %r9
mulx    432(%rsp), %r13, %rax
addq    %r13, %r9

mulx    440(%rsp), %r13, %rbx
adcq    %r13, %rax

mulx    448(%rsp), %r13, %rbp
adcq    %r13, %rbx

mulx    456(%rsp), %r13, %rsi
adcq    %r13, %rbp

mulx    464(%rsp), %r13, %rdi
adcq    %r13, %rsi

mulx    472(%rsp), %rdx, %r13
adcq    %rdx, %rdi
adcq    $0, %r13

addq    576(%rsp), %r8
adcq    %r14,  %r9
adcq    %rax, %r15
adcq    %rbx, %rcx
adcq    %rbp, %r10
adcq    %rsi, %r11
adcq    %rdi, %r12
adcq    $0,   %r13

movq    %r8, 576(%rsp)
movq    %r9, 584(%rsp)

movq    360(%rsp), %rdx

mulx    424(%rsp), %r8, %r9
mulx    432(%rsp), %r14, %rax
addq    %r14, %r9

mulx    440(%rsp), %r14, %rbx
adcq    %r14, %rax

mulx    448(%rsp), %r14, %rbp
adcq    %r14, %rbx

mulx    456(%rsp), %r14, %rsi
adcq    %r14, %rbp

mulx    464(%rsp), %r14, %rdi
adcq    %r14, %rsi

mulx    472(%rsp), %rdx, %r14
adcq    %rdx, %rdi
adcq    $0, %r14

addq    584(%rsp), %r8
adcq    %r15,  %r9
adcq    %rax, %rcx
adcq    %rbx, %r10
adcq    %rbp, %r11
adcq    %rsi, %r12
adcq    %rdi, %r13
adcq    $0,   %r14

movq    536(%rsp), %rax
movq    544(%rsp), %rbx
movq    552(%rsp), %r15
movq    560(%rsp), %rdx
movq    568(%rsp), %rbp
movq    576(%rsp), %rsi
  
xorq    %rdi,%rdi
addq    %r9, %rax
adcq    %rcx, %rbx
adcq    %r10, %r15
adcq    %r11, %rdx
adcq    %r12, %rbp
adcq    %r13, %rsi
adcq    %r14, %r8
adcq    $0, %rdi
  
movq    %rax, 536(%rsp)

movq    %r11, %rax
andq    mask32h, %rax

addq    %rax, %rdx
adcq    %r12, %rbp
adcq    %r13, %rsi
adcq    %r14, %r8
adcq    $0, %rdi

movq    %r11,  %rax
shrd    $32, %r12, %r11
shrd    $32, %r13, %r12
shrd    $32, %r14, %r13
shrd    $32, %r9,  %r14
shrd    $32, %rcx, %r9
shrd    $32, %r10, %rcx
shrd    $32, %rax, %r10

addq    536(%rsp), %r11
adcq    %r12, %rbx
adcq    %r13, %r15
adcq    %r14, %rdx
adcq    %r9,  %rbp
adcq    %rcx, %rsi
adcq    %r10, %r8
adcq    $0, %rdi

movq    %rdi, %r13
shlq    $32, %r13
    
xorq    %r14, %r14
addq    %rdi, %r11
adcq    $0, %rbx
adcq    $0, %r15
adcq    %r13, %rdx
adcq    $0, %rbp
adcq    $0, %rsi
adcq    $0, %r8
adcq    $0, %r14

movq    %r14, %r13
shlq    $32, %r13

addq    %r14, %r11
adcq    $0, %rbx
adcq    $0, %r15
adcq    %r13, %rdx

// update X2
movq    %r11, 72(%rsp) 
movq    %rbx, 80(%rsp)
movq    %r15, 88(%rsp)
movq    %rdx, 96(%rsp)
movq    %rbp, 104(%rsp)
movq    %rsi, 112(%rsp)
movq    %r8,  120(%rsp)

// Z2 ← T2 · T4
movq    480(%rsp), %rdx    

mulx    368(%rsp), %r8, %r9
mulx    376(%rsp), %rcx, %r10
addq    %rcx, %r9

mulx    384(%rsp), %rcx, %r11
adcq    %rcx, %r10

mulx    392(%rsp), %rcx, %r12
adcq    %rcx, %r11

mulx    400(%rsp), %rcx, %r13
adcq    %rcx, %r12

mulx    408(%rsp), %rcx, %r14
adcq    %rcx, %r13

mulx    416(%rsp), %rcx, %r15
adcq    %rcx, %r14
adcq    $0, %r15

movq    %r8, 536(%rsp)
movq    %r9, 544(%rsp)

movq    488(%rsp), %rdx

mulx    368(%rsp), %r8, %r9
mulx    376(%rsp), %rcx, %rax
addq    %rcx, %r9

mulx    384(%rsp), %rcx, %rbx
adcq    %rcx, %rax

mulx    392(%rsp), %rcx, %rbp
adcq    %rcx, %rbx

mulx    400(%rsp), %rcx, %rsi
adcq    %rcx, %rbp

mulx    408(%rsp), %rcx, %rdi
adcq    %rcx, %rsi

mulx    416(%rsp), %rdx, %rcx
adcq    %rdx, %rdi
adcq    $0, %rcx

addq    544(%rsp), %r8
adcq    %r10, %r9
adcq    %rax, %r11
adcq    %rbx, %r12
adcq    %rbp, %r13
adcq    %rsi, %r14
adcq    %rdi, %r15
adcq    $0,   %rcx

movq    %r8, 544(%rsp)
movq    %r9, 552(%rsp)

movq    496(%rsp), %rdx

mulx    368(%rsp), %r8, %r9
mulx    376(%rsp), %r10, %rax
addq    %r10, %r9

mulx    384(%rsp), %r10, %rbx
adcq    %r10, %rax

mulx    392(%rsp), %r10, %rbp
adcq    %r10, %rbx

mulx    400(%rsp), %r10, %rsi
adcq    %r10, %rbp

mulx    408(%rsp), %r10, %rdi
adcq    %r10, %rsi

mulx    416(%rsp), %rdx, %r10
adcq    %rdx, %rdi
adcq    $0, %r10

addq    552(%rsp), %r8
adcq    %r11,  %r9
adcq    %rax, %r12
adcq    %rbx, %r13
adcq    %rbp, %r14
adcq    %rsi, %r15
adcq    %rdi, %rcx
adcq    $0,   %r10

movq    %r8, 552(%rsp)
movq    %r9, 560(%rsp)

movq    504(%rsp), %rdx

mulx    368(%rsp), %r8, %r9
mulx    376(%rsp), %r11, %rax
addq    %r11, %r9

mulx    384(%rsp), %r11, %rbx
adcq    %r11, %rax

mulx    392(%rsp), %r11, %rbp
adcq    %r11, %rbx

mulx    400(%rsp), %r11, %rsi
adcq    %r11, %rbp

mulx    408(%rsp), %r11, %rdi
adcq    %r11, %rsi

mulx    416(%rsp), %rdx, %r11
adcq    %rdx, %rdi
adcq    $0, %r11

addq    560(%rsp), %r8
adcq    %r12,  %r9
adcq    %rax, %r13
adcq    %rbx, %r14
adcq    %rbp, %r15
adcq    %rsi, %rcx
adcq    %rdi, %r10
adcq    $0,   %r11

movq    %r8, 560(%rsp)
movq    %r9, 568(%rsp)

movq    512(%rsp), %rdx

mulx    368(%rsp), %r8, %r9
mulx    376(%rsp), %r12, %rax
addq    %r12, %r9

mulx    384(%rsp), %r12, %rbx
adcq    %r12, %rax

mulx    392(%rsp), %r12, %rbp
adcq    %r12, %rbx

mulx    400(%rsp), %r12, %rsi
adcq    %r12, %rbp

mulx    408(%rsp), %r12, %rdi
adcq    %r12, %rsi

mulx    416(%rsp), %rdx, %r12
adcq    %rdx, %rdi
adcq    $0, %r12

addq    568(%rsp), %r8
adcq    %r13,  %r9
adcq    %rax, %r14
adcq    %rbx, %r15
adcq    %rbp, %rcx
adcq    %rsi, %r10
adcq    %rdi, %r11
adcq    $0,   %r12

movq    %r8, 568(%rsp)
movq    %r9, 576(%rsp)

movq    520(%rsp), %rdx

mulx    368(%rsp), %r8, %r9
mulx    376(%rsp), %r13, %rax
addq    %r13, %r9

mulx    384(%rsp), %r13, %rbx
adcq    %r13, %rax

mulx    392(%rsp), %r13, %rbp
adcq    %r13, %rbx

mulx    400(%rsp), %r13, %rsi
adcq    %r13, %rbp

mulx    408(%rsp), %r13, %rdi
adcq    %r13, %rsi

mulx    416(%rsp), %rdx, %r13
adcq    %rdx, %rdi
adcq    $0, %r13

addq    576(%rsp), %r8
adcq    %r14,  %r9
adcq    %rax, %r15
adcq    %rbx, %rcx
adcq    %rbp, %r10
adcq    %rsi, %r11
adcq    %rdi, %r12
adcq    $0,   %r13

movq    %r8, 576(%rsp)
movq    %r9, 584(%rsp)

movq    528(%rsp), %rdx

mulx    368(%rsp), %r8, %r9
mulx    376(%rsp), %r14, %rax
addq    %r14, %r9

mulx    384(%rsp), %r14, %rbx
adcq    %r14, %rax

mulx    392(%rsp), %r14, %rbp
adcq    %r14, %rbx

mulx    400(%rsp), %r14, %rsi
adcq    %r14, %rbp

mulx    408(%rsp), %r14, %rdi
adcq    %r14, %rsi

mulx    416(%rsp), %rdx, %r14
adcq    %rdx, %rdi
adcq    $0, %r14

addq    584(%rsp), %r8
adcq    %r15,  %r9
adcq    %rax, %rcx
adcq    %rbx, %r10
adcq    %rbp, %r11
adcq    %rsi, %r12
adcq    %rdi, %r13
adcq    $0,   %r14

movq    536(%rsp), %rax
movq    544(%rsp), %rbx
movq    552(%rsp), %r15
movq    560(%rsp), %rdx
movq    568(%rsp), %rbp
movq    576(%rsp), %rsi
  
xorq    %rdi,%rdi
addq    %r9, %rax
adcq    %rcx, %rbx
adcq    %r10, %r15
adcq    %r11, %rdx
adcq    %r12, %rbp
adcq    %r13, %rsi
adcq    %r14, %r8
adcq    $0, %rdi
  
movq    %rax, 536(%rsp)

movq    %r11, %rax
andq    mask32h, %rax

addq    %rax, %rdx
adcq    %r12, %rbp
adcq    %r13, %rsi
adcq    %r14, %r8
adcq    $0, %rdi

movq    %r11,  %rax
shrd    $32, %r12, %r11
shrd    $32, %r13, %r12
shrd    $32, %r14, %r13
shrd    $32, %r9,  %r14
shrd    $32, %rcx, %r9
shrd    $32, %r10, %rcx
shrd    $32, %rax, %r10

addq    536(%rsp), %r11
adcq    %r12, %rbx
adcq    %r13, %r15
adcq    %r14, %rdx
adcq    %r9,  %rbp
adcq    %rcx, %rsi
adcq    %r10, %r8
adcq    $0, %rdi

movq    %rdi, %r13
shlq    $32, %r13
    
xorq    %r14, %r14
addq    %rdi, %r11
adcq    $0, %rbx
adcq    $0, %r15
adcq    %r13, %rdx
adcq    $0, %rbp
adcq    $0, %rsi
adcq    $0, %r8
adcq    $0, %r14

movq    %r14, %r13
shlq    $32, %r13

addq    %r14, %r11
adcq    $0, %rbx
adcq    $0, %r15
adcq    %r13, %rdx

// update Z2
movq    %r11, 128(%rsp) 
movq    %rbx, 136(%rsp)
movq    %r15, 144(%rsp)
movq    %rdx, 152(%rsp)
movq    %rbp, 160(%rsp)
movq    %rsi, 168(%rsp)
movq    %r8,  176(%rsp)

movq    56(%rsp), %rdi

movq    72(%rsp),  %r8 
movq    80(%rsp),  %r9
movq    88(%rsp), %r10
movq    96(%rsp), %r11
movq    104(%rsp), %r12
movq    112(%rsp), %r13
movq    120(%rsp), %r14

// store final value of X2
movq    %r8,   0(%rdi) 
movq    %r9,   8(%rdi)
movq    %r10, 16(%rdi)
movq    %r11, 24(%rdi)
movq    %r12, 32(%rdi)
movq    %r13, 40(%rdi)
movq    %r14, 48(%rdi)

movq    128(%rsp),  %r8 
movq    136(%rsp),  %r9
movq    144(%rsp), %r10
movq    152(%rsp), %r11
movq    160(%rsp), %r12
movq    168(%rsp), %r13
movq    176(%rsp), %r14

// store final value of Z2
movq    %r8,   56(%rdi) 
movq    %r9,   64(%rdi)
movq    %r10,  72(%rdi)
movq    %r11,  80(%rdi)
movq    %r12,  88(%rdi)
movq    %r13,  96(%rdi)
movq    %r14, 104(%rdi)

movq 	 0(%rsp), %r11
movq 	 8(%rsp), %r12
movq 	16(%rsp), %r13
movq 	24(%rsp), %r14
movq 	32(%rsp), %r15
movq 	40(%rsp), %rbx
movq 	48(%rsp), %rbp

movq 	%r11, %rsp

ret
