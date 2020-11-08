# load packages and functions ##################################################
#source("common\\defFunctions.R")
pacman::p_load(Hmisc, tidyverse, here, conflicted, fst, parameters, pacman, magrittr, lubridate,IAT)

pacman::p_load_gh("pinusm/Mmisc", "crsh/papaja")

conflict_prefer("summarise", "dplyr", quiet = T)
conflict_prefer("filter", "dplyr", quiet = T)
conflict_prefer("select", "dplyr", quiet = T)
conflict_prefer("rename", "dplyr", quiet = T)
conflict_prefer("mutate", "dplyr", quiet = T)

# to make compatible with Yoav's code:
dir = here("Rawdata")


path = paste(dir, "explicit.txt", sep = "\\")
#Read the tab-seperated values from explicit.txt
#The read.delim function is spcialized for this kind of data.
explicit.long <- read.delim(path, stringsAsFactors = FALSE)
nrow(explicit.long) #Always test all rows were read fine (open the txt file in notepad++ to count the lines)

#Learn what questionnaires we have in this data.
unique(explicit.long$questionnaire_name)
#Keep only data from the relevant questionnaire
forexp <- explicit.long[explicit.long$questionnaire_name %in% c('rses', 'deq', 'sds', 'cesd'),]

#Learn what question responses we have;
class(forexp$question_response)
#keep original question response
forexp$question_response_orig <- forexp$question_response
#Convert to numeric,  but first, deal with 'null' responses to avoid uncontrolled NA coercion
forexp$question_response[forexp$question_response == 'null'] <- NA
forexp$question_response <- as.numeric(as.character(forexp$question_response)) # this produces NA for participants that did not complete the required Qs for a cesd score.
#Convert -999 to NA; Notice that we lose here information about the rate of skipping questions.
forexp$question_response <- ifelse(forexp$question_response == -999, NA, forexp$question_response)

#Remove sessions with more responses than expected.
dups <- forexp[duplicated(forexp[,c('session_id', 'question_name')]),]
dupsids <- unique(dups$session_id)
length(dupsids)
dupexps <- forexp[forexp$session_id %in% dupsids,]
forexp <- forexp[!(forexp$session_id %in% dupsids),]

#Convert to wide format by subject.
explicit <- forexp %>% select(session_id, question_name, question_response) %>% pivot_wider(names_from = question_name, values_from = question_response)


#rsesQ01: On the whole, I am satisfied with myself
#rsesQ02: At times, I think I am no good at all
#rsesQ03: I feel that I have a number of good qualities
#rsesQ04: I am able to do things as well as most other people
#rsesQ05: I feel I do not have much to be proud of
#rsesQ06: I certainly feel useless at times
#rsesQ07: I feel that I am a person of worth, at least on an equal plane with others
#rsesQ08: I wish I could have more respect for myself
#rsesQ09: All in all, I am inclined to feel that I am a failure
#rsesQ10: I take a positive attitude toward myself.'

# reverse-code the reverse items
explicit <- explicit %>% mutate(
        rsesQ02r = rv4(rsesQ02),
        rsesQ05r = rv4(rsesQ05),
        rsesQ06r = rv4(rsesQ06),
        rsesQ08r = rv4(rsesQ08),
        rsesQ09r = rv4(rsesQ09)
)

rsesQs <- c("rsesQ01" , "rsesQ03" , "rsesQ04" , "rsesQ07" , "rsesQ10" , "rsesQ02r" , "rsesQ05r" , "rsesQ06r" , "rsesQ08r" , "rsesQ09r")

#compute RSES score
explicit$rses <- explicit %>% select(one_of(rsesQs)) %>% rowMeans(., na.rm = T)

rsesRaw <- explicit %>% select(session_id,one_of(rsesQs),rses)
rses <- rsesRaw %>% select(session_id,rses)

rsesIC <- rsesRaw %>% select(one_of(rsesQs)) %>% psych::alpha(.)
print(paste0("Raw Cronbach's Alpha for the RSES was ", round((rsesIC$total$raw_alpha),2)))


# deqQ01 'I often find that I don\'t live up to my own standards or ideals.'
# deqQ02 'There is a considerable difference between how I am now and how I would like to be.'
# deqQ03 'I tend not to be satisfied with what I have.'
# deqQ04 'I have a difficult time accepting weaknesses in myself.'
# deqQ05 'I tend to be very critical of myself.'
# deqQ06 'I very frequently compare myself to standards or goals.'

deqQs <- c("deqQ01" , "deqQ02" , "deqQ03" , "deqQ04" , "deqQ05" , "deqQ06")

