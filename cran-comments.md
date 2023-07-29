## Test environments
- R-hub ubuntu-gcc-devel (r-devel)
- R-hub windows-x86_64-release (r-release)

## R CMD check results
❯ On ubuntu-gcc-devel (r-devel)
  checking HTML version of manual ... NOTE
  Skipping checking HTML validation: no command 'tidy' found

❯ On windows-x86_64-release (r-release)
  checking for non-standard things in the check directory ... NOTE
  Found the following files/directories:
    ''NULL''

❯ On windows-x86_64-release (r-release)
  checking for detritus in the temp directory ... NOTE
  Found the following files/directories:
    'lastMiKTeXException'

0 errors | 0 warnings | 3 notes

## revdepcheck results
We checked 1 reverse dependencies (1 from CRAN + 0 from Bioconductor), comparing R CMD check results across CRAN and dev versions of this package.

 * We saw 0 new problems
 * We failed to check 0 packages
