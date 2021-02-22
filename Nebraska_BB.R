

library("RSocrata")
library(dplyr)

# Dec 2019 data: "https://opendata.fcc.gov/resource/whue-6pnt.csv?stateabbr=NE",

 df <- read.socrata(
   "https://opendata.fcc.gov/resource/whue-6pnt.csv?stateabbr=NE",
   app_token = "p8czIoFoamUMnO1ANMgLJD4yD",
   email     = "thowington@gmail.com",
   password  = "timnFC0717"
 )
 print ("read file")

df$blockcode <- as.character(df$blockcode)
save(df, file="FCC_data_NE.rda")


########

load("FCC_data_NE.rda")
dim(df)

# residential only
df <- df[which(df$consumer ==1),]
dim(df)
df$blockgroup <- substr(df$blockcode,1,12)

# maxaddown_blockgroup <- df %>% 
#   group_by(blockgroup) %>% summarise(maxdown = max(maxaddown))

maxaddown_block <- df %>% 
  group_by(blockcode) %>% summarise(maxdown = max(maxaddown))

write.table(maxaddown_block, "max_downloadspeed_block.txt", sep=',', row.names = FALSE)

# number of broadband providers by Census Block
block_data <- df %>%
  group_by(blockcode) %>%
  filter(!(techcode %in% c(60,70,90,0))) %>%
  summarise(maxdown = max(maxaddown),
                      num_providers = n_distinct(frn))

write.table(block_data, "block_data.txt", sep=',', row.names = FALSE)
# 
# # number of fiber providers by Census Block
# fiber_providers <- df %>% group_by(blockcode) %>%
#   filter(techcode == 50) %>%
#   summarise(fiber_providers = n_distinct(frn))
# dim(fiber_providers)
# 
# 
# write.table(fiber_providers, "fiber_providers.txt", sep=',', row.names = FALSE)
