# The raw data to run this script was redacted due to deidentification. 
# Use the deidentified data in the 'data' folder.
# Contact Michael Pinus at pinusm@post.bgu.ac.il for the original data.


# load packages and functions ##################################################
#source("common\\defFunctions.R")
pacman::p_load(Hmisc, tidyverse, readbulk, here, qualtRics, conflicted, fst, parameters, pacman)

pacman::p_load_gh("pinusm/Mmisc",
                  "crsh/papaja")
source("IATD.R")

conflict_prefer("summarise", "dplyr", quiet = T)
conflict_prefer("filter", "dplyr", quiet = T)
conflict_prefer("select", "dplyr", quiet = T)
conflict_prefer("rename", "dplyr", quiet = T)
conflict_prefer("mutate", "dplyr", quiet = T)

# OpenSesame ###################################################################
## Import OpenSesame data ####
# RawImplicit <- readbulk::read_opensesame(here::here("RawData/opensesame/"),subdirectories = F) %>% # select(-email) #deidentify
# fst::write.fst(RawImplicit, here::here("data/RawImplicit.fst"))
RawImplicit <- fst::read.fst(here::here("data/RawImplicit.fst"))
## make sure all subjects got in.
length(unique(RawImplicit$subject_nr))

## drop unneeded variable ####
cleanImplicit <- RawImplicit %>% 
        select(age, blockno, correct, correct_first_chance_response, correct_response, count_pickStim, datetime, handdom, id4dig, practice, response, 
               response_first_chance_response, response_second_chance_response, response_time, response_time_first_chance_response, response_time_second_chance_response,
               response_time_spacer, schighfirst, second_chance, sex, stim_color, stim_word_b, subject_nr, trueProp, File) %>% 
        filter(stim_color %in% c("orange", "blue")) %>% 
        as_tibble()

#fix for sbj 425 listed as 318 (Dor typed the wrong subject_number)
cleanImplicit[cleanImplicit$subject_nr == "318", "subject_nr"] = 425

#fix for sbj 487. I've got two files for this subject
cleanImplicit <- cleanImplicit %>% filter(subject_nr != 487)

# Qualtrics ####################################################################
## import Qualtrics data #######################################################
homeRaw <- fetch_survey("SV_6u5wIQHbVFjO8VT", time_zone = "Israel", convert = F, verbose = F) %>%
        select(-IPAddress) #deidentify
labRaw <- fetch_survey("SV_cUq7See4biJRpqd", time_zone = "Israel", convert = F, verbose = F) %>% 
        select(-IPAddress) %>%  #deidentify
        select(-Q5)  #deidentify emails

lab <- labRaw %>% 
        select(-sbj, sbj = Q16) %>% # replace temp sbj variable with actual subject number
        filter(!is.na(sbj), !is.na(Q4)) %>% 
        mutate(Q4 = as.character(Q4) %>% str_pad(4, side = "left", "0")) %>% 
        {.}

home <- homeRaw %>% 
        filter(!is.na(Q4)) %>% 
        mutate(Q4 = as.character(Q4) %>% str_pad(4, side = "left", "0")) %>% 
        {.}

### fix for double subject_nr in 210 in home (should be 214)
home[home$Q4 == "0870" , "sbj"] = 214
### fix for double subject_nr in 401 in home (should be 400)
home[home$Q4 == "3945" , "sbj"] = 400

### fix for double subject_nr in 486 in home (one should be 490)
home[home$sbj == 486 & home$Q4 == "0784" , "sbj"] = 490

### fix for double subject_nr in 401,427,483 in home (multiple entries, one not complete)
home <- home[!(home$sbj == 401 & !home$Finished),]
home <- home[!(home$sbj == 427 & !home$Finished),]
home <- home[!(home$sbj == 483 & !home$Finished),]

### fix for double subject_nr in 255 in lab qualtrics (opensesame was OK) (should be 254)
lab[lab$Q4 == "2181" , "sbj"] = 254
lab[lab$Q4 == "2181" , "Q16"] = 254

