# The raw data to run this script was redacted due to deidentification. 
# Use the deidentified data in the 'data' folder.
# Contact Michael Pinus at pinusm@post.bgu.ac.il for the original data.
# 
# load packages and functions ##################################################
pacman::p_load(Hmisc, tidyverse, readbulk, here, qualtRics, conflicted, fst, parameters, pacman, magrittr, reshape2)

pacman::p_load_gh("pinusm/Mmisc", "crsh/papaja")
source("IATD.R")

conflict_prefer("summarise", "dplyr", quiet = T)
conflict_prefer("filter", "dplyr", quiet = T)
conflict_prefer("select", "dplyr", quiet = T)
conflict_prefer("rename", "dplyr", quiet = T)
conflict_prefer("mutate", "dplyr", quiet = T)

# OpenSesame ###################################################################
## Import OpenSesame data ####
# RawImplicitT1 <- readbulk::read_opensesame(here::here("Rawdata/opensesame/1st.session/"),subdirectories = F) %>% 
# select(-email)
# fst::write.fst(RawImplicitT1, here::here("data/RawImplicitT1.fst"))
# RawImplicitT2 <- readbulk::read_opensesame(here::here("Rawdata/opensesame/2nd.session/"),subdirectories = F) %>% 
# select(-email)
# fst::write.fst(RawImplicitT2, here::here("data/RawImplicitT2.fst"))
RawImplicitT1 <- fst::read.fst(here::here("data/RawImplicitT1.fst"))
RawImplicitT2 <- fst::read.fst(here::here("data/RawImplicitT2.fst"))
## make sure all subjects got in.
length(unique(RawImplicitT1$subject_nr))
length(unique(RawImplicitT2$subject_nr))

## drop unneeded variable ####

cleanImplicitT1 <- RawImplicitT1 %>%
        filter(stim_color %in% c("orange", "blue")) %>% # drop unneed trials
        select(
                QUE_Item,
                age,
                blockno,
                correct,
                correct_first_chance_response,
                correct_response,
                count_QUE_trial,
                datetime,
                handdom,
                id4dig,
                initiation_time_mt_task,
                response_first_chance_response,
                response_mt_task,
                response_second_chance_response,
                response_time_first_chance_response,
                response_time_mt_task,
                response_time_second_chance_response,
                schighfirst,
                sex,
                stim_color,
                stim_word_a,
                stim_word_b,
                subject_nr,
                timestamps_mt_task,
                trueProp,
                xpos_mt_task,
                ypos_mt_task
                ) %>% 
        as_tibble() %>% 
        mutate(correct = ifelse(correct == "undefined", NA, correct), # this will introduce NAs whenever correct == 'undefined'.
               correct = as.numeric(correct),
               subject_nr = ifelse(subject_nr == 300, 200, subject_nr)) %>%    #fix typo in subject_nr 300. should be 200.
        {.}


cleanImplicitT2 <- RawImplicitT2 %>%
        filter(stim_color %in% c("orange", "blue")) %>% # drop unneed trials
        select(
                QUE_Item ,
                blockno ,
                correct ,
                correct_first_chance_response ,
                correct_response ,
                count_QUE_trial ,
                datetime ,
                id4dig ,
                initiation_time_mt_task ,
                response_first_chance_response ,
                response_mt_task ,
                response_second_chance_response ,
                response_time_first_chance_response ,
                response_time_mt_task ,
                response_time_second_chance_response ,
                schighfirst ,
                sex ,
                stim_color ,
                stim_word_a ,
                stim_word_b ,
                subject_nr ,
                timestamps_mt_task ,
                trueProp ,
                xpos_mt_task ,
                ypos_mt_task
        ) %>% 
        as_tibble() %>% 
        mutate(correct = ifelse(correct == "undefined", NA, correct), # this will introduce NAs whenever correct == 'undefined'.
               correct = as.numeric(correct),
               subject_nr = ifelse(subject_nr == 300, 200, subject_nr))   #fix typo in subject_nr 300. should be 200.


# are there any duplicates?
# table(RawImplicitT1$subject_nr)
#yes! 155 has twice as many trials as the others, and there's no 156. 
# let's see the ID4 fields for both 155's in t1
# RawImplicitT1 %>% filter(subject_nr == 155) %>% select(id4dig) %>% unique
# compare with the 155 in the t2
# RawImplicitT2 %>% filter(subject_nr == 155) %>% select(id4dig) %>% unique
# and the 156 in the t2
# RawImplicitT2 %>% filter(subject_nr == 156) %>% select(id4dig) %>% unique
RawImplicitT1$subject_nr[RawImplicitT1$subject_nr ==  "155" & RawImplicitT1$id4dig == "201133550"] <- 156 #all good. we may proceed

# Qualtrics ####################################################################
# RawQualtrics <- haven::read_sav("Rawdata/qualtrics/RRTsc2__2nd_session.sav") %>% 
#        select(-V6) # redact IP addresses
# fst::write.fst(RawQualtrics, here::here("data/RawQualtrics.fst"))
RawQualtrics <- fst::read.fst(here::here("data/RawQualtrics.fst"))

#get rid of all weird subject_nr values
RawQualtrics <- RawQualtrics %>% 
        filter(!is.na(subject_nr), subject_nr != "" , subject_nr < "999") %>% 
        mutate(subject_nr = ifelse(subject_nr == 300, 200, subject_nr)) #fix typo in subject_nr 300. should be 200.

# let's see if all of Opensesame's T2 participants are also on Qualtrics
anti_join(data.frame(subject_nr = unique(cleanImplicitT2$subject_nr) %>% as.character()),
          data.frame(subject_nr = unique(RawQualtrics$subject_nr) %>% as.character()), 
          by = "subject_nr")
# # subject 174 is on opensesame, but not qualtrics
anti_join(data.frame(subject_nr = unique(RawQualtrics$subject_nr) %>% as.character()),
          data.frame(subject_nr = unique(cleanImplicitT2$subject_nr) %>% as.character()), 
          by = "subject_nr")