#compute deq6 score
explicit$deq6 <- explicit %>% select(one_of(deqQs)) %>% rowMeans(., na.rm = T)

deq6Raw <- explicit %>% select(session_id,one_of(deqQs),deq6)
deq6 <- deq6Raw %>% select(session_id,deq6)

deq6IC <- deq6Raw %>% select(one_of(deqQs)) %>% psych::alpha(.)
print(paste0("Raw Cronbach's Alpha for the deq-sc6 was ", round((deq6IC$total$raw_alpha),2)))


# reverse items (low score is more social desirability)
# sdsQ1: I always admit my mistakes openly and face the potential negative consequences.
# sdsQ2: In traffic I am always polite and considerate of others.
# sdsQ3: I always accept others\' opinions, even when they don\'t agree with my own.
# sdsQ6: In conversations I always listen attentively and let others finish their sentences.
# sdsQ7: I never hesitate to help someone in case of emergency.
# sdsQ8: When I have made a promise, I keep it--no ifs, ands or buts.
# sdsQ10: I would never live off other people.
# sdsQ11: I always stay friendly and courteous with other people, even when I am stressed out.
# sdsQ12: During arguments I always stay objective and matter-of-fact.
# sdsQ14: I always eat a healthy diet.
#
# 'regular' items (high score is more social desirability)
# sdsQ4: I take out my bad moods on others now and then.
# sdsQ5: There has been an occasion when I took advantage of someone else.
# sdsQ9: I occasionally speak badly of others behind their back.
# sdsQ13: There has been at least one occasion when I failed to return an item that I borrowed.
# sdsQ15: Sometimes I only help because I expect something in return.
# sdsQ16: I sometimes litter.

# true = 1
# false = 2

sdsQs <- c("sdsQ1r" , "sdsQ2r" , "sdsQ3r" , "sdsQ4" , "sdsQ5" , "sdsQ6r",
           "sdsQ7r" , "sdsQ8r" , "sdsQ9" , "sdsQ10r" , "sdsQ11r" , "sdsQ12r",
           "sdsQ13" , "sdsQ14r" , "sdsQ15" , "sdsQ16" )

# reverse-code the reverse items
explicit <- explicit %>% mutate(
        sdsQ1r  = rv(sdsQ1, minValue = 1, maxValue = 2),
        sdsQ2r  = rv(sdsQ2, minValue = 1, maxValue = 2),
        sdsQ3r  = rv(sdsQ3, minValue = 1, maxValue = 2),
        sdsQ6r  = rv(sdsQ6, minValue = 1, maxValue = 2),
        sdsQ7r  = rv(sdsQ7, minValue = 1, maxValue = 2),
        sdsQ8r  = rv(sdsQ8, minValue = 1, maxValue = 2),
        sdsQ10r = rv(sdsQ10,minValue = 1, maxValue = 2),
        sdsQ11r = rv(sdsQ11,minValue = 1, maxValue = 2),
        sdsQ12r = rv(sdsQ12,minValue = 1, maxValue = 2),
        sdsQ14r = rv(sdsQ14,minValue = 1, maxValue = 2)
)

#compute sds score
explicit$sds <- explicit %>% select(one_of(sdsQs)) %>% rowMeans(., na.rm = T)

sdsRaw <- explicit %>% select(session_id,one_of(sdsQs),sds)
sds <- sdsRaw %>% select(session_id,sds)

sdsIC <- sdsRaw %>% select(one_of(sdsQs)) %>% psych::alpha(.)

sdsIC <- explicit %>% select(one_of(sdsQs)) %>% psych::alpha(.)
print(paste0("Raw Cronbach's Alpha for the SDS-17 was ", round((sdsIC$total$raw_alpha),2)))


# 'regular' items (high score is more depression)
# cesdQ01: During the past week, I felt depressed.
# cesdQ02: During the past week, I felt lonely.
# cesdQ03: During the past week, I had crying spells.
# cesdQ04: During the past week, I felt sad.
# cesdQ05: During the past week, my sleep was restless.

# 1 = Rarely or None of the Time (Less than 1 Day)"
# 2 = "Some or a Little of the Time (1-2 Days)"
# 3 = "Occasionally or a Moderate Amount of Time (3-4 Days)"
# 4 = "Most or All of the Time (5-7 Days)"]

