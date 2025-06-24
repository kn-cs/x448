## Reduction Modulo 2^{448}-2^{224}-1

This is the source code repository of the work [Reduction Modulo 2^{448}-2^{224}-1](https://journals.flvc.org/mathcryptology/article/view/123700/127683), authored by [Kaushik Nath](kaushik.nath@yahoo.in) & [Palash Sarkar](palash@isical.ac.in) of [Indian Statistical Institute, Kolkata, India](https://www.isical.ac.in),
containing the 7-limb 64-bit implementations of X448. All the implementations of Montgomery ladder are developed using 64-bit assembly language targeting the modern Intel architectures like Skylake and Haswell.

To report a bug or make a comment regarding the implementations please drop a mail to: [Kaushik Nath](kaushik.nath@yahoo.in).

---

### Compilation and execution of programs 
    
* Please compile the ```makefile``` in the **test** directory and execute the generated executable file. 
* Installation of the library [libcpucycles](https://cpucycles.cr.yp.to/) is required to record the timing.
---

### Overview of the implementations in the repository

* **intel64-maax-7limb**: 7-limb 64-bit assembly implementation of X448 using the instructions ```mulx/adcx/adox```.
* **intel64-mxaa-7limb**: 7-limb 64-bit assembly implementation of X448 using the instructions ```mulx/add/adc```.

---    