# subject 173 is on qualtrics, but not opensesame
# also all 100-106 didn't do opensesame in T2, so they're also missing.
# maybe 173 and 174 are the same person. the google sheet listing is weird, and I can't figure it out. I'll look at id4.
cleanImplicitT2 %>% filter(subject_nr == 174) %>% select(id4dig) %>% unique()
RawQualtrics %>% filter(subject_nr == 173) %>% select(ID4) %>% unique()
# Yes! they are the same person. let's fix that
RawQualtrics  <- RawQualtrics %>% 
        mutate(subject_nr = ifelse(subject_nr == 173, 174, subject_nr))


# Demographics #################################################################
demographics <- cleanImplicitT1 %>% select(one_of(c("subject_nr", "age", "datetime","handdom","sex"))) %>% 
        distinct() %>% 
        rename(sbj = subject_nr) %>% 
        mutate(female = case_when(sex == "Female" ~ 1,
                                  sex == "Male" ~ 0))





## CESD ########################################################################
# CESD_Q01	הייתי מוטרד/ת בשל דברים שבדרך כלל לא מטרידים אותי.
# CESD_Q02	לא היה לי חשק לאכול. לא היה לי תאבון.
# CESD_Q03	הרגשתי שאני לא יכול/ה להיפטר ממצבי רוח, אפילו לא בעזרת משפחתי או חברי.
# CESD_Q04	הרגשתי שאני טוב/ה בדיוק כמו כל אחד אחר.
# CESD_Q05	היה לי קשה להתרכז בדברים שאני עושה.
# CESD_Q06	הרגשתי מדוכא/ת.
# CESD_Q07	הרגשתי שכל מה שאני עושה דורש מאמץ.
# CESD_Q08	הרגשתי מלא/ת תקווה בקשר לעתיד.
# CESD_Q09	חשבתי שחיי הם כישלון.
# CESD_Q10	הרגשתי מפוחד/ת.
# CESD_Q11	השינה שלי לא היתה שקטה.
# CESD_Q12	הייתי מאושר/ת.
# CESD_Q13	דיברתי פחות מהרגיל.
# CESD_Q14	הרגשתי בודד/ה.
# CESD_Q15	אנשים לא היו ידידותיים כלפי.
# CESD_Q16	נהנתי מהחיים.
# CESD_Q17	היו לי התפרצויות בכי.
# CESD_Q18	הרגשתי עצוב/ה.
# CESD_Q19	הרגשתי שאנשים לא מחבבים אותי.
# CESD_Q20	לא יכולתי "להזיז את עצמי".
reverseCesd <- c("CESD.Q04", "CESD.Q08","CESD.Q12","CESD.Q16")
cesdRaw <- RawQualtrics %>% select(subject_nr,starts_with("CESD_Q")) 
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


## BSI  ########################################################################
bsiRaw <- RawQualtrics %>% select(subject_nr,starts_with("BSI_Q"))
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

## DERS  ########################################################################
# DERS_Q01	ברור לך מה את מרגיש/ה
# DERS_Q02	את/ה מקשיב/ה לרגשות שלך
# DERS_Q03	הרגשות שלך מציפים אותך ויוצאים מהשליטה שלך
# DERS_Q04	אין לך מושג איך את/ה מרגיש/ה
# DERS_Q05	קשה לך למצוא היגיון ברגשות שלך
# DERS_Q06	את/ה קשוב/ה לרגשות שלך
# DERS_Q07	את/ה יודע/ת בדיוק איך את/ה מרגיש/ה
# DERS_Q08	אכפת לך ממה שאת/ה מרגיש/ה
# DERS_Q09	את/ה מבולבל/ת לגבי ההרגשות שלך
# DERS_Q10	כאשר את/ה במצוקה את/ה מקבל/ת את הרגשות שלך
# DERS_Q11	כאשר את/ה במצוקה את/ה כועס/ת על עצמך שאת/ה מרגיש/ה ככה
# DERS_Q12	כאשר את/ה במצוקה את/ה נבוכ/ה שאת/ה מרגיש/ה ככה
# DERS_Q13	כאשר את/ה במצוקה קשה לך לעבוד
# DERS_Q14	כאשר את/ה במצוקה את/ה לא מצליח/ה לשלוט בעצמך
# DERS_Q15	כאשר את/ה במצוקה את/ה מרגיש/ה שתישארי בהרגשה הזו הרבה זמן
# DERS_Q16	כאשר את/ה במצוקה את/ה יודע/ת שבסוף זה יגיע לדיכאון
# DERS_Q17	כאשר את/ה במצוקה את/ה מרגיש/ה שהרגשות האלה של מצוקה הם חשובים ומשמעותיים
# DERS_Q18	כאשר את/ה במצוקה יש לך קושי להתמקד בדברים אחרים
# DERS_Q19	כאשר את/ה במצוקה את/ה מרגיש/ה שאת/ה לא בשליטה
# DERS_Q20	כאשר את/ה במצוקה את/ה עדיין יכולה להתפנות לדברים אחרים
# DERS_Q21	כאשר את/ה במצוקה את/ה מתבייש/ת שאת/ה מרגיש/ה ככה
# DERS_Q22	כאשר את/ה במצוקה את/ה יודע/ת שאת/ה תימצא/י את הדרך להרגיש בסופו של דבר יותר טוב
# DERS_Q23	כאשר את/ה במצוקה את/ה מרגיש/ה כזו חלש/ה
# DERS_Q24	כאשר את/ה במצוקה את/ה מרגיש/ה שאת/ה עדיין יכול/ה להיות בשליטה על ההתנהגות שלך
# DERS_Q25	כאשר את/ה במצוקה את/ה מרגיש/ה אשמה שאת/ה מרגיש/ה ככה
# DERS_Q26	כאשר את/ה במצוקה קשה לך להתרכז
# DERS_Q27	כאשר את/ה במצוקה קשה לך לשלוט בהתנהגות שלך
# DERS_Q28	כאשר את/ה במצוקה את/ה מרגיש/ה שאין שום דבר שאת/ה יכול/ה לעשות כדי לגרום לעצמך להרגיש טוב יותר
# DERS_Q29	כאשר את/ה במצוקה את/ה מתרגז/ת או מתעצבנ/ת על עצמך שאת/ה מרגיש/ה ככה
# DERS_Q30	כאשר את/ה במצוקה את/ה מרגיש/ה רע כלפי עצמך
# DERS_Q31	כאשר את/ה במצוקה, כל מה שאת/ה יכול/ה לעשות זה לשקוע בתוך המצוקה
# DERS_Q32	כאשר את/ה במצוקה את/ה מאבד/ת שליטה על ההתנהגות שלך
# DERS_Q33	כאשר את/ה במצוקה קשה לך לחשוב על משהו אחר
# DERS_Q34	כאשר את/ה במצוקה את/ה נותנ/ת לעצמך זמן כדי להבין מה את/ה באמת מרגיש/ה
# DERS_Q35	כאשר את/ה במצוקה, לוקח לך הרבה זמן לצאת ממנה ולהרגיש יותר טוב
# DERS_Q36	כאשר את/ה במצוקה הרגשות שלך מציפים 