cesdQs4 <- c("cesdQ01" , "cesdQ02" , "cesdQ03" , "cesdQ04")
cesdQs4alt <- c("cesdQ01" , "cesdQ02" , "cesdQ04" , "cesdQ05")
cesdQs5 <- c("cesdQ01" , "cesdQ02" , "cesdQ03" , "cesdQ04", "cesdQ05")

cesd5Raw <- explicit %>% select(session_id,one_of(cesdQs5)) %>%
        mutate(across(starts_with("cesdQ"), ~.x - 1))
cesd4Raw <- cesd5Raw %>% select(-cesdQ05) %>% omit.na() %>%
        mutate(cesd4 = row_sums(cesdQ01 , cesdQ02 , cesdQ03 , cesdQ04))
cesd4altRaw <- cesd5Raw %>% select(-cesdQ03) %>% omit.na() %>%
        mutate(cesd4alt = row_sums(cesdQ01 , cesdQ02 , cesdQ04 , cesdQ05))

cesd <- cesd4Raw %>% full_join(cesd4altRaw, by = "session_id") %>% select(session_id, cesd4, cesd4alt)

# let's see the correlation between my scale and Melchior's female-based scale.
cesd %$% cor(cesd4, cesd4alt, use = "complete")

cesd4IC <- cesd4Raw %>% select(one_of(cesdQs4)) %>% psych::alpha(.)
cesd4altIC <- cesd4altRaw %>% select(one_of(cesdQs4alt)) %>% psych::alpha(.)
print(paste0("Raw Cronbach's Alpha for the cesd4 was ", round((cesd4IC$total$raw_alpha),2)))
print(paste0("Raw Cronbach's Alpha for the cesd4alt was ", round((cesd4altIC$total$raw_alpha),2)))

#Save the explicit to file(recommended to view this file in Excel, to understand what we saved)
write.csv(explicit,file = here("data/explicit.csv"),na = "")

####################################################################################################################
#Read session data
####################################################################################################################

path <- paste(dir,"sessionTasks.txt", sep = "\\")
sessions.long <- read.table(path, sep = "\t", header = TRUE, fill = TRUE, stringsAsFactors = FALSE)
nrow(sessions.long) #Always test all rows were read fine (open the txt file in notepad++ to count the lines)
#Remove unimportant columns (variables)
sessions.long <- sessions.long[,c("session_id", "task_id", "task_number", "user_agent", "task_creation_date", "session_last_update_date")]

sessions.long2 <- sessions.long
sessions.long2$duplicate <- duplicated(sessions.long2[,c("session_id","task_id")]) #mark participants that did the same task (by task_id) twice, in one session as duplicates
sessions.long2 <- sessions.long2 %>%
        filter(!duplicate) %>% #remove those duplicates, because spread() can't handle them
        select(-duplicate, -user_agent) %>% #remove the duplicate column, as it has done its duty. also remove the useragent - it not very interesting at the moment
        mutate(
                session_last_update_date = ifelse(trimws(session_last_update_date) == "NULL", NA, session_last_update_date),
                task_creation_date =  dmy_hms(task_creation_date),
                session_last_update_date = dmy_hms(session_last_update_date)
        )


times <- sessions.long2 %>%
        group_by(session_id) %>%
        arrange(session_id,task_number) %>%
        mutate(taskDuration_secs = lead(task_creation_date,1) - task_creation_date,
               taskDuration_secs = ifelse(is.na(taskDuration_secs), session_last_update_date - task_creation_date,taskDuration_secs)
        ) %>%
        ungroup() %>%
        select(-task_number, -task_creation_date) %>% # remove the task_number - we don't need it here.
        spread(task_id,taskDuration_secs)  # recreate Aharon's table

#fix names for times
colnames(times)[3:ncol(times)] <- paste('t.', colnames(times)[3:ncol(times)], sep = '')

task.order <- sessions.long2 %>%
        select(-task_creation_date, -session_last_update_date) %>% # remove the task's datetime variables - we don't need them here. also remove the duplicate column, as it has done its duty.
        spread(task_number,task_id)  # this outputs something along 'the first task was x, the second task was y. If you want something like 'task x was first, task y was second', change the order of the argumnets of spread() , and edit the 'fix names' accordingly.

#fix names for task.order
colnames(task.order)[2:ncol(task.order)] <- paste('ord', colnames(task.order)[2:ncol(task.order)], sep = '')

sessions <- full_join(task.order, times, by = "session_id")

#Then calculate completion time from individual tasks
sessions <- sessions %>% mutate(
        total_secs = sessions %>% select(starts_with("t.")) %>% rowSums(na.rm = T),
        completion_secs = ifelse(!is.na(t.lastpage), total_secs,NA)
)