### find those who are duplicates, and remove the non-finished entries
home <- home[!((home$sbj %in% home$sbj[duplicated(home$sbj)]) & !home$Finished),]

### no more duplicates
length(home$sbj[duplicated(home$sbj)]) == 0
length(lab$sbj[duplicated(lab$sbj)]) == 0


# Demographics #################################################################
demographics <- cleanImplicit %>% select(one_of(c("subject_nr", "age", "datetime","handdom","sex"))) %>% 
        distinct() %>% 
        rename(sbj = subject_nr) %>% 
        mutate(female = case_when(sex == "Female" ~ 1,
                                  sex == "Male" ~ 0))

# fix typo in subject 518. says 2. have no way of know what it really is, so NA'ing it.
demographics$age[demographics$sbj == "518"] = NA


## create list of subjects that are (fe)male
male.list <- demographics %>% filter(female == 0) %>% pull(sbj)
female.list <- demographics %>% filter(female == 1) %>% pull(sbj)

## get ready for IATD. this is a multistep process.. ####
### create the err variable 
errors <- cleanImplicit %>% 
        mutate(
                err = case_when(
                        !is.na(correct_first_chance_response) & correct_first_chance_response == 1 ~ 0,
                        !is.na(correct_first_chance_response) & correct_first_chance_response == 0 ~ 1
                )
        )
#rm(cleanblocks)
### compute _full_ trial latency
latencies <- errors
latencies$response_time_second_chance_response[latencies$err == 0] <- 0
latencies$trial_latency <- latencies$response_time_first_chance_response + latencies$response_time_second_chance_response
#rm(errors)

### remove first block, and all trials where words were used.
nowords <- latencies %>% filter(stim_color != "orange")
#rm(cleanImplicit)

### remove subject with more than 2sd error rate (only in non-words trials)
counterr <- nowords %>% filter(!is.na(subject_nr)) %>% 
        group_by(subject_nr) %>% 
        summarise(count = sum(err), .groups = "drop_last")

counterr$totalTrials <- 160 # only trials with statements, by blocks: 0 + 40 + 20 + 20 + 40 + 20 + 20.
counterr$errPercent <- (counterr$count/counterr$totalTrials)*100
counterr$zerrPercent <- scale(counterr$errPercent, center = TRUE, scale = TRUE)
counterr$tooManyErrors2sd <- abs(counterr$zerrPercent) > 2
counterr$tooManyErrors2.5sd <- abs(counterr$zerrPercent) > 2.5
nowordsclean <- merge(nowords,counterr)
counterrSorted <- counterr[order(-counterr$errPercent),] 
#rm(counterrwithna)


### add Block number based on block content, only for abs(ZerrPercent) < 2.5
blocks <- nowordsclean[nowordsclean$tooManyErrors2.5sd == F,]
blocks$block_number[!is.na(blocks$blockno) & blocks$blockno == 3 & blocks$schighfirst == 0] = "B3"
blocks$block_number[!is.na(blocks$blockno) & blocks$blockno == 3 & blocks$schighfirst == 1] = "B6"
blocks$block_number[!is.na(blocks$blockno) & blocks$blockno == 6 & blocks$schighfirst == 1] = "B3"
blocks$block_number[!is.na(blocks$blockno) & blocks$blockno == 6 & blocks$schighfirst == 0] = "B6"
blocks$block_number[!is.na(blocks$blockno) & blocks$blockno == 4 & blocks$schighfirst == 0] = "B4"
blocks$block_number[!is.na(blocks$blockno) & blocks$blockno == 4 & blocks$schighfirst == 1] = "B7"
blocks$block_number[!is.na(blocks$blockno) & blocks$blockno == 7 & blocks$schighfirst == 1] = "B4"
blocks$block_number[!is.na(blocks$blockno) & blocks$blockno == 7 & blocks$schighfirst == 0] = "B7"
#rm(nowords, counterr)
 

