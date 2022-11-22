#### Try to pin to date just before next Bioc came out
Rversion <- 4.1
pkgs <- installed.packages(paste0(
    '/system/linux/lib/R-20.04/', Rversion, '/x86_64/site-library'))
all_bioc_pkgs <- available.packages(repos = 'https://bioconductor.org/packages/3.13/bioc')
all_cran_pkgs <- available.packages(repos = 'https://mran.microsoft.com/snapshot/2021-06-03')
inbioc <- pkgs[,'Package'] %in% all_bioc_pkgs[,'Package']
incran <- pkgs[,'Package'] %in% all_cran_pkgs[,'Package']
bioc_pkgs <- as.data.frame(pkgs[inbioc, c('Package','Version')])
cran_pkgs <- as.data.frame(pkgs[incran, c('Package','Version')])

install_skip <- c('Rmosek', 'iplots', 'NMF')
## NMF requires Biobase and will get installed as part of bioc
install_update <- c('matrixStats')
## need later matrixStats (0.60.1 from 2021-08-23) for newer (1.4.3) MatrixGenerics that Bioconductor 3.13 installs now (as of 2021-06-03 it was installing 1.4.0)
install_later <- c('ggm')

bioc_pkgs <- rbind(cran_pkgs['NMF', ], bioc_pkgs)

## Note that the 'Version' column is not actually used when we create the image, as we rely on the MRAN snapshot date and the Bioc version to control that.

cran_pkgs <- cran_pkgs[!cran_pkgs[,'Package'] %in% c(install_later, install_update, install_skip), ]


write.table(bioc_pkgs, paste0('bioc_packages_', Rversion, '.csv'), row.names = FALSE, col.names = TRUE, quote = FALSE, sep = ',')
write.table(cran_pkgs, paste0('cran_packages_', Rversion, '.csv'), row.names = FALSE, col.names = TRUE, quote = FALSE, sep = ',')
write.table(as.data.frame(install_update), paste0('cran_packages_update_', Rversion, '.csv'), row.names = FALSE, col.names = TRUE, quote = FALSE, sep = ',')
write.table(as.data.frame(install_later), paste0('later_packages_', Rversion, '.csv'), row.names = FALSE, col.names = TRUE, quote = FALSE, sep = ',')