#Remove data frames to free memory
rm(sessions.long, task.order, times)

#Save the session data (recommended to view this file in Excel, to understand what we saved)
write.csv(sessions,file = here("data/sessions.csv"),na = "")


####################################################################################################################
#Read reaction time tasks
####################################################################################################################
#Create the full path to the file
path = paste(dir, "iat.txt", sep = "\\")
iat <- read.table(path, sep = "\t", header = TRUE, fill = TRUE, stringsAsFactors = FALSE, quote = "")
nrow(iat) #Always test all rows were read fine (open the txt file in notepad++ to count the lines)

#Covert trial_error to numeric, and make sure trial_latency is numeric
iat$trial_error <- as.numeric(as.character(iat$trial_error))
class(iat$trial_error)
class(iat$trial_latency)

#task_name helps differentiate between the different reaction time tasks.
unique(iat$task_name)

#Get qiat rows
qiatRaw <- subset(iat, task_name %in% c('se.qiat','sc.qiat'))
#Learn a bit about how we coded the blocks.
unique(qiatRaw$block_pairing_definition)
unique(qiatRaw$block_number)
#Keep only the rows of the qiat's critical blocks.
qiatRaw <- subset(qiatRaw,
                  block_pairing_definition %in% c(
                          "High Self-Esteem/False,Low Self-Esteem/True",
                          "Low Self-Esteem/False,High Self-Esteem/True",
                          "High Self-Criticism/False,Low Self-Criticism/True",
                          "Low Self-Criticism/False,High Self-Criticism/True" # verify SC block pairings here
                  ))

#Create blockName based on the pairing condition.
qiatRaw$blockName[qiatRaw$block_pairing_definition %in%
                          c("Low Self-Criticism/False,High Self-Criticism/True") &
                          qiatRaw$block_number %in% c(4,7)] <- "B3"   #NOTICE there are 8 blocks in the qIAT (2a,2b), so block 4 is 'conceptually' block 3.
qiatRaw$blockName[qiatRaw$block_pairing_definition %in%
                          c("Low Self-Criticism/False,High Self-Criticism/True") &
                          qiatRaw$block_number %in% c(5,8)] <- "B4"
qiatRaw$blockName[qiatRaw$block_pairing_definition %in%
                          c("High Self-Criticism/False,Low Self-Criticism/True") &
                          qiatRaw$block_number %in% c(4,7)] <- "B6"
qiatRaw$blockName[qiatRaw$block_pairing_definition %in%
                          c("High Self-Criticism/False,Low Self-Criticism/True") &
                          qiatRaw$block_number %in% c(5,8)] <- "B7"
table(qiatRaw$blockName)

qiatRaw$blockOrder <- ifelse(qiatRaw$blockName %in% c('B3','B4') &
                                     qiatRaw$block_number %in% c(4,5),
                             "High Trait First",
                             NA)
qiatRaw$blockOrder <- ifelse(qiatRaw$blockName %in% c('B6','B7') &
                                     qiatRaw$block_number %in% c(7,8),
                             "High Trait First",
                             qiatRaw$blockOrder)
qiatRaw$blockOrder <- ifelse(qiatRaw$blockName %in% c('B6','B7') &
                                     qiatRaw$block_number %in% c(4,5),
                             "Low Trait First",
                             qiatRaw$blockOrder)
qiatRaw$blockOrder <- ifelse(qiatRaw$blockName %in% c('B3','B4') &
                                     qiatRaw$block_number %in% c(7,8),
                             "Low Trait First",
                             qiatRaw$blockOrder)

#qiatRaw %>% group_by(session_id) %>% count(blockOrder)

qiatRaw %<>%
        mutate(
                trait = ifelse(grepl('Criticism', block_pairing_definition), "SC", NA)
        )
#separate the two qiat's
qiatRawSC <- qiatRaw %>% filter(trait == "SC")

#Use Dan Martin's qiat scoring function. It seems faster than the one Aharon wrote.
qiatscore <- cleanIAT(qiatRaw, block_name = "blockName",
                      trial_blocks = c("B3", "B4", "B6", "B7"),
                      session_id = "session_id",
                      trial_latency = "trial_latency",
                      trial_error = "trial_error",
                      v_error = 2, v_extreme = 2, v_std = 1) #v_error=2 means recode error latency to m+600
#Sanity check. Does the qiat scores seem fine?
describe_distribution(qiatscore$IAT)

#Save the qiat scores. (recommended to view this file in Excel, to understand what we saved; use ?cleanIAT to learn what each variable in the output means)
write.csv(qiatscore,file = here("data/qiatscore.csv"),na = "")