### get only trials where block_number isn't NA
rrt <- blocks %>% filter(!is.na(block_number))
## prepare for IC analysis ####
rrt$modulo <- (1:nrow(rrt))%%3   ### nth cycle, here every 3
### make sure every subject has 80~ trials of statements
# ddply(rrt, .(subject_nr), plyr::summarize, count = sum(totalTrials)/160)
### make sure every modulo has 2520~ trials of statements
# ddply(rrt, .(modulo), plyr::summarize, count = sum(totalTrials)/160)
### make sure every modulo-subject combination has 26~ trials of statements
# ddply(rrt, .(modulo, subject_nr), plyr::summarize, count = sum(totalTrials)/160)

rrtmod0 <- rrt[rrt$modulo==0 , ]  
rrtmod1 <- rrt[rrt$modulo==1 , ]
rrtmod2 <- rrt[rrt$modulo==2 , ]
## compute IATD scores ####
rrtD <- IATD(rrt,
            block.name = "block_number",
            parsels = list(c(B3 = "B3", B6 = "B6"), c(B4 = "B4", B7 = "B7")),
            subject = "subject_nr",
            trial.latency = "trial_latency",
            trial.error = "err"
) %>% 
        select(sbj = subject_nr,
                        RRT = IAT) 

### for IC measure
rrtDmod0 <- IATD (rrtmod0,
                  block.name = "block_number",
                  parsels = list(c(B3 = "B3", B6 = "B6"), c(B4 = "B4", B7 = "B7")),
                  subject = "subject_nr",
                  trial.latency = "trial_latency",
                  trial.error = "err"
) %>% 
        select(sbj = subject_nr,
                        RRTmod0 = IAT) 

rrtDmod1 <- IATD (rrtmod1,
                  block.name = "block_number",
                  parsels = list(c(B3 = "B3", B6 = "B6"), c(B4 = "B4", B7 = "B7")),
                  subject = "subject_nr",
                  trial.latency = "trial_latency",
                  trial.error = "err"
) %>% 
        select(sbj = subject_nr,
               RRTmod1 = IAT) 

rrtDmod2 <- IATD (rrtmod2,
                  block.name = "block_number",
                  parsels = list(c(B3 = "B3", B6 = "B6"), c(B4 = "B4", B7 = "B7")),
                  subject = "subject_nr",
                  trial.latency = "trial_latency",
                  trial.error = "err"
) %>% 
        select(sbj = subject_nr,
               RRTmod2 = IAT) 

rrtDmods <- Merge(rrtDmod0, rrtDmod1, rrtDmod2, id = ~ sbj)
psych::alpha(rrtDmods[ , -1])

## CESD ########################################################################
reverseCesd <- c("CESD.Q04", "CESD.Q08","CESD.Q12","CESD.Q16")
cesdRaw <- home %>% select(sbj,starts_with("Q11_")) 
#fix names
names(cesdRaw) <- (c("sbj", "CESD.Q01", "CESD.Q02", "CESD.Q03", "CESD.Q04", "CESD.Q05", "CESD.Q06", "CESD.Q07", "CESD.Q08", "CESD.Q09", "CESD.Q10", "CESD.Q11", "CESD.Q12", "CESD.Q13", "CESD.Q14", "CESD.Q15", "CESD.Q16", "CESD.Q17", "CESD.Q18", "CESD.Q19", "CESD.Q20"))
#recode reversed Qs
cesdRaw <- cesdRaw %>% 
        mutate(CESD.Q04r = rv4zero(CESD.Q04),
               CESD.Q08r = rv4zero(CESD.Q08),
               CESD.Q12r = rv4zero(CESD.Q12),
               CESD.Q16r = rv4zero(CESD.Q16))
#compute CESD score
cesdRaw2 <- cesdRaw %>% select(-one_of(reverseCesd)) 
cesdRaw2$cesd <- rowSums(dplyr::select(cesdRaw2, -sbj))
#return
cesd <- cesdRaw2 %>% select(sbj,cesd)

