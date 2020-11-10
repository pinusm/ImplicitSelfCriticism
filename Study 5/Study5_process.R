# The raw data to run this script was redacted due to deidentification.
# Use the deidentified data in the 'data' folder.
# Contact Michael Pinus at pinusm@post.bgu.ac.il for the original data.
#

# load packages and functions ##################################################source("common\\defFunctions.R")
pacman::p_load(Hmisc, tidyverse, here, conflicted, fst, parameters, pacman, magrittr, lubridate, cocron, car, readxl,
               haven, lavaan, semPlot, apa, foreign, MASS, userfriendlyscience, pscl, lmerTest, MuMIn)

pacman::p_load_gh("pinusm/Mmisc", "crsh/papaja")

conflict_prefer("summarise", "dplyr", quiet = T)
conflict_prefer("filter", "dplyr", quiet = T)
conflict_prefer("select", "dplyr", quiet = T)
conflict_prefer("rename", "dplyr", quiet = T)
conflict_prefer("mutate", "dplyr", quiet = T)
conflict_prefer("here", "here", quiet = TRUE)
conflict_prefer("extract", "tidyr", quiet = TRUE)

dana_sample1_t1 <- read_sav("Rawdata/Dana's data/Fulldatasample1.sav") %>%
        map_df(as.character)

#set factors
# names(dana_sample1_t1) %>% writeClipboard()
keep_vars <-
        c("subnum" , "age" , "gender" , "bsi1" , "bsi2" , "bsi3" , "bsi4" , "bsi5" , "bsi6" , "bsi7" , "bsi8" , "bsi9" , "bsi10" , "bsi11" , "bsi12" , "bsi13" , "bsi14" , "bsi15" , "bsi16" , "bsi17" , "bsi18" , "bsi19" , "bsi20" , "bsi21" , "bsi22" , "bsi23" , "bsi24" , "bsi25" , "bsi26" , "bsi27" , "bsi28" , "bsi29" , "bsi30" , "bsi31" , "bsi32" , "bsi33" , "bsi34" , "bsi35" , "bsi36" , "bsi37" , "bsi38" , "bsi39" , "bsi40" , "bsi41" , "bsi42" , "bsi43" , "bsi44" , "bsi45" , "bsi46" , "bsi47" , "bsi48" , "bsi49" , "bsi50" , "bsi51" , "bsi52" , "bsi53" , "deq1" , "deq2" , "deq3" , "deq4" , "deq5" , "deq6" , "deq7" , "deq8" , "deq9" , "deq10" , "deq11" , "deq12" , "deq13" , "deq14" , "deq15" , "deq16" , "deq17" , "deq18" , "deq19" , "deq20" , "deq21" , "deq22" , "deq23" , "deq24" , "deq25" , "deq26" , "deq27" , "deq28" , "deq29" , "deq30" , "deq31" , "deq32" , "deq33" , "deq34" , "deq35" , "deq36" , "deq37" , "deq38" , "deq39" , "deq40" , "deq41" , "deq42" , "deq43" , "deq44" , "deq45" , "deq46" , "deq47" , "deq48" , "deq49" , "deq50" , "deq51" , "deq52" , "deq53" , "deq54" , "deq55" , "deq56" , "deq57" , "deq58" , "deq59" , "deq60" , "deq61" , "deq62" , "deq63" , "deq64" , "deq65" , "deq66" , "des1" , "des2" , "des3" , "des4" , "des5" , "des6" , "des7" , "des8" , "des9" , "des10" , "des11" , "des12" , "des13" , "des14" , "des15" , "des16" , "des17" , "des18" , "des19" , "des20" , "des21" , "des22" , "des23" , "des24" , "des25" , "des26" , "des27" , "des28" )
dana_sample1_t1 <-
        dana_sample1_t1 %>%
        select(one_of(keep_vars)) %>%
        filter(!is.nan(subnum), subnum != "NaN") %>%
        mutate(study = "Dana1",
               wave = 1,
               sc1 = deq7 , sc2 = deq13 , sc3 = deq17 , sc4 = deq53 , sc5 = deq64 , sc6 = deq66) %>%
        rename(orig.id = subnum) %>%
        mutate(orig.id = as.character(orig.id),
               female = case_when(gender == "1" ~ "1",
                                  gender == "2" ~ "0"))

dana_sample1_t2 <- read_sav("Rawdata/Dana's data/data and workingfile for sample1- T2. sav_1.sav") %>%
        map_df(as.character)

#names(dana_sample1_t2)
keep_vars <-
        c( "subnum" , "ageT2" , "gender", "bsi1" , "bsi2" , "bsi3" , "bsi4" , "bsi5" , "bsi6" , "bsi7" , "bsi8" , "bsi9" , "bsi10" , "bsi11" , "bsi12" , "bsi13" , "bsi14" , "bsi15" , "bsi16" , "bsi17" , "bsi18" , "bsi19" , "bsi20" , "bsi21" , "bsi22" , "bsi23" , "bsi24" , "bsi25" , "bsi26" , "bsi27" , "bsi28" , "bsi29" , "bsi30" , "bsi31" , "bsi32" , "bsi33" , "bsi34" , "bsi35" , "bsi36" , "bsi37" , "bsi38" , "bsi39" , "bsi40" , "bsi41" , "bsi42" , "bsi43" , "bsi44" , "bsi45" , "bsi46" , "bsi47" , "bsi48" , "bsi49" , "bsi50" , "bsi51" , "bsi52" , "bsi53")
dana_sample1_t2 <-
        dana_sample1_t2 %>%
        select(one_of(keep_vars)) %>%
        filter(!is.nan(subnum), subnum != "NaN") %>%
        mutate(study = "Dana1",
               wave = 2,
               female = case_when(gender == "1" ~ "1",
                                  gender == "2" ~ "0")) %>%
        rename(orig.id = subnum , age = ageT2)


#{r data load and prep: dana sample2, eval=FALSE}
dana_sample2 <- read_sav("Rawdata/Dana's data/full data sample2.sav") %>%
        map_df(as.character)