#IC for qiat ####
qiatRawSC$modulo <- 1:nrow(qiatRawSC) %% 3   ### nth cycle, here every 3

### make sure every subject has same number of trials with valid
### block_number.
qiatRaw %>%
        group_by(session_id) %>%
        filter(!is.na(block_number)) %>%
        dplyr::count()

### make sure numbers of trials with valid block_number make sense. note:
### B6,B7 are should be twice as long as B3,B4
qiatRaw %>%
        group_by(block_number) %>%
        filter(!is.na(block_number)) %>%
        dplyr::count()
# breakdown the valid trials by blocks, for each subject. this could get
# lengthy for big datasets.
qiatRaw %>%
        group_by(session_id,block_number) %>%
        filter(!is.na(block_number)) %>%
        dplyr::count()


# now same tests, by modulo, to make sure the division for the IC analysis
# worked as expected

qiatRawSC %>%
        group_by(modulo, session_id) %>%
        filter(!is.na(block_number)) %>%
        dplyr::count()
qiatRawSC %>%
        group_by(modulo, block_number) %>%
        filter(!is.na(block_number)) %>%
        dplyr::count()
qiatRawSC %>%
        group_by(modulo, session_id,block_number) %>%
        filter(!is.na(block_number)) %>%
        dplyr::count()

qiatmod0 <- qiatRawSC[qiatRawSC$modulo == 0 , ]
qiatmod1 <- qiatRawSC[qiatRawSC$modulo == 1 , ]
qiatmod2 <- qiatRawSC[qiatRawSC$modulo == 2 , ]

qiatDmod0 <- cleanIAT(qiatmod0, block_name = "blockName",
                      trial_blocks = c("B3", "B4", "B6", "B7"),
                      session_id = "session_id",
                      trial_latency = "trial_latency",
                      trial_error = "trial_error",
                      v_error = 2, v_extreme = 2, v_std = 1) #v_error=2 means recode error latency to m+600
#Sanity check. Does the qiat scores seem fine?
describe_distribution(qiatDmod0$IAT)
qiatDmod1 <- cleanIAT(qiatmod1, block_name = "blockName",
                      trial_blocks = c("B3", "B4", "B6", "B7"),
                      session_id = "session_id",
                      trial_latency = "trial_latency",
                      trial_error = "trial_error",
                      v_error = 2, v_extreme = 2, v_std = 1) #v_error=2 means recode error latency to m+600
#Sanity check. Does the qiat scores seem fine?
describe_distribution(qiatDmod1$IAT)
qiatDmod2 <- cleanIAT(qiatmod2, block_name = "blockName",
                      trial_blocks = c("B3", "B4", "B6", "B7"),
                      session_id = "session_id",
                      trial_latency = "trial_latency",
                      trial_error = "trial_error",
                      v_error = 2, v_extreme = 2, v_std = 1) #v_error=2 means recode error latency to m+600
#Sanity check. Does the qiat scores seem fine?
describe_distribution(qiatDmod2$IAT)

rm(qiatmod0,qiatmod1,qiatmod2)

qiatDmod0$qiatmod0 <- qiatDmod0$IAT
qiatDmod1$qiatmod1 <- qiatDmod1$IAT
qiatDmod2$qiatmod2 <- qiatDmod2$IAT

qiatDmod0 <- dplyr::select(qiatDmod0,session_id,qiatmod0)
qiatDmod1 <- dplyr::select(qiatDmod1,session_id,qiatmod1)
qiatDmod2 <- dplyr::select(qiatDmod2,session_id,qiatmod2)

qiatDmods <- Merge(qiatDmod0, qiatDmod1, qiatDmod2, id = ~ session_id , verbose = FALSE)
rm(qiatDmod0,qiatDmod1,qiatDmod2)
qiatIC <- psych::alpha(qiatDmods[ , -1])
qiatIC
print(paste0("Raw Cronbach's Alpha for the SC qiat is ", round((qiatIC$total$raw_alpha),2)))

#Save the qiat modulo scores. (recommended to view this file in Excel, to understand what we saved; use ?cleanIAT to learn what each variable in the output means)
write.csv(qiatDmods,file = here("data/qiatDmodsSC.csv"),na = "")
#

qiatCond <- qiatRaw[,c('session_id', 'blockOrder')] %>% distinct()

#But make sure there are no sessions with two different otherCat values
dups <- qiatCond[duplicated(qiatCond[,'session_id']),]
nrow(dups) #Make sure it is zero

