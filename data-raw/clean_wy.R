# copied text without headers starting at 1906 from
# http://cdec.water.ca.gov/cgi-progs/iodir/WSIHIST and saved file as wy.text
# 6/14/2017
wy <- readr::read_lines('data-raw/wy.txt')

parse_wy <- function(x) {
  temp <- unlist(stringr::str_split(x, ' '))
  temp2 <- temp[which(temp!= '')]

  temp3 <- dplyr::data_frame(WY = temp2[1], Oct_Mar = temp2[2], Apr_Jul = temp2[3], WYsum = temp2[4], Index = temp2[5], Yr_type = temp2[6],
                   SJ_Oct_Mar = temp2[7], SJ_Apr_Jul = temp2[8], SJ_WYsum = temp2[9], SJ_Index = temp2[10], SJ_Yr_type = temp2[11])

  return(temp3)
}

wy_parsed <- purrr::map_df(wy, parse_wy)

sac <- dplyr::mutate(wy_parsed[ , 1:6], location = 'Sacramento Valley')

san_joaquin <- dplyr::mutate(wy_parsed[ , c(1, 7:11)], location = 'San Joaquin Valley')
names(san_joaquin) <- stringr::str_replace(names(san_joaquin), 'SJ_', '')

#add 1901-1905 for san joaquin
extra_sj <- readr::read_lines(
'1901   3.49    5.58    9.39   4.60     W
1902    1.12    3.81    5.08   3.41    AN
1903    1.45    4.13    5.71   3.45    AN
1904    1.96    5.37    7.64   4.31     W
1905    1.82    3.36    5.30   3.24    AN')

parse_extra <- function(x) {

  temp <- unlist(stringr::str_split(x, ' '))
  temp2 <- temp[which(temp!= '')]

  temp3 <- dplyr::data_frame(WY = temp2[1], Oct_Mar = temp2[2], Apr_Jul = temp2[3],
                             WYsum = temp2[4], Index = temp2[5], Yr_type = temp2[6], location = 'San Joaquin Valley')

  return(temp3)
}

extra_parsed <- purrr::map_df(extra_sj, parse_extra)

water_years <- dplyr::bind_rows(sac, extra_parsed, san_joaquin)

devtools::use_data(water_years)