#names(dana_sample2)
keep_vars <-
        c("subnum" , "age" , "gender" , "bsi1" , "bsi2" , "bsi3" , "bsi4" , "bsi5" , "bsi6" , "bsi7" , "bsi8" , "bsi9" , "bsi10" , "bsi11" , "bsi12" , "bsi13" , "bsi14" , "bsi15" , "bsi16" , "bsi17" , "bsi18" , "bsi19" , "bsi20" , "bsi21" , "bsi22" , "bsi23" , "bsi24" , "bsi25" , "bsi26" , "bsi27" , "bsi28" , "bsi29" , "bsi30" , "bsi31" , "bsi32" , "bsi33" , "bsi34" , "bsi35" , "bsi36" , "bsi37" , "bsi38" , "bsi39" , "bsi40" , "bsi41" , "bsi42" , "bsi43" , "bsi44" , "bsi45" , "bsi46" , "bsi47" , "bsi48" , "bsi49" , "bsi50" , "bsi51" , "bsi52" , "bsi53" , "deq1" , "deq2" , "deq3" , "deq4" , "deq5" , "deq6" , "deq7" , "deq8" , "deq9" , "deq10" , "deq11" , "deq12" , "deq13" , "deq14" , "deq15" , "deq16" , "deq17" , "deq18" , "deq19" , "deq20" , "deq21" , "deq22" , "deq23" , "deq24" , "deq25" , "deq26" , "deq27" , "deq28" , "deq29" , "deq30" , "deq31" , "deq32" , "deq33" , "deq34" , "deq35" , "deq36" , "deq37" , "deq38" , "deq39" , "deq40" , "deq41" , "deq42" , "deq43" , "deq44" , "deq45" , "deq46" , "deq47" , "deq48" , "deq49" , "deq50" , "deq51" , "deq52" , "deq53" , "deq54" , "deq55" , "deq56" , "deq57" , "deq58" , "deq59" , "deq60" , "deq61" , "deq62" , "deq63" , "deq64" , "deq65" , "deq66" , "des1" , "des2" , "des3" , "des4" , "des5" , "des6" , "des7" , "des8" , "des9" , "des10" , "des11" , "des12" , "des13" , "des14" , "des15" , "des16" , "des17" , "des18" , "des19" , "des20" , "des21" , "des22" , "des23" , "des24" , "des25" , "des26" , "des27" , "des28" )
dana_sample2 <-
        dana_sample2 %>%
        filter(!is.nan(subnum), subnum != "NaN") %>%
        select(one_of(keep_vars)) %>%
        mutate(study = "Dana2",
               wave = 1,
               sc1 = deq7 , sc2 = deq13 , sc3 = deq17 , sc4 = deq53 , sc5 = deq64 , sc6 = deq66) %>%
        rename(orig.id = subnum) %>%
        mutate(female = case_when(gender == "1" ~ "1",
                                  gender == "2" ~ "0"))

#{r data load and prep: michael RRTSC1, eval=FALSE}
# import Qualtrics data
michael1rawBSI <- read.csv("Rawdata/Michael's data/RRTSC1/RRTsc1__Home.csv", header = TRUE, stringsAsFactors = FALSE, fileEncoding = "UTF-8",na.strings = "-99")
michael1rawBSI <- michael1rawBSI[michael1rawBSI$ResponseSet == "Default Response Set",] # keep only responses, ditch header rows
michael1rawBSI <- michael1rawBSI[!is.na(michael1rawBSI$Q4),] # keep only responses, ditch header rows

### fix for double subject_nr in 210 in michael1rawBSI (should be 214)
michael1rawBSI[michael1rawBSI$Q4 == "0870" , "sbj"] = "214"
### fix for double subject_nr in 401 in michael1rawBSI (should be 400)
michael1rawBSI[michael1rawBSI$Q4 == "3945" , "sbj"] = "400"

### keep only those that qualtrics could get browser information about (this takes care of many duplicate subjects)
michael1rawBSI <- michael1rawBSI[!(michael1rawBSI$Q1_1_TEXT == ""),]

### fix for double subject_nr in 486 in michael1rawBSI (one should be 490)
michael1rawBSI[michael1rawBSI$sbj == "486" & michael1rawBSI$Q4 == "0784" , "sbj"] = "490"

### fix for double subject_nr in 401,427,483 in michael1rawBSI (multiple entries, one not complete)
michael1rawBSI <- michael1rawBSI[!(michael1rawBSI$sbj == 401 & as.numeric(michael1rawBSI$Finished) < 1),]
michael1rawBSI <- michael1rawBSI[!(michael1rawBSI$sbj == 427 & as.numeric(michael1rawBSI$Finished) < 1),]
michael1rawBSI <- michael1rawBSI[!(michael1rawBSI$sbj == 483 & as.numeric(michael1rawBSI$Finished) < 1),]

### find those who are duplicates, and remove the non-finished entries
michael1rawBSI <- michael1rawBSI[!((michael1rawBSI$sbj %in% michael1rawBSI$sbj[duplicated(michael1rawBSI$sbj)]) & as.numeric(michael1rawBSI$Finished) < 1),]
#names(michael1rawBSI) %>% writeClipboard()

michael1BSI <- michael1rawBSI %>%
        full_join(read.csv("Rawdata/Michael's data/RRTSC1/age_sex.csv", header = TRUE, stringsAsFactors = FALSE, fileEncoding = "UTF-8",na.strings = "-99") %>%
                          mutate(sbj = as.character(sbj)),
                  by = "sbj") %>%
        select(orig.id = sbj, age, female
                      , bsi1 = Q12_1 , bsi2 = Q12_2 , bsi3 = Q12_3 , bsi4 = Q12_4 , bsi5 = Q12_5 , bsi6 = Q12_6 , bsi7 = Q12_7 , bsi8 = Q12_8 , bsi9 = Q12_9 , bsi10 = Q12_10 , bsi11 = Q12_11 , bsi12 = Q12_12 , bsi13 = Q12_13 , bsi14 = Q12_14 , bsi15 = Q12_15 , bsi16 = Q12_16 , bsi17 = Q12_17 , bsi18 = Q12_18 , bsi19 = Q12_19 , bsi20 = Q12_20 , bsi21 = Q12_21 , bsi22 = Q12_22 , bsi23 = Q12_23 , bsi24 = Q12_24 , bsi25 = Q12_25 , bsi26 = Q13_1 , bsi27 = Q13_2 , bsi28 = Q13_3 , bsi29 = Q13_4 , bsi30 = Q13_5 , bsi31 = Q13_6 , bsi32 = Q13_7 , bsi33 = Q13_8 , bsi34 = Q13_9 , bsi35 = Q13_10 , bsi36 = Q13_11 , bsi37 = Q13_12 , bsi38 = Q13_13 , bsi39 = Q13_14 , bsi40 = Q13_15 , bsi41 = Q13_16 , bsi42 = Q13_17 , bsi43 = Q13_18 , bsi44 = Q13_19 , bsi45 = Q13_20 , bsi46 = Q13_21 , bsi47 = Q13_22 , bsi48 = Q13_23 , bsi49 = Q13_24 , bsi50 = Q13_25 , bsi51 = Q13_26 , bsi52 = Q13_27 , bsi53 = Q13_28
                      , cesd1 = Q11_69 , cesd2 = Q11_70 , cesd3 = Q11_72 , cesd4 = Q11_73 , cesd5 = Q11_74 , cesd6 = Q11_75 , cesd7 = Q11_76 , cesd8 = Q11_77 , cesd9 = Q11_78 , cesd10 = Q11_79 , cesd11 = Q11_80 , cesd12 = Q11_81 , cesd13 = Q11_82 , cesd14 = Q11_83 , cesd15 = Q11_84 , cesd16 = Q11_85 , cesd17 = Q11_86 , cesd18 = Q11_87 , cesd19 = Q11_88 , cesd20 = Q11_89
                      , fscrs1 = Q14_132 , fscrs2 = Q14_133 , fscrs3 = Q14_134 , fscrs4 = Q14_135 , fscrs5 = Q14_136 , fscrs6 = Q14_137 , fscrs7 = Q14_138 , fscrs8 = Q14_139 , fscrs9 = Q14_140 , fscrs10 = Q14_141 , fscrs11 = Q14_142 , fscrs12 = Q14_143 , fscrs13 = Q14_144 , fscrs14 = Q14_145 , fscrs15 = Q14_146 , fscrs16 = Q14_147 , fscrs17 = Q14_148 , fscrs18 = Q14_149 , fscrs19 = Q14_150 , fscrs20 = Q14_151 , fscrs21 = Q14_152 , fscrs22 = Q14_153
                      , rses1 = Q15_90 , rses2 = Q15_91 , rses3 = Q15_92 , rses4 = Q15_93 , rses5 = Q15_94 , rses6 = Q15_95 , rses7 = Q15_96 , rses8 = Q15_97 , rses9 = Q15_98 , rses10 = Q15_99
)

