## 8-limb 64-bit assembly implementation of X448

The source code of this directory correspond to the work [Security and Efficiency Trade-offs for Elliptic Curve Diffie-Hellman
at the 128-bit and 224-bit Security Levels](https://eprint.iacr.org/2019/1259), authored by [Kaushik Nath](kaushik.nath@yahoo.in) & [Palash Sarkar](palash@isical.ac.in) of [Indian Statistical Institute, Kolkata, India](https://www.isical.ac.in),
containing the 8-limb 64-bit implementation of X448. 

To report a bug or make a comment regarding the implementations please drop a mail to: [Kaushik Nath](kaushik.nath@yahoo.in).

---

### Compilation and execution of programs 
    
* Please compile the ```makefile``` in the **test** directory and execute the generated executable file. 
* Installation of the library [libcpucycles](https://cpucycles.cr.yp.to/) is required to record the timing.
---

### Overview of the implementation in the repository

* **intel64-maa-8limb**: 8-limb 64-bit assembly implementation of X448 using the instructions ```mul/add/adc```.


---    