dersRaw <- RawQualtrics %>% select(sbj = subject_nr,starts_with("DERS_Q"))

#add reverse coding, where needed, using pdf in email from Gal Navon 13/09/2017.
reverseDERS <- c("DERS_Q20","DERS_Q24","DERS_Q02","DERS_Q06","DERS_Q08","DERS_Q10","DERS_Q17","DERS_Q34","DERS_Q22","DERS_Q07","DERS_Q01")

#recode reversed Qs
dersRaw <- dersRaw %>% 
        mutate(DERS_Q20R = rv5(DERS_Q20),
               DERS_Q24R = rv5(DERS_Q24),
               DERS_Q02R = rv5(DERS_Q02),
               DERS_Q06R = rv5(DERS_Q06),
               DERS_Q08R = rv5(DERS_Q08),
               DERS_Q10R = rv5(DERS_Q10),
               DERS_Q17R = rv5(DERS_Q17),
               DERS_Q34R = rv5(DERS_Q34),
               DERS_Q22R = rv5(DERS_Q22),
               DERS_Q07R = rv5(DERS_Q07),
               DERS_Q01R = rv5(DERS_Q01)
        ) %>% select(-one_of(reverseDERS))

#create lists of items in each subscale
DERS.clarity                <- c("DERS_Q01R" , "DERS_Q04" , "DERS_Q05" , "DERS_Q07R" , "DERS_Q09" )
DERS.strategy               <- c("DERS_Q15" , "DERS_Q16" , "DERS_Q22R" , "DERS_Q28" , "DERS_Q30" , "DERS_Q31" , "DERS_Q35" , "DERS_Q36" )
DERS.awareness              <- c("DERS_Q02R" , "DERS_Q06R" , "DERS_Q08R" , "DERS_Q10R" , "DERS_Q17R" , "DERS_Q34R")
DERS.impulsive              <- c("DERS_Q03" , "DERS_Q14" , "DERS_Q19" , "DERS_Q24R" , "DERS_Q27" , "DERS_Q32")
DERS.goals                  <- c("DERS_Q13" , "DERS_Q18" , "DERS_Q20R" , "DERS_Q26" , "DERS_Q33")
DERS.unacceptance           <- c("DERS_Q11" , "DERS_Q12" , "DERS_Q21" , "DERS_Q23" , "DERS_Q25" ,  "DERS_Q29")
DERS.global                 <- c("DERS_Q01R" , "DERS_Q04" , "DERS_Q05" , "DERS_Q07R" , "DERS_Q09" , "DERS_Q15" , "DERS_Q16" , "DERS_Q22R" ,
                                 "DERS_Q28" , "DERS_Q30" , "DERS_Q31" , "DERS_Q35" , "DERS_Q36" ,
                                 "DERS_Q02R" , "DERS_Q06R" , "DERS_Q08R" , "DERS_Q10R" , "DERS_Q17R" , "DERS_Q34R",
                                 "DERS_Q03" , "DERS_Q14" , "DERS_Q19" , "DERS_Q24R" , "DERS_Q27" , "DERS_Q32",
                                 "DERS_Q13" , "DERS_Q18" , "DERS_Q20R" , "DERS_Q26" , "DERS_Q33", 
                                 "DERS_Q11" , "DERS_Q12" , "DERS_Q21" , "DERS_Q23" , "DERS_Q25" ,  "DERS_Q29")

dersScores <- dersRaw %>% 
        mutate(
                DERS.clarity = rowMeans(select(dersRaw, one_of(DERS.clarity)),na.rm = T),
                DERS.strategy = rowMeans(select(dersRaw, one_of(DERS.strategy)),na.rm = T),
                DERS.awareness = rowMeans(select(dersRaw, one_of(DERS.awareness)),na.rm = T),
                DERS.impulsive = rowMeans(select(dersRaw, one_of(DERS.impulsive)),na.rm = T),
                DERS.goals = rowMeans(select(dersRaw, one_of(DERS.goals)),na.rm = T),
                DERS.unacceptance = rowMeans(select(dersRaw, one_of(DERS.unacceptance)),na.rm = T),
                DERS.global = rowMeans(select(dersRaw, one_of(DERS.global)),na.rm = T)
        ) %>% 
        select(sbj,DERS.clarity,DERS.strategy,DERS.awareness,DERS.impulsive,DERS.goals,DERS.unacceptance,DERS.global)