#convert all to numeric
michael1BSI <- data.frame(lapply(michael1BSI, function(x) as.numeric(as.character(x))))


michael1rawDEQ <- read.csv("Rawdata/Michael's data/RRTSC1/RRTsc1__Lab.csv", header = TRUE, stringsAsFactors = FALSE, fileEncoding = "UTF-8",na.strings = "-99")

michael1rawDEQ$sbj <- michael1rawDEQ$Q16
michael1rawDEQ$Enter <- NULL

michael1rawDEQ <- michael1rawDEQ[michael1rawDEQ$ResponseSet == "Default Response Set",] # keep only responses, ditch header rows
michael1rawDEQ <- michael1rawDEQ[!is.na(michael1rawDEQ$Q4),] # keep only responses, ditch header rows

### fix for double subject_nr in 255 in michael1rawDEQ qualtrics (opensesame was OK) (should be 254)
michael1rawDEQ[michael1rawDEQ$Q4 == "2181" , "sbj"] = "254"
michael1rawDEQ[michael1rawDEQ$Q4 == "2181" , "Q16"] = "254"

# DEQ6
deq6Qs <- (c("sbj", "Q10_1", "Q10_2", "Q10_3", "Q10_4", "Q10_5", "Q10_6"))
michael1DEQ <- select(michael1rawDEQ, one_of(deq6Qs))
#fix names
names(michael1DEQ) <- (c("orig.id", "sc1", "sc2", "sc3", "sc4", "sc5", "sc6"))
#convert all to numeric
michael1DEQ <- data.frame(lapply(michael1DEQ, function(x) as.numeric(as.character(x))))

michael1 <- full_join(michael1BSI , michael1DEQ , by = "orig.id") %>% add_column(study = "Michael1") %>% mutate_all(as.character) %>% add_column(wave = as.double(1))


#{r data load and prep: michael RRTSC2, eval=FALSE}
# import Qualtrics data
michael2Raw <- read_csv(here::here("Rawdata/Michael's data/RRTSC2/allds.csv"), col_names = T ,
                        cols(
                                .default = col_double(),
                                datetime = col_character(),
                                handdom = col_character(),
                                sex = col_character()
                        )) %>%
        mutate(CESD_Q04 = rv4zero(CESD_Q04r), # I'll re-reverse code these later, but I want them be in the same direction as
               # all the other datasets, for now
               CESD_Q08 = rv4zero(CESD_Q08r),
               CESD_Q12 = rv4zero(CESD_Q12r),
               CESD_Q16 = rv4zero(CESD_Q16r)) %>%
        mutate(female = case_when(sex == "Female" ~ 1,
                                  sex == "Male" ~ 0)) %>%
        select(orig.id = subject_nr, age
               , cesd1 = CESD_Q01 , cesd2 = CESD_Q02 , cesd3 = CESD_Q03 , cesd4 = CESD_Q04 , cesd5 = CESD_Q05 , cesd6 = CESD_Q06 , cesd7 = CESD_Q07 , cesd8 = CESD_Q08 , cesd9 = CESD_Q09 , cesd10 = CESD_Q10 , cesd11 = CESD_Q11 , cesd12 = CESD_Q12 , cesd13 = CESD_Q13 , cesd14 = CESD_Q14 , cesd15 = CESD_Q15 , cesd16 = CESD_Q16 , cesd17 = CESD_Q17 , cesd18 = CESD_Q18 , cesd19 = CESD_Q19 , cesd20 = CESD_Q20
               , bsi1 = BSI_Q01 , bsi2 = BSI_Q02 , bsi3 = BSI_Q03 , bsi4 = BSI_Q04 , bsi5 = BSI_Q05 , bsi6 = BSI_Q06 , bsi7 = BSI_Q07 , bsi8 = BSI_Q08 , bsi9 = BSI_Q09 , bsi10 = BSI_Q10 , bsi11 = BSI_Q11 , bsi12 = BSI_Q12 , bsi13 = BSI_Q13 , bsi14 = BSI_Q14 , bsi15 = BSI_Q15 , bsi16 = BSI_Q16 , bsi17 = BSI_Q17 , bsi18 = BSI_Q18 , bsi19 = BSI_Q19 , bsi20 = BSI_Q20 , bsi21 = BSI_Q21 , bsi22 = BSI_Q22 , bsi23 = BSI_Q23 , bsi24 = BSI_Q24 , bsi25 = BSI_Q25 , bsi26 = BSI_Q26 , bsi27 = BSI_Q27 , bsi28 = BSI_Q28 , bsi29 = BSI_Q29 , bsi30 = BSI_Q30 , bsi31 = BSI_Q31 , bsi32 = BSI_Q32 , bsi33 = BSI_Q33 , bsi34 = BSI_Q34 , bsi35 = BSI_Q35 , bsi36 = BSI_Q36 , bsi37 = BSI_Q37 , bsi38 = BSI_Q38 , bsi39 = BSI_Q39 , bsi40 = BSI_Q40 , bsi41 = BSI_Q41 , bsi42 = BSI_Q42 , bsi43 = BSI_Q43 , bsi44 = BSI_Q44 , bsi45 = BSI_Q45 , bsi46 = BSI_Q46 , bsi47 = BSI_Q47 , bsi48 = BSI_Q48 , bsi49 = BSI_Q49 , bsi50 = BSI_Q50 , bsi51 = BSI_Q51 , bsi52 = BSI_Q52 , bsi53 = BSI_Q53,
               rses = RSES_t2,
               sc1 = DEQ6Q01_t2, sc2 = DEQ6Q02_t2, sc3 = DEQ6Q03_t2, sc4 = DEQ6Q04_t2, sc5 = DEQ6Q05_t2, sc6 = DEQ6Q06_t2,
               fscrs1 = FSCRS.ISQ01_t2 , fscrs2 = FSCRS.ISQ02_t2 , fscrs3 = FSCRS.RSQ03_t2 , fscrs4 = FSCRS.ISQ04_t2 ,
               fscrs5 = FSCRS.RSQ05_t2 , fscrs6 = FSCRS.ISQ06_t2 , fscrs7 = FSCRS.ISQ07_t2 , fscrs8 = FSCRS.RSQ08_t2 ,
               fscrs9 = FSCRS.HSQ09_t2 , fscrs10 = FSCRS.HSQ10_t2 , fscrs11 = FSCRS.RSQ11_t2 , fscrs12 = FSCRS.HSQ12_t2 ,
               fscrs13 = FSCRS.RSQ13_t2 , fscrs14 = FSCRS.ISQ14_t2 , fscrs15 = FSCRS.HSQ15_t2 , fscrs16 = FSCRS.RSQ16_t2 ,
               fscrs17 = FSCRS.ISQ17_t2 , fscrs18 = FSCRS.ISQ18_t2 , fscrs19 = FSCRS.RSQ19_t2 , fscrs20 = FSCRS.ISQ20_t2 ,
               fscrs21 = FSCRS.RSQ21_t2 , fscrs22 = FSCRS.HSQ22_t2,
               female
        )