## RSES ########################################################################
reverseRses <- c("RSES.Q02","RSES.Q05", "RSES.Q06","RSES.Q08","RSES.Q09")
rsesRaw <- home %>% select(sbj,starts_with("Q15_")) 
#fix names
names(rsesRaw) <- (c("sbj", "RSES.Q01", "RSES.Q02", "RSES.Q03", "RSES.Q04", "RSES.Q05", "RSES.Q06", "RSES.Q07", "RSES.Q08", "RSES.Q09", "RSES.Q10"))
#recode reversed Qs
rsesRaw <- rsesRaw %>% mutate(
        RSES.Q02r = rv4(RSES.Q02),
        RSES.Q05r = rv4(RSES.Q05),
        RSES.Q06r = rv4(RSES.Q06),
        RSES.Q08r = rv4(RSES.Q08),
        RSES.Q09r = rv4(RSES.Q09))
#compute RSES score
rsesRaw2 <- rsesRaw %>% select(-one_of(reverseRses)) 
rsesRaw2$rses <- rowMeans(dplyr::select(rsesRaw2, -sbj))
#return
rses <- select(rsesRaw2,sbj,rses)

## DEQ6 ########################################################################
deq6Raw <- lab %>% select(sbj, starts_with("Q10_"))
#fix names
names(deq6Raw) <- (c("sbj", "DEQ6.Q01", "DEQ6.Q02", "DEQ6.Q03", "DEQ6.Q04", "DEQ6.Q05", "DEQ6.Q06"))
#compute DEQ6 score
deq6Raw$deq6 <- rowMeans(dplyr::select(deq6Raw, -sbj))
#return
deq6 <- select(deq6Raw,sbj,deq6)

## FSCRS #######################################################################
fscrsRaw <- home %>% select(sbj, starts_with("Q14_"))
#fix names
names(fscrsRaw) <- (c("sbj", "FSCRS.Q01", "FSCRS.Q02", "FSCRS.Q03", "FSCRS.Q04", "FSCRS.Q05", "FSCRS.Q06", "FSCRS.Q07", "FSCRS.Q08", "FSCRS.Q09", "FSCRS.Q10", "FSCRS.Q11", "FSCRS.Q12", "FSCRS.Q13", "FSCRS.Q14", "FSCRS.Q15", "FSCRS.Q16", "FSCRS.Q17", "FSCRS.Q18", "FSCRS.Q19", "FSCRS.Q20", "FSCRS.Q21", "FSCRS.Q22"))
fscrsHSq <- c("sbj", "FSCRS.Q09","FSCRS.Q10", "FSCRS.Q12","FSCRS.Q15","FSCRS.Q22")
fscrsRSq <- c("sbj", "FSCRS.Q03","FSCRS.Q05", "FSCRS.Q08","FSCRS.Q11","FSCRS.Q13","FSCRS.Q16","FSCRS.Q19","FSCRS.Q21")
fscrsISq <- c("sbj", "FSCRS.Q01","FSCRS.Q02", "FSCRS.Q04","FSCRS.Q06","FSCRS.Q07","FSCRS.Q14","FSCRS.Q17","FSCRS.Q18","FSCRS.Q20")
fscrsHSraw <- select(fscrsRaw, one_of(fscrsHSq))
fscrsRSraw <- select(fscrsRaw, one_of(fscrsRSq))
fscrsISraw <- select(fscrsRaw, one_of(fscrsISq))
fscrsGenraw <- fscrsRaw %>% mutate(
        FSCRS.Q03r = rv4zero(FSCRS.Q03),
        FSCRS.Q05r = rv4zero(FSCRS.Q05),
        FSCRS.Q08r = rv4zero(FSCRS.Q08),
        FSCRS.Q11r = rv4zero(FSCRS.Q11),
        FSCRS.Q13r = rv4zero(FSCRS.Q13),
        FSCRS.Q16r = rv4zero(FSCRS.Q16),
        FSCRS.Q19r = rv4zero(FSCRS.Q19),
        FSCRS.Q21r = rv4zero(FSCRS.Q21))