## MELAMED ########################################################################
# MELAMED_Q01	לוקח לי זמן להירגע בעקבות אירוע מרגש
# MELAMED_Q02	כאשר קורה לי משהו לא נעים לפני יציאתי לבילוי בערב, אני ממשיך/ה לחשוב על כך במשך כל הערב
# MELAMED_Q03	לא את כל מי שאני מכיר/ה אני מחבב/ת
# MELAMED_Q04	אני נוטה להתרגש בקלות
# MELAMED_Q05	כאשר ידוע לי מראש על קיום אירוע אני עדיין מתרגש/ת כשהאירוע קורה
# MELAMED_Q06	אני מתרגז/ת לפעמים
# MELAMED_Q07	קורה שאני חושב/ת על דברים כאלה שאי-אפשר לדבר עליהם
# MELAMED_Q08	בכל פעם שאני מתרגש/ת אני מרגיש/ה שהשינויים החלים בגופי (כמו סומק, דפיקות לב מהירות וכד') נמשכים די הרבה זמן
# MELAMED_Q09	כאשר אני נזכר/ת לפעמים באירוע לא נעים שקרה לי בעבר, אני מתרגש/ת בעקבות זאת מחדש
# MELAMED_Q10	לפעמים כשאינני מרגיש/ה טוב, אני "מצוברח/ת" (במצב רוח רע)
# MELAMED_Q11	כאשר מחכה לי משהו לא נעים למחרת, הדבר מפריע לי להירדם בלילה
# MELAMED_Q12	הרבה פעמים אני חושב/ת על כך, שהייית רוצה להתרגש פחות מכל מיני דברים
# MELAMED_Q13	לפעמים יש לי חשק לקלל
# MELAMED_Q14	כאשר משהו מרגיז אותי, קשה לי לשכוח מזה ולעסוק במשהו אחר
# MELAMED_Q15	אינני סולח/ת לאחרים בקלות
# MELAMED_Q16	באירועים משמחים אני מתרגש/ת בכל פעם מחדש, למרות שאני מחליט/ה שהפעם לא אתרגש
# MELAMED_Q17	למרות שאני מנסה, מאוד קשה לי לסלק מהראש מחשבות על צרות וכאבים

melamedFiller <- c("MELAMED_Q03" , "MELAMED_Q07" , "MELAMED_Q10" , "MELAMED_Q13" , "MELAMED_Q15" )
melamedRaw <- RawQualtrics %>% select(sbj = subject_nr,starts_with("MELAMED_") & !one_of(melamedFiller)) 
#fix names
names(melamedRaw) <- gsub(x = names(melamedRaw), pattern = "_", replacement = "\\.")

#compute Melamed score
melamedRaw$melamed <- rowMeans(dplyr::select(melamedRaw, -sbj))
#return
melamed <- select(melamedRaw,sbj,melamed)


# mousetrack mark reverse questions RSES t1
# this takes all Mouse data and turns it into a file that mousetrap can work with.
mouse.raw <- cleanImplicitT1 %>% 
        filter(!is.na(count_QUE_trial)) %>% 
        select(one_of("subject_nr", "QUE_Item", "count_QUE_trial", "initiation_time_mt_task", "response_mt_task", "response_time_mt_task", "sex", "timestamps_mt_task", "xpos_mt_task", "ypos_mt_task"
        ))

# RSES
# RSES01 אני מרגיש שאני אדם בעל ערך, לפחות כמו אנשים אחרים
# RSES02 אני מרגיש שיש לי מספר תכונות טובות
# RSES03 סך הכול, אני נוטה להרגיש שאני כישלון 
# RSES04 אני מסוגל לעשות דברים כמו רב האנשים
# RSES05 אני מרגיש שאין לי הרבה דברים להתגאות בהם
# RSES06 אני נוקט בגישה חיובית כלפי עצמי
# RSES07 באופן כללי, אני מרוצה מעצמי
# RSES08 הלוואי והיה לי יותר כבוד כלפי עצמי
# RSES09 אני בהחלט מרגיש חסר תועלת לעיתים
# RSES10 לעיתים אני חושב שאני לא שווה כלל

#DEQ-SC6
#DEQQ01"לעיתים קרובות אני מוצא\ת כי אינני חי\ה בהתאם לסטנדרטים או לאידאלים שלי" , 
#DEQQ02"קיים הבדל ניכר בין איך שאני היום לבין איך שהייתי רוצה להיות" , 
#DEQQ03"אני נוטה לא להיות מרוצה ממה שיש לי" , 
#DEQQ04"קשה לי לקבל את החולשות שלי" , 
#DEQQ05"יש לי נטייה להיות מאד ביקורתי כלפי עצמי " , 
#DEQQ06"לעיתים קרובות אני משווה את עצמי לסטנדרטים או מטרות" , 