#convert all to numeric
michael2 <- data.frame(lapply(michael2Raw, function(x) as.numeric(as.character(x)))) %>% add_column(study = "Michael2") %>% mutate_all(as.character) %>% add_column(wave = as.double(1))

#{r data load and prep: michael SCB, eval=FALSE}
michael3Raw <- fst::read_fst(here::here("Rawdata/Michael's data/SC-B/allds.fst")) %>%
        select(part1id,age) %>%
        full_join(fst::read_fst(here::here("Rawdata/Michael's data/SC-B/PI_item.fst")) %>%
                          filter(!is.nan(fscrsIS)),
                  by = "part1id") %>%
        #order of the RSES items was different, so I'll need to rename them for the reversing to be the same as all the other datasets
        rename(rses2r = rsesQ06r,
               rses5r = rsesQ07r,
               rses6r = rsesQ08r,
               rses8r = rsesQ09r,
               rses9r = rsesQ10r,
               rses1 = rsesQ01,
               rses3 = rsesQ02,
               rses4 = rsesQ03,
               rses7 = rsesQ04,
               rses10 = rsesQ05) %>%
        mutate(cesdQ04 = rv(cesdQ04r,minValue = 0,maxValue = 3), # I'll re-reverse code these later, but I want them be in the same direction as all the other datasets, for now
               cesdQ08 = rv(cesdQ08r,minValue = 0,maxValue = 3),
               cesdQ12 = rv(cesdQ12r,minValue = 0,maxValue = 3),
               cesdQ16 = rv(cesdQ16r,minValue = 0,maxValue = 3),
               rses2 = rv(rses2r,minValue = 0,maxValue = 3),
               rses5 = rv(rses5r,minValue = 0,maxValue = 3),
               rses6 = rv(rses6r,minValue = 0,maxValue = 3),
               rses8 = rv(rses8r,minValue = 0,maxValue = 3),
               rses9 = rv(rses9r,minValue = 0,maxValue = 3),
               across(starts_with("rses"),~.x + 1)
               ) %>%
        rename(orig.id = part1id,
               cesd1 = cesdQ01 , cesd2 = cesdQ02 , cesd3 = cesdQ03 , cesd4 = cesdQ04 , cesd5 = cesdQ05 , cesd6 = cesdQ06 , cesd7 = cesdQ07 , cesd8 = cesdQ08 , cesd9 = cesdQ09, cesd10 = cesdQ10,
               cesd11 = cesdQ11, cesd12 = cesdQ12, cesd13 = cesdQ13, cesd14 = cesdQ14, cesd15 = cesdQ15, cesd16 = cesdQ16, cesd17 = cesdQ17, cesd18 = cesdQ18, cesd19 = cesdQ19, cesd20 = cesdQ20,
               bsi1 = bsiQ01 , bsi2 = bsiQ02 , bsi3 = bsiQ03 , bsi4 = bsiQ04 , bsi5 = bsiQ05 , bsi6 = bsiQ06 , bsi7 = bsiQ07 , bsi8 = bsiQ08 , bsi9 = bsiQ09 , bsi10 = bsiQ10,
               bsi11 = bsiQ11, bsi12 = bsiQ12, bsi13 = bsiQ13, bsi14 = bsiQ14, bsi15 = bsiQ15, bsi16 = bsiQ16, bsi17 = bsiQ17, bsi18 = bsiQ18, bsi19 = bsiQ19, bsi20 = bsiQ20,
               bsi21 = bsiQ21, bsi22 = bsiQ22, bsi23 = bsiQ23, bsi24 = bsiQ24, bsi25 = bsiQ25, bsi26 = bsiQ26, bsi27 = bsiQ27, bsi28 = bsiQ28, bsi29 = bsiQ29, bsi30 = bsiQ30,
               bsi31 = bsiQ31, bsi32 = bsiQ32, bsi33 = bsiQ33, bsi34 = bsiQ34, bsi35 = bsiQ35, bsi36 = bsiQ36, bsi37 = bsiQ37, bsi38 = bsiQ38, bsi39 = bsiQ39, bsi40 = bsiQ40,
               bsi41 = bsiQ41, bsi42 = bsiQ42, bsi43 = bsiQ43, bsi44 = bsiQ44, bsi45 = bsiQ45, bsi46 = bsiQ46, bsi47 = bsiQ47, bsi48 = bsiQ48, bsi49 = bsiQ49, bsi50 = bsiQ50,
               bsi51 = bsiQ51, bsi52 = bsiQ52, bsi53 = bsiQ53,
               fscrs1 = fscrsQ01 , fscrs2 = fscrsQ02 , fscrs3 = fscrsQ03 , fscrs4 = fscrsQ04 , fscrs5 = fscrsQ05 , fscrs6 = fscrsQ06 , fscrs7 = fscrsQ07 , fscrs8 = fscrsQ08 , fscrs9 = fscrsQ09 , fscrs10 = fscrsQ10 ,
               fscrs11 = fscrsQ11 , fscrs12 = fscrsQ12 , fscrs13 = fscrsQ13 , fscrs14 = fscrsQ14 , fscrs15 = fscrsQ15 , fscrs16 = fscrsQ16 , fscrs17 = fscrsQ17 , fscrs18 = fscrsQ18 , fscrs19 = fscrsQ19 , fscrs20 = fscrsQ20 ,
               fscrs21 = fscrsQ21 , fscrs22 = fscrsQ22) %>%
        select(orig.id, wave, age, female,starts_with(c("bsi","cesd","fscrs","rses"))) %>%
        select(-any_of(c("fscrsIS","fscrsRS","fscrsHS","cesdQ04r","cesdQ08r","cesdQ12r","cesdQ16r","rses2r","rses5r","rses6r","rses8r","rses9r")))

michael3Raw2 <- michael3Raw %>%
        left_join(michael3Raw %>% select(orig.id) %>% distinct() %>% mutate(num.orig.id = row_number()), by = "orig.id") %>%  #need to convert all orig.id to numerics
        select(-orig.id) %>%
        rename(orig.id = num.orig.id)


#convert all to numeric
michael3 <- michael3Raw2 %>% mutate(across(everything(),~as.numeric(as.character(.x)))) %>%
        add_column(study = "Michael3") %>%
        mutate_all(as.character) %>%
        mutate(wave = as.numeric(wave))


#{r data load and prep: Moran, eval=FALSE}
moran_t1t2t3RAW <- read_excel("Rawdata/Moran's data/combined.xlsx",
                              sheet = "Sheet1") %>%
        map_df(as.character) %>%
        rename(id = id...2)