#Save the condition in a file.
write.csv(qiatCond,file = here("data/qiatCond.csv"),na = "")

#Remove data frames to free memory
rm( dups)



#Get IAT rows
iatRaw <- subset(iat, task_name %in% c('sc.iat'))
#Learn a bit about how we coded the blocks.
unique(iatRaw$block_pairing_definition)
unique(iatRaw$block_number)
#Keep only the rows of the IAT's critical blocks.
iatRaw <- subset(iatRaw,
                 block_pairing_definition %in% c('Not Self/Bad words,Self/Good words', 'Self/Bad words,Not Self/Good words',
                                                 "Self/Disappointing,Not Self/Satisfactory", "Not Self/Disappointing,Self/Satisfactory"))  ##  add the SC block pairings here

#Create blockName based on the pairing condition.
iatRaw$blockName[iatRaw$block_pairing_definition %in%
                         c('Self/Disappointing,Not Self/Satisfactory') &
                         iatRaw$block_number %in% c(3,6)] <- "B3"
iatRaw$blockName[iatRaw$block_pairing_definition %in%
                         c('Self/Disappointing,Not Self/Satisfactory') &
                         iatRaw$block_number %in% c(4,7)] <- "B4"
iatRaw$blockName[iatRaw$block_pairing_definition %in%
                         c('Not Self/Disappointing,Self/Satisfactory') &
                         iatRaw$block_number %in% c(3,6)] <- "B6"
iatRaw$blockName[iatRaw$block_pairing_definition %in%
                         c('Not Self/Disappointing,Self/Satisfactory') &
                         iatRaw$block_number %in% c(4,7)] <- "B7"
table(iatRaw$blockName)

iatRaw$blockOrder <- ifelse(iatRaw$blockName %in% c('B3','B4') &
                                    iatRaw$block_number %in% c(3,4),
                            "High Trait First",
                            NA)
iatRaw$blockOrder <- ifelse(iatRaw$blockName %in% c('B6','B7') &
                                    iatRaw$block_number %in% c(6,7),
                            "High Trait First",
                            iatRaw$blockOrder)
iatRaw$blockOrder <- ifelse(iatRaw$blockName %in% c('B6','B7') &
                                    iatRaw$block_number %in% c(3,4),
                            "Low Trait First",
                            iatRaw$blockOrder)
iatRaw$blockOrder <- ifelse(iatRaw$blockName %in% c('B3','B4') &
                                    iatRaw$block_number %in% c(6,7),
                            "Low Trait First",
                            iatRaw$blockOrder)

#iatRaw %>% group_by(session_id) %>% count(blockOrder)

iatRaw %<>%
        mutate(
                trait = ifelse(grepl('Disappointing', block_pairing_definition), "SC", NA)
        )
#separate the two qiat's
iatRawSC <- iatRaw %>% filter(trait == "SC")


#Use Dan Martin's qiat scoring function. It seems faster than the one Aharon wrote.
iatscore <- cleanIAT(iatRaw, block_name = "blockName",
                     trial_blocks = c("B3", "B4", "B6", "B7"),
                     session_id = "session_id",
                     trial_latency = "trial_latency",
                     trial_error = "trial_error",
                     v_error = 2, v_extreme = 2, v_std = 1) #v_error=2 means recode error latency to m+600
#Sanity check. Does the qiat scores seem fine?
describe_distribution(iatscore$IAT)
#Save the qiat scores. (recommended to view this file in Excel, to understand what we saved; use ?cleanIAT to learn what each variable in the output means)
write.csv(iatscore,file = here("data/iatscore.csv"),na = "")

#IC for qiat ####
iatRawSC$modulo <- 1:nrow(iatRawSC) %% 3   ### nth cycle, here every 3
### make sure every subject has same number of trials with valid
### block_number.
iatRawSC %>%
        group_by(session_id) %>%
        filter(!is.na(block_number)) %>%
        dplyr::count()

### make sure numbers of trials with valid block_number make sense. note:
### B6,B7 are should be twice as long as B3,B4
iatRawSC %>%
        group_by(block_number) %>%
        filter(!is.na(block_number)) %>%
        dplyr::count()
# breakdown the valid trials by blocks, for each subject. this could get
# lengthy for big datasets.
iatRawSC %>%
        group_by(session_id,block_number) %>%
        filter(!is.na(block_number)) %>%
        dplyr::count()


iatRawSC %>%
        group_by(modulo, session_id) %>%
        filter(!is.na(block_number)) %>%
        dplyr::count()
