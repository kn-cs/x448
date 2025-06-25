/*
+-----------------------------------------------------------------------------+
| This code corresponds to the the paper "Reduction Modulo 2^{448}-2^{224}-1" |
| authored by	      							      |
| Kaushik Nath,  Indian Statistical Institute, Kolkata, India, and            |
| Palash Sarkar, Indian Statistical Institute, Kolkata, India.	              |
+-----------------------------------------------------------------------------+
| Copyright (c) 2020, Kaushik Nath.                                           |
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
	.globl curve448_mladder_base
	
curve448_mladder_base:

	movq 	%rsp,%r11
	andq    $-32,%rsp	
	subq 	$592,%rsp

	movq 	%r11,0(%rsp)
	movq 	%r12,8(%rsp)
	movq 	%r13,16(%rsp)
	movq 	%r14,24(%rsp)
	movq 	%r15,32(%rsp)
	movq 	%rbx,40(%rsp)
	movq 	%rbp,48(%rsp)
	movq 	%rdi,56(%rsp)

	// X2 ← 1
	movq	$1,72(%rsp)
	movq	$0,80(%rsp)
	movq	$0,88(%rsp)
	movq	$0,96(%rsp)
	movq	$0,104(%rsp)
	movq	$0,112(%rsp)
	movq	$0,120(%rsp)  

	// Z2 ← 0
	movq	$0,128(%rsp)
	movq	$0,136(%rsp)
	movq	$0,144(%rsp)
	movq	$0,152(%rsp)
	movq	$0,160(%rsp)
	movq	$0,168(%rsp)
	movq	$0,176(%rsp)  

	// X3 ← XP
	movq	0(%rsi),%r8
	movq	%r8,184(%rsp)
	movq	8(%rsi),%r8
	movq	%r8,192(%rsp)
	movq	16(%rsi),%r8
	movq	%r8,200(%rsp)
	movq	24(%rsi),%r8
	movq	%r8,208(%rsp)
	movq	32(%rsi),%r8
	movq	%r8,216(%rsp)
	movq	40(%rsi),%r8
	movq	%r8,224(%rsp)
	movq	48(%rsi),%r8
	movq	%r8,232(%rsp)

	// Z3 ← 1
	movq	$1,240(%rsp)
	movq	$0,248(%rsp)
	movq	$0,256(%rsp)
	movq	$0,264(%rsp)
	movq	$0,272(%rsp)
	movq	$0,280(%rsp)
	movq	$0,288(%rsp) 

	movq    $55,304(%rsp)
	movb	$7,296(%rsp)
	movb    $0,298(%rsp)
	movq    %rdx,64(%rsp)

	movq    %rdx,%rax

	// Montgomery ladder loop

.L1:

	addq    304(%rsp),%rax
	movb    0(%rax),%r14b
	movb    %r14b,300(%rsp)

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
	 * T3 ← X3 + Z3
	 * Z3 ← X3 - Z3
	 * Z3 ← Z3^2
	 * X3 ← T3^2
	 * T3 ← T1 - T2
	 * T4 ← ((A + 2)/4) · T3
	 * T4 ← T4 + T2
	 * X2 ← T1 · T2
	 * Z2 ← T3 · T4
	 * Z3 ← Z3 · X1
	 *
	 */

	// X2
	movq    72(%rsp),%r8
	movq    80(%rsp),%r9
	movq    88(%rsp),%r10
	movq    96(%rsp),%r11
	movq    104(%rsp),%r12
	movq    112(%rsp),%r13
	movq    120(%rsp),%r14

	// copy X2
	movq    %r8,%rax
	movq    %r9,%rbx
	movq    %r10,%rbp
	movq    %r11,%rsi
	movq    %r12,%rdi
	movq    %r13,%rdx

	// T1 ← X2 + Z2
	addq    128(%rsp),%r8
	adcq    136(%rsp),%r9
	adcq    144(%rsp),%r10
	adcq    152(%rsp),%r11
	adcq    160(%rsp),%r12
	adcq    168(%rsp),%r13
	adcq    176(%rsp),%r14
	movq    $0,%rcx
	adcq    $0,%rcx

	movq    %rcx,%r15
	shlq    $32,%r15

	addq    %rcx,%r8
	adcq    $0,%r9
	adcq    $0,%r10
	adcq    %r15,%r11
	adcq    $0,%r12
	adcq    $0,%r13
	adcq    $0,%r14
	movq    $0,%rcx
	adcq    $0,%rcx

	movq    %rcx,%r15
	shlq    $32,%r15

	addq    %rcx,%r8
	adcq    $0,%r9
	adcq    $0,%r10
	adcq    %r15,%r11

	movq    %r8,312(%rsp)
	movq    %r9,320(%rsp)
	movq    %r10,328(%rsp)
	movq    %r11,336(%rsp)
	movq    %r12,344(%rsp)
	movq    %r13,352(%rsp)
	movq    %r14,360(%rsp)

	movq    120(%rsp),%r8

	// T2 ← X2 - Z2
	subq    128(%rsp),%rax
	sbbq    136(%rsp),%rbx
	sbbq    144(%rsp),%rbp
	sbbq    152(%rsp),%rsi
	sbbq    160(%rsp),%rdi
	sbbq    168(%rsp),%rdx
	sbbq    176(%rsp),%r8
	movq    $0,%rcx
	adcq    $0,%rcx

	movq    %rcx,%r15
	shlq    $32,%r15

	subq    %rcx,%rax
	sbbq    $0,%rbx
	sbbq    $0,%rbp
	sbbq    %r15,%rsi
	sbbq    $0,%rdi
	sbbq    $0,%rdx
	sbbq    $0,%r8
	movq    $0,%rcx
	adcq    $0,%rcx

	movq    %rcx,%r15
	shlq    $32,%r15

	subq    %rcx,%rax
	sbbq    $0,%rbx
	sbbq    $0,%rbp
	sbbq    %r15,%rsi

	movq    %rax,368(%rsp)
	movq    %rbx,376(%rsp)
	movq    %rbp,384(%rsp)
	movq    %rsi,392(%rsp)
	movq    %rdi,400(%rsp)
	movq    %rdx,408(%rsp)
	movq    %r8,416(%rsp)

	// X3
	movq    184(%rsp),%r8
	movq    192(%rsp),%r9
	movq    200(%rsp),%r10
	movq    208(%rsp),%r11
	movq    216(%rsp),%r12
	movq    224(%rsp),%r13
	movq    232(%rsp),%r14

	// copy X3
	movq    %r8,%rax
	movq    %r9,%rbx
	movq    %r10,%rbp
	movq    %r11,%rsi
	movq    %r12,%rdi
	movq    %r13,%rdx

	// T3 ← X3 + Z3
	addq    240(%rsp),%r8
	adcq    248(%rsp),%r9
	adcq    256(%rsp),%r10
	adcq    264(%rsp),%r11
	adcq    272(%rsp),%r12
	adcq    280(%rsp),%r13
	adcq    288(%rsp),%r14
	movq    $0,%rcx
	adcq    $0,%rcx

	movq    %rcx,%r15
	shlq    $32,%r15

	addq    %rcx,%r8
	adcq    $0,%r9
	adcq    $0,%r10
	adcq    %r15,%r11
	adcq    $0,%r12
	adcq    $0,%r13
	adcq    $0,%r14
	movq    $0,%rcx
	adcq    $0,%rcx

	movq    %rcx,%r15
	shlq    $32,%r15

	addq    %rcx,%r8
	adcq    $0,%r9
	adcq    $0,%r10
	adcq    %r15,%r11

	movq    %r8,424(%rsp)
	movq    %r9,432(%rsp)
	movq    %r10,440(%rsp)
	movq    %r11,448(%rsp)
	movq    %r12,456(%rsp)
	movq    %r13,464(%rsp)
	movq    %r14,472(%rsp)

	movq    232(%rsp),%r8

	// T4 ← X3 - Z3
	subq    240(%rsp),%rax
	sbbq    248(%rsp),%rbx
	sbbq    256(%rsp),%rbp
	sbbq    264(%rsp),%rsi
	sbbq    272(%rsp),%rdi
	sbbq    280(%rsp),%rdx
	sbbq    288(%rsp),%r8
	movq    $0,%rcx
	adcq    $0,%rcx

	movq    %rcx,%r15
	shlq    $32,%r15

	subq    %rcx,%rax
	sbbq    $0,%rbx
	sbbq    $0,%rbp
	sbbq    %r15,%rsi
	sbbq    $0,%rdi
	sbbq    $0,%rdx
	sbbq    $0,%r8
	movq    $0,%rcx
	adcq    $0,%rcx

	movq    %rcx,%r15
	shlq    $32,%r15

	subq    %rcx,%rax
	sbbq    $0,%rbx
	sbbq    $0,%rbp
	sbbq    %r15,%rsi

	movq    %rax,480(%rsp)
	movq    %rbx,488(%rsp)
	movq    %rbp,496(%rsp)
	movq    %rsi,504(%rsp)
	movq    %rdi,512(%rsp)
	movq    %rdx,520(%rsp)
	movq    %r8,528(%rsp)

	// Z3 ← T2 · T3
	movq    368(%rsp),%rdx    

	mulx    424(%rsp),%r8,%r9
	mulx    432(%rsp),%rcx,%r10
	addq    %rcx,%r9

	mulx    440(%rsp),%rcx,%r11
	adcq    %rcx,%r10

	mulx    448(%rsp),%rcx,%r12
	adcq    %rcx,%r11

	mulx    456(%rsp),%rcx,%r13
	adcq    %rcx,%r12

	mulx    464(%rsp),%rcx,%r14
	adcq    %rcx,%r13

	mulx    472(%rsp),%rcx,%r15
	adcq    %rcx,%r14
	adcq    $0,%r15

	movq    %r8,536(%rsp)
	movq    %r9,544(%rsp)

	movq    376(%rsp),%rdx

	mulx    424(%rsp),%r8,%r9
	mulx    432(%rsp),%rcx,%rax
	addq    %rcx,%r9

	mulx    440(%rsp),%rcx,%rbx
	adcq    %rcx,%rax

	mulx    448(%rsp),%rcx,%rbp
	adcq    %rcx,%rbx

	mulx    456(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    464(%rsp),%rcx,%rdi
	adcq    %rcx,%rsi

	mulx    472(%rsp),%rdx,%rcx
	adcq    %rdx,%rdi
	adcq    $0,%rcx

	addq    544(%rsp),%r8
	adcq    %r10,%r9
	adcq    %rax,%r11
	adcq    %rbx,%r12
	adcq    %rbp,%r13
	adcq    %rsi,%r14
	adcq    %rdi,%r15
	adcq    $0,%rcx

	movq    %r8,544(%rsp)
	movq    %r9,552(%rsp)

	movq    384(%rsp),%rdx

	mulx    424(%rsp),%r8,%r9
	mulx    432(%rsp),%r10,%rax
	addq    %r10,%r9

	mulx    440(%rsp),%r10,%rbx
	adcq    %r10,%rax

	mulx    448(%rsp),%r10,%rbp
	adcq    %r10,%rbx

	mulx    456(%rsp),%r10,%rsi
	adcq    %r10,%rbp

	mulx    464(%rsp),%r10,%rdi
	adcq    %r10,%rsi

	mulx    472(%rsp),%rdx,%r10
	adcq    %rdx,%rdi
	adcq    $0,%r10

	addq    552(%rsp),%r8
	adcq    %r11,%r9
	adcq    %rax,%r12
	adcq    %rbx,%r13
	adcq    %rbp,%r14
	adcq    %rsi,%r15
	adcq    %rdi,%rcx
	adcq    $0,%r10

	movq    %r8,552(%rsp)
	movq    %r9,560(%rsp)

	movq    392(%rsp),%rdx

	mulx    424(%rsp),%r8,%r9
	mulx    432(%rsp),%r11,%rax
	addq    %r11,%r9

	mulx    440(%rsp),%r11,%rbx
	adcq    %r11,%rax

	mulx    448(%rsp),%r11,%rbp
	adcq    %r11,%rbx

	mulx    456(%rsp),%r11,%rsi
	adcq    %r11,%rbp

	mulx    464(%rsp),%r11,%rdi
	adcq    %r11,%rsi

	mulx    472(%rsp),%rdx,%r11
	adcq    %rdx,%rdi
	adcq    $0,%r11

	addq    560(%rsp),%r8
	adcq    %r12,%r9
	adcq    %rax,%r13
	adcq    %rbx,%r14
	adcq    %rbp,%r15
	adcq    %rsi,%rcx
	adcq    %rdi,%r10
	adcq    $0,%r11

	movq    %r8,560(%rsp)
	movq    %r9,568(%rsp)

	movq    400(%rsp),%rdx

	mulx    424(%rsp),%r8,%r9
	mulx    432(%rsp),%r12,%rax
	addq    %r12,%r9

	mulx    440(%rsp),%r12,%rbx
	adcq    %r12,%rax

	mulx    448(%rsp),%r12,%rbp
	adcq    %r12,%rbx

	mulx    456(%rsp),%r12,%rsi
	adcq    %r12,%rbp

	mulx    464(%rsp),%r12,%rdi
	adcq    %r12,%rsi

	mulx    472(%rsp),%rdx,%r12
	adcq    %rdx,%rdi
	adcq    $0,%r12

	addq    568(%rsp),%r8
	adcq    %r13,%r9
	adcq    %rax,%r14
	adcq    %rbx,%r15
	adcq    %rbp,%rcx
	adcq    %rsi,%r10
	adcq    %rdi,%r11
	adcq    $0,%r12

	movq    %r8,568(%rsp)
	movq    %r9,576(%rsp)

	movq    408(%rsp),%rdx

	mulx    424(%rsp),%r8,%r9
	mulx    432(%rsp),%r13,%rax
	addq    %r13,%r9

	mulx    440(%rsp),%r13,%rbx
	adcq    %r13,%rax

	mulx    448(%rsp),%r13,%rbp
	adcq    %r13,%rbx

	mulx    456(%rsp),%r13,%rsi
	adcq    %r13,%rbp

	mulx    464(%rsp),%r13,%rdi
	adcq    %r13,%rsi

	mulx    472(%rsp),%rdx,%r13
	adcq    %rdx,%rdi
	adcq    $0,%r13

	addq    576(%rsp),%r8
	adcq    %r14,%r9
	adcq    %rax,%r15
	adcq    %rbx,%rcx
	adcq    %rbp,%r10
	adcq    %rsi,%r11
	adcq    %rdi,%r12
	adcq    $0,%r13

	movq    %r8,576(%rsp)
	movq    %r9,584(%rsp)

	movq    416(%rsp),%rdx

	mulx    424(%rsp),%r8,%r9
	mulx    432(%rsp),%r14,%rax
	addq    %r14,%r9

	mulx    440(%rsp),%r14,%rbx
	adcq    %r14,%rax

	mulx    448(%rsp),%r14,%rbp
	adcq    %r14,%rbx

	mulx    456(%rsp),%r14,%rsi
	adcq    %r14,%rbp

	mulx    464(%rsp),%r14,%rdi
	adcq    %r14,%rsi

	mulx    472(%rsp),%rdx,%r14
	adcq    %rdx,%rdi
	adcq    $0,%r14

	addq    584(%rsp),%r8
	adcq    %r15,%r9
	adcq    %rax,%rcx
	adcq    %rbx,%r10
	adcq    %rbp,%r11
	adcq    %rsi,%r12
	adcq    %rdi,%r13
	adcq    $0,%r14

	movq    536(%rsp),%rax
	movq    544(%rsp),%rbx
	movq    552(%rsp),%r15
	movq    560(%rsp),%rdx
	movq    568(%rsp),%rbp
	movq    576(%rsp),%rsi
	  
	xorq    %rdi,%rdi
	addq    %r9,%rax
	adcq    %rcx,%rbx
	adcq    %r10,%r15
	adcq    %r11,%rdx
	adcq    %r12,%rbp
	adcq    %r13,%rsi
	adcq    %r14,%r8
	adcq    $0,%rdi
	  
	movq    %rax,536(%rsp)

	movq    %r11,%rax
	andq    mask32h(%rip),%rax

	addq    %rax,%rdx
	adcq    %r12,%rbp
	adcq    %r13,%rsi
	adcq    %r14,%r8
	adcq    $0,%rdi

	movq    %r11,%rax
	shrd    $32,%r12,%r11
	shrd    $32,%r13,%r12
	shrd    $32,%r14,%r13
	shrd    $32,%r9,%r14
	shrd    $32,%rcx,%r9
	shrd    $32,%r10,%rcx
	shrd    $32,%rax,%r10

	addq    536(%rsp),%r11
	adcq    %r12,%rbx
	adcq    %r13,%r15
	adcq    %r14,%rdx
	adcq    %r9,%rbp
	adcq    %rcx,%rsi
	adcq    %r10,%r8
	adcq    $0,%rdi

	movq    %rdi,%r13
	shlq    $32,%r13
	    
	xorq    %r14,%r14
	addq    %rdi,%r11
	adcq    $0,%rbx
	adcq    $0,%r15
	adcq    %r13,%rdx
	adcq    $0,%rbp
	adcq    $0,%rsi
	adcq    $0,%r8
	adcq    $0,%r14

	movq    %r14,%r13
	shlq    $32,%r13

	addq    %r14,%r11
	adcq    $0,%rbx
	adcq    $0,%r15
	adcq    %r13,%rdx

	movq    %r11,240(%rsp)
	movq    %rbx,248(%rsp)
	movq    %r15,256(%rsp)
	movq    %rdx,264(%rsp)
	movq    %rbp,272(%rsp)
	movq    %rsi,280(%rsp)
	movq    %r8,288(%rsp)

	// X3 ← T1 · T4
	movq    312(%rsp),%rdx    

	mulx    480(%rsp),%r8,%r9
	mulx    488(%rsp),%rcx,%r10
	addq    %rcx,%r9

	mulx    496(%rsp),%rcx,%r11
	adcq    %rcx,%r10

	mulx    504(%rsp),%rcx,%r12
	adcq    %rcx,%r11

	mulx    512(%rsp),%rcx,%r13
	adcq    %rcx,%r12

	mulx    520(%rsp),%rcx,%r14
	adcq    %rcx,%r13

	mulx    528(%rsp),%rcx,%r15
	adcq    %rcx,%r14
	adcq    $0,%r15

	movq    %r8,536(%rsp)
	movq    %r9,544(%rsp)

	movq    320(%rsp),%rdx

	mulx    480(%rsp),%r8,%r9
	mulx    488(%rsp),%rcx,%rax
	addq    %rcx,%r9

	mulx    496(%rsp),%rcx,%rbx
	adcq    %rcx,%rax

	mulx    504(%rsp),%rcx,%rbp
	adcq    %rcx,%rbx

	mulx    512(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    520(%rsp),%rcx,%rdi
	adcq    %rcx,%rsi

	mulx    528(%rsp),%rdx,%rcx
	adcq    %rdx,%rdi
	adcq    $0,%rcx

	addq    544(%rsp),%r8
	adcq    %r10,%r9
	adcq    %rax,%r11
	adcq    %rbx,%r12
	adcq    %rbp,%r13
	adcq    %rsi,%r14
	adcq    %rdi,%r15
	adcq    $0,%rcx

	movq    %r8,544(%rsp)
	movq    %r9,552(%rsp)

	movq    328(%rsp),%rdx

	mulx    480(%rsp),%r8,%r9
	mulx    488(%rsp),%r10,%rax
	addq    %r10,%r9

	mulx    496(%rsp),%r10,%rbx
	adcq    %r10,%rax

	mulx    504(%rsp),%r10,%rbp
	adcq    %r10,%rbx

	mulx    512(%rsp),%r10,%rsi
	adcq    %r10,%rbp

	mulx    520(%rsp),%r10,%rdi
	adcq    %r10,%rsi

	mulx    528(%rsp),%rdx,%r10
	adcq    %rdx,%rdi
	adcq    $0,%r10

	addq    552(%rsp),%r8
	adcq    %r11,%r9
	adcq    %rax,%r12
	adcq    %rbx,%r13
	adcq    %rbp,%r14
	adcq    %rsi,%r15
	adcq    %rdi,%rcx
	adcq    $0,%r10

	movq    %r8,552(%rsp)
	movq    %r9,560(%rsp)

	movq    336(%rsp),%rdx

	mulx    480(%rsp),%r8,%r9
	mulx    488(%rsp),%r11,%rax
	addq    %r11,%r9

	mulx    496(%rsp),%r11,%rbx
	adcq    %r11,%rax

	mulx    504(%rsp),%r11,%rbp
	adcq    %r11,%rbx

	mulx    512(%rsp),%r11,%rsi
	adcq    %r11,%rbp

	mulx    520(%rsp),%r11,%rdi
	adcq    %r11,%rsi

	mulx    528(%rsp),%rdx,%r11
	adcq    %rdx,%rdi
	adcq    $0,%r11

	addq    560(%rsp),%r8
	adcq    %r12,%r9
	adcq    %rax,%r13
	adcq    %rbx,%r14
	adcq    %rbp,%r15
	adcq    %rsi,%rcx
	adcq    %rdi,%r10
	adcq    $0,%r11

	movq    %r8,560(%rsp)
	movq    %r9,568(%rsp)

	movq    344(%rsp),%rdx

	mulx    480(%rsp),%r8,%r9
	mulx    488(%rsp),%r12,%rax
	addq    %r12,%r9

	mulx    496(%rsp),%r12,%rbx
	adcq    %r12,%rax

	mulx    504(%rsp),%r12,%rbp
	adcq    %r12,%rbx

	mulx    512(%rsp),%r12,%rsi
	adcq    %r12,%rbp

	mulx    520(%rsp),%r12,%rdi
	adcq    %r12,%rsi

	mulx    528(%rsp),%rdx,%r12
	adcq    %rdx,%rdi
	adcq    $0,%r12

	addq    568(%rsp),%r8
	adcq    %r13,%r9
	adcq    %rax,%r14
	adcq    %rbx,%r15
	adcq    %rbp,%rcx
	adcq    %rsi,%r10
	adcq    %rdi,%r11
	adcq    $0,%r12

	movq    %r8,568(%rsp)
	movq    %r9,576(%rsp)

	movq    352(%rsp),%rdx

	mulx    480(%rsp),%r8,%r9
	mulx    488(%rsp),%r13,%rax
	addq    %r13,%r9

	mulx    496(%rsp),%r13,%rbx
	adcq    %r13,%rax

	mulx    504(%rsp),%r13,%rbp
	adcq    %r13,%rbx

	mulx    512(%rsp),%r13,%rsi
	adcq    %r13,%rbp

	mulx    520(%rsp),%r13,%rdi
	adcq    %r13,%rsi

	mulx    528(%rsp),%rdx,%r13
	adcq    %rdx,%rdi
	adcq    $0,%r13

	addq    576(%rsp),%r8
	adcq    %r14,%r9
	adcq    %rax,%r15
	adcq    %rbx,%rcx
	adcq    %rbp,%r10
	adcq    %rsi,%r11
	adcq    %rdi,%r12
	adcq    $0,%r13

	movq    %r8,576(%rsp)
	movq    %r9,584(%rsp)

	movq    360(%rsp),%rdx

	mulx    480(%rsp),%r8,%r9
	mulx    488(%rsp),%r14,%rax
	addq    %r14,%r9

	mulx    496(%rsp),%r14,%rbx
	adcq    %r14,%rax

	mulx    504(%rsp),%r14,%rbp
	adcq    %r14,%rbx

	mulx    512(%rsp),%r14,%rsi
	adcq    %r14,%rbp

	mulx    520(%rsp),%r14,%rdi
	adcq    %r14,%rsi

	mulx    528(%rsp),%rdx,%r14
	adcq    %rdx,%rdi
	adcq    $0,%r14

	addq    584(%rsp),%r8
	adcq    %r15,%r9
	adcq    %rax,%rcx
	adcq    %rbx,%r10
	adcq    %rbp,%r11
	adcq    %rsi,%r12
	adcq    %rdi,%r13
	adcq    $0,%r14

	movq    536(%rsp),%rax
	movq    544(%rsp),%rbx
	movq    552(%rsp),%r15
	movq    560(%rsp),%rdx
	movq    568(%rsp),%rbp
	movq    576(%rsp),%rsi
	  
	xorq    %rdi,%rdi
	addq    %r9,%rax
	adcq    %rcx,%rbx
	adcq    %r10,%r15
	adcq    %r11,%rdx
	adcq    %r12,%rbp
	adcq    %r13,%rsi
	adcq    %r14,%r8
	adcq    $0,%rdi
	  
	movq    %rax,536(%rsp)

	movq    %r11,%rax
	andq    mask32h(%rip),%rax

	addq    %rax,%rdx
	adcq    %r12,%rbp
	adcq    %r13,%rsi
	adcq    %r14,%r8
	adcq    $0,%rdi

	movq    %r11,%rax
	shrd    $32,%r12,%r11
	shrd    $32,%r13,%r12
	shrd    $32,%r14,%r13
	shrd    $32,%r9,%r14
	shrd    $32,%rcx,%r9
	shrd    $32,%r10,%rcx
	shrd    $32,%rax,%r10

	addq    536(%rsp),%r11
	adcq    %r12,%rbx
	adcq    %r13,%r15
	adcq    %r14,%rdx
	adcq    %r9,%rbp
	adcq    %rcx,%rsi
	adcq    %r10,%r8
	adcq    $0,%rdi

	movq    %rdi,%r13
	shlq    $32,%r13
	    
	xorq    %r14,%r14
	addq    %rdi,%r11
	adcq    $0,%rbx
	adcq    $0,%r15
	adcq    %r13,%rdx
	adcq    $0,%rbp
	adcq    $0,%rsi
	adcq    $0,%r8
	adcq    $0,%r14

	movq    %r14,%r13
	shlq    $32,%r13

	addq    %r14,%r11
	adcq    $0,%rbx
	adcq    $0,%r15
	adcq    %r13,%rdx

	movq    %r11,184(%rsp)
	movq    %rbx,192(%rsp)
	movq    %r15,200(%rsp)
	movq    %rdx,208(%rsp)
	movq    %rbp,216(%rsp)
	movq    %rsi,224(%rsp)
	movq    %r8,232(%rsp)

	movb	296(%rsp),%cl
	movb	300(%rsp),%bl
	shrb    %cl,%bl
	andb    $1,%bl
	movb    %bl,%cl
	xorb    298(%rsp),%bl
	movb    %cl,298(%rsp)

	cmpb    $1,%bl

	// CSelect(T1,T3,swap)
	movq    312(%rsp),%r8
	movq    320(%rsp),%r9
	movq    328(%rsp),%r10
	movq    336(%rsp),%r11
	movq    344(%rsp),%r12
	movq    352(%rsp),%r13
	movq    360(%rsp),%r14

	movq    424(%rsp),%r15
	movq    432(%rsp),%rax
	movq    440(%rsp),%rbx
	movq    448(%rsp),%rcx
	movq    456(%rsp),%rdx
	movq    464(%rsp),%rbp
	movq    472(%rsp),%rsi

	cmove   %r15,%r8
	cmove   %rax,%r9
	cmove   %rbx,%r10
	cmove   %rcx,%r11
	cmove   %rdx,%r12
	cmove   %rbp,%r13
	cmove   %rsi,%r14

	movq    %r8,312(%rsp)
	movq    %r9,320(%rsp)
	movq    %r10,328(%rsp)
	movq    %r11,336(%rsp)
	movq    %r12,344(%rsp)
	movq    %r13,352(%rsp)
	movq    %r14,360(%rsp)

	// CSelect(T2,T4,swap)
	movq    368(%rsp),%r8
	movq    376(%rsp),%r9
	movq    384(%rsp),%r10
	movq    392(%rsp),%r11
	movq    400(%rsp),%r12
	movq    408(%rsp),%r13
	movq    416(%rsp),%r14

	movq    480(%rsp),%r15
	movq    488(%rsp),%rax
	movq    496(%rsp),%rbx
	movq    504(%rsp),%rcx
	movq    512(%rsp),%rdx
	movq    520(%rsp),%rbp
	movq    528(%rsp),%rsi

	cmove   %r15,%r8
	cmove   %rax,%r9
	cmove   %rbx,%r10
	cmove   %rcx,%r11
	cmove   %rdx,%r12
	cmove   %rbp,%r13
	cmove   %rsi,%r14

	movq    %r8,368(%rsp)
	movq    %r9,376(%rsp)
	movq    %r10,384(%rsp)
	movq    %r11,392(%rsp)
	movq    %r12,400(%rsp)
	movq    %r13,408(%rsp)
	movq    %r14,416(%rsp)

	// T2 ← T2^2
	movq    368(%rsp),%rdx
	    
	mulx    376(%rsp),%r9,%r10
	mulx    384(%rsp),%rcx,%r11
	addq    %rcx,%r10

	mulx    392(%rsp),%rcx,%r12
	adcq    %rcx,%r11

	mulx    400(%rsp),%rcx,%r13
	adcq    %rcx,%r12

	mulx    408(%rsp),%rcx,%r14
	adcq    %rcx,%r13

	mulx    416(%rsp),%rcx,%r15
	adcq    %rcx,%r14
	adcq    $0,%r15

	movq    376(%rsp),%rdx
	mulx    384(%rsp),%rax,%rbx

	mulx    392(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    400(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    408(%rsp),%rcx,%r8
	adcq    %rcx,%rsi

	mulx    416(%rsp),%rdx,%rcx
	adcq    %rdx,%r8
	adcq    $0,%rcx

	addq    %rax,%r11
	adcq    %rbx,%r12
	adcq    %rbp,%r13
	adcq    %rsi,%r14
	adcq    %r8,%r15
	adcq    $0,%rcx

	movq    384(%rsp),%rdx
	mulx    392(%rsp),%rax,%rbx

	mulx    400(%rsp),%r8,%rbp
	addq    %r8,%rbx

	mulx    408(%rsp),%r8,%rsi
	adcq    %r8,%rbp

	mulx    416(%rsp),%rdx,%r8
	adcq    %rdx,%rsi
	adcq    $0,%r8

	addq    %rax,%r13
	adcq    %rbx,%r14
	adcq    %rbp,%r15
	adcq    %rsi,%rcx
	adcq    $0,%r8

	movq    392(%rsp),%rdx
	mulx    400(%rsp),%rax,%rbx

	mulx    408(%rsp),%rsi,%rbp
	addq    %rsi,%rbx

	mulx    416(%rsp),%rdx,%rsi
	adcq    %rdx,%rbp
	adcq    $0,%rsi

	addq    %rax,%r15
	adcq    %rbx,%rcx
	adcq    %rbp,%r8
	adcq    $0,%rsi

	movq    400(%rsp),%rdx
	mulx    408(%rsp),%rax,%rbx

	mulx    416(%rsp),%rdx,%rbp
	addq    %rdx,%rbx
	adcq    $0,%rbp

	addq    %rax,%r8
	adcq    %rbx,%rsi
	adcq    $0,%rbp

	movq    408(%rsp),%rdx
	mulx    416(%rsp),%rax,%rbx

	addq    %rax,%rbp
	adcq    $0,%rbx

	movq    $0,%rax
	shld    $1,%rbx,%rax
	shld    $1,%rbp,%rbx
	shld    $1,%rsi,%rbp
	shld    $1,%r8,%rsi
	shld    $1,%rcx,%r8
	shld    $1,%r15,%rcx
	shld    $1,%r14,%r15
	shld    $1,%r13,%r14
	shld    $1,%r12,%r13
	shld    $1,%r11,%r12
	shld    $1,%r10,%r11
	shld    $1,%r9,%r10
	shlq    $1,%r9

	movq    %r9,536(%rsp)
	movq    %r10,544(%rsp)
	movq    %r11,552(%rsp)

	movq    368(%rsp),%rdx
	mulx    %rdx,%r11,%r10
	addq    536(%rsp),%r10
	movq    %r10,536(%rsp)

	movq    376(%rsp),%rdx
	mulx    %rdx,%r9,%r10
	adcq    544(%rsp),%r9
	adcq    552(%rsp),%r10
	movq    %r9,544(%rsp)
	movq    %r10,552(%rsp)

	movq    384(%rsp),%rdx
	mulx    %rdx,%r9,%r10
	adcq    %r9,%r12
	adcq    %r10,%r13

	movq    392(%rsp),%rdx
	mulx    %rdx,%r9,%r10
	adcq    %r9,%r14
	adcq    %r10,%r15

	movq    400(%rsp),%rdx
	mulx    %rdx,%r9,%r10
	adcq    %r9,%rcx
	adcq    %r10,%r8

	movq    408(%rsp),%rdx
	mulx    %rdx,%r9,%r10
	adcq    %r9,%rsi
	adcq    %r10,%rbp

	movq    416(%rsp),%rdx
	mulx    %rdx,%r9,%r10
	adcq    %r9,%rbx
	adcq    %r10,%rax

	movq    536(%rsp),%r9
	movq    544(%rsp),%rdx
	movq    552(%rsp),%r10

	xorq    %rdi,%rdi
	addq    %r15,%r11
	adcq    %rcx,%r9
	adcq    %r8,%rdx
	adcq    %rsi,%r10
	adcq    %rbp,%r12
	adcq    %rbx,%r13
	adcq    %rax,%r14
	adcq    $0,%rdi
	    
	movq    %r11,536(%rsp)

	movq    %rsi,%r11
	andq    mask32h(%rip),%r11

	addq    %r11,%r10
	adcq    %rbp,%r12
	adcq    %rbx,%r13
	adcq    %rax,%r14
	adcq    $0,%rdi

	movq    %rsi,%r11
	shrd    $32,%rbp,%rsi
	shrd    $32,%rbx,%rbp
	shrd    $32,%rax,%rbx
	shrd    $32,%r15,%rax
	shrd    $32,%rcx,%r15
	shrd    $32,%r8,%rcx
	shrd    $32,%r11,%r8

	addq    536(%rsp),%rsi
	adcq    %rbp,%r9
	adcq    %rbx,%rdx
	adcq    %rax,%r10
	adcq    %r15,%r12
	adcq    %rcx,%r13
	adcq    %r8,%r14
	adcq    $0,%rdi

	movq    %rdi,%rax
	shlq    $32,%rax
	    
	xorq    %rcx,%rcx
	addq    %rdi,%rsi
	adcq    $0,%r9
	adcq    $0,%rdx
	adcq    %rax,%r10
	adcq    $0,%r12
	adcq    $0,%r13
	adcq    $0,%r14
	adcq    $0,%rcx

	movq    %rcx,%rax
	shlq    $32,%rax

	addq    %rcx,%rsi
	adcq    $0,%r9
	adcq    $0,%rdx
	adcq    %rax,%r10

	movq    %rsi,368(%rsp)
	movq    %r9,376(%rsp)
	movq    %rdx,384(%rsp)
	movq    %r10,392(%rsp)
	movq    %r12,400(%rsp)
	movq    %r13,408(%rsp)
	movq    %r14,416(%rsp)

	// T1 ← T1^2
	movq    312(%rsp),%rdx
	    
	mulx    320(%rsp),%r9,%r10
	mulx    328(%rsp),%rcx,%r11
	addq    %rcx,%r10

	mulx    336(%rsp),%rcx,%r12
	adcq    %rcx,%r11

	mulx    344(%rsp),%rcx,%r13
	adcq    %rcx,%r12

	mulx    352(%rsp),%rcx,%r14
	adcq    %rcx,%r13

	mulx    360(%rsp),%rcx,%r15
	adcq    %rcx,%r14
	adcq    $0,%r15

	movq    320(%rsp),%rdx
	mulx    328(%rsp),%rax,%rbx

	mulx    336(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    344(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    352(%rsp),%rcx,%r8
	adcq    %rcx,%rsi

	mulx    360(%rsp),%rdx,%rcx
	adcq    %rdx,%r8
	adcq    $0,%rcx

	addq    %rax,%r11
	adcq    %rbx,%r12
	adcq    %rbp,%r13
	adcq    %rsi,%r14
	adcq    %r8,%r15
	adcq    $0,%rcx

	movq    328(%rsp),%rdx
	mulx    336(%rsp),%rax,%rbx

	mulx    344(%rsp),%r8,%rbp
	addq    %r8,%rbx

	mulx    352(%rsp),%r8,%rsi
	adcq    %r8,%rbp

	mulx    360(%rsp),%rdx,%r8
	adcq    %rdx,%rsi
	adcq    $0,%r8

	addq    %rax,%r13
	adcq    %rbx,%r14
	adcq    %rbp,%r15
	adcq    %rsi,%rcx
	adcq    $0,%r8

	movq    336(%rsp),%rdx
	mulx    344(%rsp),%rax,%rbx

	mulx    352(%rsp),%rsi,%rbp
	addq    %rsi,%rbx

	mulx    360(%rsp),%rdx,%rsi
	adcq    %rdx,%rbp
	adcq    $0,%rsi

	addq    %rax,%r15
	adcq    %rbx,%rcx
	adcq    %rbp,%r8
	adcq    $0,%rsi

	movq    344(%rsp),%rdx
	mulx    352(%rsp),%rax,%rbx

	mulx    360(%rsp),%rdx,%rbp
	addq    %rdx,%rbx
	adcq    $0,%rbp

	addq    %rax,%r8
	adcq    %rbx,%rsi
	adcq    $0,%rbp

	movq    352(%rsp),%rdx
	mulx    360(%rsp),%rax,%rbx

	addq    %rax,%rbp
	adcq    $0,%rbx

	movq    $0,%rax
	shld    $1,%rbx,%rax
	shld    $1,%rbp,%rbx
	shld    $1,%rsi,%rbp
	shld    $1,%r8,%rsi
	shld    $1,%rcx,%r8
	shld    $1,%r15,%rcx
	shld    $1,%r14,%r15
	shld    $1,%r13,%r14
	shld    $1,%r12,%r13
	shld    $1,%r11,%r12
	shld    $1,%r10,%r11
	shld    $1,%r9,%r10
	shlq    $1,%r9

	movq    %r9,536(%rsp)
	movq    %r10,544(%rsp)
	movq    %r11,552(%rsp)

	movq    312(%rsp),%rdx
	mulx    %rdx,%r11,%r10
	addq    536(%rsp),%r10
	movq    %r10,536(%rsp)

	movq    320(%rsp),%rdx
	mulx    %rdx,%r9,%r10
	adcq    544(%rsp),%r9
	adcq    552(%rsp),%r10
	movq    %r9,544(%rsp)
	movq    %r10,552(%rsp)

	movq    328(%rsp),%rdx
	mulx    %rdx,%r9,%r10
	adcq    %r9,%r12
	adcq    %r10,%r13

	movq    336(%rsp),%rdx
	mulx    %rdx,%r9,%r10
	adcq    %r9,%r14
	adcq    %r10,%r15

	movq    344(%rsp),%rdx
	mulx    %rdx,%r9,%r10
	adcq    %r9,%rcx
	adcq    %r10,%r8

	movq    352(%rsp),%rdx
	mulx    %rdx,%r9,%r10
	adcq    %r9,%rsi
	adcq    %r10,%rbp

	movq    360(%rsp),%rdx
	mulx    %rdx,%r9,%r10
	adcq    %r9,%rbx
	adcq    %r10,%rax

	movq    536(%rsp),%r9
	movq    544(%rsp),%rdx
	movq    552(%rsp),%r10

	xorq    %rdi,%rdi
	addq    %r15,%r11
	adcq    %rcx,%r9
	adcq    %r8,%rdx
	adcq    %rsi,%r10
	adcq    %rbp,%r12
	adcq    %rbx,%r13
	adcq    %rax,%r14
	adcq    $0,%rdi
	    
	movq    %r11,536(%rsp)

	movq    %rsi,%r11
	andq    mask32h(%rip),%r11

	addq    %r11,%r10
	adcq    %rbp,%r12
	adcq    %rbx,%r13
	adcq    %rax,%r14
	adcq    $0,%rdi

	movq    %rsi,%r11
	shrd    $32,%rbp,%rsi
	shrd    $32,%rbx,%rbp
	shrd    $32,%rax,%rbx
	shrd    $32,%r15,%rax
	shrd    $32,%rcx,%r15
	shrd    $32,%r8,%rcx
	shrd    $32,%r11,%r8

	addq    536(%rsp),%rsi
	adcq    %rbp,%r9
	adcq    %rbx,%rdx
	adcq    %rax,%r10
	adcq    %r15,%r12
	adcq    %rcx,%r13
	adcq    %r8,%r14
	adcq    $0,%rdi

	movq    %rdi,%rax
	shlq    $32,%rax
	    
	xorq    %rcx,%rcx
	addq    %rdi,%rsi
	adcq    $0,%r9
	adcq    $0,%rdx
	adcq    %rax,%r10
	adcq    $0,%r12
	adcq    $0,%r13
	adcq    $0,%r14
	adcq    $0,%rcx

	movq    %rcx,%rax
	shlq    $32,%rax

	addq    %rcx,%rsi
	adcq    $0,%r9
	adcq    $0,%rdx
	adcq    %rax,%r10

	movq    %rsi,312(%rsp)
	movq    %r9,320(%rsp)
	movq    %rdx,328(%rsp)
	movq    %r10,336(%rsp)
	movq    %r12,344(%rsp)
	movq    %r13,352(%rsp)
	movq    %r14,360(%rsp)

	// X3
	movq    184(%rsp),%r8
	movq    192(%rsp),%r9
	movq    200(%rsp),%r10
	movq    208(%rsp),%r11
	movq    216(%rsp),%r12
	movq    224(%rsp),%r13
	movq    232(%rsp),%r14

	// copy X3
	movq    %r8,%rax
	movq    %r9,%rbx
	movq    %r10,%rcx
	movq    %r11,%rdx
	movq    %r12,%rbp
	movq    %r13,%rsi

	// X3 ← X3 + Z3
	addq    240(%rsp),%r8
	adcq    248(%rsp),%r9
	adcq    256(%rsp),%r10
	adcq    264(%rsp),%r11
	adcq    272(%rsp),%r12
	adcq    280(%rsp),%r13
	adcq    288(%rsp),%r14
	movq    $0,%r15
	adcq    $0,%r15

	movq    %r15,%rdi
	shlq    $32,%rdi

	addq    %r15,%r8
	adcq    $0,%r9
	adcq    $0,%r10
	adcq    %rdi,%r11
	adcq    $0,%r12
	adcq    $0,%r13
	adcq    $0,%r14
	movq    $0,%r15
	adcq    $0,%r15

	movq    %r15,%rdi
	shlq    $32,%rdi

	addq    %r15,%r8
	adcq    $0,%r9
	adcq    $0,%r10
	adcq    %rdi,%r11

	movq    232(%rsp),%rdi

	movq    %r8,184(%rsp)
	movq    %r9,192(%rsp)
	movq    %r10,200(%rsp)
	movq    %r11,208(%rsp)
	movq    %r12,216(%rsp)
	movq    %r13,224(%rsp)
	movq    %r14,232(%rsp)

	// Z3 ← X3 - Z3
	subq    240(%rsp),%rax
	sbbq    248(%rsp),%rbx
	sbbq    256(%rsp),%rcx
	sbbq    264(%rsp),%rdx
	sbbq    272(%rsp),%rbp
	sbbq    280(%rsp),%rsi
	sbbq    288(%rsp),%rdi
	movq    $0,%r8
	adcq    $0,%r8

	movq    %r8,%r9
	shlq    $32,%r9

	subq    %r8,%rax
	sbbq    $0,%rbx
	sbbq    $0,%rcx
	sbbq    %r9,%rdx
	sbbq    $0,%rbp
	sbbq    $0,%rsi
	sbbq    $0,%rdi
	movq    $0,%r8
	adcq    $0,%r8

	movq    %r8,%r9
	shlq    $32,%r9

	subq    %r8,%rax
	sbbq    $0,%rbx
	sbbq    $0,%rcx
	sbbq    %r9,%rdx

	movq    %rax,240(%rsp)
	movq    %rbx,248(%rsp)
	movq    %rcx,256(%rsp)
	movq    %rdx,264(%rsp)
	movq    %rbp,272(%rsp)
	movq    %rsi,280(%rsp)
	movq    %rdi,288(%rsp)

	// Z3 ← Z3^2
	movq    240(%rsp),%rdx
	    
	mulx    248(%rsp),%r9,%r10
	mulx    256(%rsp),%rcx,%r11
	addq    %rcx,%r10

	mulx    264(%rsp),%rcx,%r12
	adcq    %rcx,%r11

	mulx    272(%rsp),%rcx,%r13
	adcq    %rcx,%r12

	mulx    280(%rsp),%rcx,%r14
	adcq    %rcx,%r13

	mulx    288(%rsp),%rcx,%r15
	adcq    %rcx,%r14
	adcq    $0,%r15

	movq    248(%rsp),%rdx
	mulx    256(%rsp),%rax,%rbx

	mulx    264(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    272(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    280(%rsp),%rcx,%r8
	adcq    %rcx,%rsi

	mulx    288(%rsp),%rdx,%rcx
	adcq    %rdx,%r8
	adcq    $0,%rcx

	addq    %rax,%r11
	adcq    %rbx,%r12
	adcq    %rbp,%r13
	adcq    %rsi,%r14
	adcq    %r8,%r15
	adcq    $0,%rcx

	movq    256(%rsp),%rdx
	mulx    264(%rsp),%rax,%rbx

	mulx    272(%rsp),%r8,%rbp
	addq    %r8,%rbx

	mulx    280(%rsp),%r8,%rsi
	adcq    %r8,%rbp

	mulx    288(%rsp),%rdx,%r8
	adcq    %rdx,%rsi
	adcq    $0,%r8

	addq    %rax,%r13
	adcq    %rbx,%r14
	adcq    %rbp,%r15
	adcq    %rsi,%rcx
	adcq    $0,%r8

	movq    264(%rsp),%rdx
	mulx    272(%rsp),%rax,%rbx

	mulx    280(%rsp),%rsi,%rbp
	addq    %rsi,%rbx

	mulx    288(%rsp),%rdx,%rsi
	adcq    %rdx,%rbp
	adcq    $0,%rsi

	addq    %rax,%r15
	adcq    %rbx,%rcx
	adcq    %rbp,%r8
	adcq    $0,%rsi

	movq    272(%rsp),%rdx
	mulx    280(%rsp),%rax,%rbx

	mulx    288(%rsp),%rdx,%rbp
	addq    %rdx,%rbx
	adcq    $0,%rbp

	addq    %rax,%r8
	adcq    %rbx,%rsi
	adcq    $0,%rbp

	movq    280(%rsp),%rdx
	mulx    288(%rsp),%rax,%rbx

	addq    %rax,%rbp
	adcq    $0,%rbx

	movq    $0,%rax
	shld    $1,%rbx,%rax
	shld    $1,%rbp,%rbx
	shld    $1,%rsi,%rbp
	shld    $1,%r8,%rsi
	shld    $1,%rcx,%r8
	shld    $1,%r15,%rcx
	shld    $1,%r14,%r15
	shld    $1,%r13,%r14
	shld    $1,%r12,%r13
	shld    $1,%r11,%r12
	shld    $1,%r10,%r11
	shld    $1,%r9,%r10
	shlq    $1,%r9

	movq    %r9,536(%rsp)
	movq    %r10,544(%rsp)
	movq    %r11,552(%rsp)

	movq    240(%rsp),%rdx
	mulx    %rdx,%r11,%r10
	addq    536(%rsp),%r10
	movq    %r10,536(%rsp)

	movq    248(%rsp),%rdx
	mulx    %rdx,%r9,%r10
	adcq    544(%rsp),%r9
	adcq    552(%rsp),%r10
	movq    %r9,544(%rsp)
	movq    %r10,552(%rsp)

	movq    256(%rsp),%rdx
	mulx    %rdx,%r9,%r10
	adcq    %r9,%r12
	adcq    %r10,%r13

	movq    264(%rsp),%rdx
	mulx    %rdx,%r9,%r10
	adcq    %r9,%r14
	adcq    %r10,%r15

	movq    272(%rsp),%rdx
	mulx    %rdx,%r9,%r10
	adcq    %r9,%rcx
	adcq    %r10,%r8

	movq    280(%rsp),%rdx
	mulx    %rdx,%r9,%r10
	adcq    %r9,%rsi
	adcq    %r10,%rbp

	movq    288(%rsp),%rdx
	mulx    %rdx,%r9,%r10
	adcq    %r9,%rbx
	adcq    %r10,%rax

	movq    536(%rsp),%r9
	movq    544(%rsp),%rdx
	movq    552(%rsp),%r10

	xorq    %rdi,%rdi
	addq    %r15,%r11
	adcq    %rcx,%r9
	adcq    %r8,%rdx
	adcq    %rsi,%r10
	adcq    %rbp,%r12
	adcq    %rbx,%r13
	adcq    %rax,%r14
	adcq    $0,%rdi
	    
	movq    %r11,536(%rsp)

	movq    %rsi,%r11
	andq    mask32h(%rip),%r11

	addq    %r11,%r10
	adcq    %rbp,%r12
	adcq    %rbx,%r13
	adcq    %rax,%r14
	adcq    $0,%rdi

	movq    %rsi,%r11
	shrd    $32,%rbp,%rsi
	shrd    $32,%rbx,%rbp
	shrd    $32,%rax,%rbx
	shrd    $32,%r15,%rax
	shrd    $32,%rcx,%r15
	shrd    $32,%r8,%rcx
	shrd    $32,%r11,%r8

	addq    536(%rsp),%rsi
	adcq    %rbp,%r9
	adcq    %rbx,%rdx
	adcq    %rax,%r10
	adcq    %r15,%r12
	adcq    %rcx,%r13
	adcq    %r8,%r14
	adcq    $0,%rdi

	movq    %rdi,%rax
	shlq    $32,%rax
	    
	xorq    %rcx,%rcx
	addq    %rdi,%rsi
	adcq    $0,%r9
	adcq    $0,%rdx
	adcq    %rax,%r10
	adcq    $0,%r12
	adcq    $0,%r13
	adcq    $0,%r14
	adcq    $0,%rcx

	movq    %rcx,%rax
	shlq    $32,%rax

	addq    %rcx,%rsi
	adcq    $0,%r9
	adcq    $0,%rdx
	adcq    %rax,%r10

	movq    %rsi,240(%rsp) 
	movq    %r9,248(%rsp)
	movq    %rdx,256(%rsp)
	movq    %r10,264(%rsp)
	movq    %r12,272(%rsp)
	movq    %r13,280(%rsp)
	movq    %r14,288(%rsp)

	// X3 ← X3^2
	movq    184(%rsp),%rdx
	    
	mulx    192(%rsp),%r9,%r10
	mulx    200(%rsp),%rcx,%r11
	addq    %rcx,%r10

	mulx    208(%rsp),%rcx,%r12
	adcq    %rcx,%r11

	mulx    216(%rsp),%rcx,%r13
	adcq    %rcx,%r12

	mulx    224(%rsp),%rcx,%r14
	adcq    %rcx,%r13

	mulx    232(%rsp),%rcx,%r15
	adcq    %rcx,%r14
	adcq    $0,%r15

	movq    192(%rsp),%rdx
	mulx    200(%rsp),%rax,%rbx

	mulx    208(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    216(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    224(%rsp),%rcx,%r8
	adcq    %rcx,%rsi

	mulx    232(%rsp),%rdx,%rcx
	adcq    %rdx,%r8
	adcq    $0,%rcx

	addq    %rax,%r11
	adcq    %rbx,%r12
	adcq    %rbp,%r13
	adcq    %rsi,%r14
	adcq    %r8,%r15
	adcq    $0,%rcx

	movq    200(%rsp),%rdx
	mulx    208(%rsp),%rax,%rbx

	mulx    216(%rsp),%r8,%rbp
	addq    %r8,%rbx

	mulx    224(%rsp),%r8,%rsi
	adcq    %r8,%rbp

	mulx    232(%rsp),%rdx,%r8
	adcq    %rdx,%rsi
	adcq    $0,%r8

	addq    %rax,%r13
	adcq    %rbx,%r14
	adcq    %rbp,%r15
	adcq    %rsi,%rcx
	adcq    $0,%r8

	movq    208(%rsp),%rdx
	mulx    216(%rsp),%rax,%rbx

	mulx    224(%rsp),%rsi,%rbp
	addq    %rsi,%rbx

	mulx    232(%rsp),%rdx,%rsi
	adcq    %rdx,%rbp
	adcq    $0,%rsi

	addq    %rax,%r15
	adcq    %rbx,%rcx
	adcq    %rbp,%r8
	adcq    $0,%rsi

	movq    216(%rsp),%rdx
	mulx    224(%rsp),%rax,%rbx

	mulx    232(%rsp),%rdx,%rbp
	addq    %rdx,%rbx
	adcq    $0,%rbp

	addq    %rax,%r8
	adcq    %rbx,%rsi
	adcq    $0,%rbp

	movq    224(%rsp),%rdx
	mulx    232(%rsp),%rax,%rbx

	addq    %rax,%rbp
	adcq    $0,%rbx

	movq    $0,%rax
	shld    $1,%rbx,%rax
	shld    $1,%rbp,%rbx
	shld    $1,%rsi,%rbp
	shld    $1,%r8,%rsi
	shld    $1,%rcx,%r8
	shld    $1,%r15,%rcx
	shld    $1,%r14,%r15
	shld    $1,%r13,%r14
	shld    $1,%r12,%r13
	shld    $1,%r11,%r12
	shld    $1,%r10,%r11
	shld    $1,%r9,%r10
	shlq    $1,%r9

	movq    %r9,536(%rsp)
	movq    %r10,544(%rsp)
	movq    %r11,552(%rsp)

	movq    184(%rsp),%rdx
	mulx    %rdx,%r11,%r10
	addq    536(%rsp),%r10
	movq    %r10,536(%rsp)

	movq    192(%rsp),%rdx
	mulx    %rdx,%r9,%r10
	adcq    544(%rsp),%r9
	adcq    552(%rsp),%r10
	movq    %r9,544(%rsp)
	movq    %r10,552(%rsp)

	movq    200(%rsp),%rdx
	mulx    %rdx,%r9,%r10
	adcq    %r9,%r12
	adcq    %r10,%r13

	movq    208(%rsp),%rdx
	mulx    %rdx,%r9,%r10
	adcq    %r9,%r14
	adcq    %r10,%r15

	movq    216(%rsp),%rdx
	mulx    %rdx,%r9,%r10
	adcq    %r9,%rcx
	adcq    %r10,%r8

	movq    224(%rsp),%rdx
	mulx    %rdx,%r9,%r10
	adcq    %r9,%rsi
	adcq    %r10,%rbp

	movq    232(%rsp),%rdx
	mulx    %rdx,%r9,%r10
	adcq    %r9,%rbx
	adcq    %r10,%rax

	movq    536(%rsp),%r9
	movq    544(%rsp),%rdx
	movq    552(%rsp),%r10

	xorq    %rdi,%rdi
	addq    %r15,%r11
	adcq    %rcx,%r9
	adcq    %r8,%rdx
	adcq    %rsi,%r10
	adcq    %rbp,%r12
	adcq    %rbx,%r13
	adcq    %rax,%r14
	adcq    $0,%rdi
	    
	movq    %r11,536(%rsp)

	movq    %rsi,%r11
	andq    mask32h(%rip),%r11

	addq    %r11,%r10
	adcq    %rbp,%r12
	adcq    %rbx,%r13
	adcq    %rax,%r14
	adcq    $0,%rdi

	movq    %rsi,%r11
	shrd    $32,%rbp,%rsi
	shrd    $32,%rbx,%rbp
	shrd    $32,%rax,%rbx
	shrd    $32,%r15,%rax
	shrd    $32,%rcx,%r15
	shrd    $32,%r8,%rcx
	shrd    $32,%r11,%r8

	addq    536(%rsp),%rsi
	adcq    %rbp,%r9
	adcq    %rbx,%rdx
	adcq    %rax,%r10
	adcq    %r15,%r12
	adcq    %rcx,%r13
	adcq    %r8,%r14
	adcq    $0,%rdi

	movq    %rdi,%rax
	shlq    $32,%rax
	    
	xorq    %rcx,%rcx
	addq    %rdi,%rsi
	adcq    $0,%r9
	adcq    $0,%rdx
	adcq    %rax,%r10
	adcq    $0,%r12
	adcq    $0,%r13
	adcq    $0,%r14
	adcq    $0,%rcx

	movq    %rcx,%rax
	shlq    $32,%rax

	addq    %rcx,%rsi
	adcq    $0,%r9
	adcq    $0,%rdx
	adcq    %rax,%r10

	// update X3
	movq    %rsi,184(%rsp)
	movq    %r9,192(%rsp)
	movq    %rdx,200(%rsp)
	movq    %r10,208(%rsp)
	movq    %r12,216(%rsp)
	movq    %r13,224(%rsp)
	movq    %r14,232(%rsp)

	// T3 ← T1 - T2
	movq    312(%rsp),%r8
	movq    320(%rsp),%r9
	movq    328(%rsp),%r10
	movq    336(%rsp),%r11
	movq    344(%rsp),%r12
	movq    352(%rsp),%r13
	movq    360(%rsp),%r14

	subq    368(%rsp),%r8
	sbbq    376(%rsp),%r9
	sbbq    384(%rsp),%r10
	sbbq    392(%rsp),%r11
	sbbq    400(%rsp),%r12
	sbbq    408(%rsp),%r13
	sbbq    416(%rsp),%r14
	movq    $0,%rax
	adcq    $0,%rax

	movq    %rax,%rsi
	shlq    $32,%rsi

	subq    %rax,%r8
	sbbq    $0,%r9
	sbbq    $0,%r10
	sbbq    %rsi,%r11
	sbbq    $0,%r12
	sbbq    $0,%r13
	sbbq    $0,%r14
	movq    $0,%rax
	adcq    $0,%rax

	movq    %rax,%rsi
	shlq    $32,%rsi

	subq    %rax,%r8
	sbbq    $0,%r9
	sbbq    $0,%r10
	sbbq    %rsi,%r11

	movq    %r8,424(%rsp) 
	movq    %r9,432(%rsp)
	movq    %r10,440(%rsp)
	movq    %r11,448(%rsp)
	movq    %r12,456(%rsp)
	movq    %r13,464(%rsp)
	movq    %r14,472(%rsp)

	// T4 ← ((A + 2)/4) · T3
	movq    a24(%rip),%rdx

	mulx    %r8,%r8,%rcx
	mulx    %r9,%r9,%rax
	addq    %rcx,%r9

	mulx    %r10,%r10,%rcx
	adcq    %rax,%r10

	mulx    %r11,%r11,%rax
	adcq    %rcx,%r11

	mulx    %r12,%r12,%rcx
	adcq    %rax,%r12

	mulx    %r13,%r13,%rax
	adcq    %rcx,%r13

	mulx    %r14,%r14,%r15
	adcq    %rax,%r14
	adcq    $0,%r15

	movq    %r15,%rax
	shlq    $32,%rax

	addq    %r15,%r8
	adcq    $0,%r9
	adcq    $0,%r10
	adcq    %rax,%r11
	adcq    $0,%r12
	adcq    $0,%r13
	adcq    $0,%r14
	movq    $0,%r15
	adcq    $0,%r15

	movq    %r15,%rax
	shlq    $32,%rax

	addq    %r15,%r8
	adcq    $0,%r9
	adcq    $0,%r10
	adcq    %rax,%r11

	// T4 ← T4 + T2
	addq    368(%rsp),%r8
	adcq    376(%rsp),%r9
	adcq    384(%rsp),%r10
	adcq    392(%rsp),%r11
	adcq    400(%rsp),%r12
	adcq    408(%rsp),%r13
	adcq    416(%rsp),%r14
	movq    $0,%r15
	adcq    $0,%r15

	movq    %r15,%rax
	shlq    $32,%rax

	addq    %r15,%r8
	adcq    $0,%r9
	adcq    $0,%r10
	adcq    %rax,%r11
	adcq    $0,%r12
	adcq    $0,%r13
	adcq    $0,%r14
	movq    $0,%r15
	adcq    $0,%r15

	movq    %r15,%rax
	shlq    $32,%rax

	addq    %r15,%r8
	adcq    $0,%r9
	adcq    $0,%r10
	adcq    %rax,%r11

	movq    %r8,480(%rsp) 
	movq    %r9,488(%rsp)
	movq    %r10,496(%rsp)
	movq    %r11,504(%rsp)
	movq    %r12,512(%rsp)
	movq    %r13,520(%rsp)
	movq    %r14,528(%rsp)

	// X2 ← T1 · T2
	movq    312(%rsp),%rdx    

	mulx    368(%rsp),%r8,%r9
	mulx    376(%rsp),%rcx,%r10
	addq    %rcx,%r9

	mulx    384(%rsp),%rcx,%r11
	adcq    %rcx,%r10

	mulx    392(%rsp),%rcx,%r12
	adcq    %rcx,%r11

	mulx    400(%rsp),%rcx,%r13
	adcq    %rcx,%r12

	mulx    408(%rsp),%rcx,%r14
	adcq    %rcx,%r13

	mulx    416(%rsp),%rcx,%r15
	adcq    %rcx,%r14
	adcq    $0,%r15

	movq    %r8,536(%rsp)
	movq    %r9,544(%rsp)

	movq    320(%rsp),%rdx

	mulx    368(%rsp),%r8,%r9
	mulx    376(%rsp),%rcx,%rax
	addq    %rcx,%r9

	mulx    384(%rsp),%rcx,%rbx
	adcq    %rcx,%rax

	mulx    392(%rsp),%rcx,%rbp
	adcq    %rcx,%rbx

	mulx    400(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    408(%rsp),%rcx,%rdi
	adcq    %rcx,%rsi

	mulx    416(%rsp),%rdx,%rcx
	adcq    %rdx,%rdi
	adcq    $0,%rcx

	addq    544(%rsp),%r8
	adcq    %r10,%r9
	adcq    %rax,%r11
	adcq    %rbx,%r12
	adcq    %rbp,%r13
	adcq    %rsi,%r14
	adcq    %rdi,%r15
	adcq    $0,%rcx

	movq    %r8,544(%rsp)
	movq    %r9,552(%rsp)

	movq    328(%rsp),%rdx

	mulx    368(%rsp),%r8,%r9
	mulx    376(%rsp),%r10,%rax
	addq    %r10,%r9

	mulx    384(%rsp),%r10,%rbx
	adcq    %r10,%rax

	mulx    392(%rsp),%r10,%rbp
	adcq    %r10,%rbx

	mulx    400(%rsp),%r10,%rsi
	adcq    %r10,%rbp

	mulx    408(%rsp),%r10,%rdi
	adcq    %r10,%rsi

	mulx    416(%rsp),%rdx,%r10
	adcq    %rdx,%rdi
	adcq    $0,%r10

	addq    552(%rsp),%r8
	adcq    %r11,%r9
	adcq    %rax,%r12
	adcq    %rbx,%r13
	adcq    %rbp,%r14
	adcq    %rsi,%r15
	adcq    %rdi,%rcx
	adcq    $0,%r10

	movq    %r8,552(%rsp)
	movq    %r9,560(%rsp)

	movq    336(%rsp),%rdx

	mulx    368(%rsp),%r8,%r9
	mulx    376(%rsp),%r11,%rax
	addq    %r11,%r9

	mulx    384(%rsp),%r11,%rbx
	adcq    %r11,%rax

	mulx    392(%rsp),%r11,%rbp
	adcq    %r11,%rbx

	mulx    400(%rsp),%r11,%rsi
	adcq    %r11,%rbp

	mulx    408(%rsp),%r11,%rdi
	adcq    %r11,%rsi

	mulx    416(%rsp),%rdx,%r11
	adcq    %rdx,%rdi
	adcq    $0,%r11

	addq    560(%rsp),%r8
	adcq    %r12,%r9
	adcq    %rax,%r13
	adcq    %rbx,%r14
	adcq    %rbp,%r15
	adcq    %rsi,%rcx
	adcq    %rdi,%r10
	adcq    $0,%r11

	movq    %r8,560(%rsp)
	movq    %r9,568(%rsp)

	movq    344(%rsp),%rdx

	mulx    368(%rsp),%r8,%r9
	mulx    376(%rsp),%r12,%rax
	addq    %r12,%r9

	mulx    384(%rsp),%r12,%rbx
	adcq    %r12,%rax

	mulx    392(%rsp),%r12,%rbp
	adcq    %r12,%rbx

	mulx    400(%rsp),%r12,%rsi
	adcq    %r12,%rbp

	mulx    408(%rsp),%r12,%rdi
	adcq    %r12,%rsi

	mulx    416(%rsp),%rdx,%r12
	adcq    %rdx,%rdi
	adcq    $0,%r12

	addq    568(%rsp),%r8
	adcq    %r13,%r9
	adcq    %rax,%r14
	adcq    %rbx,%r15
	adcq    %rbp,%rcx
	adcq    %rsi,%r10
	adcq    %rdi,%r11
	adcq    $0,%r12

	movq    %r8,568(%rsp)
	movq    %r9,576(%rsp)

	movq    352(%rsp),%rdx

	mulx    368(%rsp),%r8,%r9
	mulx    376(%rsp),%r13,%rax
	addq    %r13,%r9

	mulx    384(%rsp),%r13,%rbx
	adcq    %r13,%rax

	mulx    392(%rsp),%r13,%rbp
	adcq    %r13,%rbx

	mulx    400(%rsp),%r13,%rsi
	adcq    %r13,%rbp

	mulx    408(%rsp),%r13,%rdi
	adcq    %r13,%rsi

	mulx    416(%rsp),%rdx,%r13
	adcq    %rdx,%rdi
	adcq    $0,%r13

	addq    576(%rsp),%r8
	adcq    %r14,%r9
	adcq    %rax,%r15
	adcq    %rbx,%rcx
	adcq    %rbp,%r10
	adcq    %rsi,%r11
	adcq    %rdi,%r12
	adcq    $0,%r13

	movq    %r8,576(%rsp)
	movq    %r9,584(%rsp)

	movq    360(%rsp),%rdx

	mulx    368(%rsp),%r8,%r9
	mulx    376(%rsp),%r14,%rax
	addq    %r14,%r9

	mulx    384(%rsp),%r14,%rbx
	adcq    %r14,%rax

	mulx    392(%rsp),%r14,%rbp
	adcq    %r14,%rbx

	mulx    400(%rsp),%r14,%rsi
	adcq    %r14,%rbp

	mulx    408(%rsp),%r14,%rdi
	adcq    %r14,%rsi

	mulx    416(%rsp),%rdx,%r14
	adcq    %rdx,%rdi
	adcq    $0,%r14

	addq    584(%rsp),%r8
	adcq    %r15,%r9
	adcq    %rax,%rcx
	adcq    %rbx,%r10
	adcq    %rbp,%r11
	adcq    %rsi,%r12
	adcq    %rdi,%r13
	adcq    $0,%r14

	movq    536(%rsp),%rax
	movq    544(%rsp),%rbx
	movq    552(%rsp),%r15
	movq    560(%rsp),%rdx
	movq    568(%rsp),%rbp
	movq    576(%rsp),%rsi
	  
	xorq    %rdi,%rdi
	addq    %r9,%rax
	adcq    %rcx,%rbx
	adcq    %r10,%r15
	adcq    %r11,%rdx
	adcq    %r12,%rbp
	adcq    %r13,%rsi
	adcq    %r14,%r8
	adcq    $0,%rdi
	  
	movq    %rax,536(%rsp)

	movq    %r11,%rax
	andq    mask32h(%rip),%rax

	addq    %rax,%rdx
	adcq    %r12,%rbp
	adcq    %r13,%rsi
	adcq    %r14,%r8
	adcq    $0,%rdi

	movq    %r11,%rax
	shrd    $32,%r12,%r11
	shrd    $32,%r13,%r12
	shrd    $32,%r14,%r13
	shrd    $32,%r9,%r14
	shrd    $32,%rcx,%r9
	shrd    $32,%r10,%rcx
	shrd    $32,%rax,%r10

	addq    536(%rsp),%r11
	adcq    %r12,%rbx
	adcq    %r13,%r15
	adcq    %r14,%rdx
	adcq    %r9,%rbp
	adcq    %rcx,%rsi
	adcq    %r10,%r8
	adcq    $0,%rdi

	movq    %rdi,%r13
	shlq    $32,%r13
	    
	xorq    %r14,%r14
	addq    %rdi,%r11
	adcq    $0,%rbx
	adcq    $0,%r15
	adcq    %r13,%rdx
	adcq    $0,%rbp
	adcq    $0,%rsi
	adcq    $0,%r8
	adcq    $0,%r14

	movq    %r14,%r13
	shlq    $32,%r13

	addq    %r14,%r11
	adcq    $0,%rbx
	adcq    $0,%r15
	adcq    %r13,%rdx

	// update X2
	movq    %r11,72(%rsp) 
	movq    %rbx,80(%rsp)
	movq    %r15,88(%rsp)
	movq    %rdx,96(%rsp)
	movq    %rbp,104(%rsp)
	movq    %rsi,112(%rsp)
	movq    %r8,120(%rsp)

	// Z2 ← T3 · T4
	movq    480(%rsp),%rdx    

	mulx    424(%rsp),%r8,%r9
	mulx    432(%rsp),%rcx,%r10
	addq    %rcx,%r9

	mulx    440(%rsp),%rcx,%r11
	adcq    %rcx,%r10

	mulx    448(%rsp),%rcx,%r12
	adcq    %rcx,%r11

	mulx    456(%rsp),%rcx,%r13
	adcq    %rcx,%r12

	mulx    464(%rsp),%rcx,%r14
	adcq    %rcx,%r13

	mulx    472(%rsp),%rcx,%r15
	adcq    %rcx,%r14
	adcq    $0,%r15

	movq    %r8,536(%rsp)
	movq    %r9,544(%rsp)

	movq    488(%rsp),%rdx

	mulx    424(%rsp),%r8,%r9
	mulx    432(%rsp),%rcx,%rax
	addq    %rcx,%r9

	mulx    440(%rsp),%rcx,%rbx
	adcq    %rcx,%rax

	mulx    448(%rsp),%rcx,%rbp
	adcq    %rcx,%rbx

	mulx    456(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    464(%rsp),%rcx,%rdi
	adcq    %rcx,%rsi

	mulx    472(%rsp),%rdx,%rcx
	adcq    %rdx,%rdi
	adcq    $0,%rcx

	addq    544(%rsp),%r8
	adcq    %r10,%r9
	adcq    %rax,%r11
	adcq    %rbx,%r12
	adcq    %rbp,%r13
	adcq    %rsi,%r14
	adcq    %rdi,%r15
	adcq    $0,%rcx

	movq    %r8,544(%rsp)
	movq    %r9,552(%rsp)

	movq    496(%rsp),%rdx

	mulx    424(%rsp),%r8,%r9
	mulx    432(%rsp),%r10,%rax
	addq    %r10,%r9

	mulx    440(%rsp),%r10,%rbx
	adcq    %r10,%rax

	mulx    448(%rsp),%r10,%rbp
	adcq    %r10,%rbx

	mulx    456(%rsp),%r10,%rsi
	adcq    %r10,%rbp

	mulx    464(%rsp),%r10,%rdi
	adcq    %r10,%rsi

	mulx    472(%rsp),%rdx,%r10
	adcq    %rdx,%rdi
	adcq    $0,%r10

	addq    552(%rsp),%r8
	adcq    %r11,%r9
	adcq    %rax,%r12
	adcq    %rbx,%r13
	adcq    %rbp,%r14
	adcq    %rsi,%r15
	adcq    %rdi,%rcx
	adcq    $0,%r10

	movq    %r8,552(%rsp)
	movq    %r9,560(%rsp)

	movq    504(%rsp),%rdx

	mulx    424(%rsp),%r8,%r9
	mulx    432(%rsp),%r11,%rax
	addq    %r11,%r9

	mulx    440(%rsp),%r11,%rbx
	adcq    %r11,%rax

	mulx    448(%rsp),%r11,%rbp
	adcq    %r11,%rbx

	mulx    456(%rsp),%r11,%rsi
	adcq    %r11,%rbp

	mulx    464(%rsp),%r11,%rdi
	adcq    %r11,%rsi

	mulx    472(%rsp),%rdx,%r11
	adcq    %rdx,%rdi
	adcq    $0,%r11

	addq    560(%rsp),%r8
	adcq    %r12,%r9
	adcq    %rax,%r13
	adcq    %rbx,%r14
	adcq    %rbp,%r15
	adcq    %rsi,%rcx
	adcq    %rdi,%r10
	adcq    $0,%r11

	movq    %r8,560(%rsp)
	movq    %r9,568(%rsp)

	movq    512(%rsp),%rdx

	mulx    424(%rsp),%r8,%r9
	mulx    432(%rsp),%r12,%rax
	addq    %r12,%r9

	mulx    440(%rsp),%r12,%rbx
	adcq    %r12,%rax

	mulx    448(%rsp),%r12,%rbp
	adcq    %r12,%rbx

	mulx    456(%rsp),%r12,%rsi
	adcq    %r12,%rbp

	mulx    464(%rsp),%r12,%rdi
	adcq    %r12,%rsi

	mulx    472(%rsp),%rdx,%r12
	adcq    %rdx,%rdi
	adcq    $0,%r12

	addq    568(%rsp),%r8
	adcq    %r13,%r9
	adcq    %rax,%r14
	adcq    %rbx,%r15
	adcq    %rbp,%rcx
	adcq    %rsi,%r10
	adcq    %rdi,%r11
	adcq    $0,%r12

	movq    %r8,568(%rsp)
	movq    %r9,576(%rsp)

	movq    520(%rsp),%rdx

	mulx    424(%rsp),%r8,%r9
	mulx    432(%rsp),%r13,%rax
	addq    %r13,%r9

	mulx    440(%rsp),%r13,%rbx
	adcq    %r13,%rax

	mulx    448(%rsp),%r13,%rbp
	adcq    %r13,%rbx

	mulx    456(%rsp),%r13,%rsi
	adcq    %r13,%rbp

	mulx    464(%rsp),%r13,%rdi
	adcq    %r13,%rsi

	mulx    472(%rsp),%rdx,%r13
	adcq    %rdx,%rdi
	adcq    $0,%r13

	addq    576(%rsp),%r8
	adcq    %r14,%r9
	adcq    %rax,%r15
	adcq    %rbx,%rcx
	adcq    %rbp,%r10
	adcq    %rsi,%r11
	adcq    %rdi,%r12
	adcq    $0,%r13

	movq    %r8,576(%rsp)
	movq    %r9,584(%rsp)

	movq    528(%rsp),%rdx

	mulx    424(%rsp),%r8,%r9
	mulx    432(%rsp),%r14,%rax
	addq    %r14,%r9

	mulx    440(%rsp),%r14,%rbx
	adcq    %r14,%rax

	mulx    448(%rsp),%r14,%rbp
	adcq    %r14,%rbx

	mulx    456(%rsp),%r14,%rsi
	adcq    %r14,%rbp

	mulx    464(%rsp),%r14,%rdi
	adcq    %r14,%rsi

	mulx    472(%rsp),%rdx,%r14
	adcq    %rdx,%rdi
	adcq    $0,%r14

	addq    584(%rsp),%r8
	adcq    %r15,%r9
	adcq    %rax,%rcx
	adcq    %rbx,%r10
	adcq    %rbp,%r11
	adcq    %rsi,%r12
	adcq    %rdi,%r13
	adcq    $0,%r14

	movq    536(%rsp),%rax
	movq    544(%rsp),%rbx
	movq    552(%rsp),%r15
	movq    560(%rsp),%rdx
	movq    568(%rsp),%rbp
	movq    576(%rsp),%rsi
	  
	xorq    %rdi,%rdi
	addq    %r9,%rax
	adcq    %rcx,%rbx
	adcq    %r10,%r15
	adcq    %r11,%rdx
	adcq    %r12,%rbp
	adcq    %r13,%rsi
	adcq    %r14,%r8
	adcq    $0,%rdi
	  
	movq    %rax,536(%rsp)

	movq    %r11,%rax
	andq    mask32h(%rip),%rax

	addq    %rax,%rdx
	adcq    %r12,%rbp
	adcq    %r13,%rsi
	adcq    %r14,%r8
	adcq    $0,%rdi

	movq    %r11,%rax
	shrd    $32,%r12,%r11
	shrd    $32,%r13,%r12
	shrd    $32,%r14,%r13
	shrd    $32,%r9,%r14
	shrd    $32,%rcx,%r9
	shrd    $32,%r10,%rcx
	shrd    $32,%rax,%r10

	addq    536(%rsp),%r11
	adcq    %r12,%rbx
	adcq    %r13,%r15
	adcq    %r14,%rdx
	adcq    %r9,%rbp
	adcq    %rcx,%rsi
	adcq    %r10,%r8
	adcq    $0,%rdi

	movq    %rdi,%r13
	shlq    $32,%r13
	    
	xorq    %r14,%r14
	addq    %rdi,%r11
	adcq    $0,%rbx
	adcq    $0,%r15
	adcq    %r13,%rdx
	adcq    $0,%rbp
	adcq    $0,%rsi
	adcq    $0,%r8
	adcq    $0,%r14

	movq    %r14,%r13
	shlq    $32,%r13

	addq    %r14,%r11
	adcq    $0,%rbx
	adcq    $0,%r15
	adcq    %r13,%rdx

	// update Z2
	movq    %r11,128(%rsp) 
	movq    %rbx,136(%rsp)
	movq    %r15,144(%rsp)
	movq    %rdx,152(%rsp)
	movq    %rbp,160(%rsp)
	movq    %rsi,168(%rsp)
	movq    %r8,176(%rsp)

	// Z3 ← Z3 · X1
	movq    $5,%rdx

	mulx    240(%rsp),%r8,%rcx
	mulx    248(%rsp),%r9,%rax
	addq    %rcx,%r9

	mulx    256(%rsp),%r10,%rcx
	adcq    %rax,%r10

	mulx    264(%rsp),%r11,%rax
	adcq    %rcx,%r11

	mulx    272(%rsp),%r12,%rcx
	adcq    %rax,%r12

	mulx    280(%rsp),%r13,%rax
	adcq    %rcx,%r13

	mulx    288(%rsp),%r14,%r15
	adcq    %rax,%r14
	adcq    $0,%r15

	movq    %r15,%rax
	shlq    $32,%rax

	addq    %r15,%r8
	adcq    $0,%r9
	adcq    $0,%r10
	adcq    %rax,%r11
	adcq    $0,%r12
	adcq    $0,%r13
	adcq    $0,%r14
	movq    $0,%r15
	adcq    $0,%r15

	movq    %r15,%rax
	shlq    $32,%rax

	addq    %r15,%r8
	adcq    $0,%r9
	adcq    $0,%r10
	adcq    %rax,%r11

	// update Z3
	movq    %r8,240(%rsp) 
	movq    %r9,248(%rsp)
	movq    %r10,256(%rsp)
	movq    %r11,264(%rsp)
	movq    %r12,272(%rsp)
	movq    %r13,280(%rsp)
	movq    %r14,288(%rsp)

	movb    296(%rsp),%cl
	subb    $1,%cl
	movb    %cl,296(%rsp)
	cmpb	$0,%cl
	jge     .L2

	movb    $7,296(%rsp)
	movq    64(%rsp),%rax
	movq    304(%rsp),%r15
	subq    $1,%r15
	movq    %r15,304(%rsp)
	cmpq	$0,%r15
	jge     .L1

	movq    56(%rsp),%rdi

	movq    72(%rsp),%r8 
	movq    80(%rsp),%r9
	movq    88(%rsp),%r10
	movq    96(%rsp),%r11
	movq    104(%rsp),%r12
	movq    112(%rsp),%r13
	movq    120(%rsp),%r14

	// store final value of X2
	movq    %r8,0(%rdi) 
	movq    %r9,8(%rdi)
	movq    %r10,16(%rdi)
	movq    %r11,24(%rdi)
	movq    %r12,32(%rdi)
	movq    %r13,40(%rdi)
	movq    %r14,48(%rdi)

	movq    128(%rsp),%r8 
	movq    136(%rsp),%r9
	movq    144(%rsp),%r10
	movq    152(%rsp),%r11
	movq    160(%rsp),%r12
	movq    168(%rsp),%r13
	movq    176(%rsp),%r14

	// store final value of Z2
	movq    %r8,56(%rdi) 
	movq    %r9,64(%rdi)
	movq    %r10,72(%rdi)
	movq    %r11,80(%rdi)
	movq    %r12,88(%rdi)
	movq    %r13,96(%rdi)
	movq    %r14,104(%rdi)

	movq 	 0(%rsp),%r11
	movq 	 8(%rsp),%r12
	movq 	16(%rsp),%r13
	movq 	24(%rsp),%r14
	movq 	32(%rsp),%r15
	movq 	40(%rsp),%rbx
	movq 	48(%rsp),%rbp

	movq 	%r11,%rsp

	ret