keep_vars <-
        c("Study" , "id" , "bsi1" , "bsi2" , "bsi3" , "bsi4" , "bsi5" , "bsi6" , "bsi7" , "bsi8" , "bsi9" , "bsi10" , "bsi11" , "bsi12" , "bsi13" , "bsi14" , "bsi15" , "bsi16" , "bsi17" , "bsi18" , "bsi19" , "bsi20" , "bsi21" , "bsi22" , "bsi23" , "bsi24" , "bsi25" , "bsi26" , "bsi27" , "bsi28" , "bsi29" , "bsi30" , "bsi31" , "bsi32" , "bsi33" , "bsi34" , "bsi35" , "bsi36" , "bsi37" , "bsi38" , "bsi39" , "bsi40" , "bsi41" , "bsi42" , "bsi43" , "bsi44" , "bsi45" , "bsi46" , "bsi47" , "bsi48" , "bsi49" , "bsi50" , "bsi51" , "bsi52" , "bsi53" , "FSCRS1" , "FSCRS2" , "FSCRS3" , "FSCRS4" , "FSCRS5" , "FSCRS6" , "FSCRS7" , "FSCRS8" , "FSCRS9" , "FSCRS10" , "FSCRS11" , "FSCRS12" , "FSCRS13" , "FSCRS14" , "FSCRS15" , "FSCRS16" , "FSCRS17" , "FSCRS18" , "FSCRS19" , "FSCRS20" , "FSCRS21" , "FSCRS22" , "SC1" , "SC2" , "SC3" , "SC4" , "SC5" , "SC6")
moran_t1t2t3RAW <-
        moran_t1t2t3RAW %>%
        filter(Study != "CheckVAR") %>%  #gets rid of old combining artifacts
        select(one_of(keep_vars)) %>%
        rename( orig.id = id) %>%
        mutate(wave = case_when(
                Study == "Moran_BSI1" ~ 1,
                Study == "Moran_BSI2" ~ 2,
                Study == "Moran_BSI3" ~ 3,
                TRUE ~ NA_real_),
               Study = "Moran")

names(moran_t1t2t3RAW) <- tolower(names(moran_t1t2t3RAW)) #convert column names to lower case to make them copmatible with the other datasets

# augment with more data I got from moran, from the same study
moran_t1t2t3_additionalRAW <- read_sav("Rawdata/Moran's data/DocData March 4.sav") %>%
        select(orig.id = id, gender = Gender, age, SE1 = SE, SE2 , SE3, Brooding1 = Brooding, Brooding2 , Brooding3) %>%
        gather(key = "key.interim", value ="value", SE1 , SE2 , SE3, Brooding1 , Brooding2, Brooding3) %>%
        mutate(wave = str_sub(key.interim,start=str_length(key.interim)) %>% as.numeric() ,
               key = str_sub(key.interim, 1, str_length(key.interim)-1),
               key = case_when(key == "SE" ~ "rses",
                               key == "Brooding" ~ "rrs.brood",
                               TRUE ~ key),
               orig.id = as.character(orig.id),
               age = as.character(age)
        ) %>%
        select(-key.interim) %>%
        filter(!is.na(orig.id)) %>%
        spread(key, value) %>%
        mutate(rses = as.character(rses)) %>%
        add_column(study = "Moran") %>%
        mutate(female = case_when(gender == "1" ~ "0",
                                  gender == "2" ~ "1")) %>%
        select(-gender)


moran_t1t2t3 <- dplyr::full_join(moran_t1t2t3RAW, moran_t1t2t3_additionalRAW , by = c("orig.id","wave","study"))

#{r data load and prep: Nirit sample1, eval=FALSE}
nirit_sample1_BSI_t1 <- read_excel("Rawdata/Nirit's data/2009 BSI time 1.xlsx") %>%
        map_df(as.character)
nirit_sample1_BSI_t1 <-
        nirit_sample1_BSI_t1 %>%
        rename( orig.id = id)

names(nirit_sample1_BSI_t1) <- tolower(names(nirit_sample1_BSI_t1)) #convert column names to lower case to make them copmatible with the other datasets
nirit_sample1_BSI_t1[nirit_sample1_BSI_t1 == "none"]      <- "0"
nirit_sample1_BSI_t1[nirit_sample1_BSI_t1 == "a little"]  <- "1"
nirit_sample1_BSI_t1[nirit_sample1_BSI_t1 == "medium"]    <- "2"
nirit_sample1_BSI_t1[nirit_sample1_BSI_t1 == "a lot"]     <- "3"
nirit_sample1_BSI_t1[nirit_sample1_BSI_t1 == "extremely"] <- "4"

nirit_sample1_BSI_t2 <- read_excel("Rawdata/Nirit's data/2009 BSI time 2.xlsx") %>%
        map_df(as.character)
nirit_sample1_BSI_t2 <-
        nirit_sample1_BSI_t2 %>%
        rename( orig.id = id) %>%
        mutate(wave = 2,
               Study = "Nirit1")

names(nirit_sample1_BSI_t2) <- tolower(names(nirit_sample1_BSI_t2)) #convert column names to lower case to make them copmatible with the other datasets
nirit_sample1_BSI_t2[nirit_sample1_BSI_t2 == "none"]      <- "0"
nirit_sample1_BSI_t2[nirit_sample1_BSI_t2 == "a little"]  <- "1"
nirit_sample1_BSI_t2[nirit_sample1_BSI_t2 == "medium"]    <- "2"
nirit_sample1_BSI_t2[nirit_sample1_BSI_t2 == "a lot"]     <- "3"
nirit_sample1_BSI_t2[nirit_sample1_BSI_t2 == "extremely"] <- "4"

nirit_sample1_deq_t1 <- read_excel(here("Rawdata/Nirit's data/2009 DEQ.xlsx")) %>%
        map_df(as.character)
nirit_sample1_deq_t1 <-
        nirit_sample1_deq_t1 %>%
        rename( orig.id = id,
                sc1 = QED1, sc2 = QED2, sc3 = QED3, sc4 = QED4, sc5 = QED5, sc6 = QED6)

names(nirit_sample1_deq_t1) <- tolower(names(nirit_sample1_deq_t1)) #convert column names to lower case to make them copmatible with the other datasets

nirit_sample1_deq_t1[nirit_sample1_deq_t1 == "strongly disagree"]  <- "1"
nirit_sample1_deq_t1[nirit_sample1_deq_t1 == "two"]    <- "2"
nirit_sample1_deq_t1[nirit_sample1_deq_t1 == "three"]     <- "3"
nirit_sample1_deq_t1[nirit_sample1_deq_t1 == "four"] <- "4"
nirit_sample1_deq_t1[nirit_sample1_deq_t1 == "five"] <- "5"
nirit_sample1_deq_t1[nirit_sample1_deq_t1 == "six"] <- "6"
nirit_sample1_deq_t1[nirit_sample1_deq_t1 == "strongly agree"] <- "7"

nirit_sample1_demographic <- read_sav(here("Rawdata/Nirit's data/demographic_expanded.sav")) %>%
        rename(orig.id = `מס__נבדק`,
               gender = `מין`) %>%
        mutate(
                female = case_when(gender == 1 ~ "0",
                                   gender == 2 ~ "1"),
                orig.id = as.character(orig.id),
                age = as.character(age)
        ) %>%
        select(orig.id,age,female)