#i'm have a difficult time with regex and unicode chars (such as Hebrew and quotations marks) so I'll try to pick it from the data, verify that it, and use it in a variable
partsofme <- (mouse.raw %>%  pull(QUE_Item))[31]
mouse.raw <- mouse.raw %>%
        mutate(
                item = case_when( #by question
                        QUE_Item %in% c("לעיתים קרובות אני מוצאת כי אינני חיה בהתאם לסטנדרטים או לאידאלים שלי" ,  "לעיתים קרובות אני מוצא כי אינני חי בהתאם לסטנדרטים או לאידאלים שלי" ) ~ "DEQ_Q01",
                        QUE_Item %in% c( "קיים הבדל ניכר בין איך שאני היום לבין איך שהייתי רוצה להיות" ) ~ "DEQ_Q02",
                        QUE_Item %in% c( "אני נוטה לא להיות מרוצה ממה שיש לי" ) ~ "DEQ_Q03",
                        QUE_Item %in% c( "קשה לי לקבל את החולשות שלי" ) ~ "DEQ_Q04",
                        QUE_Item %in% c( "יש לי נטייה להיות מאד ביקורתית כלפי עצמי" ,  "יש לי נטייה להיות מאד ביקורתי כלפי עצמי" ) ~ "DEQ_Q05",
                        QUE_Item %in% c( "לעיתים קרובות אני משווה את עצמי לסטנדרטים או מטרות" ) ~ "DEQ_Q06",
                        QUE_Item %in% c("כאשר דברים לא מצליחים לי אני מתאכזב מעצמי בקלות" ,  "כאשר דברים לא מצליחים לי אני מתאכזבת מעצמי בקלות"  ) ~ "FSCRS_Q01",
                        QUE_Item == partsofme ~ "FSCRS_Q02",
                        QUE_Item %in% c( "כאשר דברים לא מצליחים לי אני יכול להזכיר לעצמי שיש בי צדדים חיוביים" ,  "כאשר דברים לא מצליחים לי אני יכולה להזכיר לעצמי שיש בי צדדים חיוביים" ) ~ "FSCRS_Q03",
                        QUE_Item %in% c( "כאשר דברים לא מצליחים לי אני מתקשה לשלוט ברגשות של כעס ותסכול שיש לי כלפי עצמי" ) ~ "FSCRS_Q04",
                        QUE_Item %in% c( "כאשר דברים לא מצליחים לי קל לי לסלוח לעצמי" ) ~ "FSCRS_Q05",
                        QUE_Item %in% c( "כאשר דברים לא מצליחים לי יש בי חלק שמרגיש שאני לא מספיק טוב" ,  "כאשר דברים לא מצליחים לי יש בי חלק שמרגיש שאני לא מספיק טובה" ) ~ "FSCRS_Q06",
                        QUE_Item %in% c( "כאשר דברים לא מצליחים לי אני מרגיש מובס ומוכה על ידי מחשבות ביקורתיות כלפי עצמי" ,  "כאשר דברים לא מצליחים לי אני מרגישה מובסת ומוכה על ידי מחשבות ביקורתיות כלפי עצמי" ) ~ "FSCRS_Q07",
                        QUE_Item %in% c( "כאשר דברים לא מצליחים לי אני ממשיך לאהוב להיות אני" ,  "כאשר דברים לא מצליחים לי אני ממשיכה לאהוב להיות אני" ) ~ "FSCRS_Q08",
                        QUE_Item %in% c( "כאשר דברים לא מצליחים לי אני כל כל כועס על עצמי שאני מרגיש צורך לפגוע או לפצוע בעצמי" ,  "כאשר דברים לא מצליחים לי אני כל כל כועסת על עצמי שאני מרגישה צורך לפגוע או לפצוע בעצמי" ) ~ "FSCRS_Q09",
                        QUE_Item %in% c( "כאשר דברים לא מצליחים לי יש לי תחושה של גועל מעצמי" ) ~ "FSCRS_Q10",
                        QUE_Item %in% c( "כאשר דברים לא מצליחים לי אני עדיין מסוגל להרגיש נאהב ומקובל" , "כאשר דברים לא מצליחים לי אני עדיין מסוגלת להרגיש נאהבת ומקובלת" ) ~ "FSCRS_Q11",
                        QUE_Item %in% c( "כאשר דברים לא מצליחים לי מפסיק להיות איכפת לי מעצמי" ) ~ "FSCRS_Q12",
                        QUE_Item %in% c( "כאשר דברים לא מצליחים לי אני מרגיש שקל לי לאהוב את עצמי" ,  "כאשר דברים לא מצליחים לי אני מרגישה שקל לי לאהוב את עצמי" ) ~ "FSCRS_Q13",
                        QUE_Item %in% c( "כאשר דברים לא מצליחים לי אני נזכר בכישלונות שלי ולא מפסיק לחשוב עליהם" ,  "כאשר דברים לא מצליחים לי אני נזכרת בכישלונות שלי ולא מפסיקה לחשוב עליהם" ) ~ "FSCRS_Q14",
                        QUE_Item %in% c( "כאשר דברים לא מצליחים לי אני מכנה את עצמי בשמות" ) ~ "FSCRS_Q15",
                        QUE_Item %in% c( "כאשר דברים לא מצליחים לי אני עדין ותומך בעצמי" ,  "כאשר דברים לא מצליחים לי אני עדינה ותומכת בעצמי" ) ~ "FSCRS_Q16",
                        QUE_Item %in% c( "כאשר דברים לא מצליחים לי אינני מסוגל לקבל כשלונות מבלי להרגיש לקוי או פגום" ,  "כאשר דברים לא מצליחים לי אינני מסוגלת לקבל כשלונות מבלי להרגיש לקויה או פגומה" ) ~ "FSCRS_Q17",
                        QUE_Item %in% c( "כאשר דברים לא מצליחים לי אני מאמין שביקורת עצמית מגיעה לי" ,  "כאשר דברים לא מצליחים לי אני מאמינה שביקורת עצמית מגיעה לי" ) ~ "FSCRS_Q18",
                        QUE_Item %in% c( "כאשר דברים לא מצליחים לי אני מסוגל לטפל ולדאוג לעצמי" ,  "כאשר דברים לא מצליחים לי אני מסוגלת לטפל ולדאוג לעצמי" ) ~ "FSCRS_Q19",
                        QUE_Item %in% c( "כאשר דברים לא מצליחים לי יש בי חלק שרוצה להיפטר מהחלקים שאני לא אוהב בעצמי"  ,"כאשר דברים לא מצליחים לי יש בי חלק שרוצה להיפטר מהחלקים שאני לא אוהבת בעצמי" ) ~ "FSCRS_Q20",
                        QUE_Item %in% c( "כאשר דברים לא מצליחים לי אני מעודד את עצמי לקראת העתיד" ,  "כאשר דברים לא מצליחים לי אני מעודדת את עצמי לקראת העתיד" ) ~ "FSCRS_Q21",
                        QUE_Item %in% c( "כאשר דברים לא מצליחים לי אני לא אוהב להיות אני" , "כאשר דברים לא מצליחים לי אני לא אוהבת להיות אני" ) ~ "FSCRS_Q22",
                        QUE_Item %in% c( "אני מרגיש שאני אדם בעל ערך, לפחות כמו אנשים אחרים",  "אני מרגישה שאני אדם בעל ערך, לפחות כמו אנשים אחרים") ~ "RSES_Q01",
                        QUE_Item %in% c( "אני מרגישה שיש לי מספר תכונות טובות", "אני מרגיש שיש לי מספר תכונות טובות") ~ "RSES_Q02",
                        QUE_Item %in% c( "סך הכל, אני נוטה להרגיש שאני כישלון" ) ~ "RSES_Q03",
                        QUE_Item %in% c( "אני מסוגל לעשות דברים כמו רב האנשים",  "אני מסוגלת לעשות דברים כמו רב האנשים") ~ "RSES_Q04",
                        QUE_Item %in% c( "אני מרגיש שאין לי הרבה דברים להתגאות בהם",  "אני מרגישה שאין לי הרבה דברים להתגאות בהם") ~ "RSES_Q05",
                        QUE_Item %in% c( "אני נוקט בגישה חיובית כלפי עצמי",  "אני נוקטת בגישה חיובית כלפי עצמי") ~ "RSES_Q06",
                        QUE_Item %in% c( "באופן כללי, אני מרוצה מעצמי") ~ "RSES_Q07",
                        QUE_Item %in% c( "הלוואי והיה לי יותר כבוד כלפי עצמי") ~ "RSES_Q08",
                        QUE_Item %in% c("אני בהחלט מרגיש חסר תועלת לעיתים", "אני בהחלט מרגישה חסרת תועלת לעיתים") ~ "RSES_Q09",
                        QUE_Item %in% c( "לעיתים אני חושב שאני לא שווה כלל", "לעיתים אני חושבת שאני לא שווה כלל") ~ "RSES_Q10",
                        T ~ "NA_character"
                ) 
        ) %>% 
        separate(item, into = c("que","q"),remove = F) %>% 
        mutate(que = case_when( que %in% c("RSES","DEQ") ~ que,
                                que == "FSCRS" & q %in% c("Q09","Q10", "Q12","Q15","Q22") ~ "fscrsHS",
                                que == "FSCRS" & q %in% c("Q01","Q02", "Q04","Q06","Q07","Q14","Q17","Q18","Q20") ~ "fscrsIS",
                                que == "FSCRS" & q %in% c("Q03","Q05", "Q08","Q11","Q13","Q16","Q19","Q21") ~ "fscrsRS",
                                TRUE ~ NA_character_),
               response = recode(response_mt_task,
                                 "במידה רבה מסכימה" = 4,
                                 "מסכימה" = 3,
                                 "מתנגדת" = 2,
                                 "במידה רבה מתנגדת" = 1,
                                 "במידה רבה מתנגד" = 1,
                                 "במידה רבה מסכים" = 4,
                                 "מתנגד" = 2,
                                 "מסכים" = 3,
                                     ))