iatRawSC %>%
        group_by(modulo, block_number) %>%
        filter(!is.na(block_number)) %>%
        dplyr::count()
iatRawSC %>%
        group_by(modulo, session_id,block_number) %>%
        filter(!is.na(block_number)) %>%
        dplyr::count()

iatmod0 <- iatRawSC[iatRawSC$modulo == 0 , ]
iatmod1 <- iatRawSC[iatRawSC$modulo == 1 , ]
iatmod2 <- iatRawSC[iatRawSC$modulo == 2 , ]

iatDmod0 <- cleanIAT(iatmod0, block_name = "blockName",
                     trial_blocks = c("B3", "B4", "B6", "B7"),
                     session_id = "session_id",
                     trial_latency = "trial_latency",
                     trial_error = "trial_error",
                     v_error = 2, v_extreme = 2, v_std = 1) #v_error=2 means recode error latency to m+600
#Sanity check. Does the IAT scores seem fine?
describe_distribution(iatDmod0$IAT)
iatDmod1 <- cleanIAT(iatmod1, block_name = "blockName",
                     trial_blocks = c("B3", "B4", "B6", "B7"),
                     session_id = "session_id",
                     trial_latency = "trial_latency",
                     trial_error = "trial_error",
                     v_error = 2, v_extreme = 2, v_std = 1) #v_error=2 means recode error latency to m+600
#Sanity check. Does the IAT scores seem fine?
describe_distribution(iatDmod1$IAT)
iatDmod2 <- cleanIAT(iatmod2, block_name = "blockName",
                     trial_blocks = c("B3", "B4", "B6", "B7"),
                     session_id = "session_id",
                     trial_latency = "trial_latency",
                     trial_error = "trial_error",
                     v_error = 2, v_extreme = 2, v_std = 1) #v_error=2 means recode error latency to m+600
#Sanity check. Does the IAT scores seem fine?
describe_distribution(iatDmod2$IAT)

rm(iatmod0,iatmod1,iatmod2)

iatDmod0$iatmod0 <- iatDmod0$IAT
iatDmod1$iatmod1 <- iatDmod1$IAT
iatDmod2$iatmod2 <- iatDmod2$IAT

iatDmod0 <- dplyr::select(iatDmod0,session_id,iatmod0)
iatDmod1 <- dplyr::select(iatDmod1,session_id,iatmod1)
iatDmod2 <- dplyr::select(iatDmod2,session_id,iatmod2)

iatDmods <- Merge(iatDmod0, iatDmod1, iatDmod2, id = ~ session_id , verbose = FALSE)
rm(iatDmod0,iatDmod1,iatDmod2)
iatIC <- psych::alpha(iatDmods[ , -1])
iatIC
print(paste0("Raw Cronbach's Alpha for the SC IAT is ", round((iatIC$total$raw_alpha),2)))

#Save the IAT modulo scores. (recommended to view this file in Excel, to understand what we saved; use ?cleanIAT to learn what each variable in the output means)
write.csv(iatDmods,file = here("data/iatDmodsSC.csv"),na = "")

iatCond <- iatRaw[,c('session_id', 'blockOrder')] %>% distinct()

#But make sure there are no sessions with two different otherCat values
dups <- iatCond[duplicated(iatCond[,'session_id']),]
nrow(dups) #Make sure it is zero
#Save the condition in a file.
write.csv(iatCond,file = here("data/iatCond.csv"),na = "")


#Remove data frames to free memory
rm( dups)


###############
#Get study conditions
forcond <- explicit.long[explicit.long$questionnaire_name %in% c('mgr'),]
#Remove sessions with more responses than expected.
##**Elad explained to me that if participants refreshed while the study was loading, the conditions were randomly chosen more than once. **
##**So, the last saved variables are probably the correct variables, but we can simply use the actual data to infer the conditions **
dups <- forcond[duplicated(forcond[,c('session_id', 'question_name')]),]
dupsids <- unique(dups$session_id)
length(dupsids)
dupcond <- forcond[forcond$session_id %in% dupsids,]
#We'll save only those who do not have duplicates. For the duplicates, we will infer the correct conditions from other records later.
forcond <- forcond[!(forcond$session_id %in% dupsids),]

#Convert to wide format by subject.
conds <- forcond %>% pivot_wider(session_id, names_from = question_name, values_from = question_response)

#Save the conditions to file
write.csv(conds,file = here("data/conds.csv"),na = "")


#Remove data frames to free memory
rm(explicit.long, forcond, dups, dupsids, dupcond, dupexps, forexp)