nirit_sample1_t1 <- dplyr::full_join(nirit_sample1_BSI_t1, nirit_sample1_deq_t1, by = "orig.id") %>%
        full_join(nirit_sample1_demographic, by = "orig.id") %>%
        mutate(wave = 1,
               study = "Nirit1")



#{r data load and prep: Nirit sample2, eval=FALSE}
nirit_sample2 <- read_excel("Rawdata/Nirit's data/2011.xlsx") %>%
        map_df(as.character)

nirit_sample2 <- nirit_sample2 %>%
        rename(orig.id = ID,
               gender = `gender (1 - male, 2 - female)`) %>%
        mutate(Study = "Nirit2",
               wave = 1,
               female = case_when(gender == "male" ~ "0",
                                  gender == "female" ~ "1"))



names(nirit_sample2) <- tolower(names(nirit_sample2)) #convert column names to lower case to make them copmatible with the other datasets
table(nirit_sample2$gender)
nirit_sample2[nirit_sample2 == "none"]      <- "0"
nirit_sample2[nirit_sample2 == "a little"]  <- "1"
nirit_sample2[nirit_sample2 == "medium"]    <- "2"
nirit_sample2[nirit_sample2 == "a lot"]     <- "3"
nirit_sample2[nirit_sample2 == "extremely"] <- "4"


#{r data load and prep: Ofer Ostro, eval=FALSE}
Ofer1 <- read_excel("Rawdata/Ofer's data/ostro.xls") %>%
        map_df(as.character)
names(Ofer1) <- tolower(names(Ofer1)) #convert column names to lower case to make them copmatible with the other datasets
Ofer1 <-
        Ofer1 %>%
        rename( orig.id = id) %>%
        mutate(study = "Ofer1",
               wave = 1)

#{r data merge long, eval=FALSE}
allds <- bind_rows(dana_sample1_t1 , dana_sample1_t2 , dana_sample2 , moran_t1t2t3 , nirit_sample1_t1 , nirit_sample1_BSI_t2 , nirit_sample2 , Ofer1 , michael1, michael2, michael3)

allds <- type_convert(allds) #have another stab at guessing column types
#str(allds, list.len = ncol(allds)) #str for the entire variable list
allds %>% group_by(study,wave) %>% filter(!is.na(bsi1)) %>% summarise(count = n())

allds <- allds %>%
        mutate(
                fscrs3r = rv(fscrs3, minValue = 1,maxValue = 4),
                fscrs5r = rv(fscrs5, minValue = 1,maxValue = 4),
                fscrs8r = rv(fscrs8, minValue = 1,maxValue = 4),
                fscrs11r = rv(fscrs11, minValue = 1,maxValue = 4),
                fscrs13r = rv(fscrs13, minValue = 1,maxValue = 4),
                fscrs16r = rv(fscrs16, minValue = 1,maxValue = 4),
                fscrs19r = rv(fscrs19, minValue = 1,maxValue = 4),
                fscrs21r = rv(fscrs21, minValue = 1,maxValue = 4),

                cesd4r = rv(cesd4, minValue = 0,maxValue = 3),
                cesd8r = rv(cesd8, minValue = 0,maxValue = 3),
                cesd12r = rv(cesd12, minValue = 0,maxValue = 3),
                cesd16r = rv(cesd16, minValue = 0,maxValue = 3),

                # reverse coding for RSES
                rses2r = rv(rses2, minValue = 1,maxValue = 4),
                rses5r = rv(rses5, minValue = 1,maxValue = 4),
                rses6r = rv(rses6, minValue = 1,maxValue = 4),
                rses8r = rv(rses8, minValue = 1,maxValue = 4),
                rses9r = rv(rses9, minValue = 1,maxValue = 4)
        )
allds <- type_convert(allds) #have another stab at guessing column types

#{r fix factors, eval=FALSE}
# fix factors
allds$study <- factor(allds$study)

