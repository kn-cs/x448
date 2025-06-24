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
	.globl curve448_mladder_base_precompute
	
curve448_mladder_base_precompute:

	movq 	%rsp,%r11
	andq    $-32,%rsp	
	subq 	$576,%rsp

	movq 	%r11,0(%rsp)
	movq 	%r12,8(%rsp)
	movq 	%r13,16(%rsp)
	movq 	%r14,24(%rsp)
	movq 	%r15,32(%rsp)
	movq 	%rbx,40(%rsp)
	movq 	%rbp,48(%rsp)
	movq 	%rdi,56(%rsp)

	// X2 ← X(s)
	movq	$0xFFFFFFFFFFFFFFFE,%r8
	movq	$0xFFFFFFFFFFFFFFFF,%r9
	movq	$0xFFFFFFFFFFFFFFFF,%r10
	movq	$0xFFFFFFFEFFFFFFFF,%r11
	movq	$0xFFFFFFFFFFFFFFFF,%r12
	movq	$0xFFFFFFFFFFFFFFFF,%r13
	movq	$0xFFFFFFFFFFFFFFFF,%r14

	movq    %r8,72(%rsp)
	movq    %r9,80(%rsp)
	movq    %r10,88(%rsp)
	movq    %r11,96(%rsp)
	movq    %r12,104(%rsp)
	movq    %r13,112(%rsp)
	movq    %r14,120(%rsp)

	// Z2 ← 1
	movq	$1,128(%rsp)
	movq	$0,136(%rsp)
	movq	$0,144(%rsp)
	movq	$0,152(%rsp)
	movq	$0,160(%rsp)
	movq	$0,168(%rsp)
	movq	$0,176(%rsp)  

	// X3 ← X(p-s)
	movq	$0xACB1197DC99D2720,%r8
	movq	$0x23AC33FF1C69BAF8,%r9
	movq	$0xF1BD65643ACE1B51,%r10
	movq	$0x2954459D84C1F823,%r11
	movq	$0xDACDD1031C81B967,%r12
	movq	$0x3ACF03881AFFEB7B,%r13
	movq	$0xF0FAB72501324442,%r14

	movq    %r8,184(%rsp)
	movq    %r9,192(%rsp)
	movq    %r10,200(%rsp)
	movq    %r11,208(%rsp)
	movq    %r12,216(%rsp)
	movq    %r13,224(%rsp)
	movq    %r14,232(%rsp)

	// Z3 ← 1
	movq	$1,240(%rsp)
	movq	$0,248(%rsp)
	movq	$0,256(%rsp)
	movq	$0,264(%rsp)
	movq	$0,272(%rsp)
	movq	$0,280(%rsp)
	movq	$0,288(%rsp)

	leaq	table448(%rip),%rbx
	movq    %rbx,568(%rsp) 

	movq    $0,304(%rsp)
	movb	$2,296(%rsp)
	movb    $1,298(%rsp)
	movq    %rdx,64(%rsp)

	movq    %rdx,%rax