#We will need the sessions data later (because demographics is by user_id, and the sessionTasks.txt maps user_id to session_id)
path <- paste(dir, "sessionTasks.txt", sep = "\\")
ss <- read.table(path, sep = "\t", header = TRUE, fill = TRUE, stringsAsFactors = FALSE)
nrow(ss) #Always test all rows were read fine (open the txt file in notepad++ to count the lines)
ss <- ss[,c("session_id", "user_id", "session_last_update_date", "session_creation_date")] %>% distinct()


##******************************

#Read demographics data
path = paste(dir, "demographics.txt", sep = "\\")
demographics.long <- read.delim(path, na.strings = ".", stringsAsFactors = FALSE)[-5]
##**End of stuff from Aharon.
##******************************

nrow(demographics.long) #Always test all rows were read fine (open the txt file in notepad++ to count the lines)

#Remove duplicates
d2 <- demographics.long[!duplicated(demographics.long),]

#Convert to wide format (One row per user_id)
demographics <- d2 %>% pivot_wider(user_id, names_from = characteristic, values_from = value)


#Merge with session_id, mostly to get the session_id.
demographics = merge(demographics, ss[,c("session_id", "user_id")], by = "user_id")

#We drop the user_id column here (can also just set demographics.user_id = NULL)
demographics <- demographics %>% select(-user_id)


##**************************
#**Aharaon's code
#Rename columns after reshape
colnames(demographics) = sapply(colnames(demographics),
                                FUN = function(x)
                                {
                                        if (grepl("value.", x))
                                                x = substr(x, nchar("value.") + 1, nchar(x))
                                        else
                                                x = x
                                })

#Calculate age (will use the local computer time)
demographics$age = 2017 - as.numeric(as.character(demographics$birthyear))

#Decode race
demographics[!is.na(demographics$raceomb) & demographics$raceomb == 1, "race"] = "ntvAm"
demographics[!is.na(demographics$raceomb) & demographics$raceomb == 2, "race"] = "eAsia"
demographics[!is.na(demographics$raceomb) & demographics$raceomb == 3, "race"] = "sAsia"
demographics[!is.na(demographics$raceomb) & demographics$raceomb == 4, "race"] = "natPc"
demographics[!is.na(demographics$raceomb) & demographics$raceomb == 5, "race"] = "black"
demographics[!is.na(demographics$raceomb) & demographics$raceomb == 6, "race"] = "white"
demographics[!is.na(demographics$raceomb) & demographics$raceomb == 7, "race"] = "blkwh"
demographics[!is.na(demographics$raceomb) & demographics$raceomb == 8, "race"] = "mixed"
demographics[!is.na(demographics$raceomb) & demographics$raceomb == 9, "race"] = "unkno"

#Political id and origin
demographics$dPlt = demographics$politicalid
demographics$orgn = demographics$citizenship

#Reset row names (I think we don't really need this)
row.names(demographics) = 1:nrow(demographics)

#**End of Aharaon's code
##******************************

#Remove redundant variables
demographics = demographics[,c("session_id", "dPlt", "sex", "age", "orgn")] %>% mutate(sex = as.factor(sex), orgn = as.factor(orgn))
rm(demographics.long, d2, ss)


#Save the demographics to a file. (recommended to view this file in Excel, to understand what we saved)
write.csv(demographics,file = here("data/demographics.csv"),na = "")

implicitscores <- bind_rows(qIAT = qiatscore , IAT = iatscore, .id = "measure")
implicitCond <- bind_rows(qiatCond , iatCond)

allds <- Hmisc::Merge( sessions, demographics , cesd , deq6 , rses , sds , implicitscores , conds , implicitCond, id = ~session_id,
                       all = T) %>% as_tibble()


#Make sure the trait and implicit type variable are compatible (saved in the explicit.txt, but also inferred from the block_pairing_definition in iat.txt)
table(allds[,c('implicitType', 'measure')])

#Save the row-per-participant data to file, for the analysis
write.csv(allds,file = here("data/allds.csv"),na = "")

allds_item <- Hmisc::Merge( sessions, demographics , cesd5Raw , deq6Raw , rsesRaw , sdsRaw , implicitscores , conds , implicitCond, qiatDmods, iatDmods, id = ~session_id,
                       all = T) %>% as_tibble()

# Save output as csv ###########################################################

quick.fst <- function(x){
                name <- deparse(substitute(x))
                fst::write_fst(x, paste0("data/",name, ".fst"))
        }
quick.fst(allds)
quick.fst(allds_item)


