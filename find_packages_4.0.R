#### Try to pin to date just before next Bioc came out

pkgs <- installed.packages('/system/linux/lib/R-20.04/4.0/x86_64/site-library')
all_bioc_pkgs <- available.packages(repos = 'https://bioconductor.org/packages/3.12/bioc')
all_cran_pkgs <- available.packages(repos = 'https://mran.microsoft.com/snapshot/2020-06-05')
inbioc <- pkgs[,'Package'] %in% all_bioc_pkgs[,'Package']
incran <- pkgs[,'Package'] %in% all_cran_pkgs[,'Package']
bioc_pkgs <- pkgs[inbioc, ]
cran_pkgs <- pkgs[incran, ]

install_skip <- c('Rmosek', 'iplots')
install_later <- c('NBPSeq','PMA','jackstraw','samr','gRain','gRbase','PSCBS','aroma.core')
## iplots needs X11, others missing bioc dependencies, so install others after bioc pkgs
cran_pkgs <- cran_pkgs[!cran_pkgs[,'Package'] %in% c(install_later, install_skip), ]

write.table(as.data.frame(bioc_pkgs)[ , c('Package','Version')], 'bioc_packages_4.0.csv', row.names = FALSE, col.names = TRUE, quote = FALSE, sep = ',')
write.table(as.data.frame(cran_pkgs)[ , c('Package','Version')], 'cran_packages_4.0.csv', row.names = FALSE, col.names = TRUE, quote = FALSE, sep = ',')
write.table(as.data.frame(install_later), 'later_packages_4.0.csv', row.names = FALSE, col.names = TRUE, quote = FALSE, sep = ',')
