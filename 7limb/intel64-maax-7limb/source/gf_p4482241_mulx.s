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
	.globl gfp4482241mulx
	
gfp4482241mulx:

	movq    %rsp,%r11
	andq    $-32,%rsp	
	subq    $104,%rsp

	movq    %r11,0(%rsp)
	movq    %r12,8(%rsp)
	movq    %r13,16(%rsp)
	movq    %r14,24(%rsp)
	movq    %r15,32(%rsp)
	movq    %rbp,40(%rsp)
	movq    %rbx,48(%rsp)
	movq    %rdi,56(%rsp)
	    
	movq    %rdx,%rbx
	    
	xorq    %rdi,%rdi
	movq    0(%rbx),%rdx    

	mulx    0(%rsi),%r8,%r9
	mulx    8(%rsi),%rcx,%r10		
	adcx    %rcx,%r9

	mulx    16(%rsi),%rcx,%r11	
	adcx    %rcx,%r10

	mulx    24(%rsi),%rcx,%r12	
	adcx    %rcx,%r11

	mulx    32(%rsi),%rcx,%r13	
	adcx    %rcx,%r12

	mulx    40(%rsi),%rcx,%r14	
	adcx    %rcx,%r13

	mulx    48(%rsi),%rcx,%r15	
	adcx    %rcx,%r14
	adcx    %rdi,%r15

	movq    %r8,64(%rsp)

	xorq    %rdi,%rdi

	movq    8(%rbx),%rdx
	   
	mulx    0(%rsi),%rcx,%rbp
	adcx    %rcx,%r9
	adox    %rbp,%r10
	    
	mulx    8(%rsi),%rcx,%rbp
	adcx    %rcx,%r10
	adox    %rbp,%r11
	    
	mulx    16(%rsi),%rcx,%rbp
	adcx    %rcx,%r11
	adox    %rbp,%r12

	mulx    24(%rsi),%rcx,%rbp
	adcx    %rcx,%r12
	adox    %rbp,%r13

	mulx    32(%rsi),%rcx,%rbp
	adcx    %rcx,%r13
	adox    %rbp,%r14

	mulx    40(%rsi),%rcx,%rbp
	adcx    %rcx,%r14
	adox    %rbp,%r15
	    
	mulx    48(%rsi),%rcx,%rbp
	adcx    %rcx,%r15
	adox    %rbp,%rdi			
	adcq    $0,%rdi

	movq    %r9,72(%rsp)

	xorq    %r8,%r8
	movq    16(%rbx),%rdx
	    
	mulx    0(%rsi),%rcx,%rbp
	adcx    %rcx,%r10
	adox    %rbp,%r11
	    
	mulx    8(%rsi),%rcx,%rbp
	adcx    %rcx,%r11
	adox    %rbp,%r12
	    
	mulx    16(%rsi),%rcx,%rbp
	adcx    %rcx,%r12
	adox    %rbp,%r13

	mulx    24(%rsi),%rcx,%rbp
	adcx    %rcx,%r13
	adox    %rbp,%r14

	mulx    32(%rsi),%rcx,%rbp
	adcx    %rcx,%r14
	adox    %rbp,%r15

	mulx    40(%rsi),%rcx,%rbp
	adcx    %rcx,%r15
	adox    %rbp,%rdi
	    
	mulx    48(%rsi),%rcx,%rbp
	adcx    %rcx,%rdi
	adox    %rbp,%r8
	adcq    $0,%r8

	movq    %r10,80(%rsp)

	xorq    %r9,%r9
	movq    24(%rbx),%rdx
	    
	mulx    0(%rsi),%rcx,%rbp
	adcx    %rcx,%r11
	adox    %rbp,%r12
	    
	mulx    8(%rsi),%rcx,%rbp
	adcx    %rcx,%r12
	adox    %rbp,%r13
	    
	mulx    16(%rsi),%rcx,%rbp
	adcx    %rcx,%r13
	adox    %rbp,%r14

	mulx    24(%rsi),%rcx,%rbp
	adcx    %rcx,%r14
	adox    %rbp,%r15

	mulx    32(%rsi),%rcx,%rbp
	adcx    %rcx,%r15
	adox    %rbp,%rdi

	mulx    40(%rsi),%rcx,%rbp
	adcx    %rcx,%rdi
	adox    %rbp,%r8
	    
	mulx    48(%rsi),%rcx,%rbp
	adcx    %rcx,%r8
	adox    %rbp,%r9			
	adcq    $0,%r9

	movq    %r11,88(%rsp)

	xorq    %r10,%r10
	movq    32(%rbx),%rdx
	    
	mulx    0(%rsi),%rcx,%rbp
	adcx    %rcx,%r12
	adox    %rbp,%r13
	    
	mulx    8(%rsi),%rcx,%rbp
	adcx    %rcx,%r13
	adox    %rbp,%r14
	    
	mulx    16(%rsi),%rcx,%rbp
	adcx    %rcx,%r14
	adox    %rbp,%r15

	mulx    24(%rsi),%rcx,%rbp
	adcx    %rcx,%r15
	adox    %rbp,%rdi

	mulx    32(%rsi),%rcx,%rbp
	adcx    %rcx,%rdi
	adox    %rbp,%r8

	mulx    40(%rsi),%rcx,%rbp
	adcx    %rcx,%r8
	adox    %rbp,%r9
	    
	mulx    48(%rsi),%rcx,%rbp
	adcx    %rcx,%r9
	adox    %rbp,%r10			
	adcq    $0,%r10

	movq    %r12,96(%rsp)

	xorq    %r11,%r11
	movq    40(%rbx),%rdx
	    
	mulx    0(%rsi),%rcx,%rbp
	adcx    %rcx,%r13
	adox    %rbp,%r14
	    
	mulx    8(%rsi),%rcx,%rbp
	adcx    %rcx,%r14
	adox    %rbp,%r15
	    
	mulx    16(%rsi),%rcx,%rbp
	adcx    %rcx,%r15
	adox    %rbp,%rdi

	mulx    24(%rsi),%rcx,%rbp
	adcx    %rcx,%rdi
	adox    %rbp,%r8

	mulx    32(%rsi),%rcx,%rbp
	adcx    %rcx,%r8
	adox    %rbp,%r9

	mulx    40(%rsi),%rcx,%rbp
	adcx    %rcx,%r9
	adox    %rbp,%r10
	    
	mulx    48(%rsi),%rcx,%rbp
	adcx    %rcx,%r10
	adox    %rbp,%r11			
	adcq    $0,%r11

	xorq    %r12,%r12
	movq    48(%rbx),%rdx
	    
	mulx    0(%rsi),%rcx,%rbp
	adcx    %rcx,%r14
	adox    %rbp,%r15
	    
	mulx    8(%rsi),%rcx,%rbp
	adcx    %rcx,%r15
	adox    %rbp,%rdi
	    
	mulx    16(%rsi),%rcx,%rbp
	adcx    %rcx,%rdi
	adox    %rbp,%r8

	mulx    24(%rsi),%rcx,%rbp
	adcx    %rcx,%r8
	adox    %rbp,%r9

	mulx    32(%rsi),%rcx,%rbp
	adcx    %rcx,%r9
	adox    %rbp,%r10

	mulx    40(%rsi),%rcx,%rbp
	adcx    %rcx,%r10
	adox    %rbp,%r11
	    
	mulx    48(%rsi),%rcx,%rbp
	adcx    %rcx,%r11
	adox    %rbp,%r12			
	adcq    $0,%r12

	movq    64(%rsp),%rax
	movq    72(%rsp),%rbx
	movq    80(%rsp),%rcx
	movq    88(%rsp),%rdx
	movq    96(%rsp),%rbp

	xorq    %rsi,%rsi
	addq    %r15,%rax
	adcq    %rdi,%rbx
	adcq    %r8,%rcx
	adcq    %r9,%rdx
	adcq    %r10,%rbp
	adcq    %r11,%r13
	adcq    %r12,%r14
	adcq    %rsi,%rsi
	 
	movq    %rax,64(%rsp)

	movq    %r9,%rax
	andq    mask32h(%rip),%rax

	addq    %rax,%rdx
	adcq    %r10,%rbp
	adcq    %r11,%r13
	adcq    %r12,%r14
	adcq    $0,%rsi

	movq    %r9,%rax
	shrd    $32,%r10,%r9
	shrd    $32,%r11,%r10
	shrd    $32,%r12,%r11
	shrd    $32,%r15,%r12
	shrd    $32,%rdi,%r15
	shrd    $32,%r8,%rdi
	shrd    $32,%rax,%r8

	addq    64(%rsp),%r9  
	adcq    %r10,%rbx
	adcq    %r11,%rcx
	adcq    %r12,%rdx
	adcq    %r15,%rbp
	adcq    %rdi,%r13
	adcq    %r8,%r14
	adcq    $0,%rsi

	movq    %rsi,%r12
	shlq    $32,%r12
	    
	xorq    %r11,%r11
	addq    %rsi,%r9
	adcq    $0,%rbx
	adcq    $0,%rcx
	adcq    %r12,%rdx
	adcq    $0,%rbp
	adcq    $0,%r13
	adcq    $0,%r14
	adcq    $0,%r11

	movq    %r11,%r10
	shlq    $32,%r10

	addq    %r11,%r9
	adcq    $0,%rbx
	adcq    $0,%rcx
	adcq    %r10,%rdx
	  
	movq    56(%rsp),%rdi

	movq    %r9,0(%rdi)
	movq    %rbx,8(%rdi)
	movq    %rcx,16(%rdi)
	movq    %rdx,24(%rdi)
	movq    %rbp,32(%rdi)
	movq    %r13,40(%rdi)
	movq    %r14,48(%rdi)

	movq    0(%rsp),%r11
	movq    8(%rsp),%r12
	movq    16(%rsp),%r13
	movq    24(%rsp),%r14
	movq    32(%rsp),%r15
	movq    40(%rsp),%rbp
	movq    48(%rsp),%rbx

	movq    %r11,%rsp
	 
	ret