reverseRses <- c("RSES_Q03","RSES_Q05", "RSES_Q08","RSES_Q09","RSES_Q10")

mouseQs.long <-
        mouse.raw %>% 
                select(subject_nr,response,item,que) %>% 
                mutate(response2 = ifelse( item %in% reverseRses , rv4(response),response)) %>%
                select(-response) %>%
                rename(response = response2) %>%
        {.}

# mouseQs.long %>% filter(que == "RSES",item %in% reverseRses) %>% select(-subject_nr) %>%  describe_distribution()

mouse.raw %>% 
        select(subject_nr, response, item,que) %>% 
        filter(is.na(response)) # there are no NA responses, so I can proceed without worrying about na.rm = T

mouse.Qs.item <- 
        mouse.raw %>% 
        select(subject_nr, response, item,que) %>% 
        mutate(response2 = ifelse( item %in% reverseRses , rv4(response),response)) %>%
        select(-response) %>%
        rename(response = response2) %>%
        arrange(item) %>% 
        pivot_wider(id_cols = subject_nr, names_from = item, values_from = response, values_fn = mean)

mouse.questionnaires <-
        mouseQs.long %>% 
        group_by(subject_nr, que) %>% 
        summarise(mean = mean(response, na.rm = T)) %>% 
        pivot_wider(id = subject_nr,
                    names_from = "que",
                    values_from = mean) %>% 
        rename(deq6 = DEQ, rses = RSES)
        

mouse.questionnairesT1 <- mouse.questionnaires %>% rename(sbj = subject_nr)
mouse.Qs.itemT1 <- mouse.Qs.item %>% rename(sbj = subject_nr)

# this takes all Mouse data and turns it into a file that mousetrap can work with.
mouse.raw <- cleanImplicitT2 %>% 
        filter(!is.na(count_QUE_trial)) %>% 
        select(one_of("subject_nr", "QUE_Item", "count_QUE_trial", "initiation_time_mt_task", "response_mt_task", "response_time_mt_task", "sex", "timestamps_mt_task", "xpos_mt_task", "ypos_mt_task"
        ))

