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
	.globl gfp4482241nsqr
	
gfp4482241nsqr:

	movq 	%rsp,%r11
	andq    $-32,%rsp	
	subq 	$96,%rsp

	movq 	%r11,0(%rsp)
	movq 	%r12,8(%rsp)
	movq 	%r13,16(%rsp)
	movq 	%r14,24(%rsp)
	movq 	%r15,32(%rsp)
	movq 	%rbp,40(%rsp)
	movq 	%rbx,48(%rsp)
	movq 	%rdi,56(%rsp)

	movq 	 0(%rsi),%r8	
	movq 	 8(%rsi),%r9	
	movq 	16(%rsi),%r10	
	movq 	24(%rsi),%r11
	movq 	32(%rsi),%r12
	movq 	40(%rsi),%r13
	movq 	48(%rsi),%r14

	movq 	%r8,0(%rdi)
	movq 	%r9,8(%rdi)
	movq 	%r10,16(%rdi)
	movq 	%r11,24(%rdi)
	movq 	%r12,32(%rdi)
	movq 	%r13,40(%rdi)
	movq 	%r14,48(%rdi)

	mov  	%rdx,%rcx

.L:
	subq  	$1,%rcx
	movq 	%rcx,88(%rsp)

	movq    0(%rdi),%rdx
	    
	mulx    8(%rdi),%r9,%r10

	mulx    16(%rdi),%rcx,%r11
	addq    %rcx,%r10

	mulx    24(%rdi),%rcx,%r12
	adcq    %rcx,%r11

	mulx    32(%rdi),%rcx,%r13
	adcq    %rcx,%r12

	mulx    40(%rdi),%rcx,%r14
	adcq    %rcx,%r13

	mulx    48(%rdi),%rcx,%r15
	adcq    %rcx,%r14
	adcq    $0,%r15

	movq    8(%rdi),%rdx

	mulx    16(%rdi),%rax,%rbx

	mulx    24(%rdi),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    32(%rdi),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    40(%rdi),%rcx,%r8
	adcq    %rcx,%rsi

	mulx    48(%rdi),%rdx,%rcx
	adcq    %rdx,%r8
	adcq    $0,%rcx

	addq    %rax,%r11
	adcq    %rbx,%r12
	adcq    %rbp,%r13
	adcq    %rsi,%r14
	adcq    %r8,%r15
	adcq    $0,%rcx

	movq    16(%rdi),%rdx

	mulx    24(%rdi),%rax,%rbx

	mulx    32(%rdi),%r8,%rbp
	addq    %r8,%rbx

	mulx    40(%rdi),%r8,%rsi
	adcq    %r8,%rbp

	mulx    48(%rdi),%rdx,%r8
	adcq    %rdx,%rsi
	adcq    $0,%r8

	addq    %rax,%r13
	adcq    %rbx,%r14
	adcq    %rbp,%r15
	adcq    %rsi,%rcx
	adcq    $0,%r8

	movq    24(%rdi),%rdx

	mulx    32(%rdi),%rax,%rbx

	mulx    40(%rdi),%rsi,%rbp
	addq    %rsi,%rbx

	mulx    48(%rdi),%rdx,%rsi
	adcq    %rdx,%rbp
	adcq    $0,%rsi

	addq    %rax,%r15
	adcq    %rbx,%rcx
	adcq    %rbp,%r8
	adcq    $0,%rsi

	movq    32(%rdi),%rdx

	mulx    40(%rdi),%rax,%rbx

	mulx    48(%rdi),%rdx,%rbp
	addq    %rdx,%rbx
	adcq    $0,%rbp

	addq    %rax,%r8
	adcq    %rbx,%rsi
	adcq    $0,%rbp

	movq    40(%rdi),%rdx

	mulx    48(%rdi),%rax,%rbx

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

	movq    %r9,64(%rsp)
	movq    %r10,72(%rsp)
	movq    %r11,80(%rsp)

	movq    0(%rdi),%rdx
	mulx    %rdx,%r11,%r10
	addq    64(%rsp),%r10
	movq    %r10,64(%rsp)

	movq    8(%rdi),%rdx
	mulx    %rdx,%r9,%r10
	adcq    72(%rsp),%r9
	adcq    80(%rsp),%r10
	movq    %r9,72(%rsp)
	movq    %r10,80(%rsp)

	movq    16(%rdi),%rdx
	mulx    %rdx,%r9,%r10
	adcq    %r9,%r12
	adcq    %r10,%r13

	movq    24(%rdi),%rdx
	mulx    %rdx,%r9,%r10
	adcq    %r9,%r14
	adcq    %r10,%r15

	movq    32(%rdi),%rdx
	mulx    %rdx,%r9,%r10
	adcq    %r9,%rcx
	adcq    %r10,%r8

	movq    40(%rdi),%rdx
	mulx    %rdx,%r9,%r10
	adcq    %r9,%rsi
	adcq    %r10,%rbp

	movq    48(%rdi),%rdx
	mulx    %rdx,%r9,%r10
	adcq    %r9,%rbx
	adcq    %r10,%rax

	movq    64(%rsp),%r9
	movq    72(%rsp),%rdx
	movq    80(%rsp),%r10

	xorq    %rdi,%rdi
	addq    %r15,%r11
	adcq    %rcx,%r9
	adcq    %r8,%rdx
	adcq    %rsi,%r10
	adcq    %rbp,%r12
	adcq    %rbx,%r13
	adcq    %rax,%r14
	adcq    $0,%rdi
	    
	movq    %r11,64(%rsp)

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

	addq    64(%rsp),%rsi
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

	movq    56(%rsp),%rdi

	movq    %rsi,0(%rdi)
	movq    %r9,8(%rdi)
	movq    %rdx,16(%rdi)
	movq    %r10,24(%rdi)
	movq    %r12,32(%rdi)
	movq    %r13,40(%rdi)
	movq    %r14,48(%rdi)

	movq 	88(%rsp),%rcx
	cmpq    $0,%rcx
	


	jne     .L
.LAST:
	movq 	 0(%rsp),%r11
	movq 	 8(%rsp),%r12
	movq 	16(%rsp),%r13
	movq 	24(%rsp),%r14
	movq 	32(%rsp),%r15
	movq 	40(%rsp),%rbp
	movq 	48(%rsp),%rbx

	movq 	%r11,%rsp

	ret