#{r compute index scores, eval=FALSE}
alldsComputed <- allds %>%
        mutate(
                rses.pre.computed = rses,
                rses = rowMeans(data.frame( rses1 , rses2r , rses3 , rses4 , rses5r , rses6r , rses7 , rses8r , rses9r , rses10), na.rm = T),
                rses = ifelse(is.na(rses),rses.pre.computed,rses),
                bsi.general = rowMeans(data.frame( bsi1 , bsi2 , bsi3 , bsi4 , bsi5 , bsi6 , bsi7 , bsi8 , bsi9 , bsi10 , bsi11 , bsi12 , bsi13 , bsi14 , bsi15 , bsi16 , bsi17 , bsi18 , bsi19 , bsi20 , bsi21 , bsi22 , bsi23 , bsi24 , bsi25 , bsi26 , bsi27 , bsi28 , bsi29 , bsi30 , bsi31 , bsi32 , bsi33 , bsi34 , bsi35 , bsi36 , bsi37 , bsi38 , bsi39 , bsi40 , bsi41 , bsi42 , bsi43 , bsi44 , bsi45 , bsi46 , bsi47 , bsi48 , bsi49 , bsi50 , bsi51 , bsi52 , bsi53), na.rm = T),
                bsi.generalNoSC3 = rowMeans(data.frame( bsi1 , bsi2 , bsi3 , bsi4 , bsi5 , bsi6 , bsi7 , bsi8 , bsi9 , bsi10 , bsi11 , bsi12 , bsi13 , bsi14 , bsi15 , bsi16 , bsi17 , bsi18 , bsi19 , bsi20 , bsi21 , bsi23 , bsi24 , bsi25 , bsi26 , bsi27 , bsi28 , bsi29 , bsi30 , bsi31 , bsi32 , bsi33 , bsi34 , bsi35 , bsi36 , bsi37 , bsi38 , bsi39 , bsi40 , bsi41 , bsi42 , bsi43 , bsi44 , bsi45 , bsi46 , bsi47 , bsi49 , bsi51 , bsi52 , bsi53), na.rm = T),
                bsi.generalNoSC5 = rowMeans(data.frame( bsi1 , bsi2 , bsi3 , bsi4 , bsi5 , bsi6 , bsi7 , bsi8 , bsi9 , bsi10 , bsi11 , bsi12 , bsi13 , bsi14 , bsi15 , bsi16 , bsi17 , bsi18 , bsi19 , bsi20 , bsi21 , bsi23 , bsi24 , bsi25 , bsi26 , bsi27 , bsi28 , bsi29 , bsi30 , bsi31 , bsi32 , bsi33 , bsi35 , bsi36 , bsi37 , bsi38 , bsi39 , bsi40 , bsi41 , bsi42 , bsi43 , bsi44 , bsi45 , bsi46 , bsi47 , bsi49 , bsi51 , bsi53), na.rm = T),
                bsi.generalNoSC4sin = rowMeans(data.frame( bsi1 , bsi2 , bsi3 , bsi4 , bsi5 , bsi6 , bsi7 , bsi8 , bsi9 , bsi10 , bsi11 , bsi12 , bsi13 , bsi14 , bsi15 , bsi16 , bsi17 , bsi18 , bsi19 , bsi20 , bsi21 , bsi23 , bsi24 , bsi25 , bsi26 , bsi27 , bsi28 , bsi29 , bsi30 , bsi31 , bsi32 , bsi33 , bsi35 , bsi36 , bsi37 , bsi38 , bsi39 , bsi40 , bsi41 , bsi42 , bsi43 , bsi44 , bsi45 , bsi46 , bsi47 , bsi49 , bsi51 , bsi52 , bsi53), na.rm = T),
                bsi.generalNoSC4guilt = rowMeans(data.frame( bsi1 , bsi2 , bsi3 , bsi4 , bsi5 , bsi6 , bsi7 , bsi8 , bsi9 , bsi10 , bsi11 , bsi12 , bsi13 , bsi14 , bsi15 , bsi16 , bsi17 , bsi18 , bsi19 , bsi20 , bsi21 , bsi23 , bsi24 , bsi25 , bsi26 , bsi27 , bsi28 , bsi29 , bsi30 , bsi31 , bsi32 , bsi33 , bsi34 , bsi35 , bsi36 , bsi37 , bsi38 , bsi39 , bsi40 , bsi41 , bsi42 , bsi43 , bsi44 , bsi45 , bsi46 , bsi47 , bsi49 , bsi51 , bsi53), na.rm = T),
                bsi.generalNoSC3NoSuic = rowMeans(data.frame( bsi1 , bsi2 , bsi3 , bsi4 , bsi5 , bsi6 , bsi7 , bsi8 , bsi10 , bsi11 , bsi12 , bsi13 , bsi14 , bsi15 , bsi16 , bsi17 , bsi18 , bsi19 , bsi20 , bsi21 , bsi23 , bsi24 , bsi25 , bsi26 , bsi27 , bsi28 , bsi29 , bsi30 , bsi31 , bsi32 , bsi33 , bsi34 , bsi35 , bsi36 , bsi37 , bsi38 , bsi39 , bsi40 , bsi41 , bsi42 , bsi43 , bsi44 , bsi45 , bsi46 , bsi47 , bsi49 , bsi51 , bsi52 , bsi53), na.rm = T),
                bsi.generalNoSC5NoSuic = rowMeans(data.frame( bsi1 , bsi2 , bsi3 , bsi4 , bsi5 , bsi6 , bsi7 , bsi8 ,bsi10 , bsi11 , bsi12 , bsi13 , bsi14 , bsi15 , bsi16 , bsi17 , bsi18 , bsi19 , bsi20 , bsi21 , bsi23 , bsi24 , bsi25 , bsi26 , bsi27 , bsi28 , bsi29 , bsi30 , bsi31 , bsi32 , bsi33 , bsi35 , bsi36 , bsi37 , bsi38 , bsi39 , bsi40 , bsi41 , bsi42 , bsi43 , bsi44 , bsi45 , bsi46 , bsi47 , bsi49 , bsi51 , bsi53), na.rm = T),
                bsi.generalNoSC4sinNoSuic = rowMeans(data.frame( bsi1 , bsi2 , bsi3 , bsi4 , bsi5 , bsi6 , bsi7 , bsi8 , bsi10 , bsi11 , bsi12 , bsi13 , bsi14 , bsi15 , bsi16 , bsi17 , bsi18 , bsi19 , bsi20 , bsi21 , bsi23 , bsi24 , bsi25 , bsi26 , bsi27 , bsi28 , bsi29 , bsi30 , bsi31 , bsi32 , bsi33 , bsi35 , bsi36 , bsi37 , bsi38 , bsi39 , bsi40 , bsi41 , bsi42 , bsi43 , bsi44 , bsi45 , bsi46 , bsi47 , bsi49 , bsi51 , bsi52 , bsi53), na.rm = T),
                bsi.generalNoSC4guiltNoSuic = rowMeans(data.frame( bsi1 , bsi2 , bsi3 , bsi4 , bsi5 , bsi6 , bsi7 , bsi8 , bsi10 , bsi11 , bsi12 , bsi13 , bsi14 , bsi15 , bsi16 , bsi17 , bsi18 , bsi19 , bsi20 , bsi21 , bsi23 , bsi24 , bsi25 , bsi26 , bsi27 , bsi28 , bsi29 , bsi30 , bsi31 , bsi32 , bsi33 , bsi34 , bsi35 , bsi36 , bsi37 , bsi38 , bsi39 , bsi40 , bsi41 , bsi42 , bsi43 , bsi44 , bsi45 , bsi46 , bsi47 , bsi49 , bsi51 , bsi53), na.rm = T),
                bsi.Somatization = rowMeans(data.frame(bsi2 , bsi7 , bsi23 , bsi29 , bsi30 , bsi33 , bsi37), na.rm = TRUE),
                bsi.ObsessiveCompulsive = rowMeans(data.frame(bsi5 , bsi15 , bsi26 , bsi27 , bsi32 , bsi36), na.rm = TRUE),
                bsi.InterpersonalSensitivity = rowMeans(data.frame(bsi20 , bsi21 , bsi22 , bsi42), na.rm = TRUE), #has bsi22 from all BSI-SC subscales
                bsi.Anxiety = rowMeans(data.frame(bsi1 , bsi12 , bsi19 , bsi38 , bsi45 , bsi49), na.rm = TRUE),
                bsi.Depression = rowMeans(data.frame(bsi9 , bsi16 , bsi17 , bsi18 , bsi35 , bsi50), na.rm = TRUE), #has bsi50 from all BSI-SC subscales
                bsi.Hostility = rowMeans(data.frame(bsi6 , bsi13 , bsi40 , bsi41 , bsi46), na.rm = TRUE),
                bsi.PhobicAnxiety = rowMeans(data.frame(bsi8 , bsi28 , bsi31 , bsi43 , bsi47), na.rm = TRUE),
                bsi.ParanoidIdeation = rowMeans(data.frame(bsi4 , bsi10 , bsi24 , bsi48 , bsi51), na.rm = TRUE),  #has bsi48 from all BSI-SC subscales
                bsi.Psychoticism = rowMeans(data.frame(bsi3 , bsi14 , bsi34 , bsi44 , bsi53), na.rm = TRUE),  #has bsi34 from BSI-SC5, and BSI-SC4sin subscales
                bsi.InterpersonalSensitivityNoSC = rowMeans(data.frame(bsi20 , bsi21 , bsi42), na.rm = TRUE),
                bsi.DepressionNoSC = rowMeans(data.frame(bsi9 , bsi16 , bsi17 , bsi18 , bsi35), na.rm = TRUE),
                bsi.ParanoidIdeationNoSC = rowMeans(data.frame(bsi4 , bsi10 , bsi24 , bsi51), na.rm = TRUE),
                bsi.PsychoticismNoSC = rowMeans(data.frame(bsi3 , bsi14 , bsi44 , bsi53), na.rm = TRUE),
                bsi.DepressionNoSCNoSuic = rowMeans(data.frame(bsi16 , bsi17 , bsi18 , bsi35), na.rm = TRUE),
                bsi.SC5 = rowMeans(data.frame(bsi22 , bsi34, bsi48 , bsi50, bsi52), na.rm = TRUE),
                bsi.SC3 = rowMeans(data.frame(bsi22 , bsi48 , bsi50), na.rm = TRUE),
                bsi.SC4guilt = rowMeans(data.frame(bsi22 , bsi48 , bsi50, bsi52), na.rm = TRUE),
                bsi.SC4sin = rowMeans(data.frame(bsi22 , bsi48 , bsi50, bsi34), na.rm = TRUE),
                # bsi.Suic = case_when(bsi9 < 3 ~ 0, bsi9 > 2 ~ 1) ,
                bsi.Suic = bsi9 ,
                bsi.Suic_d = case_when(bsi9 < 3 ~ 0, bsi9 > 2 ~ 1) ,
                fscrs.HS = rowMeans(data.frame(fscrs9 , fscrs10 , fscrs12 , fscrs15 , fscrs22), na.rm = TRUE),
                fscrs.RS = rowMeans(data.frame(fscrs3 , fscrs5 , fscrs8 , fscrs11 , fscrs13 , fscrs16 , fscrs19 , fscrs21), na.rm = TRUE),
                fscrs.IS = rowMeans(data.frame(fscrs1 , fscrs2 , fscrs4 , fscrs6 , fscrs7 , fscrs14 , fscrs17 , fscrs18 , fscrs20), na.rm = TRUE),
                deq.sc6 = rowMeans(data.frame(sc1,sc2,sc3,sc4,sc5,sc6), na.rm = TRUE),
                cesd = rowMeans(data.frame(cesd4r, cesd8r, cesd12r, cesd16r, cesd1, cesd2, cesd3, cesd5, cesd6, cesd7, cesd9, cesd10, cesd11, cesd13, cesd14, cesd15, cesd17, cesd18, cesd19, cesd20), na.rm = TRUE),
                fscrs = rowMeans(data.frame(fscrs9 , fscrs10 , fscrs12 , fscrs15 , fscrs22 , fscrs1 , fscrs2, fscrs4 , fscrs6 , fscrs7 , fscrs14 , fscrs17 , fscrs18 , fscrs20 , fscrs3r , fscrs5r , fscrs8r , fscrs11r , fscrs13r , fscrs16r , fscrs19r , fscrs21r), na.rm = TRUE)
        ) %>%
        select(-rses.pre.computed) %>%
        select(study, wave , female, age, everything()) %>%
        select(-gender)

