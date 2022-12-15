# R CMD check results

## Test environments
- R-hub ubuntu-gcc-devel (r-devel)
- R-hub windows-x86_64-release (r-release)

## R CMD check results
❯ On ubuntu-gcc-devel (r-devel)
  checking examples ... [20s/36s] NOTE
  Examples with CPU (user + system) or elapsed time > 5s
                   user system elapsed
  bind_tf_idf2    6.501  0.084  12.221
  collapse_tokens 3.451  0.081   6.298

❯ On ubuntu-gcc-devel (r-devel)
  checking HTML version of manual ... NOTE
  Skipping checking HTML validation: no command 'tidy' found

0 errors ✔ | 0 warnings ✔ | 2 notes ✖

- To suppress the first note, I reduced the volume of sample data that used in examples.

# revdepcheck results

- There are no downstream dependencies for this package.
