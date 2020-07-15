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
.globl curve448_mladder
curve448_mladder:

movq 	%rsp, %r11
subq 	$616, %rsp

movq 	%r11,  0(%rsp)
movq 	%r12,  8(%rsp)
movq 	%r13, 16(%rsp)
movq 	%r14, 24(%rsp)
movq 	%r15, 32(%rsp)
movq 	%rbx, 40(%rsp)
movq 	%rbp, 48(%rsp)
movq 	%rdi, 56(%rsp)

// X1 ← XP, X3 ← XP
movq	0(%rsi), %r8
movq	%r8, 72(%rsp)
movq	%r8, 240(%rsp)
movq	8(%rsi), %r8
movq	%r8, 80(%rsp)
movq	%r8, 248(%rsp)
movq	16(%rsi), %r8
movq	%r8, 88(%rsp)
movq	%r8, 256(%rsp)
movq	24(%rsi), %r8
movq	%r8, 96(%rsp)
movq	%r8, 264(%rsp)
movq	32(%rsi), %r8
movq	%r8, 104(%rsp)
movq	%r8, 272(%rsp)
movq	40(%rsi), %r8
movq	%r8, 112(%rsp)
movq	%r8, 280(%rsp)
movq	48(%rsi), %r8
movq	%r8, 120(%rsp)
movq	%r8, 288(%rsp)  

// X2 ← 1
movq	$1, 128(%rsp)
movq	$0, 136(%rsp)
movq	$0, 144(%rsp)
movq	$0, 152(%rsp)
movq	$0, 160(%rsp)
movq	$0, 168(%rsp)
movq	$0, 176(%rsp)  

// Z2 ← 0
movq	$0, 184(%rsp)
movq	$0, 192(%rsp)
movq	$0, 200(%rsp)
movq	$0, 208(%rsp)
movq	$0, 216(%rsp)
movq	$0, 224(%rsp)
movq	$0, 232(%rsp)  

// Z3 ← 1
movq	$1, 296(%rsp)
movq	$0, 304(%rsp)
movq	$0, 312(%rsp)
movq	$0, 320(%rsp)
movq	$0, 328(%rsp)
movq	$0, 336(%rsp)
movq	$0, 344(%rsp) 

movq    $55, 360(%rsp)
movb	$7, 352(%rsp)
movb    $0, 354(%rsp)
movq    %rdx, 64(%rsp)

movq    %rdx, %rax

// Montgomery ladder loop

.L1:

addq    360(%rsp), %rax
movb    0(%rax), %r14b
movb    %r14b, 356(%rsp)

.L2:

/* 
 * Montgomery ladder step
 *
 * T1 ← X2 + Z2
 * T2 ← X2 - Z2
 * T3 ← X3 + Z3
 * T4 ← X3 - Z3
 * Z3 ← T2 · T3
 * X3 ← T1 · T4
 *
 * bit ← n[i]
 * select ← bit ⊕ prevbit
 * prevbit ← bit
 * CSelect(T1,T3,select): if (select == 1) {T1 = T3}
 * CSelect(T2,T4,select): if (select == 1) {T2 = T4}
 *
 * T2 ← T2^2
 * T1 ← T1^2
 * X3 ← X3 + Z3
 * Z3 ← X3 - Z3
 * Z3 ← Z3^2
 * X3 ← X3^2
 * T3 ← T1 - T2
 * T4 ← ((A + 2)/4) · T3
 * T4 ← T4 + T2
 * X2 ← T1 · T2
 * Z2 ← T3 · T4
 * Z3 ← Z3 · X1
 *
 */

// X2
movq    128(%rsp), %r8
movq    136(%rsp), %r9
movq    144(%rsp), %r10
movq    152(%rsp), %r11
movq    160(%rsp), %r12
movq    168(%rsp), %r13
movq    176(%rsp), %r14

// copy X2
movq    %r8,  %rax
movq    %r9,  %rbx
movq    %r10, %rbp
movq    %r11, %rsi
movq    %r12, %rdi
movq    %r13, %rdx

// T1 ← X2 + Z2
addq    184(%rsp), %r8
adcq    192(%rsp), %r9
adcq    200(%rsp), %r10
adcq    208(%rsp), %r11
adcq    216(%rsp), %r12
adcq    224(%rsp), %r13
adcq    232(%rsp), %r14
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

movq    %r8,  368(%rsp)
movq    %r9,  376(%rsp)
movq    %r10, 384(%rsp)
movq    %r11, 392(%rsp)
movq    %r12, 400(%rsp)
movq    %r13, 408(%rsp)
movq    %r14, 416(%rsp)

movq    176(%rsp), %r8

// T2 ← X2 - Z2
subq    184(%rsp), %rax
sbbq    192(%rsp), %rbx
sbbq    200(%rsp), %rbp
sbbq    208(%rsp), %rsi
sbbq    216(%rsp), %rdi
sbbq    224(%rsp), %rdx
sbbq    232(%rsp), %r8
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

movq    %rax, 424(%rsp)
movq    %rbx, 432(%rsp)
movq    %rbp, 440(%rsp)
movq    %rsi, 448(%rsp)
movq    %rdi, 456(%rsp)
movq    %rdx, 464(%rsp)
movq    %r8,  472(%rsp)

// X3
movq    240(%rsp), %r8
movq    248(%rsp), %r9
movq    256(%rsp), %r10
movq    264(%rsp), %r11
movq    272(%rsp), %r12
movq    280(%rsp), %r13
movq    288(%rsp), %r14

// copy X3
movq    %r8,  %rax
movq    %r9,  %rbx
movq    %r10, %rbp
movq    %r11, %rsi
movq    %r12, %rdi
movq    %r13, %rdx

// T3 ← X3 + Z3
addq    296(%rsp), %r8
adcq    304(%rsp), %r9
adcq    312(%rsp), %r10
adcq    320(%rsp), %r11
adcq    328(%rsp), %r12
adcq    336(%rsp), %r13
adcq    344(%rsp), %r14
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

movq    %r8,  480(%rsp)
movq    %r9,  488(%rsp)
movq    %r10, 496(%rsp)
movq    %r11, 504(%rsp)
movq    %r12, 512(%rsp)
movq    %r13, 520(%rsp)
movq    %r14, 528(%rsp)

movq    288(%rsp), %r8

// T4 ← X3 - Z3
subq    296(%rsp), %rax
sbbq    304(%rsp), %rbx
sbbq    312(%rsp), %rbp
sbbq    320(%rsp), %rsi
sbbq    328(%rsp), %rdi
sbbq    336(%rsp), %rdx
sbbq    344(%rsp), %r8
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

movq    %rax, 536(%rsp)
movq    %rbx, 544(%rsp)
movq    %rbp, 552(%rsp)
movq    %rsi, 560(%rsp)
movq    %rdi, 568(%rsp)
movq    %rdx, 576(%rsp)
movq    %r8,  584(%rsp)

// Z3 ← T2 · T3
xorq    %rdi, %rdi
movq    424(%rsp), %rdx    