# taken from https://stackoverflow.com/questions/52490552/r-convert-nan-to-na
is.nan.data.frame <- function(x)
{
        do.call(cbind, lapply(x, is.nan))
}
#alldsComputed$fscrs test to convert Nan. should be high value
# alldsComputed %>%   filter(is.nan(fscrs)) %>%   summarise(countNAN = n())

alldsComputed[is.nan(alldsComputed) ] <- NA

#alldsComputed$fscrs test to convert Nan. should be zero
#alldsComputed %>% filter(is.nan(fscrs)) %>% summarise(countNAN = n())

alldsOnlyComputed <-
        alldsComputed %>%
        select(study , wave , age , orig.id, female , bsi.general , bsi.generalNoSC3 , bsi.generalNoSC5 , bsi.generalNoSC4sin , bsi.generalNoSC4guilt , bsi.generalNoSC3NoSuic , bsi.generalNoSC5NoSuic , bsi.generalNoSC4sinNoSuic , bsi.generalNoSC4guiltNoSuic , bsi.Somatization , bsi.ObsessiveCompulsive , bsi.InterpersonalSensitivity , bsi.Anxiety , bsi.Depression , bsi.Hostility , bsi.PhobicAnxiety , bsi.ParanoidIdeation , bsi.Psychoticism , bsi.InterpersonalSensitivityNoSC , bsi.DepressionNoSC , bsi.ParanoidIdeationNoSC , bsi.PsychoticismNoSC , bsi.DepressionNoSCNoSuic , bsi.SC5 , bsi.SC3 , bsi.SC4guilt , bsi.SC4sin , bsi.Suic , bsi.Suic_d, fscrs.HS , fscrs.RS , fscrs.IS , deq.sc6 , cesd , fscrs, rrs.brood, rses )


#{r convert to wide format, eval=FALSE}
appendDataFrameColumns <- function(df, prefix="", suffix="", sep="") {
        colnames(df) <- paste(prefix, colnames(df), suffix, sep=sep)
        return(df)
}

alldsComputedWithID <-alldsComputed %>%
        mutate(id = row_number())
alldsComputed1 <-
        alldsComputedWithID %>%
        filter(wave == 1)
alldsComputed2 <-
        alldsComputedWithID %>%
        filter(wave == 2)
alldsComputed3 <-
        alldsComputedWithID %>%
        filter(wave == 3)
alldsComputed12 <-
        full_join(alldsComputed1,alldsComputed2, by = c("orig.id" , "study"), suffix = c(".t1", ".t2"))
alldsComputedWide <-
        full_join(alldsComputed12, alldsComputed3 %>%
                          appendDataFrameColumns(suffix = ".t3") %>%
                          rename(orig.id = orig.id.t3,
                                 study = study.t3), by = c("orig.id" , "study"))

rm(alldsComputedWithID, alldsComputed1,alldsComputed2,alldsComputed3,alldsComputed12)

alldsComputedWide <-
        alldsComputedWide  %>%
        select(
                -wave.t1,
                -wave.t2,
                -age.t2,
                -female.t2,
                -wave.t3,
                -age.t3,
                -female.t3) %>%
        select(
                age = age.t1,
                female = female.t1,
                everything()
        )

#{r create new.id, eval=FALSE}
alldsComputed <- alldsComputed %>% mutate(new.id = as.factor(paste0(study, "_",orig.id)))
alldsComputedWide <- alldsComputedWide %>% mutate(new.id = as.factor(paste0(study, "_",orig.id)))
alldsOnlyComputed <- alldsOnlyComputed %>% mutate(new.id = as.factor(paste0(study, "_",orig.id)))

#{r export to SPSS, eval=FALSE}
# write.foreign(alldsComputed, here("data/alldsComputed.txt"), here("data/alldsComputed.sps"), package="SPSS")
# write.foreign(alldsComputedWide, here("data/alldsComputedWide.txt"), here("data/alldsComputedWide.sps"), package="SPSS")
# write_excel_csv(alldsComputed, here("data/alldsComputed.csv"))
# write_excel_csv(alldsComputedWide, here("data/alldsComputedWide.csv"))
# write_excel_csv(alldsOnlyComputed, here("data/alldsOnlyComputed.csv"))
table(alldsComputedWide$study)
fst::write_fst(allds, "data/allds.fst")
fst::write_fst(alldsComputed, "data/alldsComputed.fst")
fst::write_fst(alldsComputedWide, "data/alldsComputedWide.fst")
fst::write_fst(alldsOnlyComputed, "data/alldsOnlyComputed.fst")

#{r load feathers}
allds <- fst::read_fst(here("data/allds.fst"))
alldsComputed <- fst::read_fst(here("data/alldsComputed.fst"))
alldsComputedWide <- fst::read_fst(here("data/alldsComputedWide.fst"))
alldsOnlyComputed <- fst::read_fst(here("data/alldsOnlyComputed.fst"))