#i'm have a difficult time with regex and unicode chars (such as Hebrew and quotations marks) so I'll try to pick it from the data, verify that it, and use it in a variable
mouse.raw <- mouse.raw %>%
        mutate(
                item = case_when( #by question
                        QUE_Item %in% c( "אני מרגיש שאני אדם בעל ערך, לפחות כמו אנשים אחרים",  "אני מרגישה שאני אדם בעל ערך, לפחות כמו אנשים אחרים") ~ "RSES_Q01",
                        QUE_Item %in% c( "אני מרגישה שיש לי מספר תכונות טובות", "אני מרגיש שיש לי מספר תכונות טובות") ~ "RSES_Q02",
                        QUE_Item %in% c( "סך הכל, אני נוטה להרגיש שאני כישלון" ) ~ "RSES_Q03",
                        QUE_Item %in% c( "אני מסוגל לעשות דברים כמו רב האנשים",  "אני מסוגלת לעשות דברים כמו רב האנשים") ~ "RSES_Q04",
                        QUE_Item %in% c( "אני מרגיש שאין לי הרבה דברים להתגאות בהם",  "אני מרגישה שאין לי הרבה דברים להתגאות בהם") ~ "RSES_Q05",
                        QUE_Item %in% c( "אני נוקט בגישה חיובית כלפי עצמי",  "אני נוקטת בגישה חיובית כלפי עצמי") ~ "RSES_Q06",
                        QUE_Item %in% c( "באופן כללי, אני מרוצה מעצמי") ~ "RSES_Q07",
                        QUE_Item %in% c( "הלוואי והיה לי יותר כבוד כלפי עצמי") ~ "RSES_Q08",
                        QUE_Item %in% c("אני בהחלט מרגיש חסר תועלת לעיתים", "אני בהחלט מרגישה חסרת תועלת לעיתים") ~ "RSES_Q09",
                        QUE_Item %in% c( "לעיתים אני חושב שאני לא שווה כלל", "לעיתים אני חושבת שאני לא שווה כלל") ~ "RSES_Q10",
                        QUE_Item %in% c("לעיתים קרובות אני מוצאת כי אינני חיה בהתאם לסטנדרטים או לאידאלים שלי" ,  "לעיתים קרובות אני מוצא כי אינני חי בהתאם לסטנדרטים או לאידאלים שלי" ) ~ "DEQ_Q01",
                        QUE_Item %in% c( "קיים הבדל ניכר בין איך שאני היום לבין איך שהייתי רוצה להיות" ) ~ "DEQ_Q02",
                        QUE_Item %in% c( "אני נוטה לא להיות מרוצה ממה שיש לי" ) ~ "DEQ_Q03",
                        QUE_Item %in% c( "קשה לי לקבל את החולשות שלי" ) ~ "DEQ_Q04",
                        QUE_Item %in% c( "יש לי נטייה להיות מאד ביקורתית כלפי עצמי" ,  "יש לי נטייה להיות מאד ביקורתי כלפי עצמי" ) ~ "DEQ_Q05",
                        QUE_Item %in% c( "לעיתים קרובות אני משווה את עצמי לסטנדרטים או מטרות" ) ~ "DEQ_Q06",
                        QUE_Item %in% c("כאשר דברים לא מצליחים לי אני מתאכזב מעצמי בקלות" ,  "כאשר דברים לא מצליחים לי אני מתאכזבת מעצמי בקלות"  ) ~ "FSCRS_Q01",
                        QUE_Item == partsofme ~ "FSCRS_Q02",
                        QUE_Item %in% c( "כאשר דברים לא מצליחים לי אני יכול להזכיר לעצמי שיש בי צדדים חיוביים" ,  "כאשר דברים לא מצליחים לי אני יכולה להזכיר לעצמי שיש בי צדדים חיוביים" ) ~ "FSCRS_Q03",
                        QUE_Item %in% c( "כאשר דברים לא מצליחים לי אני מתקשה לשלוט ברגשות של כעס ותסכול שיש לי כלפי עצמי" ) ~ "FSCRS_Q04",
                        QUE_Item %in% c( "כאשר דברים לא מצליחים לי קל לי לסלוח לעצמי" ) ~ "FSCRS_Q05",
                        QUE_Item %in% c( "כאשר דברים לא מצליחים לי יש בי חלק שמרגיש שאני לא מספיק טוב" ,  "כאשר דברים לא מצליחים לי יש בי חלק שמרגיש שאני לא מספיק טובה" ) ~ "FSCRS_Q06",
                        QUE_Item %in% c( "כאשר דברים לא מצליחים לי אני מרגיש מובס ומוכה על ידי מחשבות ביקורתיות כלפי עצמי" ,  "כאשר דברים לא מצליחים לי אני מרגישה מובסת ומוכה על ידי מחשבות ביקורתיות כלפי עצמי" ) ~ "FSCRS_Q07",
                        QUE_Item %in% c( "כאשר דברים לא מצליחים לי אני ממשיך לאהוב להיות אני" ,  "כאשר דברים לא מצליחים לי אני ממשיכה לאהוב להיות אני" ) ~ "FSCRS_Q08",
                        QUE_Item %in% c( "כאשר דברים לא מצליחים לי אני כל כל כועס על עצמי שאני מרגיש צורך לפגוע או לפצוע בעצמי" ,  "כאשר דברים לא מצליחים לי אני כל כל כועסת על עצמי שאני מרגישה צורך לפגוע או לפצוע בעצמי" ) ~ "FSCRS_Q09",
                        QUE_Item %in% c( "כאשר דברים לא מצליחים לי יש לי תחושה של גועל מעצמי" ) ~ "FSCRS_Q10",
                        QUE_Item %in% c( "כאשר דברים לא מצליחים לי אני עדיין מסוגל להרגיש נאהב ומקובל" , "כאשר דברים לא מצליחים לי אני עדיין מסוגלת להרגיש נאהבת ומקובלת" ) ~ "FSCRS_Q11",
                        QUE_Item %in% c( "כאשר דברים לא מצליחים לי מפסיק להיות איכפת לי מעצמי" ) ~ "FSCRS_Q12",
                        QUE_Item %in% c( "כאשר דברים לא מצליחים לי אני מרגיש שקל לי לאהוב את עצמי" ,  "כאשר דברים לא מצליחים לי אני מרגישה שקל לי לאהוב את עצמי" ) ~ "FSCRS_Q13",
                        QUE_Item %in% c( "כאשר דברים לא מצליחים לי אני נזכר בכישלונות שלי ולא מפסיק לחשוב עליהם" ,  "כאשר דברים לא מצליחים לי אני נזכרת בכישלונות שלי ולא מפסיקה לחשוב עליהם" ) ~ "FSCRS_Q14",
                        QUE_Item %in% c( "כאשר דברים לא מצליחים לי אני מכנה את עצמי בשמות" ) ~ "FSCRS_Q15",
                        QUE_Item %in% c( "כאשר דברים לא מצליחים לי אני עדין ותומך בעצמי" ,  "כאשר דברים לא מצליחים לי אני עדינה ותומכת בעצמי" ) ~ "FSCRS_Q16",
                        QUE_Item %in% c( "כאשר דברים לא מצליחים לי אינני מסוגל לקבל כשלונות מבלי להרגיש לקוי או פגום" ,  "כאשר דברים לא מצליחים לי אינני מסוגלת לקבל כשלונות מבלי להרגיש לקויה או פגומה" ) ~ "FSCRS_Q17",
                        QUE_Item %in% c( "כאשר דברים לא מצליחים לי אני מאמין שביקורת עצמית מגיעה לי" ,  "כאשר דברים לא מצליחים לי אני מאמינה שביקורת עצמית מגיעה לי" ) ~ "FSCRS_Q18",
                        QUE_Item %in% c( "כאשר דברים לא מצליחים לי אני מסוגל לטפל ולדאוג לעצמי" ,  "כאשר דברים לא מצליחים לי אני מסוגלת לטפל ולדאוג לעצמי" ) ~ "FSCRS_Q19",
                        QUE_Item %in% c( "כאשר דברים לא מצליחים לי יש בי חלק שרוצה להיפטר מהחלקים שאני לא אוהב בעצמי"  ,"כאשר דברים לא מצליחים לי יש בי חלק שרוצה להיפטר מהחלקים שאני לא אוהבת בעצמי" ) ~ "FSCRS_Q20",
                        QUE_Item %in% c( "כאשר דברים לא מצליחים לי אני מעודד את עצמי לקראת העתיד" ,  "כאשר דברים לא מצליחים לי אני מעודדת את עצמי לקראת העתיד" ) ~ "FSCRS_Q21",
                        QUE_Item %in% c( "כאשר דברים לא מצליחים לי אני לא אוהב להיות אני" , "כאשר דברים לא מצליחים לי אני לא אוהבת להיות אני" ) ~ "FSCRS_Q22",
                        T ~ "NA_character"
                ) 
        ) %>% 
        separate(item, into = c("que","q"),remove = F) %>% 
        mutate(que = case_when( que %in% c("RSES","DEQ") ~ que,
                                que == "FSCRS" & q %in% c("Q09","Q10", "Q12","Q15","Q22") ~ "fscrsHS",
                                que == "FSCRS" & q %in% c("Q01","Q02", "Q04","Q06","Q07","Q14","Q17","Q18","Q20") ~ "fscrsIS",
                                que == "FSCRS" & q %in% c("Q03","Q05", "Q08","Q11","Q13","Q16","Q19","Q21") ~ "fscrsRS",
                                TRUE ~ NA_character_),
               response = recode(response_mt_task,
                                 "במידה רבה מסכימה" = 4,
                                 "מסכימה" = 3,
                                 "מתנגדת" = 2,
                                 "במידה רבה מתנגדת" = 1,
                                 "במידה רבה מתנגד" = 1,
                                 "במידה רבה מסכים" = 4,
                                 "מתנגד" = 2,
                                 "מסכים" = 3,
                                     ))

