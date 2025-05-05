#### Try to pin to date just before next Bioc came out
R_VERSION <- "4.5.0"
BIOC_VERSION <- "3.21"
ROCKER_DATE <- "2025-04-30"
pkgs <- installed.packages(paste0(
    '/system/linux/lib/R-24.04/', R_VERSION, '/x86_64/site-library'))
all_bioc_pkgs <- available.packages(repos = paste0('https://bioconductor.org/packages/', BIOC_VERSION, '/bioc'))
all_cran_pkgs <- available.packages(repos = paste0('https://packagemanager.posit.co/cran/__linux__/noble/', ROCKER_DATE))
inbioc <- pkgs[,'Package'] %in% all_bioc_pkgs[,'Package']
incran <- pkgs[,'Package'] %in% all_cran_pkgs[,'Package']
bioc_pkgs <- as.data.frame(pkgs[inbioc, c('Package','Version')])
cran_pkgs <- as.data.frame(pkgs[incran, c('Package','Version')])

install_skip <- c('Rmosek', 'NMF')
## NMF requires Biobase and will get installed as part of bioc

# install_update <- c('matrixStats')
## need later matrixStats (0.60.1 from 2021-08-23) for newer (1.4.3) MatrixGenerics that Bioconductor 3.13 installs now (as of 2021-06-03 it was installing 1.4.0)
install_later <- c('gRbase','rags2ridges')   # needs graph installed (which comes from bioconductor)

bioc_pkgs <- rbind(cran_pkgs['NMF', ], bioc_pkgs)

## Note that the 'Version' column is not actually used when we create the image, as we rely on the MRAN snapshot date and the Bioc version to control that.

# cran_pkgs <- cran_pkgs[!cran_pkgs[,'Package'] %in% c(install_later, install_update, install_skip), ]
cran_pkgs <- cran_pkgs[!cran_pkgs[,'Package'] %in% c(install_later, install_skip), ]


write.table(bioc_pkgs, paste0('bioc_packages_', R_VERSION, '.csv'), row.names = FALSE, col.names = TRUE, quote = FALSE, sep = ',')
write.table(cran_pkgs, paste0('cran_packages_', R_VERSION, '.csv'), row.names = FALSE, col.names = TRUE, quote = FALSE, sep = ',')
# write.table(as.data.frame(install_update), paste0('cran_packages_update_', R_VERSION, '.csv'), row.names = FALSE, col.names = TRUE, quote = FALSE, sep = ',')
write.table(as.data.frame(install_later), paste0('later_packages_', R_VERSION, '.csv'), row.names = FALSE, col.names = TRUE, quote = FALSE, sep = ',')