mulx    480(%rsp), %r8, %r9
mulx    488(%rsp), %rcx, %r10		
adcx    %rcx, %r9

mulx    496(%rsp), %rcx, %r11	
adcx    %rcx, %r10

mulx    504(%rsp), %rcx, %r12	
adcx    %rcx, %r11

mulx    512(%rsp), %rcx, %r13	
adcx    %rcx, %r12

mulx    520(%rsp), %rcx, %r14	
adcx    %rcx, %r13

mulx    528(%rsp), %rcx, %r15	
adcx    %rcx, %r14
adcx    %rdi, %r15

xorq    %rdi, %rdi
movq    432(%rsp), %rdx
   
mulx    480(%rsp), %rcx, %rbp
adcx    %rcx, %r9
adox    %rbp, %r10
    
mulx    488(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    496(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12

mulx    504(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    512(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    520(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15
    
mulx    528(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi			
adcq    $0, %rdi

xorq    %rsi, %rsi
movq    440(%rsp), %rdx
    
mulx    480(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    488(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    496(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    504(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    512(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    520(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi
    
mulx    528(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi
adcq    $0, %rsi

movq    %r10, 592(%rsp)

xorq    %rbx, %rbx
movq    448(%rsp), %rdx
    
mulx    480(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    488(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
    
mulx    496(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    504(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    512(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi

mulx    520(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi
    
mulx    528(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx			
adcq    $0, %rbx

movq    %r11, 600(%rsp)

xorq    %r10, %r10
movq    456(%rsp), %rdx
    
mulx    480(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
    
mulx    488(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14
    
mulx    496(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    504(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi

mulx    512(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    520(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx
    
mulx    528(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10			
adcq    $0, %r10

movq    %r12, 608(%rsp)

xorq    %r11, %r11
movq    464(%rsp), %rdx
    
mulx    480(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14
    
mulx    488(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15
    
mulx    496(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi

mulx    504(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    512(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    520(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10
    
mulx    528(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11			
adcq    $0, %r11

xorq    %r12, %r12
movq    472(%rsp), %rdx
    
mulx    480(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15
    
mulx    488(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi
    
mulx    496(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    504(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    512(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    520(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    528(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12			
adcq    $0, %r12

movq    592(%rsp), %rcx
movq    600(%rsp), %rdx
movq    608(%rsp), %rbp

xorq    %rax, %rax
addq    %r15, %r8
adcq    %rdi, %r9
adcq    %rsi, %rcx
adcq    %rbx, %rdx
adcq    %r10, %rbp
adcq    %r11, %r13
adcq    %r12, %r14
adcq    %rax, %rax

movq    %r8, 592(%rsp)

movq    %rbx, %r8
andq    mask32h, %r8

addq    %r8,  %rdx
adcq    %r10, %rbp
adcq    %r11, %r13
adcq    %r12, %r14
adcq    $0, %rax

movq    %rbx,  %r8
shrd    $32, %r10, %rbx
shrd    $32, %r11, %r10
shrd    $32, %r12, %r11
shrd    $32, %r15, %r12
shrd    $32, %rdi, %r15
shrd    $32, %rsi, %rdi
shrd    $32, %r8,  %rsi

addq    592(%rsp), %rbx
adcq    %r10, %r9
adcq    %r11, %rcx
adcq    %r12, %rdx
adcq    %r15, %rbp
adcq    %rdi, %r13
adcq    %rsi, %r14
adcq    $0,  %rax

movq    %rax, %r12
shlq    $32, %r12

xorq    %r10,%r10
addq    %rax, %rbx
adcq    $0, %r9
adcq    $0, %rcx
adcq    %r12, %rdx
adcq    $0, %rbp
adcq    $0, %r13
adcq    $0, %r14
adcq    $0, %r10

movq    %r10, %r15
shlq    $32, %r15

addq    %r10, %rbx
adcq    $0, %r9
adcq    $0, %rcx
adcq    %r15, %rdx

movq    %rbx, 296(%rsp)
movq    %r9,  304(%rsp)
movq    %rcx, 312(%rsp)
movq    %rdx, 320(%rsp)
movq    %rbp, 328(%rsp)
movq    %r13, 336(%rsp)
movq    %r14, 344(%rsp)

// X3 ← T1 · T4
xorq    %rdi, %rdi
movq    368(%rsp), %rdx    

mulx    536(%rsp), %r8, %r9
mulx    544(%rsp), %rcx, %r10		
adcx    %rcx, %r9

mulx    552(%rsp), %rcx, %r11	
adcx    %rcx, %r10

mulx    560(%rsp), %rcx, %r12	
adcx    %rcx, %r11

mulx    568(%rsp), %rcx, %r13	
adcx    %rcx, %r12

mulx    576(%rsp), %rcx, %r14	
adcx    %rcx, %r13

mulx    584(%rsp), %rcx, %r15	
adcx    %rcx, %r14
adcx    %rdi, %r15

xorq    %rdi, %rdi
movq    376(%rsp), %rdx
   
mulx    536(%rsp), %rcx, %rbp
adcx    %rcx, %r9
adox    %rbp, %r10
    
mulx    544(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    552(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12

mulx    560(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    568(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    576(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15
    
mulx    584(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi			
adcq    $0, %rdi

xorq    %rsi, %rsi
movq    384(%rsp), %rdx
    
mulx    536(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    544(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    552(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    560(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    568(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    576(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi
    
mulx    584(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi
adcq    $0, %rsi

movq    %r10, 592(%rsp)

xorq    %rbx, %rbx
movq    392(%rsp), %rdx
    
mulx    536(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    544(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
    
mulx    552(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    560(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    568(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi

mulx    576(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi
    
mulx    584(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx			
adcq    $0, %rbx

movq    %r11, 600(%rsp)

xorq    %r10, %r10
movq    400(%rsp), %rdx
    
mulx    536(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
    
mulx    544(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14
    
mulx    552(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    560(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi

mulx    568(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    576(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx
    
mulx    584(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10			
adcq    $0, %r10

movq    %r12, 608(%rsp)

xorq    %r11, %r11
movq    408(%rsp), %rdx
    
mulx    536(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14
    
mulx    544(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15
    
mulx    552(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi

mulx    560(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    568(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    576(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10
    
mulx    584(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11			
adcq    $0, %r11

xorq    %r12, %r12
movq    416(%rsp), %rdx
    
mulx    536(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15
    
mulx    544(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi
    
mulx    552(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    560(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    568(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    576(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    584(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12			
adcq    $0, %r12

movq    592(%rsp), %rcx
movq    600(%rsp), %rdx
movq    608(%rsp), %rbp

xorq    %rax, %rax
addq    %r15, %r8
adcq    %rdi, %r9
adcq    %rsi, %rcx
adcq    %rbx, %rdx
adcq    %r10, %rbp
adcq    %r11, %r13
adcq    %r12, %r14
adcq    %rax, %rax

movq    %r8, 592(%rsp)

movq    %rbx, %r8
andq    mask32h, %r8

addq    %r8,  %rdx
adcq    %r10, %rbp
adcq    %r11, %r13
adcq    %r12, %r14
adcq    $0, %rax

movq    %rbx,  %r8
shrd    $32, %r10, %rbx
shrd    $32, %r11, %r10
shrd    $32, %r12, %r11
shrd    $32, %r15, %r12
shrd    $32, %rdi, %r15
shrd    $32, %rsi, %rdi
shrd    $32, %r8,  %rsi

addq    592(%rsp), %rbx
adcq    %r10, %r9
adcq    %r11, %rcx
adcq    %r12, %rdx
adcq    %r15, %rbp
adcq    %rdi, %r13
adcq    %rsi, %r14
adcq    $0,  %rax

movq    %rax, %r12
shlq    $32, %r12

xorq    %r10,%r10
addq    %rax, %rbx
adcq    $0, %r9
adcq    $0, %rcx
adcq    %r12, %rdx
adcq    $0, %rbp
adcq    $0, %r13
adcq    $0, %r14
adcq    $0, %r10

movq    %r10, %r15
shlq    $32, %r15

addq    %r10, %rbx
adcq    $0, %r9
adcq    $0, %rcx
adcq    %r15, %rdx

movq    %rbx, 240(%rsp)
movq    %r9,  248(%rsp)
movq    %rcx, 256(%rsp)
movq    %rdx, 264(%rsp)
movq    %rbp, 272(%rsp)
movq    %r13, 280(%rsp)
movq    %r14, 288(%rsp)

movb	352(%rsp), %cl
movb	356(%rsp), %bl
shrb    %cl, %bl
andb    $1, %bl
movb    %bl, %cl
xorb    354(%rsp), %bl
movb    %cl, 354(%rsp)

cmpb    $1, %bl

// CSelect(T1,T3,swap)
movq    368(%rsp), %r8
movq    376(%rsp), %r9
movq    384(%rsp), %r10
movq    392(%rsp), %r11
movq    400(%rsp), %r12
movq    408(%rsp), %r13
movq    416(%rsp), %r14

movq    480(%rsp), %r15
movq    488(%rsp), %rax
movq    496(%rsp), %rbx
movq    504(%rsp), %rcx
movq    512(%rsp), %rdx
movq    520(%rsp), %rbp
movq    528(%rsp), %rsi

cmove   %r15, %r8
cmove   %rax, %r9
cmove   %rbx, %r10
cmove   %rcx, %r11
cmove   %rdx, %r12
cmove   %rbp, %r13
cmove   %rsi, %r14

movq    %r8,  368(%rsp)
movq    %r9,  376(%rsp)
movq    %r10, 384(%rsp)
movq    %r11, 392(%rsp)
movq    %r12, 400(%rsp)
movq    %r13, 408(%rsp)
movq    %r14, 416(%rsp)

// CSelect(T2,T4,swap)
movq    424(%rsp), %r8
movq    432(%rsp), %r9
movq    440(%rsp), %r10
movq    448(%rsp), %r11
movq    456(%rsp), %r12
movq    464(%rsp), %r13
movq    472(%rsp), %r14

movq    536(%rsp), %r15
movq    544(%rsp), %rax
movq    552(%rsp), %rbx
movq    560(%rsp), %rcx
movq    568(%rsp), %rdx
movq    576(%rsp), %rbp
movq    584(%rsp), %rsi

cmove   %r15, %r8
cmove   %rax, %r9
cmove   %rbx, %r10
cmove   %rcx, %r11
cmove   %rdx, %r12
cmove   %rbp, %r13
cmove   %rsi, %r14

movq    %r8,  424(%rsp)
movq    %r9,  432(%rsp)
movq    %r10, 440(%rsp)
movq    %r11, 448(%rsp)
movq    %r12, 456(%rsp)
movq    %r13, 464(%rsp)
movq    %r14, 472(%rsp)

// T2 ← T2^2
movq    424(%rsp), %rdx
xorq    %r8, %r8
    
mulx    432(%rsp), %r9, %r10

mulx    440(%rsp), %rcx, %r11
adcx    %rcx, %r10

mulx    448(%rsp), %rcx, %r12
adcx    %rcx, %r11

mulx    456(%rsp), %rcx, %r13
adcx    %rcx, %r12

mulx    464(%rsp), %rcx, %r14
adcx    %rcx, %r13

mulx    472(%rsp), %rcx, %r15
adcx    %rcx, %r14
adcx    %r8, %r15
    
movq    432(%rsp), %rdx
xorq    %rdi, %rdi
    
mulx    440(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12

mulx    448(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    456(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    472(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %r8
adcx    %rdi, %r8
    
movq    440(%rsp), %rdx
xorq    %rbx, %rbx

mulx    448(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    456(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %r8

mulx    472(%rsp), %rcx, %rbp
adcx    %rcx, %r8
adox    %rbp, %rdi
adcx    %rbx, %rdi

movq    %r11, 592(%rsp)

movq    448(%rsp), %rdx
xorq    %r11, %r11

mulx    456(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %r8

mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %r8
adox    %rbp, %rdi

mulx    472(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rbx
adcx    %r11, %rbx

movq    456(%rsp), %rdx
xorq    %rax, %rax

mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rbx

mulx    472(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r11
adcx    %rax, %r11

movq    464(%rsp), %rdx

mulx    472(%rsp), %rcx, %rsi
adcx    %rcx, %r11
adcx    %rax, %rsi

movq    592(%rsp), %rdx

movq    $0, %rbp
shld    $1, %rsi, %rbp
shld    $1, %r11, %rsi
shld    $1, %rbx, %r11
shld    $1, %rdi, %rbx
shld    $1, %r8,  %rdi
shld    $1, %r15, %r8
shld    $1, %r14, %r15
shld    $1, %r13, %r14
shld    $1, %r12, %r13
shld    $1, %rdx, %r12
shld    $1, %r10, %rdx
shld    $1, %r9,  %r10
shlq    $1, %r9

movq    %rdx, 592(%rsp)		
movq    %r12, 600(%rsp)
	  
xorq    %rdx, %rdx
movq    424(%rsp), %rdx
mulx    %rdx, %r12, %rax
adcx    %rax, %r9

movq    432(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %r10
adcx    592(%rsp), %rax
movq    %rax, 592(%rsp)

movq    440(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    600(%rsp), %rcx
adcx    %rax, %r13
movq    %rcx, 600(%rsp)

movq    448(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %r14
adcx    %rax, %r15

movq    456(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %r8
adcx    %rax, %rdi

movq    464(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %rbx
adcx    %rax, %r11

movq    472(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %rsi
adcx    %rax, %rbp

movq    592(%rsp), %rcx
movq    600(%rsp), %rdx

xorq    %rax, %rax
addq    %r15, %r12
adcq    %r8,   %r9
adcq    %rdi, %r10
adcq    %rbx, %rcx
adcq    %r11, %rdx
adcq    %rsi, %r13
adcq    %rbp, %r14
adcq    %rax, %rax
    
movq    %r12, 592(%rsp)

movq    %rbx, %r12
andq    mask32h, %r12

addq    %r12, %rcx
adcq    %r11, %rdx
adcq    %rsi, %r13
adcq    %rbp, %r14
adcq    $0, %rax

movq    %rbx,  %r12
shrd    $32, %r11, %rbx
shrd    $32, %rsi, %r11
shrd    $32, %rbp, %rsi
shrd    $32, %r15, %rbp
shrd    $32, %r8,  %r15
shrd    $32, %rdi, %r8
shrd    $32, %r12, %rdi

addq    592(%rsp), %rbx
adcq    %r11, %r9
adcq    %rsi, %r10
adcq    %rbp, %rcx
adcq    %r15, %rdx
adcq    %r8,  %r13
adcq    %rdi, %r14
adcq    $0, %rax

movq    %rax, %r12
shlq    $32, %r12

xorq    %r11, %r11
addq    %rax, %rbx
adcq    $0, %r9
adcq    $0, %r10
adcq    %r12, %rcx
adcq    $0, %rdx
adcq    $0, %r13
adcq    $0, %r14
adcq    $0, %r11

movq    %r11, %r12
shlq    $32, %r12

addq    %r11, %rbx
adcq    $0, %r9
adcq    $0, %r10
adcq    %r12, %rcx

movq    %rbx, 424(%rsp)
movq    %r9,  432(%rsp)
movq    %r10, 440(%rsp)
movq    %rcx, 448(%rsp)
movq    %rdx, 456(%rsp)
movq    %r13, 464(%rsp)
movq    %r14, 472(%rsp)

// T1 ← T1^2
movq    368(%rsp), %rdx
xorq    %r8, %r8
    
mulx    376(%rsp), %r9, %r10

mulx    384(%rsp), %rcx, %r11
adcx    %rcx, %r10

mulx    392(%rsp), %rcx, %r12
adcx    %rcx, %r11

mulx    400(%rsp), %rcx, %r13
adcx    %rcx, %r12

mulx    408(%rsp), %rcx, %r14
adcx    %rcx, %r13

mulx    416(%rsp), %rcx, %r15
adcx    %rcx, %r14
adcx    %r8, %r15
    
movq    376(%rsp), %rdx
xorq    %rdi, %rdi
    
mulx    384(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12

mulx    392(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    400(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    408(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    416(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %r8
adcx    %rdi, %r8
    
movq    384(%rsp), %rdx
xorq    %rbx, %rbx

mulx    392(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    400(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    408(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %r8

mulx    416(%rsp), %rcx, %rbp
adcx    %rcx, %r8
adox    %rbp, %rdi
adcx    %rbx, %rdi

movq    %r11, 592(%rsp)

movq    392(%rsp), %rdx
xorq    %r11, %r11

mulx    400(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %r8

mulx    408(%rsp), %rcx, %rbp
adcx    %rcx, %r8
adox    %rbp, %rdi

mulx    416(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rbx
adcx    %r11, %rbx

movq    400(%rsp), %rdx
xorq    %rax, %rax

mulx    408(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rbx

mulx    416(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r11
adcx    %rax, %r11

movq    408(%rsp), %rdx

mulx    416(%rsp), %rcx, %rsi
adcx    %rcx, %r11
adcx    %rax, %rsi

movq    592(%rsp), %rdx

movq    $0, %rbp
shld    $1, %rsi, %rbp
shld    $1, %r11, %rsi
shld    $1, %rbx, %r11
shld    $1, %rdi, %rbx
shld    $1, %r8,  %rdi
shld    $1, %r15, %r8
shld    $1, %r14, %r15
shld    $1, %r13, %r14
shld    $1, %r12, %r13
shld    $1, %rdx, %r12
shld    $1, %r10, %rdx
shld    $1, %r9,  %r10
shlq    $1, %r9

movq    %rdx, 592(%rsp)		
movq    %r12, 600(%rsp)
	  
xorq    %rdx, %rdx
movq    368(%rsp), %rdx
mulx    %rdx, %r12, %rax
adcx    %rax, %r9

movq    376(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %r10
adcx    592(%rsp), %rax
movq    %rax, 592(%rsp)

movq    384(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    600(%rsp), %rcx
adcx    %rax, %r13
movq    %rcx, 600(%rsp)

movq    392(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %r14
adcx    %rax, %r15

movq    400(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %r8
adcx    %rax, %rdi

movq    408(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %rbx
adcx    %rax, %r11

movq    416(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %rsi
adcx    %rax, %rbp

movq    592(%rsp), %rcx
movq    600(%rsp), %rdx

xorq    %rax, %rax
addq    %r15, %r12
adcq    %r8,   %r9
adcq    %rdi, %r10
adcq    %rbx, %rcx
adcq    %r11, %rdx
adcq    %rsi, %r13
adcq    %rbp, %r14
adcq    %rax, %rax
    
movq    %r12, 592(%rsp)

movq    %rbx, %r12
andq    mask32h, %r12

addq    %r12, %rcx
adcq    %r11, %rdx
adcq    %rsi, %r13
adcq    %rbp, %r14
adcq    $0, %rax

movq    %rbx,  %r12
shrd    $32, %r11, %rbx
shrd    $32, %rsi, %r11
shrd    $32, %rbp, %rsi
shrd    $32, %r15, %rbp
shrd    $32, %r8,  %r15
shrd    $32, %rdi, %r8
shrd    $32, %r12, %rdi

addq    592(%rsp), %rbx
adcq    %r11, %r9
adcq    %rsi, %r10
adcq    %rbp, %rcx
adcq    %r15, %rdx
adcq    %r8,  %r13
adcq    %rdi, %r14
adcq    $0, %rax

movq    %rax, %r12
shlq    $32, %r12

xorq    %r11, %r11
addq    %rax, %rbx
adcq    $0, %r9
adcq    $0, %r10
adcq    %r12, %rcx
adcq    $0, %rdx
adcq    $0, %r13
adcq    $0, %r14
adcq    $0, %r11

movq    %r11, %r12
shlq    $32, %r12

addq    %r11, %rbx
adcq    $0, %r9
adcq    $0, %r10
adcq    %r12, %rcx

movq    %rbx, 368(%rsp)
movq    %r9,  376(%rsp)
movq    %r10, 384(%rsp)
movq    %rcx, 392(%rsp)
movq    %rdx, 400(%rsp)
movq    %r13, 408(%rsp)
movq    %r14, 416(%rsp)

// X3
movq    240(%rsp), %r8
movq    248(%rsp), %r9
movq    256(%rsp), %r10
movq    264(%rsp), %r11
movq    272(%rsp), %r12
movq    280(%rsp), %r13
movq    288(%rsp), %r14

// copy X3
movq    %r8,  %rax
movq    %r9,  %rbx
movq    %r10, %rcx
movq    %r11, %rdx
movq    %r12, %rbp
movq    %r13, %rsi

// X3 ← X3 + Z3
addq    296(%rsp), %r8
adcq    304(%rsp), %r9
adcq    312(%rsp), %r10
adcq    320(%rsp), %r11
adcq    328(%rsp), %r12
adcq    336(%rsp), %r13
adcq    344(%rsp), %r14
movq    $0, %r15
adcq    $0, %r15

movq    %r15, %rdi
shlq    $32,  %rdi

addq    %r15, %r8
adcq    $0, %r9
adcq    $0, %r10
adcq    %rdi, %r11
adcq    $0, %r12
adcq    $0, %r13
adcq    $0, %r14
movq    $0, %r15
adcq    $0, %r15

movq    %r15, %rdi
shlq    $32, %rdi

addq    %r15, %r8
adcq    $0, %r9
adcq    $0, %r10
adcq    %rdi, %r11

movq    288(%rsp), %rdi

movq    %r8,  240(%rsp)
movq    %r9,  248(%rsp)
movq    %r10, 256(%rsp)
movq    %r11, 264(%rsp)
movq    %r12, 272(%rsp)
movq    %r13, 280(%rsp)
movq    %r14, 288(%rsp)

// Z3 ← X3 - Z3
subq    296(%rsp), %rax
sbbq    304(%rsp), %rbx
sbbq    312(%rsp), %rcx
sbbq    320(%rsp), %rdx
sbbq    328(%rsp), %rbp
sbbq    336(%rsp), %rsi
sbbq    344(%rsp), %rdi
movq    $0, %r8
adcq    $0, %r8

movq    %r8, %r9
shlq    $32, %r9

subq    %r8, %rax
sbbq    $0, %rbx
sbbq    $0, %rcx
sbbq    %r9, %rdx
sbbq    $0, %rbp
sbbq    $0, %rsi
sbbq    $0, %rdi
movq    $0, %r8
adcq    $0, %r8

movq    %r8, %r9
shlq    $32, %r9

subq    %r8, %rax
sbbq    $0, %rbx
sbbq    $0, %rcx
sbbq    %r9, %rdx

movq    %rax, 296(%rsp)
movq    %rbx, 304(%rsp)
movq    %rcx, 312(%rsp)
movq    %rdx, 320(%rsp)
movq    %rbp, 328(%rsp)
movq    %rsi, 336(%rsp)
movq    %rdi, 344(%rsp)

// Z3 ← Z3^2
movq    296(%rsp), %rdx
xorq    %r8, %r8
    
mulx    304(%rsp), %r9, %r10

mulx    312(%rsp), %rcx, %r11
adcx    %rcx, %r10

mulx    320(%rsp), %rcx, %r12
adcx    %rcx, %r11

mulx    328(%rsp), %rcx, %r13
adcx    %rcx, %r12

mulx    336(%rsp), %rcx, %r14
adcx    %rcx, %r13

mulx    344(%rsp), %rcx, %r15
adcx    %rcx, %r14
adcx    %r8, %r15
    
movq    304(%rsp), %rdx
xorq    %rdi, %rdi
    
mulx    312(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12

mulx    320(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    328(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    336(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    344(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %r8
adcx    %rdi, %r8
    
movq    312(%rsp), %rdx
xorq    %rbx, %rbx

mulx    320(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    328(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    336(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %r8

mulx    344(%rsp), %rcx, %rbp
adcx    %rcx, %r8
adox    %rbp, %rdi
adcx    %rbx, %rdi

movq    %r11, 592(%rsp)

movq    320(%rsp), %rdx
xorq    %r11, %r11

mulx    328(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %r8

mulx    336(%rsp), %rcx, %rbp
adcx    %rcx, %r8
adox    %rbp, %rdi

mulx    344(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rbx
adcx    %r11, %rbx

movq    328(%rsp), %rdx
xorq    %rax, %rax

mulx    336(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rbx

mulx    344(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r11
adcx    %rax, %r11

movq    336(%rsp), %rdx

mulx    344(%rsp), %rcx, %rsi
adcx    %rcx, %r11
adcx    %rax, %rsi

movq    592(%rsp), %rdx

movq    $0, %rbp
shld    $1, %rsi, %rbp
shld    $1, %r11, %rsi
shld    $1, %rbx, %r11
shld    $1, %rdi, %rbx
shld    $1, %r8,  %rdi
shld    $1, %r15, %r8
shld    $1, %r14, %r15
shld    $1, %r13, %r14
shld    $1, %r12, %r13
shld    $1, %rdx, %r12
shld    $1, %r10, %rdx
shld    $1, %r9,  %r10
shlq    $1, %r9 

movq    %rdx, 592(%rsp)		
movq    %r12, 600(%rsp)
	  
xorq    %rdx, %rdx
movq    296(%rsp), %rdx
mulx    %rdx, %r12, %rax
adcx    %rax, %r9

movq    304(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %r10
adcx    592(%rsp), %rax
movq    %rax, 592(%rsp)

movq    312(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    600(%rsp), %rcx
adcx    %rax, %r13
movq    %rcx, 600(%rsp)

movq    320(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %r14
adcx    %rax, %r15

movq    328(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %r8
adcx    %rax, %rdi

movq    336(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %rbx
adcx    %rax, %r11

movq    344(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %rsi
adcx    %rax, %rbp

movq    592(%rsp), %rcx
movq    600(%rsp), %rdx

xorq    %rax, %rax
addq    %r15, %r12
adcq    %r8,   %r9
adcq    %rdi, %r10
adcq    %rbx, %rcx
adcq    %r11, %rdx
adcq    %rsi, %r13
adcq    %rbp, %r14
adcq    %rax, %rax
    
movq    %r12, 592(%rsp)

movq    %rbx, %r12
andq    mask32h, %r12

addq    %r12, %rcx
adcq    %r11, %rdx
adcq    %rsi, %r13
adcq    %rbp, %r14
adcq    $0, %rax

movq    %rbx,  %r12
shrd    $32, %r11, %rbx
shrd    $32, %rsi, %r11
shrd    $32, %rbp, %rsi
shrd    $32, %r15, %rbp
shrd    $32, %r8,  %r15
shrd    $32, %rdi, %r8
shrd    $32, %r12, %rdi

addq    592(%rsp), %rbx
adcq    %r11, %r9
adcq    %rsi, %r10
adcq    %rbp, %rcx
adcq    %r15, %rdx
adcq    %r8,  %r13
adcq    %rdi, %r14
adcq    $0, %rax

movq    %rax, %r12
shlq    $32, %r12

xorq    %r11, %r11
addq    %rax, %rbx
adcq    $0, %r9
adcq    $0, %r10
adcq    %r12, %rcx
adcq    $0, %rdx
adcq    $0, %r13
adcq    $0, %r14
adcq    $0, %r11

movq    %r11, %r12
shlq    $32, %r12

addq    %r11, %rbx
adcq    $0, %r9
adcq    $0, %r10
adcq    %r12, %rcx

movq    %rbx, 296(%rsp) 
movq    %r9,  304(%rsp)
movq    %r10, 312(%rsp)
movq    %rcx, 320(%rsp)
movq    %rdx, 328(%rsp)
movq    %r13, 336(%rsp)
movq    %r14, 344(%rsp)

// X3 ← X3^2
movq    240(%rsp), %rdx
xorq    %r8, %r8
    
mulx    248(%rsp), %r9, %r10

mulx    256(%rsp), %rcx, %r11
adcx    %rcx, %r10

mulx    264(%rsp), %rcx, %r12
adcx    %rcx, %r11

mulx    272(%rsp), %rcx, %r13
adcx    %rcx, %r12

mulx    280(%rsp), %rcx, %r14
adcx    %rcx, %r13

mulx    288(%rsp), %rcx, %r15
adcx    %rcx, %r14
adcx    %r8, %r15
    
movq    248(%rsp), %rdx
xorq    %rdi, %rdi
    
mulx    256(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12

mulx    264(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    272(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    280(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    288(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %r8
adcx    %rdi, %r8
    
movq    256(%rsp), %rdx
xorq    %rbx, %rbx

mulx    264(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    272(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    280(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %r8

mulx    288(%rsp), %rcx, %rbp
adcx    %rcx, %r8
adox    %rbp, %rdi
adcx    %rbx, %rdi

movq    %r11, 592(%rsp)

movq    264(%rsp), %rdx
xorq    %r11, %r11

mulx    272(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %r8

mulx    280(%rsp), %rcx, %rbp
adcx    %rcx, %r8
adox    %rbp, %rdi

mulx    288(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rbx
adcx    %r11, %rbx

movq    272(%rsp), %rdx
xorq    %rax, %rax

mulx    280(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rbx

mulx    288(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r11
adcx    %rax, %r11

movq    280(%rsp), %rdx

mulx    288(%rsp), %rcx, %rsi
adcx    %rcx, %r11
adcx    %rax, %rsi

movq    592(%rsp), %rdx

movq    $0, %rbp
shld    $1, %rsi, %rbp
shld    $1, %r11, %rsi
shld    $1, %rbx, %r11
shld    $1, %rdi, %rbx
shld    $1, %r8,  %rdi
shld    $1, %r15, %r8
shld    $1, %r14, %r15
shld    $1, %r13, %r14
shld    $1, %r12, %r13
shld    $1, %rdx, %r12
shld    $1, %r10, %rdx
shld    $1, %r9,  %r10
shlq    $1, %r9 

movq    %rdx, 592(%rsp)		
movq    %r12, 600(%rsp)
	  
xorq    %rdx, %rdx
movq    240(%rsp), %rdx
mulx    %rdx, %r12, %rax
adcx    %rax, %r9

movq    248(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %r10
adcx    592(%rsp), %rax
movq    %rax, 592(%rsp)

movq    256(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    600(%rsp), %rcx
adcx    %rax, %r13
movq    %rcx, 600(%rsp)

movq    264(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %r14
adcx    %rax, %r15

movq    272(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %r8
adcx    %rax, %rdi

movq    280(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %rbx
adcx    %rax, %r11

movq    288(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %rsi
adcx    %rax, %rbp

movq    592(%rsp), %rcx
movq    600(%rsp), %rdx

xorq    %rax, %rax
addq    %r15, %r12
adcq    %r8,   %r9
adcq    %rdi, %r10
adcq    %rbx, %rcx
adcq    %r11, %rdx
adcq    %rsi, %r13
adcq    %rbp, %r14
adcq    %rax, %rax
    
movq    %r12, 592(%rsp)

movq    %rbx, %r12
andq    mask32h, %r12

addq    %r12, %rcx
adcq    %r11, %rdx
adcq    %rsi, %r13
adcq    %rbp, %r14
adcq    $0, %rax

movq    %rbx,  %r12
shrd    $32, %r11, %rbx
shrd    $32, %rsi, %r11
shrd    $32, %rbp, %rsi
shrd    $32, %r15, %rbp
shrd    $32, %r8,  %r15
shrd    $32, %rdi, %r8
shrd    $32, %r12, %rdi

addq    592(%rsp), %rbx
adcq    %r11, %r9
adcq    %rsi, %r10
adcq    %rbp, %rcx
adcq    %r15, %rdx
adcq    %r8,  %r13
adcq    %rdi, %r14
adcq    $0, %rax

movq    %rax, %r12
shlq    $32, %r12

xorq    %r11, %r11
addq    %rax, %rbx
adcq    $0, %r9
adcq    $0, %r10
adcq    %r12, %rcx
adcq    $0, %rdx
adcq    $0, %r13
adcq    $0, %r14
adcq    $0, %r11

movq    %r11, %r12
shlq    $32, %r12

addq    %r11, %rbx
adcq    $0, %r9
adcq    $0, %r10
adcq    %r12, %rcx

// update X3
movq    %rbx, 240(%rsp)
movq    %r9,  248(%rsp)
movq    %r10, 256(%rsp)
movq    %rcx, 264(%rsp)
movq    %rdx, 272(%rsp)
movq    %r13, 280(%rsp)
movq    %r14, 288(%rsp)

// T3 ← T1 - T2
movq    368(%rsp), %r8
movq    376(%rsp), %r9
movq    384(%rsp), %r10
movq    392(%rsp), %r11
movq    400(%rsp), %r12
movq    408(%rsp), %r13
movq    416(%rsp), %r14

subq    424(%rsp), %r8
sbbq    432(%rsp), %r9
sbbq    440(%rsp), %r10
sbbq    448(%rsp), %r11
sbbq    456(%rsp), %r12
sbbq    464(%rsp), %r13
sbbq    472(%rsp), %r14
movq    $0, %rax
adcq    $0, %rax

movq    %rax, %rsi
shlq    $32,  %rsi

subq    %rax, %r8
sbbq    $0, %r9
sbbq    $0, %r10
sbbq    %rsi, %r11
sbbq    $0, %r12
sbbq    $0, %r13
sbbq    $0, %r14
movq    $0, %rax
adcq    $0, %rax

movq    %rax, %rsi
shlq    $32, %rsi

subq    %rax, %r8
sbbq    $0, %r9
sbbq    $0, %r10
sbbq    %rsi, %r11

movq    %r8,  480(%rsp) 
movq    %r9,  488(%rsp)
movq    %r10, 496(%rsp)
movq    %r11, 504(%rsp)
movq    %r12, 512(%rsp)
movq    %r13, 520(%rsp)
movq    %r14, 528(%rsp)

// T4 ← ((A + 2)/4) · T3
xorq    %r15, %r15
movq    a24, %rdx

mulx    %r8, %r8, %rcx
mulx    %r9, %r9, %rax
adcx    %rcx, %r9

mulx    %r10, %r10, %rcx
adcx    %rax, %r10

mulx    %r11, %r11, %rax
adcx    %rcx, %r11

mulx    %r12, %r12, %rcx
adcx    %rax, %r12

mulx    %r13, %r13, %rax
adcx    %rcx, %r13

mulx    %r14, %r14, %rcx
adcx    %rax, %r14
adcx    %rcx, %r15

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

// T4 ← T4 + T2
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

movq    %r8,  536(%rsp) 
movq    %r9,  544(%rsp)
movq    %r10, 552(%rsp)
movq    %r11, 560(%rsp)
movq    %r12, 568(%rsp)
movq    %r13, 576(%rsp)
movq    %r14, 584(%rsp)

// X2 ← T1 · T2
xorq    %rdi, %rdi
movq    368(%rsp), %rdx    

mulx    424(%rsp), %r8, %r9
mulx    432(%rsp), %rcx, %r10		
adcx    %rcx, %r9

mulx    440(%rsp), %rcx, %r11	
adcx    %rcx, %r10

mulx    448(%rsp), %rcx, %r12	
adcx    %rcx, %r11

mulx    456(%rsp), %rcx, %r13	
adcx    %rcx, %r12

mulx    464(%rsp), %rcx, %r14	
adcx    %rcx, %r13

mulx    472(%rsp), %rcx, %r15	
adcx    %rcx, %r14
adcx    %rdi, %r15

xorq    %rdi, %rdi
movq    376(%rsp), %rdx
   
mulx    424(%rsp), %rcx, %rbp
adcx    %rcx, %r9
adox    %rbp, %r10
    
mulx    432(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    440(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12

mulx    448(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    456(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15
    
mulx    472(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi			
adcq    $0, %rdi

xorq    %rsi, %rsi
movq    384(%rsp), %rdx
    
mulx    424(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    432(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    440(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    448(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    456(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi
    
mulx    472(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi
adcq    $0, %rsi

movq    %r10, 592(%rsp)

xorq    %rbx, %rbx
movq    392(%rsp), %rdx
    
mulx    424(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    432(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
    
mulx    440(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    448(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    456(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi

mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi
    
mulx    472(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx			
adcq    $0, %rbx

movq    %r11, 600(%rsp)

xorq    %r10, %r10
movq    400(%rsp), %rdx
    
mulx    424(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
    
mulx    432(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14
    
mulx    440(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    448(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi

mulx    456(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx
    
mulx    472(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10			
adcq    $0, %r10

movq    %r12, 608(%rsp)

xorq    %r11, %r11
movq    408(%rsp), %rdx
    
mulx    424(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14
    
mulx    432(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15
    
mulx    440(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi

mulx    448(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    456(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10
    
mulx    472(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11			
adcq    $0, %r11

xorq    %r12, %r12
movq    416(%rsp), %rdx
    
mulx    424(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15
    
mulx    432(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi
    
mulx    440(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    448(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    456(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    472(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12			
adcq    $0, %r12

movq    592(%rsp), %rcx
movq    600(%rsp), %rdx
movq    608(%rsp), %rbp

xorq    %rax, %rax
addq    %r15, %r8
adcq    %rdi, %r9
adcq    %rsi, %rcx
adcq    %rbx, %rdx
adcq    %r10, %rbp
adcq    %r11, %r13
adcq    %r12, %r14
adcq    %rax, %rax

movq    %r8, 592(%rsp)

movq    %rbx, %r8
andq    mask32h, %r8

addq    %r8,  %rdx
adcq    %r10, %rbp
adcq    %r11, %r13
adcq    %r12, %r14
adcq    $0, %rax

movq    %rbx,  %r8
shrd    $32, %r10, %rbx
shrd    $32, %r11, %r10
shrd    $32, %r12, %r11
shrd    $32, %r15, %r12
shrd    $32, %rdi, %r15
shrd    $32, %rsi, %rdi
shrd    $32, %r8,  %rsi

addq    592(%rsp), %rbx
adcq    %r10, %r9
adcq    %r11, %rcx
adcq    %r12, %rdx
adcq    %r15, %rbp
adcq    %rdi, %r13
adcq    %rsi, %r14
adcq    $0,  %rax

movq    %rax, %r12
shlq    $32, %r12

xorq    %r10,%r10
addq    %rax, %rbx
adcq    $0, %r9
adcq    $0, %rcx
adcq    %r12, %rdx
adcq    $0, %rbp
adcq    $0, %r13
adcq    $0, %r14
adcq    $0, %r10

movq    %r10, %r15
shlq    $32, %r15

addq    %r10, %rbx
adcq    $0, %r9
adcq    $0, %rcx
adcq    %r15, %rdx

// update X2
movq    %rbx, 128(%rsp) 
movq    %r9,  136(%rsp)
movq    %rcx, 144(%rsp)
movq    %rdx, 152(%rsp)
movq    %rbp, 160(%rsp)
movq    %r13, 168(%rsp)
movq    %r14, 176(%rsp)

// Z2 ← T3 · T4
xorq    %rdi, %rdi
movq    536(%rsp), %rdx    

mulx    480(%rsp), %r8, %r9
mulx    488(%rsp), %rcx, %r10		
adcx    %rcx, %r9

mulx    496(%rsp), %rcx, %r11	
adcx    %rcx, %r10

mulx    504(%rsp), %rcx, %r12	
adcx    %rcx, %r11

mulx    512(%rsp), %rcx, %r13	
adcx    %rcx, %r12

mulx    520(%rsp), %rcx, %r14	
adcx    %rcx, %r13

mulx    528(%rsp), %rcx, %r15	
adcx    %rcx, %r14
adcx    %rdi, %r15

xorq    %rdi, %rdi
movq    544(%rsp), %rdx
   
mulx    480(%rsp), %rcx, %rbp
adcx    %rcx, %r9
adox    %rbp, %r10
    
mulx    488(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    496(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12

mulx    504(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    512(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    520(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15
    
mulx    528(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi			
adcq    $0, %rdi

xorq    %rsi, %rsi
movq    552(%rsp), %rdx
    
mulx    480(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    488(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    496(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    504(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    512(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    520(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi
    
mulx    528(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi
adcq    $0, %rsi

movq    %r10, 592(%rsp)

xorq    %rbx, %rbx
movq    560(%rsp), %rdx
    
mulx    480(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    488(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
    
mulx    496(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    504(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    512(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi

mulx    520(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi
    
mulx    528(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx			
adcq    $0, %rbx

movq    %r11, 600(%rsp)

xorq    %r10, %r10
movq    568(%rsp), %rdx
    
mulx    480(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
    
mulx    488(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14
    
mulx    496(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    504(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi

mulx    512(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    520(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx
    
mulx    528(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10			
adcq    $0, %r10

movq    %r12, 608(%rsp)

xorq    %r11, %r11
movq    576(%rsp), %rdx
    
mulx    480(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14
    
mulx    488(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15
    
mulx    496(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi

mulx    504(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    512(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    520(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10
    
mulx    528(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11			
adcq    $0, %r11

xorq    %r12, %r12
movq    584(%rsp), %rdx
    
mulx    480(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15
    
mulx    488(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi
    
mulx    496(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    504(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    512(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    520(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    528(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12			
adcq    $0, %r12

movq    592(%rsp), %rcx
movq    600(%rsp), %rdx
movq    608(%rsp), %rbp

xorq    %rax, %rax
addq    %r15, %r8
adcq    %rdi, %r9
adcq    %rsi, %rcx
adcq    %rbx, %rdx
adcq    %r10, %rbp
adcq    %r11, %r13
adcq    %r12, %r14
adcq    %rax, %rax

movq    %r8, 592(%rsp)

movq    %rbx, %r8
andq    mask32h, %r8

addq    %r8,  %rdx
adcq    %r10, %rbp
adcq    %r11, %r13
adcq    %r12, %r14
adcq    $0, %rax

movq    %rbx,  %r8
shrd    $32, %r10, %rbx
shrd    $32, %r11, %r10
shrd    $32, %r12, %r11
shrd    $32, %r15, %r12
shrd    $32, %rdi, %r15
shrd    $32, %rsi, %rdi
shrd    $32, %r8,  %rsi

addq    592(%rsp), %rbx
adcq    %r10, %r9
adcq    %r11, %rcx
adcq    %r12, %rdx
adcq    %r15, %rbp
adcq    %rdi, %r13
adcq    %rsi, %r14
adcq    $0,  %rax

movq    %rax, %r12
shlq    $32, %r12

xorq    %r10,%r10
addq    %rax, %rbx
adcq    $0, %r9
adcq    $0, %rcx
adcq    %r12, %rdx
adcq    $0, %rbp
adcq    $0, %r13
adcq    $0, %r14
adcq    $0, %r10

movq    %r10, %r15
shlq    $32, %r15

addq    %r10, %rbx
adcq    $0, %r9
adcq    $0, %rcx
adcq    %r15, %rdx

// update Z2
movq    %rbx, 184(%rsp) 
movq    %r9,  192(%rsp)
movq    %rcx, 200(%rsp)
movq    %rdx, 208(%rsp)
movq    %rbp, 216(%rsp)
movq    %r13, 224(%rsp)
movq    %r14, 232(%rsp)

// Z3 ← Z3 · X1
xorq    %rdi, %rdi
movq    296(%rsp), %rdx    

mulx    72(%rsp), %r8, %r9
mulx    80(%rsp), %rcx, %r10		
adcx    %rcx, %r9

mulx    88(%rsp), %rcx, %r11	
adcx    %rcx, %r10

mulx    96(%rsp), %rcx, %r12	
adcx    %rcx, %r11

mulx    104(%rsp), %rcx, %r13	
adcx    %rcx, %r12

mulx    112(%rsp), %rcx, %r14	
adcx    %rcx, %r13

mulx    120(%rsp), %rcx, %r15	
adcx    %rcx, %r14
adcx    %rdi, %r15

xorq    %rdi, %rdi
movq    304(%rsp), %rdx
   
mulx    72(%rsp), %rcx, %rbp
adcx    %rcx, %r9
adox    %rbp, %r10
    
mulx    80(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    88(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12

mulx    96(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    104(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    112(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15
    
mulx    120(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi			
adcq    $0, %rdi

xorq    %rsi, %rsi
movq    312(%rsp), %rdx
    
mulx    72(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    80(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    88(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    96(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    104(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    112(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi
    
mulx    120(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi
adcq    $0, %rsi

movq    %r10, 592(%rsp)

xorq    %rbx, %rbx
movq    320(%rsp), %rdx
    
mulx    72(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    80(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
    
mulx    88(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    96(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    104(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi

mulx    112(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi
    
mulx    120(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx			
adcq    $0, %rbx

movq    %r11, 600(%rsp)

xorq    %r10, %r10
movq    328(%rsp), %rdx
    
mulx    72(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
    
mulx    80(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14
    
mulx    88(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    96(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi

mulx    104(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    112(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx
    
mulx    120(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10			
adcq    $0, %r10

movq    %r12, 608(%rsp)

xorq    %r11, %r11
movq    336(%rsp), %rdx
    
mulx    72(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14
    
mulx    80(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15
    
mulx    88(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi

mulx    96(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    104(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    112(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10
    
mulx    120(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11			
adcq    $0, %r11

xorq    %r12, %r12
movq    344(%rsp), %rdx
    
mulx    72(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15
    
mulx    80(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi
    
mulx    88(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    96(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    104(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    112(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    120(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12			
adcq    $0, %r12

movq    592(%rsp), %rcx
movq    600(%rsp), %rdx
movq    608(%rsp), %rbp

xorq    %rax, %rax
addq    %r15, %r8
adcq    %rdi, %r9
adcq    %rsi, %rcx
adcq    %rbx, %rdx
adcq    %r10, %rbp
adcq    %r11, %r13
adcq    %r12, %r14
adcq    %rax, %rax

movq    %r8, 592(%rsp)

movq    %rbx, %r8
andq    mask32h, %r8

addq    %r8,  %rdx
adcq    %r10, %rbp
adcq    %r11, %r13
adcq    %r12, %r14
adcq    $0, %rax

movq    %rbx,  %r8
shrd    $32, %r10, %rbx
shrd    $32, %r11, %r10
shrd    $32, %r12, %r11
shrd    $32, %r15, %r12
shrd    $32, %rdi, %r15
shrd    $32, %rsi, %rdi
shrd    $32, %r8,  %rsi

addq    592(%rsp), %rbx
adcq    %r10, %r9
adcq    %r11, %rcx
adcq    %r12, %rdx
adcq    %r15, %rbp
adcq    %rdi, %r13
adcq    %rsi, %r14
adcq    $0,  %rax

movq    %rax, %r12
shlq    $32, %r12

xorq    %r10,%r10
addq    %rax, %rbx
adcq    $0, %r9
adcq    $0, %rcx
adcq    %r12, %rdx
adcq    $0, %rbp
adcq    $0, %r13
adcq    $0, %r14
adcq    $0, %r10

movq    %r10, %r15
shlq    $32, %r15

addq    %r10, %rbx
adcq    $0, %r9
adcq    $0, %rcx
adcq    %r15, %rdx

// update Z3
movq    %rbx, 296(%rsp) 
movq    %r9,  304(%rsp)
movq    %rcx, 312(%rsp)
movq    %rdx, 320(%rsp)
movq    %rbp, 328(%rsp)
movq    %r13, 336(%rsp)
movq    %r14, 344(%rsp)

movb    352(%rsp), %cl
subb    $1, %cl
movb    %cl, 352(%rsp)
cmpb	$0, %cl
jge     .L2

movb    $7, 352(%rsp)
movq    64(%rsp), %rax
movq    360(%rsp), %r15
subq    $1, %r15
movq    %r15, 360(%rsp)
cmpq	$0, %r15
jge     .L1

movq    56(%rsp), %rdi

movq    128(%rsp),  %r8 
movq    136(%rsp),  %r9
movq    144(%rsp), %r10
movq    152(%rsp), %r11
movq    160(%rsp), %r12
movq    168(%rsp), %r13
movq    176(%rsp), %r14

// store final value of X2
movq    %r8,   0(%rdi) 
movq    %r9,   8(%rdi)
movq    %r10, 16(%rdi)
movq    %r11, 24(%rdi)
movq    %r12, 32(%rdi)
movq    %r13, 40(%rdi)
movq    %r14, 48(%rdi)

movq    184(%rsp),  %r8 
movq    192(%rsp),  %r9
movq    200(%rsp), %r10
movq    208(%rsp), %r11
movq    216(%rsp), %r12
movq    224(%rsp), %r13
movq    232(%rsp), %r14

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