fscrsGenraw <- fscrsGenraw %>% select(-one_of(fscrsRSq[-1]))
#compute FSCRS scores
fscrsHSraw$fscrsHS <- rowMeans(dplyr::select(fscrsHSraw, -sbj))
fscrsRSraw$fscrsRS <- rowMeans(dplyr::select(fscrsRSraw, -sbj))
fscrsISraw$fscrsIS <- rowMeans(dplyr::select(fscrsISraw, -sbj))
fscrsGenraw$fscrsGen <- rowMeans(dplyr::select(fscrsGenraw, -sbj))
#return
fscrs <- Merge(select(fscrsHSraw,sbj,fscrsHS),
               select(fscrsISraw,sbj,fscrsIS),
               select(fscrsRSraw,sbj,fscrsRS),
               select(fscrsGenraw,sbj,fscrsGen),
               id = ~sbj)
               

## BSI  ########################################################################
bsiRaw <- home %>% select(sbj,starts_with("Q12_"), starts_with("Q13_"))
names(bsiRaw) <- (c("sbj",  "BSI.Q01", "BSI.Q02", "BSI.Q03", "BSI.Q04", "BSI.Q05", "BSI.Q06", "BSI.Q07", "BSI.Q08", "BSI.Q09", "BSI.Q10", "BSI.Q11", "BSI.Q12", "BSI.Q13", "BSI.Q14", "BSI.Q15", "BSI.Q16", "BSI.Q17", "BSI.Q18", "BSI.Q19", "BSI.Q20", "BSI.Q21", "BSI.Q22", "BSI.Q23", "BSI.Q24", "BSI.Q25", "BSI.Q26", "BSI.Q27", "BSI.Q28", "BSI.Q29", "BSI.Q30", "BSI.Q31", "BSI.Q32", "BSI.Q33", "BSI.Q34", "BSI.Q35", "BSI.Q36", "BSI.Q37", "BSI.Q38", "BSI.Q39", "BSI.Q40", "BSI.Q41", "BSI.Q42", "BSI.Q43", "BSI.Q44", "BSI.Q45", "BSI.Q46", "BSI.Q47", "BSI.Q48", "BSI.Q49", "BSI.Q50", "BSI.Q51", "BSI.Q52", "BSI.Q53"))

#create lists of items in each subscale
BSI.Somatization                <- c("BSI.Q02","BSI.Q07", "BSI.Q23","BSI.Q29","BSI.Q30","BSI.Q37")
BSI.ObsessiveCompulsive         <- c("BSI.Q05","BSI.Q15", "BSI.Q26","BSI.Q27","BSI.Q32","BSI.Q36")
BSI.InterpersonalSensitivity    <- c("BSI.Q20","BSI.Q21", "BSI.Q22","BSI.Q42")
BSI.Anxiety                     <- c("BSI.Q01","BSI.Q12", "BSI.Q19","BSI.Q38","BSI.Q45","BSI.Q49")
BSI.Depression                  <- c("BSI.Q09","BSI.Q16", "BSI.Q17","BSI.Q18","BSI.Q35","BSI.Q50")
BSI.Hostility                   <- c("BSI.Q06","BSI.Q13", "BSI.Q40","BSI.Q41","BSI.Q46")
BSI.PhobicAnxiety               <- c("BSI.Q08","BSI.Q28", "BSI.Q31","BSI.Q43","BSI.Q47")
BSI.ParanoidIdeation            <- c("BSI.Q04","BSI.Q10", "BSI.Q24","BSI.Q48","BSI.Q51")
BSI.Psychoticism                <- c("BSI.Q03","BSI.Q14", "BSI.Q34","BSI.Q44","BSI.Q53")
BSI.general                     <- c("BSI.Q01", "BSI.Q02", "BSI.Q03", "BSI.Q04", "BSI.Q05", "BSI.Q06", "BSI.Q07", "BSI.Q08", "BSI.Q09", "BSI.Q10", "BSI.Q11", "BSI.Q12", "BSI.Q13", "BSI.Q14", "BSI.Q15", "BSI.Q16", "BSI.Q17", "BSI.Q18", "BSI.Q19", "BSI.Q20", "BSI.Q21", "BSI.Q22", "BSI.Q23", "BSI.Q24", "BSI.Q25", "BSI.Q26", "BSI.Q27", "BSI.Q28", "BSI.Q29", "BSI.Q30", "BSI.Q31", "BSI.Q32", "BSI.Q33", "BSI.Q34", "BSI.Q35", "BSI.Q36", "BSI.Q37", "BSI.Q38", "BSI.Q39", "BSI.Q40", "BSI.Q41", "BSI.Q42", "BSI.Q43", "BSI.Q44", "BSI.Q45", "BSI.Q46", "BSI.Q47", "BSI.Q48", "BSI.Q49", "BSI.Q50", "BSI.Q51", "BSI.Q52", "BSI.Q53")
BSI.withoutOCD                  <- c("BSI.Q01", "BSI.Q02", "BSI.Q03", "BSI.Q04", "BSI.Q06", "BSI.Q07", "BSI.Q08", "BSI.Q09", "BSI.Q10", "BSI.Q11", "BSI.Q12", "BSI.Q13", "BSI.Q14", "BSI.Q16", "BSI.Q17", "BSI.Q18", "BSI.Q19", "BSI.Q20", "BSI.Q21", "BSI.Q22", "BSI.Q23", "BSI.Q24", "BSI.Q25", "BSI.Q28", "BSI.Q29", "BSI.Q30", "BSI.Q31", "BSI.Q33", "BSI.Q34", "BSI.Q35", "BSI.Q37", "BSI.Q38", "BSI.Q39", "BSI.Q40", "BSI.Q41", "BSI.Q42", "BSI.Q43", "BSI.Q44", "BSI.Q45", "BSI.Q46", "BSI.Q47", "BSI.Q48", "BSI.Q49", "BSI.Q50", "BSI.Q51", "BSI.Q52", "BSI.Q53")


