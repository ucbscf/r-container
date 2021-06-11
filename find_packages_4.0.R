#### Try to pin to date just before next Bioc came out

pkgs <- installed.packages('/system/linux/lib/R-20.04/4.0/x86_64/site-library')
all_bioc_pkgs <- available.packages(repos = 'https://bioconductor.org/packages/3.12/bioc')
all_cran_pkgs <- available.packages(repos = 'https://mran.microsoft.com/snapshot/2020-06-05')
inbioc <- pkgs[,'Package'] %in% all_bioc_pkgs[,'Package']
incran <- pkgs[,'Package'] %in% all_cran_pkgs[,'Package']
bioc_pkgs <- pkgs[inbioc, ]
cran_pkgs <- pkgs[incran, ]

install_skip <- c('Rmosek', 'iplots', 'NMF')
## NMF requires Biobase and will get installed as part of bioc
install_later <- c('ggm')

## Later version (later than 2020-06-05) of matrixStats needed for bioc deps
bioc_df <- as.data.frame(bioc_pkgs)[ , c('Package','Version')]
bioc_df <- rbind(c('matrixStats', '0.58.0'), bioc_df)
bioc_df <- rbind(c('NMF', '0.22.0'), bioc_df)

## Note that the 'Version' column is not actually used when we create the image, as we rely on the MRAN snapshot date and the Bioc version to control that.

cran_pkgs <- cran_pkgs[!cran_pkgs[,'Package'] %in% c(install_later, install_skip), ]


write.table(bioc_df, 'bioc_packages_4.0.csv', row.names = FALSE, col.names = TRUE, quote = FALSE, sep = ',')
write.table(as.data.frame(cran_pkgs)[ , c('Package','Version')], 'cran_packages_4.0.csv', row.names = FALSE, col.names = TRUE, quote = FALSE, sep = ',')
write.table(as.data.frame(install_later), 'later_packages_4.0.csv', row.names = FALSE, col.names = TRUE, quote = FALSE, sep = ',')