reverseRses <- c("RSES_Q03","RSES_Q05", "RSES_Q08","RSES_Q09","RSES_Q10")

mouseQs.long <-
        mouse.raw %>% 
        select(subject_nr,response,item,que) %>% 
        mutate(response2 = ifelse( item %in% reverseRses , rv4(response),response)) %>%
        select(-response) %>%
        rename(response = response2) %>%
        {.}

# mouseQs.long %>% filter(que == "RSES",item %in% reverseRses) %>% select(-subject_nr) %>%  describe_distribution()


mouse.raw %>% 
        select(subject_nr, response, item,que) %>% 
        filter(is.na(response)) # there are no NA responses, so I can proceed without worrying about na.rm = T

mouse.Qs.item <-
        mouse.raw %>% 
        select(subject_nr, response, item,que) %>% 
        mutate(response2 = ifelse( item %in% reverseRses , rv4(response),response)) %>%
        select(-response) %>%
        rename(response = response2) %>%
        arrange(subject_nr,item) %>% 
        pivot_wider(id_cols = subject_nr, names_from = item, values_from = response, values_fn = mean)


mouse.questionnaires <-
        mouseQs.long %>% 
        group_by(subject_nr, que) %>% 
        summarise(mean = mean(response, na.rm = T)) %>% 
        pivot_wider(id = subject_nr,
                    names_from = "que",
                    values_from = mean) %>% 
        rename(deq6 = DEQ, rses = RSES)
        

mouse.questionnairesT2 <- mouse.questionnaires %>% rename(sbj = subject_nr)
mouse.Qs.itemT2 <- mouse.Qs.item %>% rename(sbj = subject_nr)



mouse.questionnaires <- mouse.questionnairesT1 %>% rename(deq6T1 = deq6, fscrsHST1 = fscrsHS, fscrsIST1 = fscrsIS, fscrsRST1 = fscrsRS, rsesT1 = rses) %>% full_join(
        mouse.questionnairesT2 %>% rename(deq6T2 = deq6, fscrsHST2 = fscrsHS, fscrsIST2 = fscrsIS, fscrsRST2 = fscrsRS, rsesT2 = rses),
        by = "sbj"
)

mouse.Qs.item <- mouse.Qs.itemT1 %>% setNames( c("sbj" , (mouse.Qs.itemT1 %>% names())[-1] %>% paste0("T1"))) %>% full_join(
        mouse.Qs.itemT2 %>% setNames( c("sbj" , (mouse.Qs.itemT2 %>% names())[-1] %>% paste0("T2"))),
        by = "sbj"
)


## get ready for IATD. this is a multistep process.. ####
### create the err variable 
errors <- cleanImplicitT1 %>% 
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

rrtDT1 <- rrtD
rrtDmodsT1 <- rrtDmods
latenciesT1 <- latencies
counterrSortedT1 <- counterrSorted
counterrT1 <- counterr
blocksT1 <- blocks

#now, the RRT from the second session
## get ready for IATD. this is a multistep process.. ####
### create the err variable 
errors <- cleanImplicitT2 %>% 
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

rrtDT2 <- rrtD
rrtDmodsT2 <- rrtDmods
latenciesT2 <- latencies
counterrSortedT2 <- counterrSorted
counterrT2 <- counterr
blocksT2 <- blocks

rrtD <- rrtDT1 %>% rename(RRTt1 = RRT) %>% full_join(rrtDT2%>% rename(RRTt2 = RRT), by = "sbj") 
rrtDmods <- rrtDmodsT1 %>% rename(RRTmod0T1 = RRTmod0, RRTmod1T1 = RRTmod1, RRTmod2T1 = RRTmod2) %>% full_join(
        rrtDmodsT2 %>% rename(RRTmod0T2 = RRTmod0, RRTmod1T2 = RRTmod1, RRTmod2T2 = RRTmod2),
        by = "sbj"
)



# merge DS #####################################################################
#list all DFs
#names(which(sapply(.GlobalEnv, is.data.frame)))  # get all current dataframes. edited output below
allds <-     Merge(demographics, bsiScores , cesd , rrtD , mouse.questionnaires, melamed, dersScores,
               id = ~sbj) %>% as_tibble()
allds_item <- Merge(demographics, bsiRaw, cesdRaw2 , mouse.Qs.item, rrtDmods , melamedRaw, dersRaw,
               id = ~sbj) %>% as_tibble()
# Save output as csv ###########################################################

quick.fst <- function(x){
                name <- deparse(substitute(x))
                fst::write_fst(x, paste0("data/",name, ".fst"))
        }
quick.fst(allds)
quick.fst(allds_item)
# quick.fst(home)
# quick.fst(cleanImplicit)
quick.fst(latenciesT1)
quick.fst(latenciesT2)
quick.fst(counterrT1)
quick.fst(counterrT2)
quick.fst(counterrSortedT1)
quick.fst(counterrSortedT2)
quick.fst(blocksT1)
quick.fst(blocksT2)
quick.fst(mouse.Qs.itemT1)
quick.fst(mouse.Qs.itemT2)