.L1:

	addq    304(%rsp),%rax
	movb    0(%rax),%r14b
	movb    %r14b,300(%rsp)

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

	movb	296(%rsp),%cl
	movb	300(%rsp),%bl
	shrb    %cl,%bl
	andb    $1,%bl
	movb    %bl,%cl
	xorb    298(%rsp),%bl
	movb    %cl,298(%rsp)

	cmpb    $1,%bl

	// CSwap(X2,X3,swap)
	movq    72(%rsp),%r8
	movq    80(%rsp),%r9
	movq    88(%rsp),%r10
	movq    96(%rsp),%r11
	movq    104(%rsp),%r12
	movq    112(%rsp),%r13
	movq    120(%rsp),%r14

	movq    184(%rsp),%r15
	movq    192(%rsp),%rax
	movq    200(%rsp),%rbx
	movq    208(%rsp),%rcx
	movq    216(%rsp),%rdx
	movq    224(%rsp),%rbp
	movq    232(%rsp),%rsi

	movq    %r8,%rdi
	cmove   %r15,%r8
	cmove   %rdi,%r15

	movq    %r9,%rdi
	cmove   %rax,%r9
	cmove   %rdi,%rax

	movq    %r10,%rdi
	cmove   %rbx,%r10
	cmove   %rdi,%rbx

	movq    %r11,%rdi
	cmove   %rcx,%r11
	cmove   %rdi,%rcx

	movq    %r12,%rdi
	cmove   %rdx,%r12
	cmove   %rdi,%rdx

	movq    %r13,%rdi
	cmove   %rbp,%r13
	cmove   %rdi,%rbp

	movq    %r14,%rdi
	cmove   %rsi,%r14
	cmove   %rdi,%rsi

	movq    %r8,72(%rsp)
	movq    %r9,80(%rsp)
	movq    %r10,88(%rsp)
	movq    %r11,96(%rsp)
	movq    %r12,104(%rsp)
	movq    %r13,112(%rsp)
	movq    %r14,120(%rsp)

	movq    %r15 ,184(%rsp)
	movq    %rax,192(%rsp)
	movq    %rbx,200(%rsp)
	movq    %rcx,208(%rsp)
	movq    %rdx,216(%rsp)
	movq    %rbp,224(%rsp)
	movq    %rsi,232(%rsp)

	// CSwap(Z2,Z3,swap)
	movq    128(%rsp),%r8
	movq    136(%rsp),%r9
	movq    144(%rsp),%r10
	movq    152(%rsp),%r11
	movq    160(%rsp),%r12
	movq    168(%rsp),%r13
	movq    176(%rsp),%r14

	movq    240(%rsp),%r15
	movq    248(%rsp),%rax
	movq    256(%rsp),%rbx
	movq    264(%rsp),%rcx
	movq    272(%rsp),%rdx
	movq    280(%rsp),%rbp
	movq    288(%rsp),%rsi

	movq    %r8,%rdi
	cmove   %r15,%r8
	cmove   %rdi,%r15

	movq    %r9,%rdi
	cmove   %rax,%r9
	cmove   %rdi,%rax

	movq    %r10,%rdi
	cmove   %rbx,%r10
	cmove   %rdi,%rbx

	movq    %r11,%rdi
	cmove   %rcx,%r11
	cmove   %rdi,%rcx

	movq    %r12,%rdi
	cmove   %rdx,%r12
	cmove   %rdi,%rdx

	movq    %r13,%rdi
	cmove   %rbp,%r13
	cmove   %rdi,%rbp

	movq    %r14,%rdi
	cmove   %rsi,%r14
	cmove   %rdi,%rsi

	movq    %r14,176(%rsp)

	movq    %r15,240(%rsp)
	movq    %rax,248(%rsp)
	movq    %rbx,256(%rsp)
	movq    %rcx,264(%rsp)
	movq    %rdx,272(%rsp)
	movq    %rbp,280(%rsp)
	movq    %rsi,288(%rsp)

	// X2
	movq    72(%rsp),%r15
	movq    80(%rsp),%rax
	movq    88(%rsp),%rbx
	movq    96(%rsp),%rcx
	movq    104(%rsp),%rdx
	movq    112(%rsp),%rbp
	movq    120(%rsp),%rsi

	// T2 ← X2 - Z2
	subq    %r8,%r15
	sbbq    %r9,%rax
	sbbq    %r10,%rbx
	sbbq    %r11,%rcx
	sbbq    %r12,%rdx
	sbbq    %r13,%rbp
	sbbq    %r14,%rsi
	movq    $0,%rdi
	adcq    $0,%rdi

	movq    %rdi,%r14
	shlq    $32,%r14

	subq    %rdi,%r15
	sbbq    $0,%rax
	sbbq    $0,%rbx
	sbbq    %r14,%rcx
	sbbq    $0,%rdx
	sbbq    $0,%rbp
	sbbq    $0,%rsi
	movq    $0,%rdi
	adcq    $0,%rdi

	movq    %rdi,%r14
	shlq    $32,%r14

	subq    %rdi,%r15
	sbbq    $0,%rax
	sbbq    $0,%rbx
	sbbq    %r14,%rcx

	movq    %r15,368(%rsp)
	movq    %rax,376(%rsp)
	movq    %rbx,384(%rsp)
	movq    %rcx,392(%rsp)
	movq    %rdx,400(%rsp)
	movq    %rbp,408(%rsp)
	movq    %rsi,416(%rsp)

	movq    176(%rsp),%r14

	// T1 ← X2 + Z2
	addq    72(%rsp),%r8
	adcq    80(%rsp),%r9
	adcq    88(%rsp),%r10
	adcq    96(%rsp),%r11
	adcq    104(%rsp),%r12
	adcq    112(%rsp),%r13
	adcq    120(%rsp),%r14
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

	// T3 ← μ[i] · T2
	movq	568(%rsp),%rbx

	xorq    %rdi,%rdi
	movq    0(%rbx),%rdx    

	mulx    368(%rsp),%r8,%r9
	mulx    376(%rsp),%rcx,%r10		
	adcx    %rcx,%r9

	mulx    384(%rsp),%rcx,%r11	
	adcx    %rcx,%r10

	mulx    392(%rsp),%rcx,%r12	
	adcx    %rcx,%r11

	mulx    400(%rsp),%rcx,%r13	
	adcx    %rcx,%r12

	mulx    408(%rsp),%rcx,%r14	
	adcx    %rcx,%r13

	mulx    416(%rsp),%rcx,%r15	
	adcx    %rcx,%r14
	adcx    %rdi,%r15

	xorq    %rdi,%rdi

	movq    8(%rbx),%rdx
	   
	mulx    368(%rsp),%rcx,%rbp
	adcx    %rcx,%r9
	adox    %rbp,%r10
	    
	mulx    376(%rsp),%rcx,%rbp
	adcx    %rcx,%r10
	adox    %rbp,%r11
	    
	mulx    384(%rsp),%rcx,%rbp
	adcx    %rcx,%r11
	adox    %rbp,%r12

	mulx    392(%rsp),%rcx,%rbp
	adcx    %rcx,%r12
	adox    %rbp,%r13

	mulx    400(%rsp),%rcx,%rbp
	adcx    %rcx,%r13
	adox    %rbp,%r14

	mulx    408(%rsp),%rcx,%rbp
	adcx    %rcx,%r14
	adox    %rbp,%r15
	    
	mulx    416(%rsp),%rcx,%rbp
	adcx    %rcx,%r15
	adox    %rbp,%rdi			
	adcq    $0,%rdi

	movq    %r8,536(%rsp)

	xorq    %rsi,%rsi
	movq    16(%rbx),%rdx
	    
	mulx    368(%rsp),%rcx,%rbp
	adcx    %rcx,%r10
	adox    %rbp,%r11
	    
	mulx    376(%rsp),%rcx,%rbp
	adcx    %rcx,%r11
	adox    %rbp,%r12
	    
	mulx    384(%rsp),%rcx,%rbp
	adcx    %rcx,%r12
	adox    %rbp,%r13

	mulx    392(%rsp),%rcx,%rbp
	adcx    %rcx,%r13
	adox    %rbp,%r14

	mulx    400(%rsp),%rcx,%rbp
	adcx    %rcx,%r14
	adox    %rbp,%r15

	mulx    408(%rsp),%rcx,%rbp
	adcx    %rcx,%r15
	adox    %rbp,%rdi
	    
	mulx    416(%rsp),%rcx,%rbp
	adcx    %rcx,%rdi
	adox    %rbp,%rsi
	adcq    $0,%rsi

	movq    %r9,544(%rsp)

	xorq    %r8,%r8
	movq    24(%rbx),%rdx
	    
	mulx    368(%rsp),%rcx,%rbp
	adcx    %rcx,%r11
	adox    %rbp,%r12
	    
	mulx    376(%rsp),%rcx,%rbp
	adcx    %rcx,%r12
	adox    %rbp,%r13
	    
	mulx    384(%rsp),%rcx,%rbp
	adcx    %rcx,%r13
	adox    %rbp,%r14

	mulx    392(%rsp),%rcx,%rbp
	adcx    %rcx,%r14
	adox    %rbp,%r15

	mulx    400(%rsp),%rcx,%rbp
	adcx    %rcx,%r15
	adox    %rbp,%rdi

	mulx    408(%rsp),%rcx,%rbp
	adcx    %rcx,%rdi
	adox    %rbp,%rsi
	    
	mulx    416(%rsp),%rcx,%rbp
	adcx    %rcx,%rsi
	adox    %rbp,%r8			
	adcq    $0,%r8

	movq    %r10,552(%rsp)

	xorq    %r9,%r9
	movq    32(%rbx),%rdx
	    
	mulx    368(%rsp),%rcx,%rbp
	adcx    %rcx,%r12
	adox    %rbp,%r13
	    
	mulx    376(%rsp),%rcx,%rbp
	adcx    %rcx,%r13
	adox    %rbp,%r14
	    
	mulx    384(%rsp),%rcx,%rbp
	adcx    %rcx,%r14
	adox    %rbp,%r15

	mulx    392(%rsp),%rcx,%rbp
	adcx    %rcx,%r15
	adox    %rbp,%rdi

	mulx    400(%rsp),%rcx,%rbp
	adcx    %rcx,%rdi
	adox    %rbp,%rsi

	mulx    408(%rsp),%rcx,%rbp
	adcx    %rcx,%rsi
	adox    %rbp,%r8
	    
	mulx    416(%rsp),%rcx,%rbp
	adcx    %rcx,%r8
	adox    %rbp,%r9
	adcq    $0,%r9

	movq    %r11,560(%rsp)

	xorq    %r10,%r10
	movq    40(%rbx),%rdx
	    
	mulx    368(%rsp),%rcx,%rbp
	adcx    %rcx,%r13
	adox    %rbp,%r14
	    
	mulx    376(%rsp),%rcx,%rbp
	adcx    %rcx,%r14
	adox    %rbp,%r15
	    
	mulx    384(%rsp),%rcx,%rbp
	adcx    %rcx,%r15
	adox    %rbp,%rdi

	mulx    392(%rsp),%rcx,%rbp
	adcx    %rcx,%rdi
	adox    %rbp,%rsi

	mulx    400(%rsp),%rcx,%rbp
	adcx    %rcx,%rsi
	adox    %rbp,%r8

	mulx    408(%rsp),%rcx,%rbp
	adcx    %rcx,%r8
	adox    %rbp,%r9
	    
	mulx    416(%rsp),%rcx,%rbp
	adcx    %rcx,%r9
	adox    %rbp,%r10
	adcq    $0,%r10

	xorq    %r11,%r11
	movq    48(%rbx),%rdx
	    
	mulx    368(%rsp),%rcx,%rbp
	adcx    %rcx,%r14
	adox    %rbp,%r15
	    
	mulx    376(%rsp),%rcx,%rbp
	adcx    %rcx,%r15
	adox    %rbp,%rdi
	    
	mulx    384(%rsp),%rcx,%rbp
	adcx    %rcx,%rdi
	adox    %rbp,%rsi

	mulx    392(%rsp),%rcx,%rbp
	adcx    %rcx,%rsi
	adox    %rbp,%r8

	mulx    400(%rsp),%rcx,%rbp
	adcx    %rcx,%r8
	adox    %rbp,%r9

	mulx    408(%rsp),%rcx,%rbp
	adcx    %rcx,%r9
	adox    %rbp,%r10
	    
	mulx    416(%rsp),%rcx,%rbp
	adcx    %rcx,%r10
	adox    %rbp,%r11			
	adcq    $0,%r11

	movq    536(%rsp),%rax
	movq    544(%rsp),%rbx
	movq    552(%rsp),%rcx
	movq    560(%rsp),%rdx

	xorq    %rbp,%rbp
	addq    %r15,%rax
	adcq    %rdi,%rbx
	adcq    %rsi,%rcx
	adcq    %r8,%rdx
	adcq    %r9,%r12
	adcq    %r10,%r13
	adcq    %r11,%r14
	adcq    %rbp,%rbp
	 
	movq    %rax,536(%rsp)

	movq    %r8,%rax
	andq    mask32h(%rip),%rax

	addq    %rax,%rdx
	adcq    %r9,%r12
	adcq    %r10,%r13
	adcq    %r11,%r14
	adcq    $0,%rbp

	movq    %r8,%rax
	shrd    $32,%r9,%r8
	shrd    $32,%r10,%r9
	shrd    $32,%r11,%r10
	shrd    $32,%r15,%r11
	shrd    $32,%rdi,%r15
	shrd    $32,%rsi,%rdi
	shrd    $32,%rax,%rsi

	addq    536(%rsp),%r8
	adcq    %r9,%rbx
	adcq    %r10,%rcx
	adcq    %r11,%rdx
	adcq    %r15,%r12
	adcq    %rdi,%r13
	adcq    %rsi,%r14
	adcq    $0,%rbp

	movq    %rbp,%r15
	shlq    $32,%r15
	    
	xorq    %r11,%r11
	addq    %rbp,%r8
	adcq    $0,%rbx
	adcq    $0,%rcx
	adcq    %r15,%rdx
	adcq    $0,%r12
	adcq    $0,%r13
	adcq    $0,%r14
	adcq    $0,%r11

	movq    %r11,%r10
	shlq    $32,%r10

	addq    %r11,%r8
	adcq    $0,%rbx
	adcq    $0,%rcx
	adcq    %r10,%rdx

	movq    %r14,472(%rsp)

	// T1
	movq    312(%rsp),%r9
	movq    320(%rsp),%r10
	movq    328(%rsp),%r11
	movq    336(%rsp),%r15
	movq    344(%rsp),%rax
	movq    352(%rsp),%rbp
	movq    360(%rsp),%rsi

	// T2 ← T1 - T3
	subq    %r8,%r9
	sbbq    %rbx,%r10
	sbbq    %rcx,%r11
	sbbq    %rdx,%r15
	sbbq    %r12,%rax
	sbbq    %r13,%rbp
	sbbq    %r14,%rsi
	movq    $0,%rdi
	adcq    $0,%rdi

	movq    %rdi,%r14
	shlq    $32,%r14

	subq    %rdi,%r9
	sbbq    $0,%r10
	sbbq    $0,%r11
	sbbq    %r14,%r15
	sbbq    $0,%rax
	sbbq    $0,%rbp
	sbbq    $0,%rsi
	movq    $0,%rdi
	adcq    $0,%rdi

	movq    %rdi,%r14
	shlq    $32,%r14

	subq    %rdi,%r9
	sbbq    $0,%r10
	sbbq    $0,%r11
	sbbq    %r14,%r15

	movq    %r9,368(%rsp)
	movq    %r10,376(%rsp)
	movq    %r11,384(%rsp)
	movq    %r15,392(%rsp)
	movq    %rax,400(%rsp)
	movq    %rbp,408(%rsp)
	movq    %rsi,416(%rsp)

	movq    472(%rsp),%r14

	// T1 ← T1 + T3
	addq    312(%rsp),%r8
	adcq    320(%rsp),%rbx
	adcq    328(%rsp),%rcx
	adcq    336(%rsp),%rdx
	adcq    344(%rsp),%r12
	adcq    352(%rsp),%r13
	adcq    360(%rsp),%r14
	movq    $0,%rdi
	adcq    $0,%rdi

	movq    %rdi,%r15
	shlq    $32,%r15

	addq    %rdi,%r8
	adcq    $0,%rbx
	adcq    $0,%rcx
	adcq    %r15,%rdx
	adcq    $0,%r12
	adcq    $0,%r13
	adcq    $0,%r14
	movq    $0,%rdi
	adcq    $0,%rdi

	movq    %rdi,%r15
	shlq    $32,%r15

	addq    %rdi,%r8
	adcq    $0,%rbx
	adcq    $0,%rcx
	adcq    %r15,%rdx

	movq    %r8,312(%rsp)
	movq    %rbx,320(%rsp)
	movq    %rcx,328(%rsp)
	movq    %rdx,336(%rsp)
	movq    %r12,344(%rsp)
	movq    %r13,352(%rsp)
	movq    %r14,360(%rsp)

	// T1 ← T1^2
	movq    312(%rsp),%rdx
	xorq    %r8,%r8
	    
	mulx    320(%rsp),%r9,%r10

	mulx    328(%rsp),%rcx,%r11
	adcx    %rcx,%r10

	mulx    336(%rsp),%rcx,%r12
	adcx    %rcx,%r11

	mulx    344(%rsp),%rcx,%r13
	adcx    %rcx,%r12

	mulx    352(%rsp),%rcx,%r14
	adcx    %rcx,%r13

	mulx    360(%rsp),%rcx,%r15
	adcx    %rcx,%r14
	adcx    %r8,%r15
	    
	movq    320(%rsp),%rdx
	xorq    %rdi,%rdi
	    
	mulx    328(%rsp),%rcx,%rbp
	adcx    %rcx,%r11
	adox    %rbp,%r12

	mulx    336(%rsp),%rcx,%rbp
	adcx    %rcx,%r12
	adox    %rbp,%r13

	mulx    344(%rsp),%rcx,%rbp
	adcx    %rcx,%r13
	adox    %rbp,%r14

	mulx    352(%rsp),%rcx,%rbp
	adcx    %rcx,%r14
	adox    %rbp,%r15

	mulx    360(%rsp),%rcx,%rbp
	adcx    %rcx,%r15
	adox    %rbp,%r8
	adcx    %rdi,%r8
	    
	movq    328(%rsp),%rdx
	xorq    %rbx,%rbx

	mulx    336(%rsp),%rcx,%rbp
	adcx    %rcx,%r13
	adox    %rbp,%r14

	mulx    344(%rsp),%rcx,%rbp
	adcx    %rcx,%r14
	adox    %rbp,%r15

	mulx    352(%rsp),%rcx,%rbp
	adcx    %rcx,%r15
	adox    %rbp,%r8

	mulx    360(%rsp),%rcx,%rbp
	adcx    %rcx,%r8
	adox    %rbp,%rdi
	adcx    %rbx,%rdi

	movq    %r11,536(%rsp)

	movq    336(%rsp),%rdx
	xorq    %r11,%r11

	mulx    344(%rsp),%rcx,%rbp
	adcx    %rcx,%r15
	adox    %rbp,%r8

	mulx    352(%rsp),%rcx,%rbp
	adcx    %rcx,%r8
	adox    %rbp,%rdi

	mulx    360(%rsp),%rcx,%rbp
	adcx    %rcx,%rdi
	adox    %rbp,%rbx
	adcx    %r11,%rbx

	movq    344(%rsp),%rdx
	xorq    %rax,%rax

	mulx    352(%rsp),%rcx,%rbp
	adcx    %rcx,%rdi
	adox    %rbp,%rbx

	mulx    360(%rsp),%rcx,%rbp
	adcx    %rcx,%rbx
	adox    %rbp,%r11
	adcx    %rax,%r11

	movq    352(%rsp),%rdx

	mulx    360(%rsp),%rcx,%rsi
	adcx    %rcx,%r11
	adcx    %rax,%rsi

	movq    536(%rsp),%rdx

	movq    $0,%rbp
	shld    $1,%rsi,%rbp
	shld    $1,%r11,%rsi
	shld    $1,%rbx,%r11
	shld    $1,%rdi,%rbx
	shld    $1,%r8,%rdi
	shld    $1,%r15,%r8
	shld    $1,%r14,%r15
	shld    $1,%r13,%r14
	shld    $1,%r12,%r13
	shld    $1,%rdx,%r12
	shld    $1,%r10,%rdx
	shld    $1,%r9,%r10
	shlq    $1,%r9

	movq    %rdx,536(%rsp)		
	movq    %r12,544(%rsp)
		  
	xorq    %rdx,%rdx
	movq    312(%rsp),%rdx
	mulx    %rdx,%r12,%rax
	adcx    %rax,%r9

	movq    320(%rsp),%rdx
	mulx    %rdx,%rcx,%rax
	adcx    %rcx,%r10
	adcx    536(%rsp),%rax
	movq    %rax,536(%rsp)

	movq    328(%rsp),%rdx
	mulx    %rdx,%rcx,%rax
	adcx    544(%rsp),%rcx
	adcx    %rax,%r13
	movq    %rcx,544(%rsp)

	movq    336(%rsp),%rdx
	mulx    %rdx,%rcx,%rax
	adcx    %rcx,%r14
	adcx    %rax,%r15

	movq    344(%rsp),%rdx
	mulx    %rdx,%rcx,%rax
	adcx    %rcx,%r8
	adcx    %rax,%rdi

	movq    352(%rsp),%rdx
	mulx    %rdx,%rcx,%rax
	adcx    %rcx,%rbx
	adcx    %rax,%r11

	movq    360(%rsp),%rdx
	mulx    %rdx,%rcx,%rax
	adcx    %rcx,%rsi
	adcx    %rax,%rbp

	movq    536(%rsp),%rcx
	movq    544(%rsp),%rdx

	xorq    %rax,%rax
	addq    %r15,%r12
	adcq    %r8,%r9
	adcq    %rdi,%r10
	adcq    %rbx,%rcx
	adcq    %r11,%rdx
	adcq    %rsi,%r13
	adcq    %rbp,%r14
	adcq    %rax,%rax
	    
	movq    %r12,536(%rsp)

	movq    %rbx,%r12
	andq    mask32h(%rip),%r12

	addq    %r12,%rcx
	adcq    %r11,%rdx
	adcq    %rsi,%r13
	adcq    %rbp,%r14
	adcq    $0,%rax

	movq    %rbx,%r12
	shrd    $32,%r11,%rbx
	shrd    $32,%rsi,%r11
	shrd    $32,%rbp,%rsi
	shrd    $32,%r15,%rbp
	shrd    $32,%r8,%r15
	shrd    $32,%rdi,%r8
	shrd    $32,%r12,%rdi

	addq    536(%rsp),%rbx
	adcq    %r11,%r9
	adcq    %rsi,%r10
	adcq    %rbp,%rcx
	adcq    %r15,%rdx
	adcq    %r8,%r13
	adcq    %rdi,%r14
	adcq    $0,%rax

	movq    %rax,%r12
	shlq    $32,%r12

	xorq    %r11,%r11
	addq    %rax,%rbx
	adcq    $0,%r9
	adcq    $0,%r10
	adcq    %r12,%rcx
	adcq    $0,%rdx
	adcq    $0,%r13
	adcq    $0,%r14
	adcq    $0,%r11

	movq    %r11,%r12
	shlq    $32,%r12

	addq    %r11,%rbx
	adcq    $0,%r9
	adcq    $0,%r10
	adcq    %r12,%rcx

	movq    %rbx,312(%rsp)
	movq    %r9,320(%rsp)
	movq    %r10,328(%rsp)
	movq    %rcx,336(%rsp)
	movq    %rdx,344(%rsp)
	movq    %r13,352(%rsp)
	movq    %r14,360(%rsp)

	// T2 ← T2^2
	movq    368(%rsp),%rdx
	xorq    %r8,%r8
	    
	mulx    376(%rsp),%r9,%r10

	mulx    384(%rsp),%rcx,%r11
	adcx    %rcx,%r10

	mulx    392(%rsp),%rcx,%r12
	adcx    %rcx,%r11

	mulx    400(%rsp),%rcx,%r13
	adcx    %rcx,%r12

	mulx    408(%rsp),%rcx,%r14
	adcx    %rcx,%r13

	mulx    416(%rsp),%rcx,%r15
	adcx    %rcx,%r14
	adcx    %r8,%r15
	    
	movq    376(%rsp),%rdx
	xorq    %rdi,%rdi
	    
	mulx    384(%rsp),%rcx,%rbp
	adcx    %rcx,%r11
	adox    %rbp,%r12

	mulx    392(%rsp),%rcx,%rbp
	adcx    %rcx,%r12
	adox    %rbp,%r13

	mulx    400(%rsp),%rcx,%rbp
	adcx    %rcx,%r13
	adox    %rbp,%r14

	mulx    408(%rsp),%rcx,%rbp
	adcx    %rcx,%r14
	adox    %rbp,%r15

	mulx    416(%rsp),%rcx,%rbp
	adcx    %rcx,%r15
	adox    %rbp,%r8
	adcx    %rdi,%r8
	    
	movq    384(%rsp),%rdx
	xorq    %rbx,%rbx

	mulx    392(%rsp),%rcx,%rbp
	adcx    %rcx,%r13
	adox    %rbp,%r14

	mulx    400(%rsp),%rcx,%rbp
	adcx    %rcx,%r14
	adox    %rbp,%r15

	mulx    408(%rsp),%rcx,%rbp
	adcx    %rcx,%r15
	adox    %rbp,%r8

	mulx    416(%rsp),%rcx,%rbp
	adcx    %rcx,%r8
	adox    %rbp,%rdi
	adcx    %rbx,%rdi

	movq    %r11,536(%rsp)

	movq    392(%rsp),%rdx
	xorq    %r11,%r11

	mulx    400(%rsp),%rcx,%rbp
	adcx    %rcx,%r15
	adox    %rbp,%r8

	mulx    408(%rsp),%rcx,%rbp
	adcx    %rcx,%r8
	adox    %rbp,%rdi

	mulx    416(%rsp),%rcx,%rbp
	adcx    %rcx,%rdi
	adox    %rbp,%rbx
	adcx    %r11,%rbx

	movq    400(%rsp),%rdx
	xorq    %rax,%rax

	mulx    408(%rsp),%rcx,%rbp
	adcx    %rcx,%rdi
	adox    %rbp,%rbx

	mulx    416(%rsp),%rcx,%rbp
	adcx    %rcx,%rbx
	adox    %rbp,%r11
	adcx    %rax,%r11

	movq    408(%rsp),%rdx

	mulx    416(%rsp),%rcx,%rsi
	adcx    %rcx,%r11
	adcx    %rax,%rsi

	movq    536(%rsp),%rdx

	movq    $0,%rbp
	shld    $1,%rsi,%rbp
	shld    $1,%r11,%rsi
	shld    $1,%rbx,%r11
	shld    $1,%rdi,%rbx
	shld    $1,%r8,%rdi
	shld    $1,%r15,%r8
	shld    $1,%r14,%r15
	shld    $1,%r13,%r14
	shld    $1,%r12,%r13
	shld    $1,%rdx,%r12
	shld    $1,%r10,%rdx
	shld    $1,%r9,%r10
	shlq    $1,%r9

	movq    %rdx,536(%rsp)		
	movq    %r12,544(%rsp)
		  
	xorq    %rdx,%rdx
	movq    368(%rsp),%rdx
	mulx    %rdx,%r12,%rax
	adcx    %rax,%r9

	movq    376(%rsp),%rdx
	mulx    %rdx,%rcx,%rax
	adcx    %rcx,%r10
	adcx    536(%rsp),%rax
	movq    %rax,536(%rsp)

	movq    384(%rsp),%rdx
	mulx    %rdx,%rcx,%rax
	adcx    544(%rsp),%rcx
	adcx    %rax,%r13
	movq    %rcx,544(%rsp)

	movq    392(%rsp),%rdx
	mulx    %rdx,%rcx,%rax
	adcx    %rcx,%r14
	adcx    %rax,%r15

	movq    400(%rsp),%rdx
	mulx    %rdx,%rcx,%rax
	adcx    %rcx,%r8
	adcx    %rax,%rdi

	movq    408(%rsp),%rdx
	mulx    %rdx,%rcx,%rax
	adcx    %rcx,%rbx
	adcx    %rax,%r11

	movq    416(%rsp),%rdx
	mulx    %rdx,%rcx,%rax
	adcx    %rcx,%rsi
	adcx    %rax,%rbp

	movq    536(%rsp),%rcx
	movq    544(%rsp),%rdx

	xorq    %rax,%rax
	addq    %r15,%r12
	adcq    %r8,%r9
	adcq    %rdi,%r10
	adcq    %rbx,%rcx
	adcq    %r11,%rdx
	adcq    %rsi,%r13
	adcq    %rbp,%r14
	adcq    %rax,%rax
	    
	movq    %r12,536(%rsp)

	movq    %rbx,%r12
	andq    mask32h(%rip),%r12

	addq    %r12,%rcx
	adcq    %r11,%rdx
	adcq    %rsi,%r13
	adcq    %rbp,%r14
	adcq    $0,%rax

	movq    %rbx,%r12
	shrd    $32,%r11,%rbx
	shrd    $32,%rsi,%r11
	shrd    $32,%rbp,%rsi
	shrd    $32,%r15,%rbp
	shrd    $32,%r8,%r15
	shrd    $32,%rdi,%r8
	shrd    $32,%r12,%rdi

	addq    536(%rsp),%rbx
	adcq    %r11,%r9
	adcq    %rsi,%r10
	adcq    %rbp,%rcx
	adcq    %r15,%rdx
	adcq    %r8,%r13
	adcq    %rdi,%r14
	adcq    $0,%rax

	movq    %rax,%r12
	shlq    $32,%r12

	xorq    %r11,%r11
	addq    %rax,%rbx
	adcq    $0,%r9
	adcq    $0,%r10
	adcq    %r12,%rcx
	adcq    $0,%rdx
	adcq    $0,%r13
	adcq    $0,%r14
	adcq    $0,%r11

	movq    %r11,%r12
	shlq    $32,%r12

	addq    %r11,%rbx
	adcq    $0,%r9
	adcq    $0,%r10
	adcq    %r12,%rcx

	movq    %rbx,368(%rsp)
	movq    %r9,376(%rsp)
	movq    %r10,384(%rsp)
	movq    %rcx,392(%rsp)
	movq    %rdx,400(%rsp)
	movq    %r13,408(%rsp)
	movq    %r14,416(%rsp)

	// X2 ← Z3 · T1
	xorq    %rdi,%rdi
	movq    312(%rsp),%rdx    

	mulx    240(%rsp),%r8,%r9
	mulx    248(%rsp),%rcx,%r10		
	adcx    %rcx,%r9

	mulx    256(%rsp),%rcx,%r11	
	adcx    %rcx,%r10

	mulx    264(%rsp),%rcx,%r12	
	adcx    %rcx,%r11

	mulx    272(%rsp),%rcx,%r13	
	adcx    %rcx,%r12

	mulx    280(%rsp),%rcx,%r14	
	adcx    %rcx,%r13

	mulx    288(%rsp),%rcx,%r15	
	adcx    %rcx,%r14
	adcx    %rdi,%r15

	xorq    %rdi,%rdi
	movq    320(%rsp),%rdx
	   
	mulx    240(%rsp),%rcx,%rbp
	adcx    %rcx,%r9
	adox    %rbp,%r10
	    
	mulx    248(%rsp),%rcx,%rbp
	adcx    %rcx,%r10
	adox    %rbp,%r11
	    
	mulx    256(%rsp),%rcx,%rbp
	adcx    %rcx,%r11
	adox    %rbp,%r12

	mulx    264(%rsp),%rcx,%rbp
	adcx    %rcx,%r12
	adox    %rbp,%r13

	mulx    272(%rsp),%rcx,%rbp
	adcx    %rcx,%r13
	adox    %rbp,%r14

	mulx    280(%rsp),%rcx,%rbp
	adcx    %rcx,%r14
	adox    %rbp,%r15
	    
	mulx    288(%rsp),%rcx,%rbp
	adcx    %rcx,%r15
	adox    %rbp,%rdi			
	adcq    $0,%rdi

	xorq    %rsi,%rsi
	movq    328(%rsp),%rdx
	    
	mulx    240(%rsp),%rcx,%rbp
	adcx    %rcx,%r10
	adox    %rbp,%r11
	    
	mulx    248(%rsp),%rcx,%rbp
	adcx    %rcx,%r11
	adox    %rbp,%r12
	    
	mulx    256(%rsp),%rcx,%rbp
	adcx    %rcx,%r12
	adox    %rbp,%r13

	mulx    264(%rsp),%rcx,%rbp
	adcx    %rcx,%r13
	adox    %rbp,%r14

	mulx    272(%rsp),%rcx,%rbp
	adcx    %rcx,%r14
	adox    %rbp,%r15

	mulx    280(%rsp),%rcx,%rbp
	adcx    %rcx,%r15
	adox    %rbp,%rdi
	    
	mulx    288(%rsp),%rcx,%rbp
	adcx    %rcx,%rdi
	adox    %rbp,%rsi
	adcq    $0,%rsi

	movq    %r10,536(%rsp)

	xorq    %rbx,%rbx
	movq    336(%rsp),%rdx
	    
	mulx    240(%rsp),%rcx,%rbp
	adcx    %rcx,%r11
	adox    %rbp,%r12
	    
	mulx    248(%rsp),%rcx,%rbp
	adcx    %rcx,%r12
	adox    %rbp,%r13
	    
	mulx    256(%rsp),%rcx,%rbp
	adcx    %rcx,%r13
	adox    %rbp,%r14

	mulx    264(%rsp),%rcx,%rbp
	adcx    %rcx,%r14
	adox    %rbp,%r15

	mulx    272(%rsp),%rcx,%rbp
	adcx    %rcx,%r15
	adox    %rbp,%rdi

	mulx    280(%rsp),%rcx,%rbp
	adcx    %rcx,%rdi
	adox    %rbp,%rsi
	    
	mulx    288(%rsp),%rcx,%rbp
	adcx    %rcx,%rsi
	adox    %rbp,%rbx			
	adcq    $0,%rbx

	movq    %r11,544(%rsp)

	xorq    %r10,%r10
	movq    344(%rsp),%rdx
	    
	mulx    240(%rsp),%rcx,%rbp
	adcx    %rcx,%r12
	adox    %rbp,%r13
	    
	mulx    248(%rsp),%rcx,%rbp
	adcx    %rcx,%r13
	adox    %rbp,%r14
	    
	mulx    256(%rsp),%rcx,%rbp
	adcx    %rcx,%r14
	adox    %rbp,%r15

	mulx    264(%rsp),%rcx,%rbp
	adcx    %rcx,%r15
	adox    %rbp,%rdi

	mulx    272(%rsp),%rcx,%rbp
	adcx    %rcx,%rdi
	adox    %rbp,%rsi

	mulx    280(%rsp),%rcx,%rbp
	adcx    %rcx,%rsi
	adox    %rbp,%rbx
	    
	mulx    288(%rsp),%rcx,%rbp
	adcx    %rcx,%rbx
	adox    %rbp,%r10			
	adcq    $0,%r10

	movq    %r12,552(%rsp)

	xorq    %r11,%r11
	movq    352(%rsp),%rdx
	    
	mulx    240(%rsp),%rcx,%rbp
	adcx    %rcx,%r13
	adox    %rbp,%r14
	    
	mulx    248(%rsp),%rcx,%rbp
	adcx    %rcx,%r14
	adox    %rbp,%r15
	    
	mulx    256(%rsp),%rcx,%rbp
	adcx    %rcx,%r15
	adox    %rbp,%rdi

	mulx    264(%rsp),%rcx,%rbp
	adcx    %rcx,%rdi
	adox    %rbp,%rsi

	mulx    272(%rsp),%rcx,%rbp
	adcx    %rcx,%rsi
	adox    %rbp,%rbx

	mulx    280(%rsp),%rcx,%rbp
	adcx    %rcx,%rbx
	adox    %rbp,%r10
	    
	mulx    288(%rsp),%rcx,%rbp
	adcx    %rcx,%r10
	adox    %rbp,%r11			
	adcq    $0,%r11

	xorq    %r12,%r12
	movq    360(%rsp),%rdx
	    
	mulx    240(%rsp),%rcx,%rbp
	adcx    %rcx,%r14
	adox    %rbp,%r15
	    
	mulx    248(%rsp),%rcx,%rbp
	adcx    %rcx,%r15
	adox    %rbp,%rdi
	    
	mulx    256(%rsp),%rcx,%rbp
	adcx    %rcx,%rdi
	adox    %rbp,%rsi

	mulx    264(%rsp),%rcx,%rbp
	adcx    %rcx,%rsi
	adox    %rbp,%rbx

	mulx    272(%rsp),%rcx,%rbp
	adcx    %rcx,%rbx
	adox    %rbp,%r10

	mulx    280(%rsp),%rcx,%rbp
	adcx    %rcx,%r10
	adox    %rbp,%r11
	    
	mulx    288(%rsp),%rcx,%rbp
	adcx    %rcx,%r11
	adox    %rbp,%r12			
	adcq    $0,%r12

	movq    536(%rsp),%rcx
	movq    544(%rsp),%rdx
	movq    552(%rsp),%rbp

	xorq    %rax,%rax
	addq    %r15,%r8
	adcq    %rdi,%r9
	adcq    %rsi,%rcx
	adcq    %rbx,%rdx
	adcq    %r10,%rbp
	adcq    %r11,%r13
	adcq    %r12,%r14
	adcq    %rax,%rax

	movq    %r8,536(%rsp)

	movq    %rbx,%r8
	andq    mask32h(%rip),%r8

	addq    %r8,%rdx
	adcq    %r10,%rbp
	adcq    %r11,%r13
	adcq    %r12,%r14
	adcq    $0,%rax

	movq    %rbx,%r8
	shrd    $32,%r10,%rbx
	shrd    $32,%r11,%r10
	shrd    $32,%r12,%r11
	shrd    $32,%r15,%r12
	shrd    $32,%rdi,%r15
	shrd    $32,%rsi,%rdi
	shrd    $32,%r8,%rsi

	addq    536(%rsp),%rbx
	adcq    %r10,%r9
	adcq    %r11,%rcx
	adcq    %r12,%rdx
	adcq    %r15,%rbp
	adcq    %rdi,%r13
	adcq    %rsi,%r14
	adcq    $0,%rax

	movq    %rax,%r12
	shlq    $32,%r12

	xorq    %r10,%r10
	addq    %rax,%rbx
	adcq    $0,%r9
	adcq    $0,%rcx
	adcq    %r12,%rdx
	adcq    $0,%rbp
	adcq    $0,%r13
	adcq    $0,%r14
	adcq    $0,%r10

	movq    %r10,%r15
	shlq    $32,%r15

	addq    %r10,%rbx
	adcq    $0,%r9
	adcq    $0,%rcx
	adcq    %r15,%rdx

	movq    %rbx,72(%rsp) 
	movq    %r9,80(%rsp)
	movq    %rcx,88(%rsp)
	movq    %rdx,96(%rsp)
	movq    %rbp,104(%rsp)
	movq    %r13,112(%rsp)
	movq    %r14,120(%rsp)

	// Z2 ← X3 · T2
	xorq    %rdi,%rdi
	movq    184(%rsp),%rdx    

	mulx    368(%rsp),%r8,%r9
	mulx    376(%rsp),%rcx,%r10		
	adcx    %rcx,%r9

	mulx    384(%rsp),%rcx,%r11	
	adcx    %rcx,%r10

	mulx    392(%rsp),%rcx,%r12	
	adcx    %rcx,%r11

	mulx    400(%rsp),%rcx,%r13	
	adcx    %rcx,%r12

	mulx    408(%rsp),%rcx,%r14	
	adcx    %rcx,%r13

	mulx    416(%rsp),%rcx,%r15	
	adcx    %rcx,%r14
	adcx    %rdi,%r15

	xorq    %rdi,%rdi
	movq    192(%rsp),%rdx
	   
	mulx    368(%rsp),%rcx,%rbp
	adcx    %rcx,%r9
	adox    %rbp,%r10
	    
	mulx    376(%rsp),%rcx,%rbp
	adcx    %rcx,%r10
	adox    %rbp,%r11
	    
	mulx    384(%rsp),%rcx,%rbp
	adcx    %rcx,%r11
	adox    %rbp,%r12

	mulx    392(%rsp),%rcx,%rbp
	adcx    %rcx,%r12
	adox    %rbp,%r13

	mulx    400(%rsp),%rcx,%rbp
	adcx    %rcx,%r13
	adox    %rbp,%r14

	mulx    408(%rsp),%rcx,%rbp
	adcx    %rcx,%r14
	adox    %rbp,%r15
	    
	mulx    416(%rsp),%rcx,%rbp
	adcx    %rcx,%r15
	adox    %rbp,%rdi			
	adcq    $0,%rdi

	xorq    %rsi,%rsi
	movq    200(%rsp),%rdx
	    
	mulx    368(%rsp),%rcx,%rbp
	adcx    %rcx,%r10
	adox    %rbp,%r11
	    
	mulx    376(%rsp),%rcx,%rbp
	adcx    %rcx,%r11
	adox    %rbp,%r12
	    
	mulx    384(%rsp),%rcx,%rbp
	adcx    %rcx,%r12
	adox    %rbp,%r13

	mulx    392(%rsp),%rcx,%rbp
	adcx    %rcx,%r13
	adox    %rbp,%r14

	mulx    400(%rsp),%rcx,%rbp
	adcx    %rcx,%r14
	adox    %rbp,%r15

	mulx    408(%rsp),%rcx,%rbp
	adcx    %rcx,%r15
	adox    %rbp,%rdi
	    
	mulx    416(%rsp),%rcx,%rbp
	adcx    %rcx,%rdi
	adox    %rbp,%rsi
	adcq    $0,%rsi

	movq    %r10,536(%rsp)

	xorq    %rbx,%rbx
	movq    208(%rsp),%rdx
	    
	mulx    368(%rsp),%rcx,%rbp
	adcx    %rcx,%r11
	adox    %rbp,%r12
	    
	mulx    376(%rsp),%rcx,%rbp
	adcx    %rcx,%r12
	adox    %rbp,%r13
	    
	mulx    384(%rsp),%rcx,%rbp
	adcx    %rcx,%r13
	adox    %rbp,%r14

	mulx    392(%rsp),%rcx,%rbp
	adcx    %rcx,%r14
	adox    %rbp,%r15

	mulx    400(%rsp),%rcx,%rbp
	adcx    %rcx,%r15
	adox    %rbp,%rdi

	mulx    408(%rsp),%rcx,%rbp
	adcx    %rcx,%rdi
	adox    %rbp,%rsi
	    
	mulx    416(%rsp),%rcx,%rbp
	adcx    %rcx,%rsi
	adox    %rbp,%rbx			
	adcq    $0,%rbx

	movq    %r11,544(%rsp)

	xorq    %r10,%r10
	movq    216(%rsp),%rdx
	    
	mulx    368(%rsp),%rcx,%rbp
	adcx    %rcx,%r12
	adox    %rbp,%r13
	    
	mulx    376(%rsp),%rcx,%rbp
	adcx    %rcx,%r13
	adox    %rbp,%r14
	    
	mulx    384(%rsp),%rcx,%rbp
	adcx    %rcx,%r14
	adox    %rbp,%r15

	mulx    392(%rsp),%rcx,%rbp
	adcx    %rcx,%r15
	adox    %rbp,%rdi

	mulx    400(%rsp),%rcx,%rbp
	adcx    %rcx,%rdi
	adox    %rbp,%rsi

	mulx    408(%rsp),%rcx,%rbp
	adcx    %rcx,%rsi
	adox    %rbp,%rbx
	    
	mulx    416(%rsp),%rcx,%rbp
	adcx    %rcx,%rbx
	adox    %rbp,%r10			
	adcq    $0,%r10

	movq    %r12,552(%rsp)

	xorq    %r11,%r11
	movq    224(%rsp),%rdx
	    
	mulx    368(%rsp),%rcx,%rbp
	adcx    %rcx,%r13
	adox    %rbp,%r14
	    
	mulx    376(%rsp),%rcx,%rbp
	adcx    %rcx,%r14
	adox    %rbp,%r15
	    
	mulx    384(%rsp),%rcx,%rbp
	adcx    %rcx,%r15
	adox    %rbp,%rdi

	mulx    392(%rsp),%rcx,%rbp
	adcx    %rcx,%rdi
	adox    %rbp,%rsi

	mulx    400(%rsp),%rcx,%rbp
	adcx    %rcx,%rsi
	adox    %rbp,%rbx

	mulx    408(%rsp),%rcx,%rbp
	adcx    %rcx,%rbx
	adox    %rbp,%r10
	    
	mulx    416(%rsp),%rcx,%rbp
	adcx    %rcx,%r10
	adox    %rbp,%r11			
	adcq    $0,%r11

	xorq    %r12,%r12
	movq    232(%rsp),%rdx
	    
	mulx    368(%rsp),%rcx,%rbp
	adcx    %rcx,%r14
	adox    %rbp,%r15
	    
	mulx    376(%rsp),%rcx,%rbp
	adcx    %rcx,%r15
	adox    %rbp,%rdi
	    
	mulx    384(%rsp),%rcx,%rbp
	adcx    %rcx,%rdi
	adox    %rbp,%rsi

	mulx    392(%rsp),%rcx,%rbp
	adcx    %rcx,%rsi
	adox    %rbp,%rbx

	mulx    400(%rsp),%rcx,%rbp
	adcx    %rcx,%rbx
	adox    %rbp,%r10

	mulx    408(%rsp),%rcx,%rbp
	adcx    %rcx,%r10
	adox    %rbp,%r11
	    
	mulx    416(%rsp),%rcx,%rbp
	adcx    %rcx,%r11
	adox    %rbp,%r12			
	adcq    $0,%r12

	movq    536(%rsp),%rcx
	movq    544(%rsp),%rdx
	movq    552(%rsp),%rbp

	xorq    %rax,%rax
	addq    %r15,%r8
	adcq    %rdi,%r9
	adcq    %rsi,%rcx
	adcq    %rbx,%rdx
	adcq    %r10,%rbp
	adcq    %r11,%r13
	adcq    %r12,%r14
	adcq    %rax,%rax

	movq    %r8,536(%rsp)

	movq    %rbx,%r8
	andq    mask32h(%rip),%r8

	addq    %r8,%rdx
	adcq    %r10,%rbp
	adcq    %r11,%r13
	adcq    %r12,%r14
	adcq    $0,%rax

	movq    %rbx,%r8
	shrd    $32,%r10,%rbx
	shrd    $32,%r11,%r10
	shrd    $32,%r12,%r11
	shrd    $32,%r15,%r12
	shrd    $32,%rdi,%r15
	shrd    $32,%rsi,%rdi
	shrd    $32,%r8,%rsi

	addq    536(%rsp),%rbx
	adcq    %r10,%r9
	adcq    %r11,%rcx
	adcq    %r12,%rdx
	adcq    %r15,%rbp
	adcq    %rdi,%r13
	adcq    %rsi,%r14
	adcq    $0,%rax

	movq    %rax,%r12
	shlq    $32,%r12

	xorq    %r10,%r10
	addq    %rax,%rbx
	adcq    $0,%r9
	adcq    $0,%rcx
	adcq    %r12,%rdx
	adcq    $0,%rbp
	adcq    $0,%r13
	adcq    $0,%r14
	adcq    $0,%r10

	movq    %r10,%r15
	shlq    $32,%r15

	addq    %r10,%rbx
	adcq    $0,%r9
	adcq    $0,%rcx
	adcq    %r15,%rdx

	movq    %rbx,128(%rsp) 
	movq    %r9,136(%rsp)
	movq    %rcx,144(%rsp)
	movq    %rdx,152(%rsp)
	movq    %rbp,160(%rsp)
	movq    %r13,168(%rsp)
	movq    %r14,176(%rsp)

	movq    568(%rsp),%rbx
	addq    $56,%rbx
	movq    %rbx,568(%rsp)
	movb    296(%rsp),%cl
	addb    $1,%cl
	movb    %cl,296(%rsp)
	cmpb	$7,%cl
	jle     .L2

	movb    $0,296(%rsp)
	movq    64(%rsp),%rax
	movq    304(%rsp),%r15
	addq    $1,%r15
	movq    %r15,304(%rsp)
	cmpq	$55,%r15
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

	// T1 ← T1^2
	movq    312(%rsp),%rdx
	xorq    %r8,%r8
	    
	mulx    320(%rsp),%r9,%r10

	mulx    328(%rsp),%rcx,%r11
	adcx    %rcx,%r10

	mulx    336(%rsp),%rcx,%r12
	adcx    %rcx,%r11

	mulx    344(%rsp),%rcx,%r13
	adcx    %rcx,%r12

	mulx    352(%rsp),%rcx,%r14
	adcx    %rcx,%r13

	mulx    360(%rsp),%rcx,%r15
	adcx    %rcx,%r14
	adcx    %r8,%r15
	    
	movq    320(%rsp),%rdx
	xorq    %rdi,%rdi
	    
	mulx    328(%rsp),%rcx,%rbp
	adcx    %rcx,%r11
	adox    %rbp,%r12

	mulx    336(%rsp),%rcx,%rbp
	adcx    %rcx,%r12
	adox    %rbp,%r13

	mulx    344(%rsp),%rcx,%rbp
	adcx    %rcx,%r13
	adox    %rbp,%r14

	mulx    352(%rsp),%rcx,%rbp
	adcx    %rcx,%r14
	adox    %rbp,%r15

	mulx    360(%rsp),%rcx,%rbp
	adcx    %rcx,%r15
	adox    %rbp,%r8
	adcx    %rdi,%r8
	    
	movq    328(%rsp),%rdx
	xorq    %rbx,%rbx

	mulx    336(%rsp),%rcx,%rbp
	adcx    %rcx,%r13
	adox    %rbp,%r14

	mulx    344(%rsp),%rcx,%rbp
	adcx    %rcx,%r14
	adox    %rbp,%r15

	mulx    352(%rsp),%rcx,%rbp
	adcx    %rcx,%r15
	adox    %rbp,%r8

	mulx    360(%rsp),%rcx,%rbp
	adcx    %rcx,%r8
	adox    %rbp,%rdi
	adcx    %rbx,%rdi

	movq    %r11,536(%rsp)

	movq    336(%rsp),%rdx
	xorq    %r11,%r11

	mulx    344(%rsp),%rcx,%rbp
	adcx    %rcx,%r15
	adox    %rbp,%r8

	mulx    352(%rsp),%rcx,%rbp
	adcx    %rcx,%r8
	adox    %rbp,%rdi

	mulx    360(%rsp),%rcx,%rbp
	adcx    %rcx,%rdi
	adox    %rbp,%rbx
	adcx    %r11,%rbx

	movq    344(%rsp),%rdx
	xorq    %rax,%rax

	mulx    352(%rsp),%rcx,%rbp
	adcx    %rcx,%rdi
	adox    %rbp,%rbx

	mulx    360(%rsp),%rcx,%rbp
	adcx    %rcx,%rbx
	adox    %rbp,%r11
	adcx    %rax,%r11

	movq    352(%rsp),%rdx

	mulx    360(%rsp),%rcx,%rsi
	adcx    %rcx,%r11
	adcx    %rax,%rsi

	movq    536(%rsp),%rdx

	movq    $0,%rbp
	shld    $1,%rsi,%rbp
	shld    $1,%r11,%rsi
	shld    $1,%rbx,%r11
	shld    $1,%rdi,%rbx
	shld    $1,%r8,%rdi
	shld    $1,%r15,%r8
	shld    $1,%r14,%r15
	shld    $1,%r13,%r14
	shld    $1,%r12,%r13
	shld    $1,%rdx,%r12
	shld    $1,%r10,%rdx
	shld    $1,%r9,%r10
	shlq    $1,%r9

	movq    %rdx,536(%rsp)		
	movq    %r12,544(%rsp)
		  
	xorq    %rdx,%rdx
	movq    312(%rsp),%rdx
	mulx    %rdx,%r12,%rax
	adcx    %rax,%r9

	movq    320(%rsp),%rdx
	mulx    %rdx,%rcx,%rax
	adcx    %rcx,%r10
	adcx    536(%rsp),%rax
	movq    %rax,536(%rsp)

	movq    328(%rsp),%rdx
	mulx    %rdx,%rcx,%rax
	adcx    544(%rsp),%rcx
	adcx    %rax,%r13
	movq    %rcx,544(%rsp)

	movq    336(%rsp),%rdx
	mulx    %rdx,%rcx,%rax
	adcx    %rcx,%r14
	adcx    %rax,%r15

	movq    344(%rsp),%rdx
	mulx    %rdx,%rcx,%rax
	adcx    %rcx,%r8
	adcx    %rax,%rdi

	movq    352(%rsp),%rdx
	mulx    %rdx,%rcx,%rax
	adcx    %rcx,%rbx
	adcx    %rax,%r11

	movq    360(%rsp),%rdx
	mulx    %rdx,%rcx,%rax
	adcx    %rcx,%rsi
	adcx    %rax,%rbp

	movq    536(%rsp),%rcx
	movq    544(%rsp),%rdx

	xorq    %rax,%rax
	addq    %r15,%r12
	adcq    %r8,%r9
	adcq    %rdi,%r10
	adcq    %rbx,%rcx
	adcq    %r11,%rdx
	adcq    %rsi,%r13
	adcq    %rbp,%r14
	adcq    %rax,%rax
	    
	movq    %r12,536(%rsp)

	movq    %rbx,%r12
	andq    mask32h(%rip),%r12

	addq    %r12,%rcx
	adcq    %r11,%rdx
	adcq    %rsi,%r13
	adcq    %rbp,%r14
	adcq    $0,%rax

	movq    %rbx,%r12
	shrd    $32,%r11,%rbx
	shrd    $32,%rsi,%r11
	shrd    $32,%rbp,%rsi
	shrd    $32,%r15,%rbp
	shrd    $32,%r8,%r15
	shrd    $32,%rdi,%r8
	shrd    $32,%r12,%rdi

	addq    536(%rsp),%rbx
	adcq    %r11,%r9
	adcq    %rsi,%r10
	adcq    %rbp,%rcx
	adcq    %r15,%rdx
	adcq    %r8,%r13
	adcq    %rdi,%r14
	adcq    $0,%rax

	movq    %rax,%r12
	shlq    $32,%r12

	xorq    %r11,%r11
	addq    %rax,%rbx
	adcq    $0,%r9
	adcq    $0,%r10
	adcq    %r12,%rcx
	adcq    $0,%rdx
	adcq    $0,%r13
	adcq    $0,%r14
	adcq    $0,%r11

	movq    %r11,%r12
	shlq    $32,%r12

	addq    %r11,%rbx
	adcq    $0,%r9
	adcq    $0,%r10
	adcq    %r12,%rcx

	movq    %rbx,312(%rsp)
	movq    %r9,320(%rsp)
	movq    %r10,328(%rsp)
	movq    %rcx,336(%rsp)
	movq    %rdx,344(%rsp)
	movq    %r13,352(%rsp)
	movq    %r14,360(%rsp)

	// T3 ← T2^2
	movq    368(%rsp),%rdx
	xorq    %r8,%r8
	    
	mulx    376(%rsp),%r9,%r10

	mulx    384(%rsp),%rcx,%r11
	adcx    %rcx,%r10

	mulx    392(%rsp),%rcx,%r12
	adcx    %rcx,%r11

	mulx    400(%rsp),%rcx,%r13
	adcx    %rcx,%r12

	mulx    408(%rsp),%rcx,%r14
	adcx    %rcx,%r13

	mulx    416(%rsp),%rcx,%r15
	adcx    %rcx,%r14
	adcx    %r8,%r15
	    
	movq    376(%rsp),%rdx
	xorq    %rdi,%rdi
	    
	mulx    384(%rsp),%rcx,%rbp
	adcx    %rcx,%r11
	adox    %rbp,%r12

	mulx    392(%rsp),%rcx,%rbp
	adcx    %rcx,%r12
	adox    %rbp,%r13

	mulx    400(%rsp),%rcx,%rbp
	adcx    %rcx,%r13
	adox    %rbp,%r14

	mulx    408(%rsp),%rcx,%rbp
	adcx    %rcx,%r14
	adox    %rbp,%r15

	mulx    416(%rsp),%rcx,%rbp
	adcx    %rcx,%r15
	adox    %rbp,%r8
	adcx    %rdi,%r8
	    
	movq    384(%rsp),%rdx
	xorq    %rbx,%rbx

	mulx    392(%rsp),%rcx,%rbp
	adcx    %rcx,%r13
	adox    %rbp,%r14

	mulx    400(%rsp),%rcx,%rbp
	adcx    %rcx,%r14
	adox    %rbp,%r15

	mulx    408(%rsp),%rcx,%rbp
	adcx    %rcx,%r15
	adox    %rbp,%r8

	mulx    416(%rsp),%rcx,%rbp
	adcx    %rcx,%r8
	adox    %rbp,%rdi
	adcx    %rbx,%rdi

	movq    %r11,536(%rsp)

	movq    392(%rsp),%rdx
	xorq    %r11,%r11

	mulx    400(%rsp),%rcx,%rbp
	adcx    %rcx,%r15
	adox    %rbp,%r8

	mulx    408(%rsp),%rcx,%rbp
	adcx    %rcx,%r8
	adox    %rbp,%rdi

	mulx    416(%rsp),%rcx,%rbp
	adcx    %rcx,%rdi
	adox    %rbp,%rbx
	adcx    %r11,%rbx

	movq    400(%rsp),%rdx
	xorq    %rax,%rax

	mulx    408(%rsp),%rcx,%rbp
	adcx    %rcx,%rdi
	adox    %rbp,%rbx

	mulx    416(%rsp),%rcx,%rbp
	adcx    %rcx,%rbx
	adox    %rbp,%r11
	adcx    %rax,%r11

	movq    408(%rsp),%rdx

	mulx    416(%rsp),%rcx,%rsi
	adcx    %rcx,%r11
	adcx    %rax,%rsi

	movq    536(%rsp),%rdx

	movq    $0,%rbp
	shld    $1,%rsi,%rbp
	shld    $1,%r11,%rsi
	shld    $1,%rbx,%r11
	shld    $1,%rdi,%rbx
	shld    $1,%r8,%rdi
	shld    $1,%r15,%r8
	shld    $1,%r14,%r15
	shld    $1,%r13,%r14
	shld    $1,%r12,%r13
	shld    $1,%rdx,%r12
	shld    $1,%r10,%rdx
	shld    $1,%r9,%r10
	shlq    $1,%r9

	movq    %rdx,536(%rsp)		
	movq    %r12,544(%rsp)
		  
	xorq    %rdx,%rdx
	movq    368(%rsp),%rdx
	mulx    %rdx,%r12,%rax
	adcx    %rax,%r9

	movq    376(%rsp),%rdx
	mulx    %rdx,%rcx,%rax
	adcx    %rcx,%r10
	adcx    536(%rsp),%rax
	movq    %rax,536(%rsp)

	movq    384(%rsp),%rdx
	mulx    %rdx,%rcx,%rax
	adcx    544(%rsp),%rcx
	adcx    %rax,%r13
	movq    %rcx,544(%rsp)

	movq    392(%rsp),%rdx
	mulx    %rdx,%rcx,%rax
	adcx    %rcx,%r14
	adcx    %rax,%r15

	movq    400(%rsp),%rdx
	mulx    %rdx,%rcx,%rax
	adcx    %rcx,%r8
	adcx    %rax,%rdi

	movq    408(%rsp),%rdx
	mulx    %rdx,%rcx,%rax
	adcx    %rcx,%rbx
	adcx    %rax,%r11

	movq    416(%rsp),%rdx
	mulx    %rdx,%rcx,%rax
	adcx    %rcx,%rsi
	adcx    %rax,%rbp

	movq    536(%rsp),%rcx
	movq    544(%rsp),%rdx

	xorq    %rax,%rax
	addq    %r15,%r12
	adcq    %r8,%r9
	adcq    %rdi,%r10
	adcq    %rbx,%rcx
	adcq    %r11,%rdx
	adcq    %rsi,%r13
	adcq    %rbp,%r14
	adcq    %rax,%rax
	    
	movq    %r12,536(%rsp)

	movq    %rbx,%r12
	andq    mask32h(%rip),%r12

	addq    %r12,%rcx
	adcq    %r11,%rdx
	adcq    %rsi,%r13
	adcq    %rbp,%r14
	adcq    $0,%rax

	movq    %rbx,%r12
	shrd    $32,%r11,%rbx
	shrd    $32,%rsi,%r11
	shrd    $32,%rbp,%rsi
	shrd    $32,%r15,%rbp
	shrd    $32,%r8,%r15
	shrd    $32,%rdi,%r8
	shrd    $32,%r12,%rdi

	addq    536(%rsp),%rbx
	adcq    %r11,%r9
	adcq    %rsi,%r10
	adcq    %rbp,%rcx
	adcq    %r15,%rdx
	adcq    %r8,%r13
	adcq    %rdi,%r14
	adcq    $0,%rax

	movq    %rax,%r12
	shlq    $32,%r12

	xorq    %r11,%r11
	addq    %rax,%rbx
	adcq    $0,%r9
	adcq    $0,%r10
	adcq    %r12,%rcx
	adcq    $0,%rdx
	adcq    $0,%r13
	adcq    $0,%r14
	adcq    $0,%r11

	movq    %r11,%r12
	shlq    $32,%r12

	addq    %r11,%rbx
	adcq    $0,%r9
	adcq    $0,%r10
	adcq    %r12,%rcx

	movq    %rbx,424(%rsp)
	movq    %r9,432(%rsp)
	movq    %r10,440(%rsp)
	movq    %rcx,448(%rsp)
	movq    %rdx,456(%rsp)
	movq    %r13,464(%rsp)
	movq    %r14,472(%rsp)

	// T1
	movq    312(%rsp),%r8
	movq    320(%rsp),%r9
	movq    328(%rsp),%r10
	movq    336(%rsp),%r11
	movq    344(%rsp),%r12
	movq    352(%rsp),%r13
	movq    360(%rsp),%r14

	// T2 ← T1 - T3
	subq    424(%rsp),%r8
	sbbq    432(%rsp),%r9
	sbbq    440(%rsp),%r10
	sbbq    448(%rsp),%r11
	sbbq    456(%rsp),%r12
	sbbq    464(%rsp),%r13
	sbbq    472(%rsp),%r14
	movq    $0,%rcx
	adcq    $0,%rcx

	movq    %rcx,%r15
	shlq    $32,%r15

	subq    %rcx,%r8
	sbbq    $0,%r9
	sbbq    $0,%r10
	sbbq    %r15,%r11
	sbbq    $0,%r12
	sbbq    $0,%r13
	sbbq    $0,%r14
	movq    $0,%rcx
	adcq    $0,%rcx

	movq    %rcx,%r15
	shlq    $32,%r15

	subq    %rcx,%r8
	sbbq    $0,%r9
	sbbq    $0,%r10
	sbbq    %r15,%r11

	movq    %r8,368(%rsp)
	movq    %r9,376(%rsp)
	movq    %r10,384(%rsp)
	movq    %r11,392(%rsp)
	movq    %r12,400(%rsp)
	movq    %r13,408(%rsp)
	movq    %r14,416(%rsp)

	// T4 ← ((A + 2)/4) · T2
	xorq    %r15,%r15
	movq    a24(%rip),%rdx

	mulx    %r8,%r8,%rcx
	mulx    %r9,%r9,%rax
	adcx    %rcx,%r9

	mulx    %r10,%r10,%rcx
	adcx    %rax,%r10

	mulx    %r11,%r11,%rax
	adcx    %rcx,%r11

	mulx    %r12,%r12,%rcx
	adcx    %rax,%r12

	mulx    %r13,%r13,%rax
	adcx    %rcx,%r13

	mulx    %r14,%r14,%rcx
	adcx    %rax,%r14
	adcx    %rcx,%r15

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

	// T4 ← T4 + T3
	addq    424(%rsp),%r8
	adcq    432(%rsp),%r9
	adcq    440(%rsp),%r10
	adcq    448(%rsp),%r11
	adcq    456(%rsp),%r12
	adcq    464(%rsp),%r13
	adcq    472(%rsp),%r14
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

	// X2 ← T1 · T3
	xorq    %rdi,%rdi
	movq    312(%rsp),%rdx    

	mulx    424(%rsp),%r8,%r9
	mulx    432(%rsp),%rcx,%r10		
	adcx    %rcx,%r9

	mulx    440(%rsp),%rcx,%r11	
	adcx    %rcx,%r10

	mulx    448(%rsp),%rcx,%r12	
	adcx    %rcx,%r11

	mulx    456(%rsp),%rcx,%r13	
	adcx    %rcx,%r12

	mulx    464(%rsp),%rcx,%r14	
	adcx    %rcx,%r13

	mulx    472(%rsp),%rcx,%r15	
	adcx    %rcx,%r14
	adcx    %rdi,%r15

	xorq    %rdi,%rdi
	movq    320(%rsp),%rdx
	   
	mulx    424(%rsp),%rcx,%rbp
	adcx    %rcx,%r9
	adox    %rbp,%r10
	    
	mulx    432(%rsp),%rcx,%rbp
	adcx    %rcx,%r10
	adox    %rbp,%r11
	    
	mulx    440(%rsp),%rcx,%rbp
	adcx    %rcx,%r11
	adox    %rbp,%r12

	mulx    448(%rsp),%rcx,%rbp
	adcx    %rcx,%r12
	adox    %rbp,%r13

	mulx    456(%rsp),%rcx,%rbp
	adcx    %rcx,%r13
	adox    %rbp,%r14

	mulx    464(%rsp),%rcx,%rbp
	adcx    %rcx,%r14
	adox    %rbp,%r15
	    
	mulx    472(%rsp),%rcx,%rbp
	adcx    %rcx,%r15
	adox    %rbp,%rdi			
	adcq    $0,%rdi

	xorq    %rsi,%rsi
	movq    328(%rsp),%rdx
	    
	mulx    424(%rsp),%rcx,%rbp
	adcx    %rcx,%r10
	adox    %rbp,%r11
	    
	mulx    432(%rsp),%rcx,%rbp
	adcx    %rcx,%r11
	adox    %rbp,%r12
	    
	mulx    440(%rsp),%rcx,%rbp
	adcx    %rcx,%r12
	adox    %rbp,%r13

	mulx    448(%rsp),%rcx,%rbp
	adcx    %rcx,%r13
	adox    %rbp,%r14

	mulx    456(%rsp),%rcx,%rbp
	adcx    %rcx,%r14
	adox    %rbp,%r15

	mulx    464(%rsp),%rcx,%rbp
	adcx    %rcx,%r15
	adox    %rbp,%rdi
	    
	mulx    472(%rsp),%rcx,%rbp
	adcx    %rcx,%rdi
	adox    %rbp,%rsi
	adcq    $0,%rsi

	movq    %r10,536(%rsp)

	xorq    %rbx,%rbx
	movq    336(%rsp),%rdx
	    
	mulx    424(%rsp),%rcx,%rbp
	adcx    %rcx,%r11
	adox    %rbp,%r12
	    
	mulx    432(%rsp),%rcx,%rbp
	adcx    %rcx,%r12
	adox    %rbp,%r13
	    
	mulx    440(%rsp),%rcx,%rbp
	adcx    %rcx,%r13
	adox    %rbp,%r14

	mulx    448(%rsp),%rcx,%rbp
	adcx    %rcx,%r14
	adox    %rbp,%r15

	mulx    456(%rsp),%rcx,%rbp
	adcx    %rcx,%r15
	adox    %rbp,%rdi

	mulx    464(%rsp),%rcx,%rbp
	adcx    %rcx,%rdi
	adox    %rbp,%rsi
	    
	mulx    472(%rsp),%rcx,%rbp
	adcx    %rcx,%rsi
	adox    %rbp,%rbx			
	adcq    $0,%rbx

	movq    %r11,544(%rsp)

	xorq    %r10,%r10
	movq    344(%rsp),%rdx
	    
	mulx    424(%rsp),%rcx,%rbp
	adcx    %rcx,%r12
	adox    %rbp,%r13
	    
	mulx    432(%rsp),%rcx,%rbp
	adcx    %rcx,%r13
	adox    %rbp,%r14
	    
	mulx    440(%rsp),%rcx,%rbp
	adcx    %rcx,%r14
	adox    %rbp,%r15

	mulx    448(%rsp),%rcx,%rbp
	adcx    %rcx,%r15
	adox    %rbp,%rdi

	mulx    456(%rsp),%rcx,%rbp
	adcx    %rcx,%rdi
	adox    %rbp,%rsi

	mulx    464(%rsp),%rcx,%rbp
	adcx    %rcx,%rsi
	adox    %rbp,%rbx
	    
	mulx    472(%rsp),%rcx,%rbp
	adcx    %rcx,%rbx
	adox    %rbp,%r10			
	adcq    $0,%r10

	movq    %r12,552(%rsp)

	xorq    %r11,%r11
	movq    352(%rsp),%rdx
	    
	mulx    424(%rsp),%rcx,%rbp
	adcx    %rcx,%r13
	adox    %rbp,%r14
	    
	mulx    432(%rsp),%rcx,%rbp
	adcx    %rcx,%r14
	adox    %rbp,%r15
	    
	mulx    440(%rsp),%rcx,%rbp
	adcx    %rcx,%r15
	adox    %rbp,%rdi

	mulx    448(%rsp),%rcx,%rbp
	adcx    %rcx,%rdi
	adox    %rbp,%rsi

	mulx    456(%rsp),%rcx,%rbp
	adcx    %rcx,%rsi
	adox    %rbp,%rbx

	mulx    464(%rsp),%rcx,%rbp
	adcx    %rcx,%rbx
	adox    %rbp,%r10
	    
	mulx    472(%rsp),%rcx,%rbp
	adcx    %rcx,%r10
	adox    %rbp,%r11			
	adcq    $0,%r11

	xorq    %r12,%r12
	movq    360(%rsp),%rdx
	    
	mulx    424(%rsp),%rcx,%rbp
	adcx    %rcx,%r14
	adox    %rbp,%r15
	    
	mulx    432(%rsp),%rcx,%rbp
	adcx    %rcx,%r15
	adox    %rbp,%rdi
	    
	mulx    440(%rsp),%rcx,%rbp
	adcx    %rcx,%rdi
	adox    %rbp,%rsi

	mulx    448(%rsp),%rcx,%rbp
	adcx    %rcx,%rsi
	adox    %rbp,%rbx

	mulx    456(%rsp),%rcx,%rbp
	adcx    %rcx,%rbx
	adox    %rbp,%r10

	mulx    464(%rsp),%rcx,%rbp
	adcx    %rcx,%r10
	adox    %rbp,%r11
	    
	mulx    472(%rsp),%rcx,%rbp
	adcx    %rcx,%r11
	adox    %rbp,%r12			
	adcq    $0,%r12

	movq    536(%rsp),%rcx
	movq    544(%rsp),%rdx
	movq    552(%rsp),%rbp

	xorq    %rax,%rax
	addq    %r15,%r8
	adcq    %rdi,%r9
	adcq    %rsi,%rcx
	adcq    %rbx,%rdx
	adcq    %r10,%rbp
	adcq    %r11,%r13
	adcq    %r12,%r14
	adcq    %rax,%rax

	movq    %r8,536(%rsp)

	movq    %rbx,%r8
	andq    mask32h(%rip),%r8

	addq    %r8,%rdx
	adcq    %r10,%rbp
	adcq    %r11,%r13
	adcq    %r12,%r14
	adcq    $0,%rax

	movq    %rbx,%r8
	shrd    $32,%r10,%rbx
	shrd    $32,%r11,%r10
	shrd    $32,%r12,%r11
	shrd    $32,%r15,%r12
	shrd    $32,%rdi,%r15
	shrd    $32,%rsi,%rdi
	shrd    $32,%r8,%rsi

	addq    536(%rsp),%rbx
	adcq    %r10,%r9
	adcq    %r11,%rcx
	adcq    %r12,%rdx
	adcq    %r15,%rbp
	adcq    %rdi,%r13
	adcq    %rsi,%r14
	adcq    $0,%rax

	movq    %rax,%r12
	shlq    $32,%r12

	xorq    %r10,%r10
	addq    %rax,%rbx
	adcq    $0,%r9
	adcq    $0,%rcx
	adcq    %r12,%rdx
	adcq    $0,%rbp
	adcq    $0,%r13
	adcq    $0,%r14
	adcq    $0,%r10

	movq    %r10,%r15
	shlq    $32,%r15

	addq    %r10,%rbx
	adcq    $0,%r9
	adcq    $0,%rcx
	adcq    %r15,%rdx

	movq    %rbx,72(%rsp) 
	movq    %r9,80(%rsp)
	movq    %rcx,88(%rsp)
	movq    %rdx,96(%rsp)
	movq    %rbp,104(%rsp)
	movq    %r13,112(%rsp)
	movq    %r14,120(%rsp)

	// Z2 ← T2 · T4
	xorq    %rdi,%rdi
	movq    480(%rsp),%rdx    

	mulx    368(%rsp),%r8,%r9
	mulx    376(%rsp),%rcx,%r10		
	adcx    %rcx,%r9

	mulx    384(%rsp),%rcx,%r11	
	adcx    %rcx,%r10

	mulx    392(%rsp),%rcx,%r12	
	adcx    %rcx,%r11

	mulx    400(%rsp),%rcx,%r13	
	adcx    %rcx,%r12

	mulx    408(%rsp),%rcx,%r14	
	adcx    %rcx,%r13

	mulx    416(%rsp),%rcx,%r15	
	adcx    %rcx,%r14
	adcx    %rdi,%r15

	xorq    %rdi,%rdi
	movq    488(%rsp),%rdx
	   
	mulx    368(%rsp),%rcx,%rbp
	adcx    %rcx,%r9
	adox    %rbp,%r10
	    
	mulx    376(%rsp),%rcx,%rbp
	adcx    %rcx,%r10
	adox    %rbp,%r11
	    
	mulx    384(%rsp),%rcx,%rbp
	adcx    %rcx,%r11
	adox    %rbp,%r12

	mulx    392(%rsp),%rcx,%rbp
	adcx    %rcx,%r12
	adox    %rbp,%r13

	mulx    400(%rsp),%rcx,%rbp
	adcx    %rcx,%r13
	adox    %rbp,%r14

	mulx    408(%rsp),%rcx,%rbp
	adcx    %rcx,%r14
	adox    %rbp,%r15
	    
	mulx    416(%rsp),%rcx,%rbp
	adcx    %rcx,%r15
	adox    %rbp,%rdi			
	adcq    $0,%rdi

	xorq    %rsi,%rsi
	movq    496(%rsp),%rdx
	    
	mulx    368(%rsp),%rcx,%rbp
	adcx    %rcx,%r10
	adox    %rbp,%r11
	    
	mulx    376(%rsp),%rcx,%rbp
	adcx    %rcx,%r11
	adox    %rbp,%r12
	    
	mulx    384(%rsp),%rcx,%rbp
	adcx    %rcx,%r12
	adox    %rbp,%r13

	mulx    392(%rsp),%rcx,%rbp
	adcx    %rcx,%r13
	adox    %rbp,%r14

	mulx    400(%rsp),%rcx,%rbp
	adcx    %rcx,%r14
	adox    %rbp,%r15

	mulx    408(%rsp),%rcx,%rbp
	adcx    %rcx,%r15
	adox    %rbp,%rdi
	    
	mulx    416(%rsp),%rcx,%rbp
	adcx    %rcx,%rdi
	adox    %rbp,%rsi
	adcq    $0,%rsi

	movq    %r10,536(%rsp)

	xorq    %rbx,%rbx
	movq    504(%rsp),%rdx
	    
	mulx    368(%rsp),%rcx,%rbp
	adcx    %rcx,%r11
	adox    %rbp,%r12
	    
	mulx    376(%rsp),%rcx,%rbp
	adcx    %rcx,%r12
	adox    %rbp,%r13
	    
	mulx    384(%rsp),%rcx,%rbp
	adcx    %rcx,%r13
	adox    %rbp,%r14

	mulx    392(%rsp),%rcx,%rbp
	adcx    %rcx,%r14
	adox    %rbp,%r15

	mulx    400(%rsp),%rcx,%rbp
	adcx    %rcx,%r15
	adox    %rbp,%rdi

	mulx    408(%rsp),%rcx,%rbp
	adcx    %rcx,%rdi
	adox    %rbp,%rsi
	    
	mulx    416(%rsp),%rcx,%rbp
	adcx    %rcx,%rsi
	adox    %rbp,%rbx			
	adcq    $0,%rbx

	movq    %r11,544(%rsp)

	xorq    %r10,%r10
	movq    512(%rsp),%rdx
	    
	mulx    368(%rsp),%rcx,%rbp
	adcx    %rcx,%r12
	adox    %rbp,%r13
	    
	mulx    376(%rsp),%rcx,%rbp
	adcx    %rcx,%r13
	adox    %rbp,%r14
	    
	mulx    384(%rsp),%rcx,%rbp
	adcx    %rcx,%r14
	adox    %rbp,%r15

	mulx    392(%rsp),%rcx,%rbp
	adcx    %rcx,%r15
	adox    %rbp,%rdi

	mulx    400(%rsp),%rcx,%rbp
	adcx    %rcx,%rdi
	adox    %rbp,%rsi

	mulx    408(%rsp),%rcx,%rbp
	adcx    %rcx,%rsi
	adox    %rbp,%rbx
	    
	mulx    416(%rsp),%rcx,%rbp
	adcx    %rcx,%rbx
	adox    %rbp,%r10			
	adcq    $0,%r10

	movq    %r12,552(%rsp)

	xorq    %r11,%r11
	movq    520(%rsp),%rdx
	    
	mulx    368(%rsp),%rcx,%rbp
	adcx    %rcx,%r13
	adox    %rbp,%r14
	    
	mulx    376(%rsp),%rcx,%rbp
	adcx    %rcx,%r14
	adox    %rbp,%r15
	    
	mulx    384(%rsp),%rcx,%rbp
	adcx    %rcx,%r15
	adox    %rbp,%rdi

	mulx    392(%rsp),%rcx,%rbp
	adcx    %rcx,%rdi
	adox    %rbp,%rsi

	mulx    400(%rsp),%rcx,%rbp
	adcx    %rcx,%rsi
	adox    %rbp,%rbx

	mulx    408(%rsp),%rcx,%rbp
	adcx    %rcx,%rbx
	adox    %rbp,%r10
	    
	mulx    416(%rsp),%rcx,%rbp
	adcx    %rcx,%r10
	adox    %rbp,%r11			
	adcq    $0,%r11

	xorq    %r12,%r12
	movq    528(%rsp),%rdx
	    
	mulx    368(%rsp),%rcx,%rbp
	adcx    %rcx,%r14
	adox    %rbp,%r15
	    
	mulx    376(%rsp),%rcx,%rbp
	adcx    %rcx,%r15
	adox    %rbp,%rdi
	    
	mulx    384(%rsp),%rcx,%rbp
	adcx    %rcx,%rdi
	adox    %rbp,%rsi

	mulx    392(%rsp),%rcx,%rbp
	adcx    %rcx,%rsi
	adox    %rbp,%rbx

	mulx    400(%rsp),%rcx,%rbp
	adcx    %rcx,%rbx
	adox    %rbp,%r10

	mulx    408(%rsp),%rcx,%rbp
	adcx    %rcx,%r10
	adox    %rbp,%r11
	    
	mulx    416(%rsp),%rcx,%rbp
	adcx    %rcx,%r11
	adox    %rbp,%r12			
	adcq    $0,%r12

	movq    536(%rsp),%rcx
	movq    544(%rsp),%rdx
	movq    552(%rsp),%rbp

	xorq    %rax,%rax
	addq    %r15,%r8
	adcq    %rdi,%r9
	adcq    %rsi,%rcx
	adcq    %rbx,%rdx
	adcq    %r10,%rbp
	adcq    %r11,%r13
	adcq    %r12,%r14
	adcq    %rax,%rax

	movq    %r8,536(%rsp)

	movq    %rbx,%r8
	andq    mask32h(%rip),%r8

	addq    %r8,%rdx
	adcq    %r10,%rbp
	adcq    %r11,%r13
	adcq    %r12,%r14
	adcq    $0,%rax

	movq    %rbx,%r8
	shrd    $32,%r10,%rbx
	shrd    $32,%r11,%r10
	shrd    $32,%r12,%r11
	shrd    $32,%r15,%r12
	shrd    $32,%rdi,%r15
	shrd    $32,%rsi,%rdi
	shrd    $32,%r8,%rsi

	addq    536(%rsp),%rbx
	adcq    %r10,%r9
	adcq    %r11,%rcx
	adcq    %r12,%rdx
	adcq    %r15,%rbp
	adcq    %rdi,%r13
	adcq    %rsi,%r14
	adcq    $0,%rax

	movq    %rax,%r12
	shlq    $32,%r12

	xorq    %r10,%r10
	addq    %rax,%rbx
	adcq    $0,%r9
	adcq    $0,%rcx
	adcq    %r12,%rdx
	adcq    $0,%rbp
	adcq    $0,%r13
	adcq    $0,%r14
	adcq    $0,%r10

	movq    %r10,%r15
	shlq    $32,%r15

	addq    %r10,%rbx
	adcq    $0,%r9
	adcq    $0,%rcx
	adcq    %r15,%rdx

	movq    %rbx,128(%rsp) 
	movq    %r9,136(%rsp)
	movq    %rcx,144(%rsp)
	movq    %rdx,152(%rsp)
	movq    %rbp,160(%rsp)
	movq    %r13,168(%rsp)
	movq    %r14,176(%rsp)

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

	// T1 ← T1^2
	movq    312(%rsp),%rdx
	xorq    %r8,%r8
	    
	mulx    320(%rsp),%r9,%r10

	mulx    328(%rsp),%rcx,%r11
	adcx    %rcx,%r10

	mulx    336(%rsp),%rcx,%r12
	adcx    %rcx,%r11

	mulx    344(%rsp),%rcx,%r13
	adcx    %rcx,%r12

	mulx    352(%rsp),%rcx,%r14
	adcx    %rcx,%r13

	mulx    360(%rsp),%rcx,%r15
	adcx    %rcx,%r14
	adcx    %r8,%r15
	    
	movq    320(%rsp),%rdx
	xorq    %rdi,%rdi
	    
	mulx    328(%rsp),%rcx,%rbp
	adcx    %rcx,%r11
	adox    %rbp,%r12

	mulx    336(%rsp),%rcx,%rbp
	adcx    %rcx,%r12
	adox    %rbp,%r13

	mulx    344(%rsp),%rcx,%rbp
	adcx    %rcx,%r13
	adox    %rbp,%r14

	mulx    352(%rsp),%rcx,%rbp
	adcx    %rcx,%r14
	adox    %rbp,%r15

	mulx    360(%rsp),%rcx,%rbp
	adcx    %rcx,%r15
	adox    %rbp,%r8
	adcx    %rdi,%r8
	    
	movq    328(%rsp),%rdx
	xorq    %rbx,%rbx

	mulx    336(%rsp),%rcx,%rbp
	adcx    %rcx,%r13
	adox    %rbp,%r14

	mulx    344(%rsp),%rcx,%rbp
	adcx    %rcx,%r14
	adox    %rbp,%r15

	mulx    352(%rsp),%rcx,%rbp
	adcx    %rcx,%r15
	adox    %rbp,%r8

	mulx    360(%rsp),%rcx,%rbp
	adcx    %rcx,%r8
	adox    %rbp,%rdi
	adcx    %rbx,%rdi

	movq    %r11,536(%rsp)

	movq    336(%rsp),%rdx
	xorq    %r11,%r11

	mulx    344(%rsp),%rcx,%rbp
	adcx    %rcx,%r15
	adox    %rbp,%r8

	mulx    352(%rsp),%rcx,%rbp
	adcx    %rcx,%r8
	adox    %rbp,%rdi

	mulx    360(%rsp),%rcx,%rbp
	adcx    %rcx,%rdi
	adox    %rbp,%rbx
	adcx    %r11,%rbx

	movq    344(%rsp),%rdx
	xorq    %rax,%rax

	mulx    352(%rsp),%rcx,%rbp
	adcx    %rcx,%rdi
	adox    %rbp,%rbx

	mulx    360(%rsp),%rcx,%rbp
	adcx    %rcx,%rbx
	adox    %rbp,%r11
	adcx    %rax,%r11

	movq    352(%rsp),%rdx

	mulx    360(%rsp),%rcx,%rsi
	adcx    %rcx,%r11
	adcx    %rax,%rsi

	movq    536(%rsp),%rdx

	movq    $0,%rbp
	shld    $1,%rsi,%rbp
	shld    $1,%r11,%rsi
	shld    $1,%rbx,%r11
	shld    $1,%rdi,%rbx
	shld    $1,%r8,%rdi
	shld    $1,%r15,%r8
	shld    $1,%r14,%r15
	shld    $1,%r13,%r14
	shld    $1,%r12,%r13
	shld    $1,%rdx,%r12
	shld    $1,%r10,%rdx
	shld    $1,%r9,%r10
	shlq    $1,%r9

	movq    %rdx,536(%rsp)		
	movq    %r12,544(%rsp)
		  
	xorq    %rdx,%rdx
	movq    312(%rsp),%rdx
	mulx    %rdx,%r12,%rax
	adcx    %rax,%r9

	movq    320(%rsp),%rdx
	mulx    %rdx,%rcx,%rax
	adcx    %rcx,%r10
	adcx    536(%rsp),%rax
	movq    %rax,536(%rsp)

	movq    328(%rsp),%rdx
	mulx    %rdx,%rcx,%rax
	adcx    544(%rsp),%rcx
	adcx    %rax,%r13
	movq    %rcx,544(%rsp)

	movq    336(%rsp),%rdx
	mulx    %rdx,%rcx,%rax
	adcx    %rcx,%r14
	adcx    %rax,%r15

	movq    344(%rsp),%rdx
	mulx    %rdx,%rcx,%rax
	adcx    %rcx,%r8
	adcx    %rax,%rdi

	movq    352(%rsp),%rdx
	mulx    %rdx,%rcx,%rax
	adcx    %rcx,%rbx
	adcx    %rax,%r11

	movq    360(%rsp),%rdx
	mulx    %rdx,%rcx,%rax
	adcx    %rcx,%rsi
	adcx    %rax,%rbp

	movq    536(%rsp),%rcx
	movq    544(%rsp),%rdx

	xorq    %rax,%rax
	addq    %r15,%r12
	adcq    %r8,%r9
	adcq    %rdi,%r10
	adcq    %rbx,%rcx
	adcq    %r11,%rdx
	adcq    %rsi,%r13
	adcq    %rbp,%r14
	adcq    %rax,%rax
	    
	movq    %r12,536(%rsp)

	movq    %rbx,%r12
	andq    mask32h(%rip),%r12

	addq    %r12,%rcx
	adcq    %r11,%rdx
	adcq    %rsi,%r13
	adcq    %rbp,%r14
	adcq    $0,%rax

	movq    %rbx,%r12
	shrd    $32,%r11,%rbx
	shrd    $32,%rsi,%r11
	shrd    $32,%rbp,%rsi
	shrd    $32,%r15,%rbp
	shrd    $32,%r8,%r15
	shrd    $32,%rdi,%r8
	shrd    $32,%r12,%rdi

	addq    536(%rsp),%rbx
	adcq    %r11,%r9
	adcq    %rsi,%r10
	adcq    %rbp,%rcx
	adcq    %r15,%rdx
	adcq    %r8,%r13
	adcq    %rdi,%r14
	adcq    $0,%rax

	movq    %rax,%r12
	shlq    $32,%r12

	xorq    %r11,%r11
	addq    %rax,%rbx
	adcq    $0,%r9
	adcq    $0,%r10
	adcq    %r12,%rcx
	adcq    $0,%rdx
	adcq    $0,%r13
	adcq    $0,%r14
	adcq    $0,%r11

	movq    %r11,%r12
	shlq    $32,%r12

	addq    %r11,%rbx
	adcq    $0,%r9
	adcq    $0,%r10
	adcq    %r12,%rcx

	movq    %rbx,312(%rsp)
	movq    %r9,320(%rsp)
	movq    %r10,328(%rsp)
	movq    %rcx,336(%rsp)
	movq    %rdx,344(%rsp)
	movq    %r13,352(%rsp)
	movq    %r14,360(%rsp)

	// T3 ← T2^2
	movq    368(%rsp),%rdx
	xorq    %r8,%r8
	    
	mulx    376(%rsp),%r9,%r10

	mulx    384(%rsp),%rcx,%r11
	adcx    %rcx,%r10

	mulx    392(%rsp),%rcx,%r12
	adcx    %rcx,%r11

	mulx    400(%rsp),%rcx,%r13
	adcx    %rcx,%r12

	mulx    408(%rsp),%rcx,%r14
	adcx    %rcx,%r13

	mulx    416(%rsp),%rcx,%r15
	adcx    %rcx,%r14
	adcx    %r8,%r15
	    
	movq    376(%rsp),%rdx
	xorq    %rdi,%rdi
	    
	mulx    384(%rsp),%rcx,%rbp
	adcx    %rcx,%r11
	adox    %rbp,%r12

	mulx    392(%rsp),%rcx,%rbp
	adcx    %rcx,%r12
	adox    %rbp,%r13

	mulx    400(%rsp),%rcx,%rbp
	adcx    %rcx,%r13
	adox    %rbp,%r14

	mulx    408(%rsp),%rcx,%rbp
	adcx    %rcx,%r14
	adox    %rbp,%r15

	mulx    416(%rsp),%rcx,%rbp
	adcx    %rcx,%r15
	adox    %rbp,%r8
	adcx    %rdi,%r8
	    
	movq    384(%rsp),%rdx
	xorq    %rbx,%rbx

	mulx    392(%rsp),%rcx,%rbp
	adcx    %rcx,%r13
	adox    %rbp,%r14

	mulx    400(%rsp),%rcx,%rbp
	adcx    %rcx,%r14
	adox    %rbp,%r15

	mulx    408(%rsp),%rcx,%rbp
	adcx    %rcx,%r15
	adox    %rbp,%r8

	mulx    416(%rsp),%rcx,%rbp
	adcx    %rcx,%r8
	adox    %rbp,%rdi
	adcx    %rbx,%rdi

	movq    %r11,536(%rsp)

	movq    392(%rsp),%rdx
	xorq    %r11,%r11

	mulx    400(%rsp),%rcx,%rbp
	adcx    %rcx,%r15
	adox    %rbp,%r8

	mulx    408(%rsp),%rcx,%rbp
	adcx    %rcx,%r8
	adox    %rbp,%rdi

	mulx    416(%rsp),%rcx,%rbp
	adcx    %rcx,%rdi
	adox    %rbp,%rbx
	adcx    %r11,%rbx

	movq    400(%rsp),%rdx
	xorq    %rax,%rax

	mulx    408(%rsp),%rcx,%rbp
	adcx    %rcx,%rdi
	adox    %rbp,%rbx

	mulx    416(%rsp),%rcx,%rbp
	adcx    %rcx,%rbx
	adox    %rbp,%r11
	adcx    %rax,%r11

	movq    408(%rsp),%rdx

	mulx    416(%rsp),%rcx,%rsi
	adcx    %rcx,%r11
	adcx    %rax,%rsi

	movq    536(%rsp),%rdx

	movq    $0,%rbp
	shld    $1,%rsi,%rbp
	shld    $1,%r11,%rsi
	shld    $1,%rbx,%r11
	shld    $1,%rdi,%rbx
	shld    $1,%r8,%rdi
	shld    $1,%r15,%r8
	shld    $1,%r14,%r15
	shld    $1,%r13,%r14
	shld    $1,%r12,%r13
	shld    $1,%rdx,%r12
	shld    $1,%r10,%rdx
	shld    $1,%r9,%r10
	shlq    $1,%r9

	movq    %rdx,536(%rsp)		
	movq    %r12,544(%rsp)
		  
	xorq    %rdx,%rdx
	movq    368(%rsp),%rdx
	mulx    %rdx,%r12,%rax
	adcx    %rax,%r9

	movq    376(%rsp),%rdx
	mulx    %rdx,%rcx,%rax
	adcx    %rcx,%r10
	adcx    536(%rsp),%rax
	movq    %rax,536(%rsp)

	movq    384(%rsp),%rdx
	mulx    %rdx,%rcx,%rax
	adcx    544(%rsp),%rcx
	adcx    %rax,%r13
	movq    %rcx,544(%rsp)

	movq    392(%rsp),%rdx
	mulx    %rdx,%rcx,%rax
	adcx    %rcx,%r14
	adcx    %rax,%r15

	movq    400(%rsp),%rdx
	mulx    %rdx,%rcx,%rax
	adcx    %rcx,%r8
	adcx    %rax,%rdi

	movq    408(%rsp),%rdx
	mulx    %rdx,%rcx,%rax
	adcx    %rcx,%rbx
	adcx    %rax,%r11

	movq    416(%rsp),%rdx
	mulx    %rdx,%rcx,%rax
	adcx    %rcx,%rsi
	adcx    %rax,%rbp

	movq    536(%rsp),%rcx
	movq    544(%rsp),%rdx

	xorq    %rax,%rax
	addq    %r15,%r12
	adcq    %r8,%r9
	adcq    %rdi,%r10
	adcq    %rbx,%rcx
	adcq    %r11,%rdx
	adcq    %rsi,%r13
	adcq    %rbp,%r14
	adcq    %rax,%rax
	    
	movq    %r12,536(%rsp)

	movq    %rbx,%r12
	andq    mask32h(%rip),%r12

	addq    %r12,%rcx
	adcq    %r11,%rdx
	adcq    %rsi,%r13
	adcq    %rbp,%r14
	adcq    $0,%rax

	movq    %rbx,%r12
	shrd    $32,%r11,%rbx
	shrd    $32,%rsi,%r11
	shrd    $32,%rbp,%rsi
	shrd    $32,%r15,%rbp
	shrd    $32,%r8,%r15
	shrd    $32,%rdi,%r8
	shrd    $32,%r12,%rdi

	addq    536(%rsp),%rbx
	adcq    %r11,%r9
	adcq    %rsi,%r10
	adcq    %rbp,%rcx
	adcq    %r15,%rdx
	adcq    %r8,%r13
	adcq    %rdi,%r14
	adcq    $0,%rax

	movq    %rax,%r12
	shlq    $32,%r12

	xorq    %r11,%r11
	addq    %rax,%rbx
	adcq    $0,%r9
	adcq    $0,%r10
	adcq    %r12,%rcx
	adcq    $0,%rdx
	adcq    $0,%r13
	adcq    $0,%r14
	adcq    $0,%r11

	movq    %r11,%r12
	shlq    $32,%r12

	addq    %r11,%rbx
	adcq    $0,%r9
	adcq    $0,%r10
	adcq    %r12,%rcx

	movq    %rbx,424(%rsp)
	movq    %r9,432(%rsp)
	movq    %r10,440(%rsp)
	movq    %rcx,448(%rsp)
	movq    %rdx,456(%rsp)
	movq    %r13,464(%rsp)
	movq    %r14,472(%rsp)

	// T1
	movq    312(%rsp),%r8
	movq    320(%rsp),%r9
	movq    328(%rsp),%r10
	movq    336(%rsp),%r11
	movq    344(%rsp),%r12
	movq    352(%rsp),%r13
	movq    360(%rsp),%r14

	// T2 ← T1 - T3
	subq    424(%rsp),%r8
	sbbq    432(%rsp),%r9
	sbbq    440(%rsp),%r10
	sbbq    448(%rsp),%r11
	sbbq    456(%rsp),%r12
	sbbq    464(%rsp),%r13
	sbbq    472(%rsp),%r14
	movq    $0,%rcx
	adcq    $0,%rcx

	movq    %rcx,%r15
	shlq    $32,%r15

	subq    %rcx,%r8
	sbbq    $0,%r9
	sbbq    $0,%r10
	sbbq    %r15,%r11
	sbbq    $0,%r12
	sbbq    $0,%r13
	sbbq    $0,%r14
	movq    $0,%rcx
	adcq    $0,%rcx

	movq    %rcx,%r15
	shlq    $32,%r15

	subq    %rcx,%r8
	sbbq    $0,%r9
	sbbq    $0,%r10
	sbbq    %r15,%r11

	movq    %r8,368(%rsp)
	movq    %r9,376(%rsp)
	movq    %r10,384(%rsp)
	movq    %r11,392(%rsp)
	movq    %r12,400(%rsp)
	movq    %r13,408(%rsp)
	movq    %r14,416(%rsp)

	// T4 ← ((A + 2)/4) · T2
	xorq    %r15,%r15
	movq    a24(%rip),%rdx

	mulx    %r8,%r8,%rcx
	mulx    %r9,%r9,%rax
	adcx    %rcx,%r9

	mulx    %r10,%r10,%rcx
	adcx    %rax,%r10

	mulx    %r11,%r11,%rax
	adcx    %rcx,%r11

	mulx    %r12,%r12,%rcx
	adcx    %rax,%r12

	mulx    %r13,%r13,%rax
	adcx    %rcx,%r13

	mulx    %r14,%r14,%rcx
	adcx    %rax,%r14
	adcx    %rcx,%r15

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

	// T4 ← T4 + T3
	addq    424(%rsp),%r8
	adcq    432(%rsp),%r9
	adcq    440(%rsp),%r10
	adcq    448(%rsp),%r11
	adcq    456(%rsp),%r12
	adcq    464(%rsp),%r13
	adcq    472(%rsp),%r14
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

	// X2 ← T1 · T3
	xorq    %rdi,%rdi
	movq    312(%rsp),%rdx    

	mulx    424(%rsp),%r8,%r9
	mulx    432(%rsp),%rcx,%r10		
	adcx    %rcx,%r9

	mulx    440(%rsp),%rcx,%r11	
	adcx    %rcx,%r10

	mulx    448(%rsp),%rcx,%r12	
	adcx    %rcx,%r11

	mulx    456(%rsp),%rcx,%r13	
	adcx    %rcx,%r12

	mulx    464(%rsp),%rcx,%r14	
	adcx    %rcx,%r13

	mulx    472(%rsp),%rcx,%r15	
	adcx    %rcx,%r14
	adcx    %rdi,%r15

	xorq    %rdi,%rdi
	movq    320(%rsp),%rdx
	   
	mulx    424(%rsp),%rcx,%rbp
	adcx    %rcx,%r9
	adox    %rbp,%r10
	    
	mulx    432(%rsp),%rcx,%rbp
	adcx    %rcx,%r10
	adox    %rbp,%r11
	    
	mulx    440(%rsp),%rcx,%rbp
	adcx    %rcx,%r11
	adox    %rbp,%r12

	mulx    448(%rsp),%rcx,%rbp
	adcx    %rcx,%r12
	adox    %rbp,%r13

	mulx    456(%rsp),%rcx,%rbp
	adcx    %rcx,%r13
	adox    %rbp,%r14

	mulx    464(%rsp),%rcx,%rbp
	adcx    %rcx,%r14
	adox    %rbp,%r15
	    
	mulx    472(%rsp),%rcx,%rbp
	adcx    %rcx,%r15
	adox    %rbp,%rdi			
	adcq    $0,%rdi

	xorq    %rsi,%rsi
	movq    328(%rsp),%rdx
	    
	mulx    424(%rsp),%rcx,%rbp
	adcx    %rcx,%r10
	adox    %rbp,%r11
	    
	mulx    432(%rsp),%rcx,%rbp
	adcx    %rcx,%r11
	adox    %rbp,%r12
	    
	mulx    440(%rsp),%rcx,%rbp
	adcx    %rcx,%r12
	adox    %rbp,%r13

	mulx    448(%rsp),%rcx,%rbp
	adcx    %rcx,%r13
	adox    %rbp,%r14

	mulx    456(%rsp),%rcx,%rbp
	adcx    %rcx,%r14
	adox    %rbp,%r15

	mulx    464(%rsp),%rcx,%rbp
	adcx    %rcx,%r15
	adox    %rbp,%rdi
	    
	mulx    472(%rsp),%rcx,%rbp
	adcx    %rcx,%rdi
	adox    %rbp,%rsi
	adcq    $0,%rsi

	movq    %r10,536(%rsp)

	xorq    %rbx,%rbx
	movq    336(%rsp),%rdx
	    
	mulx    424(%rsp),%rcx,%rbp
	adcx    %rcx,%r11
	adox    %rbp,%r12
	    
	mulx    432(%rsp),%rcx,%rbp
	adcx    %rcx,%r12
	adox    %rbp,%r13
	    
	mulx    440(%rsp),%rcx,%rbp
	adcx    %rcx,%r13
	adox    %rbp,%r14

	mulx    448(%rsp),%rcx,%rbp
	adcx    %rcx,%r14
	adox    %rbp,%r15

	mulx    456(%rsp),%rcx,%rbp
	adcx    %rcx,%r15
	adox    %rbp,%rdi

	mulx    464(%rsp),%rcx,%rbp
	adcx    %rcx,%rdi
	adox    %rbp,%rsi
	    
	mulx    472(%rsp),%rcx,%rbp
	adcx    %rcx,%rsi
	adox    %rbp,%rbx			
	adcq    $0,%rbx

	movq    %r11,544(%rsp)

	xorq    %r10,%r10
	movq    344(%rsp),%rdx
	    
	mulx    424(%rsp),%rcx,%rbp
	adcx    %rcx,%r12
	adox    %rbp,%r13
	    
	mulx    432(%rsp),%rcx,%rbp
	adcx    %rcx,%r13
	adox    %rbp,%r14
	    
	mulx    440(%rsp),%rcx,%rbp
	adcx    %rcx,%r14
	adox    %rbp,%r15

	mulx    448(%rsp),%rcx,%rbp
	adcx    %rcx,%r15
	adox    %rbp,%rdi

	mulx    456(%rsp),%rcx,%rbp
	adcx    %rcx,%rdi
	adox    %rbp,%rsi

	mulx    464(%rsp),%rcx,%rbp
	adcx    %rcx,%rsi
	adox    %rbp,%rbx
	    
	mulx    472(%rsp),%rcx,%rbp
	adcx    %rcx,%rbx
	adox    %rbp,%r10			
	adcq    $0,%r10

	movq    %r12,552(%rsp)

	xorq    %r11,%r11
	movq    352(%rsp),%rdx
	    
	mulx    424(%rsp),%rcx,%rbp
	adcx    %rcx,%r13
	adox    %rbp,%r14
	    
	mulx    432(%rsp),%rcx,%rbp
	adcx    %rcx,%r14
	adox    %rbp,%r15
	    
	mulx    440(%rsp),%rcx,%rbp
	adcx    %rcx,%r15
	adox    %rbp,%rdi

	mulx    448(%rsp),%rcx,%rbp
	adcx    %rcx,%rdi
	adox    %rbp,%rsi

	mulx    456(%rsp),%rcx,%rbp
	adcx    %rcx,%rsi
	adox    %rbp,%rbx

	mulx    464(%rsp),%rcx,%rbp
	adcx    %rcx,%rbx
	adox    %rbp,%r10
	    
	mulx    472(%rsp),%rcx,%rbp
	adcx    %rcx,%r10
	adox    %rbp,%r11			
	adcq    $0,%r11

	xorq    %r12,%r12
	movq    360(%rsp),%rdx
	    
	mulx    424(%rsp),%rcx,%rbp
	adcx    %rcx,%r14
	adox    %rbp,%r15
	    
	mulx    432(%rsp),%rcx,%rbp
	adcx    %rcx,%r15
	adox    %rbp,%rdi
	    
	mulx    440(%rsp),%rcx,%rbp
	adcx    %rcx,%rdi
	adox    %rbp,%rsi

	mulx    448(%rsp),%rcx,%rbp
	adcx    %rcx,%rsi
	adox    %rbp,%rbx

	mulx    456(%rsp),%rcx,%rbp
	adcx    %rcx,%rbx
	adox    %rbp,%r10

	mulx    464(%rsp),%rcx,%rbp
	adcx    %rcx,%r10
	adox    %rbp,%r11
	    
	mulx    472(%rsp),%rcx,%rbp
	adcx    %rcx,%r11
	adox    %rbp,%r12			
	adcq    $0,%r12

	movq    536(%rsp),%rcx
	movq    544(%rsp),%rdx
	movq    552(%rsp),%rbp

	xorq    %rax,%rax
	addq    %r15,%r8
	adcq    %rdi,%r9
	adcq    %rsi,%rcx
	adcq    %rbx,%rdx
	adcq    %r10,%rbp
	adcq    %r11,%r13
	adcq    %r12,%r14
	adcq    %rax,%rax

	movq    %r8,536(%rsp)

	movq    %rbx,%r8
	andq    mask32h(%rip),%r8

	addq    %r8,%rdx
	adcq    %r10,%rbp
	adcq    %r11,%r13
	adcq    %r12,%r14
	adcq    $0,%rax

	movq    %rbx,%r8
	shrd    $32,%r10,%rbx
	shrd    $32,%r11,%r10
	shrd    $32,%r12,%r11
	shrd    $32,%r15,%r12
	shrd    $32,%rdi,%r15
	shrd    $32,%rsi,%rdi
	shrd    $32,%r8,%rsi

	addq    536(%rsp),%rbx
	adcq    %r10,%r9
	adcq    %r11,%rcx
	adcq    %r12,%rdx
	adcq    %r15,%rbp
	adcq    %rdi,%r13
	adcq    %rsi,%r14
	adcq    $0,%rax

	movq    %rax,%r12
	shlq    $32,%r12

	xorq    %r10,%r10
	addq    %rax,%rbx
	adcq    $0,%r9
	adcq    $0,%rcx
	adcq    %r12,%rdx
	adcq    $0,%rbp
	adcq    $0,%r13
	adcq    $0,%r14
	adcq    $0,%r10

	movq    %r10,%r15
	shlq    $32,%r15

	addq    %r10,%rbx
	adcq    $0,%r9
	adcq    $0,%rcx
	adcq    %r15,%rdx

	// update X2
	movq    %rbx,72(%rsp) 
	movq    %r9,80(%rsp)
	movq    %rcx,88(%rsp)
	movq    %rdx,96(%rsp)
	movq    %rbp,104(%rsp)
	movq    %r13,112(%rsp)
	movq    %r14,120(%rsp)

	// Z2 ← T2 · T4
	xorq    %rdi,%rdi
	movq    480(%rsp),%rdx    

	mulx    368(%rsp),%r8,%r9
	mulx    376(%rsp),%rcx,%r10		
	adcx    %rcx,%r9

	mulx    384(%rsp),%rcx,%r11	
	adcx    %rcx,%r10

	mulx    392(%rsp),%rcx,%r12	
	adcx    %rcx,%r11

	mulx    400(%rsp),%rcx,%r13	
	adcx    %rcx,%r12

	mulx    408(%rsp),%rcx,%r14	
	adcx    %rcx,%r13

	mulx    416(%rsp),%rcx,%r15	
	adcx    %rcx,%r14
	adcx    %rdi,%r15

	xorq    %rdi,%rdi
	movq    488(%rsp),%rdx
	   
	mulx    368(%rsp),%rcx,%rbp
	adcx    %rcx,%r9
	adox    %rbp,%r10
	    
	mulx    376(%rsp),%rcx,%rbp
	adcx    %rcx,%r10
	adox    %rbp,%r11
	    
	mulx    384(%rsp),%rcx,%rbp
	adcx    %rcx,%r11
	adox    %rbp,%r12

	mulx    392(%rsp),%rcx,%rbp
	adcx    %rcx,%r12
	adox    %rbp,%r13

	mulx    400(%rsp),%rcx,%rbp
	adcx    %rcx,%r13
	adox    %rbp,%r14

	mulx    408(%rsp),%rcx,%rbp
	adcx    %rcx,%r14
	adox    %rbp,%r15
	    
	mulx    416(%rsp),%rcx,%rbp
	adcx    %rcx,%r15
	adox    %rbp,%rdi			
	adcq    $0,%rdi

	xorq    %rsi,%rsi
	movq    496(%rsp),%rdx
	    
	mulx    368(%rsp),%rcx,%rbp
	adcx    %rcx,%r10
	adox    %rbp,%r11
	    
	mulx    376(%rsp),%rcx,%rbp
	adcx    %rcx,%r11
	adox    %rbp,%r12
	    
	mulx    384(%rsp),%rcx,%rbp
	adcx    %rcx,%r12
	adox    %rbp,%r13

	mulx    392(%rsp),%rcx,%rbp
	adcx    %rcx,%r13
	adox    %rbp,%r14

	mulx    400(%rsp),%rcx,%rbp
	adcx    %rcx,%r14
	adox    %rbp,%r15

	mulx    408(%rsp),%rcx,%rbp
	adcx    %rcx,%r15
	adox    %rbp,%rdi
	    
	mulx    416(%rsp),%rcx,%rbp
	adcx    %rcx,%rdi
	adox    %rbp,%rsi
	adcq    $0,%rsi

	movq    %r10,536(%rsp)

	xorq    %rbx,%rbx
	movq    504(%rsp),%rdx
	    
	mulx    368(%rsp),%rcx,%rbp
	adcx    %rcx,%r11
	adox    %rbp,%r12
	    
	mulx    376(%rsp),%rcx,%rbp
	adcx    %rcx,%r12
	adox    %rbp,%r13
	    
	mulx    384(%rsp),%rcx,%rbp
	adcx    %rcx,%r13
	adox    %rbp,%r14

	mulx    392(%rsp),%rcx,%rbp
	adcx    %rcx,%r14
	adox    %rbp,%r15

	mulx    400(%rsp),%rcx,%rbp
	adcx    %rcx,%r15
	adox    %rbp,%rdi

	mulx    408(%rsp),%rcx,%rbp
	adcx    %rcx,%rdi
	adox    %rbp,%rsi
	    
	mulx    416(%rsp),%rcx,%rbp
	adcx    %rcx,%rsi
	adox    %rbp,%rbx			
	adcq    $0,%rbx

	movq    %r11,544(%rsp)

	xorq    %r10,%r10
	movq    512(%rsp),%rdx
	    
	mulx    368(%rsp),%rcx,%rbp
	adcx    %rcx,%r12
	adox    %rbp,%r13
	    
	mulx    376(%rsp),%rcx,%rbp
	adcx    %rcx,%r13
	adox    %rbp,%r14
	    
	mulx    384(%rsp),%rcx,%rbp
	adcx    %rcx,%r14
	adox    %rbp,%r15

	mulx    392(%rsp),%rcx,%rbp
	adcx    %rcx,%r15
	adox    %rbp,%rdi

	mulx    400(%rsp),%rcx,%rbp
	adcx    %rcx,%rdi
	adox    %rbp,%rsi

	mulx    408(%rsp),%rcx,%rbp
	adcx    %rcx,%rsi
	adox    %rbp,%rbx
	    
	mulx    416(%rsp),%rcx,%rbp
	adcx    %rcx,%rbx
	adox    %rbp,%r10			
	adcq    $0,%r10

	movq    %r12,552(%rsp)

	xorq    %r11,%r11
	movq    520(%rsp),%rdx
	    
	mulx    368(%rsp),%rcx,%rbp
	adcx    %rcx,%r13
	adox    %rbp,%r14
	    
	mulx    376(%rsp),%rcx,%rbp
	adcx    %rcx,%r14
	adox    %rbp,%r15
	    
	mulx    384(%rsp),%rcx,%rbp
	adcx    %rcx,%r15
	adox    %rbp,%rdi

	mulx    392(%rsp),%rcx,%rbp
	adcx    %rcx,%rdi
	adox    %rbp,%rsi

	mulx    400(%rsp),%rcx,%rbp
	adcx    %rcx,%rsi
	adox    %rbp,%rbx

	mulx    408(%rsp),%rcx,%rbp
	adcx    %rcx,%rbx
	adox    %rbp,%r10
	    
	mulx    416(%rsp),%rcx,%rbp
	adcx    %rcx,%r10
	adox    %rbp,%r11			
	adcq    $0,%r11

	xorq    %r12,%r12
	movq    528(%rsp),%rdx
	    
	mulx    368(%rsp),%rcx,%rbp
	adcx    %rcx,%r14
	adox    %rbp,%r15
	    
	mulx    376(%rsp),%rcx,%rbp
	adcx    %rcx,%r15
	adox    %rbp,%rdi
	    
	mulx    384(%rsp),%rcx,%rbp
	adcx    %rcx,%rdi
	adox    %rbp,%rsi

	mulx    392(%rsp),%rcx,%rbp
	adcx    %rcx,%rsi
	adox    %rbp,%rbx

	mulx    400(%rsp),%rcx,%rbp
	adcx    %rcx,%rbx
	adox    %rbp,%r10

	mulx    408(%rsp),%rcx,%rbp
	adcx    %rcx,%r10
	adox    %rbp,%r11
	    
	mulx    416(%rsp),%rcx,%rbp
	adcx    %rcx,%r11
	adox    %rbp,%r12			
	adcq    $0,%r12

	movq    536(%rsp),%rcx
	movq    544(%rsp),%rdx
	movq    552(%rsp),%rbp

	xorq    %rax,%rax
	addq    %r15,%r8
	adcq    %rdi,%r9
	adcq    %rsi,%rcx
	adcq    %rbx,%rdx
	adcq    %r10,%rbp
	adcq    %r11,%r13
	adcq    %r12,%r14
	adcq    %rax,%rax

	movq    %r8,536(%rsp)

	movq    %rbx,%r8
	andq    mask32h(%rip),%r8

	addq    %r8,%rdx
	adcq    %r10,%rbp
	adcq    %r11,%r13
	adcq    %r12,%r14
	adcq    $0,%rax

	movq    %rbx,%r8
	shrd    $32,%r10,%rbx
	shrd    $32,%r11,%r10
	shrd    $32,%r12,%r11
	shrd    $32,%r15,%r12
	shrd    $32,%rdi,%r15
	shrd    $32,%rsi,%rdi
	shrd    $32,%r8,%rsi

	addq    536(%rsp),%rbx
	adcq    %r10,%r9
	adcq    %r11,%rcx
	adcq    %r12,%rdx
	adcq    %r15,%rbp
	adcq    %rdi,%r13
	adcq    %rsi,%r14
	adcq    $0,%rax

	movq    %rax,%r12
	shlq    $32,%r12

	xorq    %r10,%r10
	addq    %rax,%rbx
	adcq    $0,%r9
	adcq    $0,%rcx
	adcq    %r12,%rdx
	adcq    $0,%rbp
	adcq    $0,%r13
	adcq    $0,%r14
	adcq    $0,%r10

	movq    %r10,%r15
	shlq    $32,%r15

	addq    %r10,%rbx
	adcq    $0,%r9
	adcq    $0,%rcx
	adcq    %r15,%rdx

	// update Z2
	movq    %rbx,128(%rsp) 
	movq    %r9,136(%rsp)
	movq    %rcx,144(%rsp)
	movq    %rdx,152(%rsp)
	movq    %rbp,160(%rsp)
	movq    %r13,168(%rsp)
	movq    %r14,176(%rsp)

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
