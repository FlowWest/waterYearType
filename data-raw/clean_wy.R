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

dplyr::glimpse(wy_parsed)

sac <- wy_parsed[ , 1:6] %>%
  dplyr::mutate(location = 'Sacramento Valley')

san_joaquin <- wy_parsed[ , c(1, 7:11)] %>%
  dplyr::mutate(location = 'San Joaquin Valley')
names(san_joaquin) <- stringr::str_replace(names(san_joaquin), 'SJ_', '')

both <- bind_rows(sac, san_joaquin)