bsiScores <- bsiRaw %>% 
        mutate(
                BSI.Somatization = rowMeans(select(bsiRaw, one_of(BSI.Somatization)),na.rm = F),
                BSI.ObsessiveCompulsive = rowMeans(select(bsiRaw, one_of(BSI.ObsessiveCompulsive)),na.rm = F),
                BSI.InterpersonalSensitivity = rowMeans(select(bsiRaw, one_of(BSI.InterpersonalSensitivity)),na.rm = F),
                BSI.Anxiety = rowMeans(select(bsiRaw, one_of(BSI.Anxiety)),na.rm = F),
                BSI.Depression = rowMeans(select(bsiRaw, one_of(BSI.Depression)),na.rm = F),
                BSI.Hostility = rowMeans(select(bsiRaw, one_of(BSI.Hostility)),na.rm = F),
                BSI.PhobicAnxiety = rowMeans(select(bsiRaw, one_of(BSI.PhobicAnxiety)),na.rm = F),
                BSI.ParanoidIdeation = rowMeans(select(bsiRaw, one_of(BSI.ParanoidIdeation)),na.rm = F),
                BSI.Psychoticism = rowMeans(select(bsiRaw, one_of(BSI.Psychoticism)),na.rm = F),
                BSI.general = rowMeans(select(bsiRaw, one_of(BSI.general)),na.rm = F),
                BSI.withoutOCD = rowMeans(select(bsiRaw, one_of(BSI.withoutOCD)),na.rm = F),
                BSI.Suicidal = BSI.Q09
        ) %>% select(-one_of(BSI.general))


# merge DS #####################################################################
#list all DFs
#names(which(sapply(.GlobalEnv, is.data.frame)))  # get all current dataframes. edited output below
RRTSC1 <-     Merge(demographics, bsiScores , cesd , deq6 , fscrs , rrtD , rses,
               id = ~sbj) %>% as_tibble()
allds_item <- Merge(demographics, bsiRaw, cesdRaw2 , deq6Raw , fscrsGenraw , rrtDmods , rsesRaw2,
               id = ~sbj) %>% as_tibble()
# Save output as csv ###########################################################

quick.fst <- function(x){
                name <- deparse(substitute(x))
                fst::write_fst(x, paste0("data/",name, ".fst"))
        }
quick.fst(RRTSC1)
quick.fst(allds_item)
quick.fst(home)
quick.fst(cleanImplicit)
quick.fst(latencies)
quick.fst(counterr)
quick.fst(counterrSorted)
quick.fst(blocks)

