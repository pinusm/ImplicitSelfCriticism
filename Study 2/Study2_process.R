# This file can't run due to deidentification. Contact Michael Pinus at pinusm@post.bgu.ac.il for the original code
# (which is identical, except for replaceing RedactedUser@EmailXX with real email addresses)

# load packages and functions ##################################################
pacman::p_load(Hmisc, tidyverse, here, conflicted, fst, parameters, pacman, magrittr, lubridate,IAT, qualtRics, janitor)

pacman::p_load_gh("pinusm/Mmisc", "crsh/papaja")

conflict_prefer("summarise", "dplyr", quiet = T)
conflict_prefer("filter", "dplyr", quiet = T)
conflict_prefer("select", "dplyr", quiet = T)
conflict_prefer("rename", "dplyr", quiet = T)
conflict_prefer("mutate", "dplyr", quiet = T)
conflict_prefer("lag", "dplyr", quiet = T)

# to make compatible with Yoav's code:
dir = here("Rawdata")

surveys <- all_surveys()
survey_t1_home <- fetch_survey(surveyID = surveys$id[surveys$name == "SC-B1 - 1st Session - auto reminder for part 2"],
                            force_request = F,
                            verbose = TRUE,
                            label = T,
                            convert = F,
                            time_zone = "Israel",
                            fileEncoding = "UTF-8",
                            )

survey_t1_lab <- fetch_survey(surveyID = surveys$id[surveys$name == "SC-B1 - 1st Session"],
                               force_request = F,
                               verbose = TRUE,
                               label = T,
                               convert = F,
                               time_zone = "Israel",
                               fileEncoding = "UTF-8") %>%
        mutate(part1id = as.character(subject_nr)) %>%
        filter(subject_nr < 600)

survey_t1 <-
        bind_rows(home = survey_t1_home, lab = survey_t1_lab, .id = "batch")


for_dup_emails <- survey_t1 %>% filter(!is.na(email)) %>% select(email)
dup_emails <- for_dup_emails[duplicated(for_dup_emails$email),] %>% distinct()
#but verify each and every single weird response.


survey_selected_t1 <- survey_t1 %>%
        select(ResponseId, StartDate, EndDate, Finished, Status, email, part1id , wave, batch , comparingP, consent = Q28, age, gender, hidden_words_RetriesQ1 = RetriesQ1, hidden_words_RetriesQ2 = RetriesQ2, hidden_words_RetriesQ3 = RetriesQ3, hidden_words_RetriesQ4 = RetriesQ4, hidden_words_RetriesQ5 = RetriesQ5, hidden_words_RetriesQ6 = RetriesQ6, hidden_words_RetriesQ7 = RetriesQ7, hidden_words_RetriesQ8 = RetriesQ8, hidden_words_RetriesQ9 = RetriesQ9, hidden_words_RetriesQ10 = RetriesQ10, hidden_words_RT_1, hidden_words_RT_2, hidden_words_RT_3, hidden_words_RT_4, hidden_words_RT_5, hidden_words_RT_6, hidden_words_RT_7, hidden_words_RT_8, hidden_words_RT_9, hidden_words_RT_10, expecting = Q6_1, estimateFirstTrial = Q7_1, estimateSeconds = Q8,
        satis_gen = Q16_1, satis_speed = Q19_1, satis_firstTrial = Q18_1, estimateVsReal = Q20, ins_hidden_words_RT = hidden_words_RT_ins, #needs a rename so I'll use ends_with() later, and the instructions won't be included.
               ins_hidden_words_RetriesQ = RetriesQins,#needs a rename so I'll use ends_with() later, and the instructions won't be included.
        excuse_FirstClick = `1_Q10_First Click`, cream_FirstClick = `10_Q10_First Click`, ceremony_FirstClick = `2_Q10_First Click`, trust_FirstClick = `3_Q10_First Click`, formula_FirstClick =  `4_Q10_First Click`, flow_FirstClick =  `5_Q10_First Click`, freq_FirstClick =  `6_Q10_First Click`, combost_FirstClick =  `7_Q10_First Click`, measure_FirstClick =  `8_Q10_First Click`, rubber_FirstClick =  `9_Q10_First Click`, excuse_LastClick = `1_Q10_Last Click`, cream_LastClick = `10_Q10_Last Click`, ceremony_LastClick = `2_Q10_Last Click`, trust_LastClick = `3_Q10_Last Click`, formula_LastClick = `4_Q10_Last Click`, flow_LastClick = `5_Q10_Last Click`, freq_LastClick = `6_Q10_Last Click`, combost_LastClick = `7_Q10_Last Click`, measure_LastClick = `8_Q10_Last Click`, rubber_LastClick = `9_Q10_Last Click`, excuse_PageSubmit = `1_Q10_Page Submit`, cream_PageSubmit = `10_Q10_Page Submit`, ceremony_PageSubmit = `2_Q10_Page Submit`, trust_PageSubmit = `3_Q10_Page Submit`, formula_PageSubmit = `4_Q10_Page Submit`, flow_PageSubmit = `5_Q10_Page Submit`, freq_PageSubmit = `6_Q10_Page Submit`, combost_PageSubmit = `7_Q10_Page Submit`, measure_PageSubmit = `8_Q10_Page Submit`, rubber_PageSubmit = `9_Q10_Page Submit`, excuse_ClickCount = `1_Q10_Click Count`, cream_ClickCount = `10_Q10_Click Count`, ceremony_ClickCount = `2_Q10_Click Count`, trust_ClickCount = `3_Q10_Click Count`, formula_ClickCount = `4_Q10_Click Count`, flow_ClickCount = `5_Q10_Click Count`, freq_ClickCount = `6_Q10_Click Count`, combost_ClickCount = `7_Q10_Click Count`, measure_ClickCount = `8_Q10_Click Count`, rubber_ClickCount = `9_Q10_Click Count`,
        Lower1_round7 = `10_Q14`, Lower1_round8 = `11_Q14`, Lower1_round9 = `12_Q14`, Lower1_round10 = `13_Q14`, Lower1_round1 = `4_Q14`, Lower1_round2 = `5_Q14`, Lower1_round3 = `6_Q14`, Lower1_round4 = `7_Q14`, Lower1_round5 = `8_Q14`, Lower1_round6 = `9_Q14`, Higher2_round7 = `10_Q22`, Higher2_round8 = `11_Q22`, Higher2_round9 = `12_Q22`, Higher2_round10 = `13_Q22`, Higher2_round1 = `4_Q22`, Higher2_round2 = `5_Q22`, Higher2_round3 = `6_Q22`, Higher2_round4 = `7_Q22`, Higher2_round5 = `8_Q22`, Higher2_round6 = `9_Q22`, Higher1_round7 = `10_Q23`, Higher1_round8 = `11_Q23`, Higher1_round9 = `12_Q23`, Higher1_round10 = `13_Q23`, Higher1_round1 = `4_Q23`, Higher1_round2 = `5_Q23`, Higher1_round3 = `6_Q23`, Higher1_round4 = `7_Q23`, Higher1_round5 = `8_Q23`, Higher1_round6 = `9_Q23`, Lower2_round7 = `10_Q24`, Lower2_round8 = `11_Q24`, Lower2_round9 = `12_Q24`, Lower2_round10 = `13_Q24`, Lower2_round1 = `4_Q24`, Lower2_round2 = `5_Q24`, Lower2_round3 = `6_Q24`, Lower2_round4 = `7_Q24`, Lower2_round5 = `8_Q24`, Lower2_round6 = `9_Q24`,
        FL_16_DO_FL_19,FL_16_DO_FL_20,FL_16_DO_FL_21,FL_16_DO_FL_22) %>%
        ## Recoding survey_selected$gender
        filter(!is.na(gender)) %>%
        # select(-gender) %>%
        mutate(part1id = case_when(ResponseId == "R_2uD5XEUuxBSGx9M" ~ "156", # fix for experimenter typo
                                   ResponseId == "R_AsQDERf0louwNuV" ~ "155", # fix for experimenter typo
                                   ResponseId == "R_ywraSpDv8pFPd7z" ~ "154", # fix for experimenter typo
                                   ResponseId == "R_3345rTPvQ6r7kRH" ~ "153", # fix for experimenter typo
                                   ResponseId == "R_2fs9EmKbbn9CjXP" ~ "188", # fix for experimenter typo
                                   TRUE ~ part1id
        )
        ) %>%
        filter(!(part1id %in% 101:108)) %>% # remove online pilot participants
        filter(part1id != 143) # something very weird went on with this one. looks like he/she might have participated twice?!? I noticed when a spread() to create countInfoItems failed. I'll remove it.


# this is tricky, and very much opinionated !!!!!!
# I will create composite responses where I think they are required.


ReviewedPart1ids <- c(
        "R_1dugeoOSikKGDbv" , "R_30oRSeJD2dRjCAx" , "R_3J8ECml5fTKFzUP" , "R_2TnlmmEqI5yiKxB" , "R_2BxHDyTb0WHd9Vo" , "R_3sgKjfgaPvisY1X" , "R_2EjfwFUQgEKED9E" , "R_333XTkeDFfD4wAW" , "R_2rvCELNnwCZnm2f" , "R_ZIBQ0phwjWw8aZP" , "R_2q41V1vJ3RwxIMd" , "R_3L5u3hk4Dpl95Dp" , "R_2A1dSHKCKHdWp3P" , "R_2qz4xdQeglNHLkf" , "R_3D0ixXQjQhk6F7C" , "R_3rNeQKggTXV2HvF" , "R_38ZiWeFn4TC3KnL" , "R_3rNeQKggTXV2HvF" , "R_3eaUwQYRj8j1vmo" , "R_PGHWOMGQsvXODap" , "R_1cYRnIJZEgKAbTC" , "R_1rvOzwgNprwZPBm" , "R_1g5EIsbmzXBWTi6" , "R_3Olf0UQczNBqV3T" , "R_DH4ay21wikLoLyV" , "R_2R8GZNUSKShVAAo" , "R_3rU8mjyanXWshGa" , "R_3016f6wCfPtIccS" , "R_D6KN1Ds8peOCS8F" , "R_42vMpOctScB4u53" , "R_3haQAZfy4wpVpEt" , "R_2azaqM5t7NTeN2c" , "R_3Gp4fhwWeG2I3kK" , "R_12ng2oBGHQDAF86" , "R_1JWozbLPj3DuiRE" , "R_1MPWju2sXBGPdao" , "R_3EnxWcdqME9XjMI" , "R_3hAyJANYCBJNZYz" , "R_SCwoxukjbXB7ssN" , "R_2A0BM1eOjGqFJnJ" , "R_3qBXpXADqzYTA0s" , "R_9Bo2wFlu9JOlP21" , "R_2aeRrToneU5xubr" , "R_2QEtjXWrXT9HnSP" , "R_3OjliBvFJ4lKhUK" , "R_1g8CT9QNBPyhjFy" , "R_qCPqgTQL6O36Ksx" , "R_2chIv6wPoCbMd7v" , "R_1KkhqLSee8SCpvR" , "R_tDtEAuu8yZ1ki3f" , "R_2QDUbitFHwNmN3p" , "R_1FbnT9bvaVwRZKs" , "R_1FzU0OFsoQYinGQ" , "R_3nBLqcTV6UnS9kI" , "R_6ygaXJFwxWtTNex" , "R_ZDHHDS3H9TC0CHv" , "R_2cC2Pt1a3ksDoz4" , "R_10NaoJ3h5kQRvif" , "R_2xSsrLQsCYIwHwf" , "R_Dwa88SkXjk0SEYF" , "R_2WuK3A6UcbV2Wbl" , "R_3mZzh4r4yN0Cowh" , "R_3nDcGF4Z9Bm2oXk" , "R_tWc5D8FnW8xoBDb" , "R_30ehWCOpdeLvbPR" , "R_1pKXDhXwXggLxNW" , "R_2DN7b9WnoN2DXea" , "R_3qVzBNAwSuzsDiC" , "R_2v1FUXGi2wbbuZg" , "R_2rV3DZf73yrVTUB" , "R_30jwMVRKXQn7LdU" , "R_yVzoY3jgHwOoaBz" , "R_3HoI5lqKqUs4E4Z" , "R_2Ec2GQyt65m96Wv" , "R_2rV3DZf73yrVTUB" , "R_6sQYC3StNBwSsDf" , "R_eIGNTPvFIycymWd" , "R_2QfyE5ao30lxeF9" , "R_3HoI5lqKqUs4E4Z" , "R_2taupMsmjH2Akrd" , "R_1dsPzFD31sgxLPP" , "R_yVzoY3jgHwOoaBz" , "R_30jwMVRKXQn7LdU" , "R_2Ec2GQyt65m96Wv" , "R_12buLyvkF7FZmfk" , "R_3qBCLW7UOyjj4fN" , "R_2xPMuhAJ76EErDt" , "R_2OTEtyKVfzvsjt5" , "R_1QymZP72pLri25d" , "R_3eldqxPzbA1yMEN" , "R_1CJ7XwqJSODMQsF" , "R_1kIz10700ugrMKJ" , "R_sBRV6jblIyfnqz7"
)

# copy lists of responseIDs to clipboard
# survey_selected_t1 %>%
#   arrange(StartDate, email) %>%
#   filter(!(ResponseID %in% ReviewedPart1ids)) %>%
#   select(ResponseID) %>%
#   unlist() %>%
#   writeClipboard()



review <- survey_selected_t1 %>%
        arrange(email, StartDate) %>%
        filter(!(ResponseId %in% ReviewedPart1ids))

cheatedTBL <- tribble(~part1id, ~email, ~felony,
                      "R_3J8ECml5fTKFzUP" , "RedactedUser@Email1" ,  "double entries"
                      ,"R_2TnlmmEqI5yiKxB" , "RedactedUser@Email1" ,  "double entries"
                      ,"R_2BxHDyTb0WHd9Vo" , "RedactedUser@Email2" , "double entries"
                      ,"R_3sgKjfgaPvisY1X" , "RedactedUser@Email2" , "double entries"
                      ,"R_333XTkeDFfD4wAW" , "RedactedUser@Email3" , "only saw insructions"
                      ,"R_ZIBQ0phwjWw8aZP" , "RedactedUser@Email4" , "triple entries"
                      ,"R_2q41V1vJ3RwxIMd" , "RedactedUser@Email4" , "triple entries"
                      ,"R_3L5u3hk4Dpl95Dp" , "RedactedUser@Email4" , "triple entries"
                      ,"R_2qz4xdQeglNHLkf" , "RedactedUser@Email5" , "double COMPLETE entries"
                      ,"R_3D0ixXQjQhk6F7C" , "RedactedUser@Email5" , "double COMPLETE entries"
                      ,"R_3rNeQKggTXV2HvF" , "RedactedUser@Email6" , "double COMPLETE entries"
                      ,"R_38ZiWeFn4TC3KnL" , "RedactedUser@Email6" , "double COMPLETE entries"
                      ,"R_3eaUwQYRj8j1vmo" , "RedactedUser@Email6" , "AND one partial entry"
                      ,"R_2R8GZNUSKShVAAo" , "RedactedUser@Email7" , "double COMPLETE entries"
                      ,"R_3rU8mjyanXWshGa" , "RedactedUser@Email7" , "double COMPLETE entries"
                      ,"R_3016f6wCfPtIccS" , "RedactedUser@Email7" , "AND one partial entry"
                      ,"R_12ng2oBGHQDAF86" , "RedactedUser@Email8"     , "double entry for 2nd session"
                      ,"R_2aeRrToneU5xubr" , "RedactedUser@Email9"     , "double entry for 2nd session"
                      ,"R_3OjliBvFJ4lKhUK" , "RedactedUser@Email10"  , "double entries, didn't complete"
                      ,"R_1g8CT9QNBPyhjFy" , "RedactedUser@Email10"  , "double entries, didn't complete"
                      ,"R_qCPqgTQL6O36Ksx" , "RedactedUser@Email11" , "double entries"
                      ,"R_2chIv6wPoCbMd7v" , "RedactedUser@Email11" , "double entries"
                      ,"R_1KkhqLSee8SCpvR" , "RedactedUser@Email12", "triple entries"
                      ,"R_tDtEAuu8yZ1ki3f" , "RedactedUser@Email12", "triple entries"
                      ,"R_2QDUbitFHwNmN3p" , "RedactedUser@Email12", "triple entries"
                      ,"R_tMLbtrGN1tPBAvD" , "RedactedUser@Email13" , "double entry for 2nd session"
                      ,"R_6sQYC3StNBwSsDf" , "RedactedUser@Email14" , "double entries"
                      ,"R_3eldqxPzbA1yMEN" , "RedactedUser@Email14" , "double entries"
                      ,"R_1dsPzFD31sgxLPP" , "RedactedUser@Email15" , "double entries"
                      ,"R_sBRV6jblIyfnqz7" , "RedactedUser@Email15" , "double entries"
                      ,"R_12buLyvkF7FZmfk" , "RedactedUser@Email16" , "triple entries"
                      ,"R_3qBCLW7UOyjj4fN" , "RedactedUser@Email16" , "triple entries"
                      ,"R_2xPMuhAJ76EErDt" , "RedactedUser@Email16" , "triple entries"
                      ,"R_3qBXpXADqzYTA0s" , "RedactedUser@Email17" , "double entries"
                      ,"R_3nBLqcTV6UnS9kI" , "RedactedUser@Email17" , "double entries"
)


# reviewing specific responseIDS
#  survey_selected_t1 %>%
#   filter(ResponseID %in% c(
#   "R_6sQYC3StNBwSsDf" ,"R_3eldqxPzbA1yMEN"
#   )
# ) %>%
#   View

# remove double complete entries
survey_finished_t1 <- survey_selected_t1 %>%
        filter(Finished == T) %>%                         # keep only finished
        filter(!(ResponseId %in% c("R_3D0ixXQjQhk6F7C" #RedactedUser@Email5
                                   , "R_3rNeQKggTXV2HvF" #RedactedUser@Email6
                                   , "R_3rU8mjyanXWshGa" #RedactedUser@Email7
                                   , "R_tDtEAuu8yZ1ki3f" #RedactedUser@Email12
                                   , "R_2QDUbitFHwNmN3p" #RedactedUser@Email12
                                   , "R_3nBLqcTV6UnS9kI" #RedactedUser@Email17
                                   , "R_3qBCLW7UOyjj4fN" #RedactedUser@Email16
                                   , "R_2xPMuhAJ76EErDt" #RedactedUser@Email16
        )
        )) %>%  # remove double/triple complete entries
        mutate(cheated = ifelse(ResponseId %in% cheatedTBL$part1id, T, F))


#process first session SCB
surveyKeepVars_t1 <- survey_finished_t1 %>%
        mutate(duration_t1 = EndDate - StartDate) %>%
        select(part1id , email, age , StartDate, expecting , estimateFirstTrial , estimateSeconds , satis_gen , satis_speed ,
               satis_firstTrial , estimateVsReal , ins_hidden_words_RetriesQ , ins_hidden_words_RT , duration_t1, cheated ,
               batch , hidden_words_RetriesQ1 , hidden_words_RetriesQ2 , hidden_words_RetriesQ3 , hidden_words_RetriesQ4 ,
               hidden_words_RetriesQ5 , hidden_words_RetriesQ6 , hidden_words_RetriesQ7 , hidden_words_RetriesQ8 ,
               hidden_words_RetriesQ9 , hidden_words_RetriesQ10,
               FL_16_DO_FL_19,FL_16_DO_FL_20,FL_16_DO_FL_21,FL_16_DO_FL_22) %>%
        mutate(estimateVsReal = fct_recode(estimateVsReal,
                                           "7" = "7 - הצלחת יותר מהניחוש שלך",
                                           "1" = "1 - הצלחת פחות מהניחוש שלך"
                                           ) %>% as.character() %>% as.numeric())

realSeconds <- survey_finished_t1 %>% select(part1id)
realSeconds$realSeconds <- double(nrow(realSeconds))
realSeconds$realSeconds <- as.double(survey_finished_t1 %>% select(starts_with("hidden_words_RT_")) %>% rowMeans(.,na.rm = T) ) / as.double(1000)
# There's a tiny difference if using the time logs for qualtrics pagesubmit, or from javascript's timestamps. I'll use JS, because it uses miliseconds, not seconds. the comparison is below, commented-out.
# tibble(submit = survey_selected_t1 %>% select(ends_with("PageSubmit")) %>% rowMeans(.,na.rm = T), RT = survey_selected_t1 %>% select(starts_with("hidden_words_RT_")) %>% rowMeans(.,na.rm = T))
realSeconds_raw <- survey_finished_t1 %>% select(part1id,starts_with("hidden_words_RT_"))

forCountInfoItems <- survey_finished_t1 %>%
        select(part1id,starts_with("lower"), starts_with("higher"))  %>%
        remove_empty("cols") %>%
        type_convert() %>%
        mutate(part1id = as.character(part1id)) %>%
        pivot_longer(cols = c(starts_with("Lower"),starts_with("Higher")), names_to = "Key", values_to = "value", values_drop_na = T) %>%
        arrange(part1id,Key) %>%
        separate(Key, c("countInfoItems", "round"), "_round", remove = T, convert = T ) %>%
        mutate(countInfoItems = ifelse(countInfoItems == "Lower", "Lower1", countInfoItems))

countInfoItems <- forCountInfoItems %>% group_by(part1id, countInfoItems) %>%  summarise(count = n()) %>% pivot_wider(id_cols = "part1id",names_from = countInfoItems, values_from = count)

compareResponse <- forCountInfoItems %>% select(-round) %>% filter(value != "מידע נוסף") %>%
        mutate(value_rec = recode(value,
                                  "משתתף מספר ${e://Field/comparingP} יותר טוב ממני" = "2",
                                  "משתתף מספר ${e://Field/comparingP} פחות טוב ממני" = "1"
        ) %>% as.numeric(),
        correct = (value_rec == 1 & countInfoItems %in% c("Lower1","Lower2")) | (value_rec == 2 & countInfoItems %in% c("Higher1","Higher2"))) %>%
        group_by(part1id) %>%
        summarise(allCompareCorrect = sum(correct) == 4)

countFirstTrials <- survey_finished_t1 %>%
        select(part1id,starts_with("hidden_words_RetriesQ")) %>%
        pivot_longer(starts_with("hidden_words_RetriesQ"),
                     names_to = "Key", values_to = "value", values_drop_na = TRUE) %>%
        arrange(part1id,Key) %>%
        group_by(part1id) %>%
        filter(value == 1) %>%
        summarise(realFirstTrial = n())



comparison_DspOrd <- survey_selected_t1 %>% select(part1id, FL_16_DO_FL_19,FL_16_DO_FL_20,FL_16_DO_FL_21,FL_16_DO_FL_22) %>%
        pivot_longer(-part1id,names_to = "comparing", values_to = "order") %>%
        mutate(comparingP = case_when(
                grepl(x = comparing, pattern = "FL_19") ~ "Higher1",
                grepl(x = comparing, pattern = "FL_20") ~ "Higher2",
                grepl(x = comparing, pattern = "FL_21") ~ "Lower2",
                grepl(x = comparing, pattern = "FL_22") ~ "Lower1")
               ) %>%
        separate(comparingP,into = c("type","degree"),sep = "er") %>%
        select(-comparing)

survey_t2_home <- fetch_survey(surveyID = surveys$id[surveys$name == "SC-B1 - 2nd Session - auto reminder for part 2"],
                               force_request = F,
                               verbose = TRUE,
                               label = T,
                               convert = F,
                               time_zone = "Israel",
                               fileEncoding = "UTF-8")

survey_t2_lab <- fetch_survey(surveyID = surveys$id[surveys$name == "SC-B1 - 2nd Session"],
                              force_request = F,
                              verbose = TRUE,
                              label = T,
                              convert = F,
                              time_zone = "Israel",
                              fileEncoding = "UTF-8") %>%
        mutate(part1id = as.character(subject_nr)) %>%
        filter(subject_nr < 600)

survey_t2 <-
        bind_rows(home = survey_t2_home, lab = survey_t2_lab)


survey_finished_t2 <- survey_t2 %>%
        filter( !is.na(part1id)
                , Finished == 1
                , part1id != "testtest"
        ) %>% mutate(duration_t2 = EndDate - StartDate) %>%
        select(
                part1id,
                StartDate,
                gender,
                age_t2 = age,
                memory,
                change,
                retrospectiveSC_1 = retrospective_1 ,
                retrospectiveSC_2 = retrospective_2 ,
                retrospectiveSC_3 = retrospective_3 ,
                retrospectiveSC_4 = retrospective_4 ,
                retrospectiveSC_5 = retrospective_5 ,
                retrospectiveSC_6 = retrospective_6 ,
                duration_t2,
                ResponseId,
                Finished
        ) %>%
        arrange(part1id,StartDate) %>%
        mutate(duplicated = ifelse(lag(part1id) == part1id , T , F),
               duplicated = ifelse(row_number() == 1 , F, duplicated)) %>%
        filter(!is.na(gender)) %>%
        select(-gender) %>%
        select(ResponseId, everything()) %>%
        mutate(part1id = case_when(ResponseId == "R_3R3HU04y60JeuTW" ~ "156", # fix for experimenter typo
                                   ResponseId == "R_1GZmiss5l5Ny4q5" ~ "155", # fix for experimenter typo
                                   # the would-be actual 154 P did not complete the second session
                                   ResponseId == "R_sceAL8DMm5aoT7j" ~ "153", # fix for experimenter typo
                                   ResponseId == "R_3KvibvDjMsOAx5G" ~ "126", # fix for experimenter typo
                                   TRUE ~ part1id
        )
        ) %>%
        filter(!(part1id %in% 101:108)) %>% # remove online pilot participants
        filter(part1id != 143) # something very weird went on with this one. looks like he/she might have participated twice?!? I noticed when a spread() to create countInfoItems failed. I'll remove it.

verifybyemail <- survey_finished_t2 %>%
        left_join(surveyKeepVars_t1 %>% select(part1id,email), by = "part1id") %>%
        select(ResponseId,part1id,email,everything()) %>%
        arrange(StartDate)

retrospectSC <- survey_finished_t2  %>%
        filter(!ResponseId %in% c("R_2xWUPOGZxf2i93u"   #RedactedUser@Email8
                                  ,"R_tMLbtrGN1tPBAvD"  #RedactedUser@Email13
        ))

verifybyemail <- retrospectSC %>%
        left_join(surveyKeepVars_t1 %>% select(part1id,email), by = "part1id") %>%
        select(part1id,email
               ,ResponseId
               , everything())
# if there are any Ps with NA for email, it means that they cheated on the first session, and I handeled it manually elsewhere (look in the code to find it).
#rm(verifybyemail)

dups_SCB_T2 <- retrospectSC[duplicated(retrospectSC[,'part1id']),]
dupsids_SCB_T2 <- unique(dups_SCB_T2$part1id)

retrospectSC <- retrospectSC %>%
        filter( part1id != "R_3rNeQKggTXV2HvF" #RedactedUser@Email6
                ,part1id != "R_3qBXpXADqzYTA0s" #RedactedUser@Email17
                ,ResponseId != "R_2eQL1lKf66p8zoh" #RedactedUser@Email18
                ,ResponseId != "R_1HeQHKhwcLCY8mq" #RedactedUser@Email4
                ,ResponseId != "R_1pYdHiADfuFOhFy" #RedactedUser@Email19
                ,ResponseId != "R_3nUVcOoqz1uyn1F" #RedactedUser@Email20
                ,ResponseId != "R_TpFSkWBSBhCw4o1" #RedactedUser@Email9
                ,ResponseId != "R_xrvTFvtOzaUuMr7" #RedactedUser@Email21
                ,ResponseId != "R_2TAXOLCURluwbYs" #RedactedUser@Email21
                ,ResponseId != "R_1dyrcxzZUjqx82R" #RedactedUser@Email21

        ) %>%
        mutate(
                part1id = case_when(
                        part1id == "R_3D0ixXQjQhk6F7C" ~ "R_2qz4xdQeglNHLkf"  # RedactedUser@Email5 finished twice, but returned with the second session_id, that one that I did not keep. overwrite with the correct session_id before merge.
                        , part1id == "R_3rU8mjyanXWshGa" ~ "R_2R8GZNUSKShVAAo"  # RedactedUser@Email7 finished twice, but returned with the second session_id, that one that I did not keep. overwrite with the correct session_id before merge.
                        , part1id == "R_3nBLqcTV6UnS9kI" ~ "R_3qBXpXADqzYTA0s"  # RedactedUser@Email17 finished twice, but returned with the second session_id, that one that I did not keep. overwrite with the correct session_id before merge.
                        , part1id == "R_2xPMuhAJ76EErDt" ~ "R_12buLyvkF7FZmfk"  # RedactedUser@Email16 finished three times, but returned with the third session_id, that one that I did not keep. overwrite with the correct session_id before merge.
                        , TRUE ~ part1id)
        )
##                                                                           ##
##      this also needs to be fixed for the data coming out of PI!!!         ##
##                                                                           ##

SCB_merge <- Merge(surveyKeepVars_t1 %>%
                           rename(StartDate_t1 = StartDate), realSeconds , countInfoItems , compareResponse , countFirstTrials , retrospectSC %>%
                           rename(StartDate_t2 = StartDate),
                   id = ~ part1id) %>%
        mutate(total_qualtrics_min = duration_t1 + duration_t2, inter_session_days = StartDate_t2 - StartDate_t1) %>%
        arrange(StartDate_t1) %>%
        as_tibble() %>%
        type_convert()

retriesQs <-
        c( "hidden_words_RetriesQ1",
           "hidden_words_RetriesQ2",
           "hidden_words_RetriesQ3",
           "hidden_words_RetriesQ4",
           "hidden_words_RetriesQ5",
           "hidden_words_RetriesQ6",
           "hidden_words_RetriesQ7",
           "hidden_words_RetriesQ8",
           "hidden_words_RetriesQ9",
           "hidden_words_RetriesQ10")
satisQs <- c("satis_gen" , "satis_speed" , "satis_firstTrial")

SCB_merge$HWGsatis <- SCB_merge %>% select(one_of(satisQs)) %>% rowMeans(.) #should be low for high SC - it's hard to be satisfied with your performance
# SCB_merge$expecting # percent that will make you feel good. should be high for high SC - the standart is set very high
# SCB_merge$estimateVsReal # were you better or wrose than your estimate. should be low for high SC.
SCB_merge$HWGmeanRetries <- SCB_merge %>% select(one_of(retriesQs)) %>% rowMeans(.) #should be low for high SC - it's hard to give up and try for nothing
SCB_merge$countInfoItemsHigher <- SCB_merge %>% select(Higher1 , Higher2) %>% rowMeans(. , na.rm = T) # should be low for high SC - it's easy to say someone else is better
SCB_merge$countInfoItemsLower <- SCB_merge %>% select(Lower1 , Lower2) %>% rowMeans(. , na.rm = T) # should be high for high SC - it's hard to say someone else is worse
SCB <- SCB_merge %>% mutate(countInfoDiff = countInfoItemsLower - countInfoItemsHigher, # should be high for high SC.
                            expectSatisDiff = expecting - HWGsatis # should be high for high SC.
)

SCB <- Hmisc::Merge(realSeconds_raw,SCB,id = ~part1id)

path = paste(dir, "explicit.txt", sep = "\\")
#Read the tab-seperated values from explicit.txt
#The read.delim function is spcialized for this kind of data.
explicit.long <- read.delim(path, stringsAsFactors = FALSE)
nrow(explicit.long) #Always test all rows were read fine (open the txt file in notepad++ to count the lines)

#Learn what questionnaires we have in this data.
unique(explicit.long$questionnaire_name)
#Keep only data from the relevant questionnaire
forexp <- explicit.long %>% filter(questionnaire_name %in%
                                           c('cesd',
                                             'rses',
                                             'fscrs',
                                             'bsi',
                                             'mgr'))

#Learn what question responses we have;
class(forexp$question_response)

forexp <- forexp %>%
        mutate(question_response_orig = question_response,#keep original question response
               question_response = ifelse(question_response == 'null', NA, question_response),#Convert to numeric,  but first, deal with 'null' responses to avoid uncontrolled NA coercion
               question_response = as.numeric(as.character(question_response)),
               question_response = ifelse(question_response == -999, NA, question_response)) #Convert -999 to NA; Notice that we lose here information about the rate of skipping questions.

#Remove sessions with more responses than expected.
dups <- forexp[duplicated(forexp[,c('session_id', 'question_name')]),]
dupsids <- unique(dups$session_id)
length(dupsids)
dupexps <- forexp %>% filter(session_id %in% dupsids)
forexp <- forexp %>% filter(!session_id %in% dupsids)
#Convert to wide format by subject.
explicit <- forexp %>% select(session_id, question_name, question_response) %>% pivot_wider(names_from = question_name, values_from = question_response) %>%
        rename(part1id = subject_nr)

#RSES
#rsesQ01: I feel that I am a person of worth, at least on an equal plane with others
#rsesQ02: I feel that I have a number of good qualities
#rsesQ03: I am able to do things as well as most other people
#rsesQ04: I take a positive attitude toward myself.'
#rsesQ05: On the whole, I am satisfied with myself
#rsesQ06: All in all, I am inclined to feel that I am a failure
#rsesQ07: I feel I do not have much to be proud of
#rsesQ08: I wish I could have more respect for myself
#rsesQ09: I certainly feel useless at times
#rsesQ10: At times, I think I am no good at all

# reverse-code the reverse items
explicit <- explicit %>%
        mutate(
                rsesQ06r = rv4zero(rsesQ06),
                rsesQ07r = rv4zero(rsesQ07),
                rsesQ08r = rv4zero(rsesQ08),
                rsesQ09r = rv4zero(rsesQ09),
                rsesQ10r = rv4zero(rsesQ10)
        )
rsesQs <- c("rsesQ01" , "rsesQ02" , "rsesQ03" , "rsesQ04" , "rsesQ05" , "rsesQ06r" , "rsesQ07r" , "rsesQ08r" , "rsesQ09r" , "rsesQ10r")

#compute RSES score
explicit$rses <- explicit %>% select(one_of(rsesQs)) %>% rowMeans(.)
rsesRaw <- explicit %>% select(session_id,one_of(rsesQs))

rsesIC <- explicit %>% select(one_of(rsesQs)) %>% psych::alpha(.)
print(paste0("Raw Cronbach's Alpha for the RSES was ", round((rsesIC$total$raw_alpha),2)))


## CESD
# 'regular' items (high score is more depression) # cesdQ01 במהלך השבועיים האחרונים, כולל היום הייתי מוטרד בשל דברים שבדרך כלל לא מטרידים אותי. # cesdQ02 במהלך השבועיים האחרונים, כולל היום לא היה לי חשק לאכול. לא היה לי תאבון. # cesdQ03 במהלך השבועיים האחרונים, כולל היום הרגשתי שאני לא יכול להיפטר ממצבי רוח, אפילו לא בעזרת משפחתיאו חברי. # cesdQ04 במהלך השבועיים האחרונים, כולל היום הרגשתי שאני טוב בדיוק כמו כל אחד אחר. # cesdQ05 במהלך השבועיים האחרונים, כולל היום היה לי קשה להתרכז בדברים שאני עושה. # cesdQ06 במהלך השבועיים האחרונים, כולל היום הרגשתי מדוכא. # cesdQ07 במהלך השבועיים האחרונים, כולל היום הרגשתי שכל מה שאני עושה דורש מאמץ. # cesdQ08 במהלך השבועיים האחרונים, כולל היום הרגשתי מלא תקווה בקשר לעתיד. # cesdQ09 במהלך השבועיים האחרונים, כולל היום חשבתי שחיי הם כישלון. # cesdQ10 במהלך השבועיים האחרונים, כולל היום הרגשתי מפוחד. # cesdQ11 במהלך השבועיים האחרונים, כולל היום השינה שלי לא היתה שקטה. # cesdQ12 במהלך השבועיים האחרונים, כולל היום הייתי מאושר. # cesdQ13 במהלך השבועיים האחרונים, כולל היום דיברתי פחות מהרגיל. # cesdQ14 במהלך השבועיים האחרונים, כולל היום הרגשתי בודד. # cesdQ15 במהלך השבועיים האחרונים, כולל היום אנשים לא היו ידידותיים כלפי. # cesdQ16 במהלך השבועיים האחרונים, כולל היום נהנתי מהחיים. # cesdQ17 במהלך השבועיים האחרונים, כולל היום היו לי התפרצויות בכי. # cesdQ18 במהלך השבועיים האחרונים, כולל היום הרגשתי עצוב. # cesdQ19 במהלך השבועיים האחרונים, כולל היום הרגשתי שאנשים לא מחבבים אותי. # cesdQ20 במהלך השבועיים האחרונים, כולל היום לא יכולתי "להזיז את עצמי"

# 0 = Rarely or None of the Time (Less than 1 Day)" # 1 = "Some or a Little of the Time (1-2 Days)"  # 2 = "Occasionally or a Moderate Amount of Time (3-4 Days)" # 3 = "Most or All of the Time (5-7 Days)"]

# reverse-code the reverse items
explicit <- explicit %>%
        mutate(
                cesdQ04r = rv4zero(cesdQ04),
                cesdQ08r = rv4zero(cesdQ08),
                cesdQ12r = rv4zero(cesdQ12),
                cesdQ16r = rv4zero(cesdQ16)
        )

cesdQs <- c("cesdQ01" , "cesdQ02" , "cesdQ03" , "cesdQ04r" , "cesdQ05" , "cesdQ06" , "cesdQ07" , "cesdQ08r" , "cesdQ09" , "cesdQ10" , "cesdQ11" , "cesdQ12r" , "cesdQ13" , "cesdQ14" , "cesdQ15" , "cesdQ16r" , "cesdQ17" , "cesdQ18" , "cesdQ19" , "cesdQ20")

#compute cesd score
explicit$cesd <- explicit %>% select(one_of(cesdQs)) %>% rowSums(., na.rm = F)

cesdRaw <- explicit %>% select(session_id,one_of(cesdQs))

cesdIC <- cesdRaw %>% select(one_of(cesdQs)) %>% psych::alpha(.)
print(paste0("Raw Cronbach's Alpha for the cesd was ", round((cesdIC$total$raw_alpha),2)))

#BSI
# bsiQ01 צבנות # bsiQ02 רגשת עילפון או סחרחורת # bsiQ03 חשבה שמישהו אחר יכול לשלוט על מחשבותיך # bsiQ04 רגשה שאחרים אשמים בבעיות שלך # bsiQ05 שיים בזיכרון # bsiQ06 תרגז ומתעצבן מהר # bsiQ07 אבים בלב או בחזה # bsiQ08 חד ממקומות פתוחים # bsiQ09 חשבות לשים קץ לחייך # bsiQ10 הרגשה שאי אפשר לסמוך על מרבית האנשים # bsiQ11 חוסר תאבון # bsiQ12 הרגשת פחד פתאומי ללא סיבה # bsiQ13 התפרצויות זעם שלא יכולת לשלוט בהן # bsiQ14 הרגשת בדידות גם כשהינך בחברת אנשים # bsiQ15 הרגשה שמשהו מפריע לך לבצע דברים # bsiQ16 הרגשת בדידות # bsiQ17 מצוברח # bsiQ18 חוסר עניין בדברים # bsiQ19 הרגשת פחד # bsiQ20 הנך נפגע בקלות # bsiQ21 הרגשה שאנשים אינם ידידותיים או שאינם מסמפטים אותך # bsiQ22 הרגשה שהנך נחות מאחרים # bsiQ23 בחילה או אי-שקט בבטן # bsiQ24 הרגשה שאנשים מסתכלים או מדברים עליך # bsiQ25 קושי להירדם # bsiQ26 צורך לחזור ולבדוק מה שעשית # bsiQ27 קושי בהחלטה # bsiQ28 פחד לנסוע באוטובוס או ברכבת # bsiQ29 קושי בנשימה # bsiQ30 גלי חום או קור # bsiQ31 צורך להמנע ממקומות או מפעולות אשר מפחידים אותך # bsiQ32 שהראש נעשה ריק # bsiQ33 שהגפיים כאילו מאובנות או דקירות בחלקים שונים של הגוף # bsiQ34 מחשבה שמגיע לך עונש על חטאיך # bsiQ35 חוסר תקווה לגבי העתיד# bsiQ36 קשיי ריכוז # bsiQ37 הרגשת חולשה בחלקים מגופך # bsiQ38 הרגשת מתח # bsiQ39 מחשבות על מוות # bsiQ40 דחף להכות, לפצוע או להזיק למישהו # bsiQ41 דחף לשבור ולהפוך דברים # bsiQ42 הרגשת מבוכה בחברה # bsiQ43 הרגשת אי נוחות פנימית # bsiQ44 חוסר הרגשת קרבה לאנשים # bsiQ45 התקפי פחד או פאניקה # bsiQ46 נכנס לויכוחים מהירים # bsiQ47 הרגשת עצבנות כשהינך נשאר לבד # bsiQ48 שהאחרים אינם מעריכים כראוי את הישגיך # bsiQ49 חוסר שקט כזה שאינך יכול לשבת במקום אחד # bsiQ50 הרגשת חוסר ערך # bsiQ51 הרגשה שאנשים ינצלו אותך (אם תתן להם) # bsiQ52 הרגשות אשמה # bsiQ53 הרגשה שמשהו לא בסדר עם הראש שלך

bsiDepQs <- c("bsiQ09" , "bsiQ16" , "bsiQ17" , "bsiQ18" , "bsiQ35" , "bsiQ50")

bsiRaw <- explicit %>% select(session_id, starts_with("bsiQ"),-ends_with("rt"))

#compute bsi score
explicit$bsi.general <- explicit %>% select(starts_with("bsiQ"),-ends_with("rt")) %>% rowMeans(., na.rm = T)
explicit$bsi.Depression <- explicit %>% select(one_of(bsiDepQs)) %>% rowMeans(., na.rm = F)

#fscrs
# is fscrsQ01 אני מתאכזב מעצמי בקלות
# is fscrsQ02 יש בי חלק ש"יורד" על עצמי
# rs fscrsQ03 אני יכול להזכיר לעצמי שיש בי צדדים חיוביים
# is fscrsQ04 אני מתקשה לשלוט ברגשות של כעס ותסכול שיש לי כלפי עצמי
# rs fscrsQ05 קל לי לסלוח לעצמי
# is fscrsQ06 יש בי חלק שמרגיש שאני לא מספיק טוב
# is fscrsQ07 אני מרגיש מובס ומוכה על ידי מחשבות ביקורתיות כלפי עצמי
# rs fscrsQ08 אני ממשיך לאהוב להיות אני
# hs fscrsQ09 אני כל כך כועס על עצמי שאני מרגיש צורך לפגוע או לפצוע בעצמי
# hs fscrsQ10 יש לי תחושה של גועל מעצמי
# rs fscrsQ11 אני עדיין מסוגל להרגיש נאהב ומקובל
# hs fscrsQ12 מפסיק להיות איכפת לי מעצמי
# rs fscrsQ13 אני מרגיש שקל לי לאהוב את עצמי
# is fscrsQ14 אני נזכר בכישלונות שלי ולא מפסיק לחשוב עליהם
# hs fscrsQ15 אני מכנה את עצמי בשמות
# rs fscrsQ16 אני עדין ותומך בעצמי
# is fscrsQ17 אינני מסוגל לקבל כשלונות מבלי להרגיש לקוי או פגום
# is fscrsQ18 אני מאמין שביקורת עצמית מגיעה לי
# rs fscrsQ19 אני מסוגל לטפל ולדאוג לעצמי
# is fscrsQ20 יש בי חלק שרוצה להיפטר מהחלקים שאני לא אוהב בעצמי
# rs fscrsQ21 אני מעודד את עצמי לקראת העתיד
# hs fscrsQ22 אני לא אוהב להיות אני

fscrsHSq <- c("fscrsQ09","fscrsQ10", "fscrsQ12","fscrsQ15","fscrsQ22")
fscrsRSq <- c("fscrsQ03","fscrsQ05", "fscrsQ08","fscrsQ11","fscrsQ13","fscrsQ16","fscrsQ19","fscrsQ21")
fscrsISq <- c("fscrsQ01","fscrsQ02", "fscrsQ04","fscrsQ06","fscrsQ07","fscrsQ14","fscrsQ17","fscrsQ18","fscrsQ20")

fscrsHSraw <- explicit %>% select(session_id, one_of(fscrsHSq))
fscrsRSraw <- explicit %>% select(session_id, one_of(fscrsRSq))
fscrsISraw <- explicit %>% select(session_id, one_of(fscrsISq))
#compute FSCRS scores
fscrsHSraw$fscrsHS <- rowMeans(dplyr::select(fscrsHSraw, -session_id),na.rm = T)
fscrsRSraw$fscrsRS <- rowMeans(dplyr::select(fscrsRSraw, -session_id),na.rm = T)
fscrsISraw$fscrsIS <- rowMeans(dplyr::select(fscrsISraw, -session_id),na.rm = T)
#return
fscrs <- Merge(fscrsHSraw %>% select(session_id,fscrsHS),
               fscrsISraw %>% select(session_id,fscrsIS),
               fscrsRSraw %>% select(session_id,fscrsRS),
               id = ~session_id)
explicit <- full_join(explicit,fscrs, by = "session_id")



#Save the explicit to file(recommended to view this file in Excel, to understand what we saved)
write.csv(explicit,file = here("data/explicit.csv"),na = "")

####################################################################################################################
#Read session data
####################################################################################################################

#Read session data

path <- paste(dir,"sessionTasks.txt", sep = "\\")
sessions.long <- read.table(path, sep = "\t", header = TRUE, fill = TRUE, stringsAsFactors = FALSE)
nrow(sessions.long) #Always test all rows were read fine (open the txt file in notepad++ to count the lines)
#Remove unimportant columns (variables)
sessions.long <- sessions.long[,c("session_id", "user_id" , "task_id", "task_number", "user_agent", "task_creation_date", "session_last_update_date")]

sessions.long2 <- sessions.long %>%
        filter(session_id != 6904750,
               session_id != 6904748)  # fix a problematic user in the development stages (not production!), where the same test subject did more than on task as the first task (that was michael, while coding the tasks and previewing them)

#let's see the tasks we have on our hands
unique(sessions.long2$task_id) #nothing funky. it appears all subjects did only tasks from THIS study
sessions.long2$duplicate <- duplicated(sessions.long2[,c("session_id","task_id")]) #mark participants that did the same task (by task_id) twice, in one session as duplicates
sessions.long2 <- sessions.long2 %>%
        filter(!duplicate #remove those duplicates, because spread() can't handle them
        ) %>%
        select(-duplicate) %>% #remove the duplicate column, as it has done its duty. also remove the useragent - it not very interesting at the moment
        mutate(
                session_last_update_date = ifelse(trimws(session_last_update_date) == "NULL", NA, session_last_update_date),
                task_creation_date =  dmy_hms(task_creation_date),
                session_last_update_date = dmy_hms(session_last_update_date)
        )


times <- sessions.long2 %>%
        group_by(session_id) %>%
        arrange(session_id,task_number) %>%
        mutate(taskDuration_secs = as.numeric(interval(task_creation_date,lead(task_creation_date,1))),
               taskDuration_secs = ifelse(is.na(taskDuration_secs), as.numeric(interval(task_creation_date,session_last_update_date)),taskDuration_secs)
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
        total_secs = sessions %>% select(starts_with("t."),-t.session_last_update_date,-t.user_agent) %>% rowSums(na.rm = T),
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
iat <- read.table(path, sep = "\t", header = TRUE, fill = TRUE, stringsAsFactors = FALSE, quote = "", encoding = "UTF-8")
nrow(iat) #Always test all rows were read fine (open the txt file in notepad++ to count the lines)

#Covert trial_error to numeric, and make sure trial_latency is numeric
iat$trial_error <- as.numeric(as.character(iat$trial_error))
class(iat$trial_error)
class(iat$trial_latency)

#task_name helps differentiate between the different reaction time tasks.
unique(iat$task_name)

#Get qiat rows
qiatRaw <- subset(iat, task_name %in% c("sc.qiat_f" ,"se.qiat_f" ,"sc.qiat_m", "se.qiat_m"))
#Learn a bit about how we coded the blocks.
unique(qiatRaw$block_pairing_definition)
unique(qiatRaw$block_number)
#Keep only the rows of the qiat's critical blocks.
qiatRaw <- subset(qiatRaw,
                  block_pairing_definition %in% c(
                          "lowSC/שקר,highSC/אמת",
                          "highSE/שקר,lowSE/אמת",
                          "lowSE/שקר,highSE/אמת",
                          "highSC/שקר,lowSC/אמת"
                  ))

#Create blockName based on the pairing condition.
qiatRaw$blockName[qiatRaw$block_pairing_definition %in%
                          c("lowSC/שקר,highSC/אמת","lowSE/שקר,highSE/אמת") &
                          qiatRaw$block_number %in% c(4,7)] <- "B3"   #NOTICE there are 8 blocks in the qIAT (2a,2b), so block 4 is 'conceptually' block 3.
qiatRaw$blockName[qiatRaw$block_pairing_definition %in%
                          c("lowSC/שקר,highSC/אמת","lowSE/שקר,highSE/אמת") &
                          qiatRaw$block_number %in% c(5,8)] <- "B4"
qiatRaw$blockName[qiatRaw$block_pairing_definition %in%
                          c("highSC/שקר,lowSC/אמת","highSE/שקר,lowSE/אמת") &
                          qiatRaw$block_number %in% c(4,7)] <- "B6"
qiatRaw$blockName[qiatRaw$block_pairing_definition %in%
                          c("highSC/שקר,lowSC/אמת","highSE/שקר,lowSE/אמת") &
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
                trait = ifelse(grepl('SC', block_pairing_definition), "SC", "SE")
        )
#separate the two qiat's
qiatRawSC <- qiatRaw %>% filter(trait == "SC")
qiatRawSE <- qiatRaw %>% filter(trait == "SE")

#Use Dan Martin's qiat scoring function. It seems faster than the one Aharon wrote.
qiatscoreSC <- cleanIAT(qiatRawSC, block_name = "blockName",
                      trial_blocks = c("B3", "B4", "B6", "B7"),
                      session_id = "session_id",
                      trial_latency = "trial_latency",
                      trial_error = "trial_error",
                      v_error = 2, v_extreme = 2, v_std = 1) #v_error=2 means recode error latency to m+600
#Sanity check. Does the qiat scores seem fine?
describe_distribution(qiatscoreSC$IAT)

#Save the qiat scores. (recommended to view this file in Excel, to understand what we saved; use ?cleanIAT to learn what each variable in the output means)
write.csv(qiatscoreSC,file = here("data/qiatscoreSC.csv"),na = "")

#Use Dan Martin's qiat scoring function. It seems faster than the one Aharon wrote.
qiatscoreSE <- cleanIAT(qiatRawSE, block_name = "blockName",
                      trial_blocks = c("B3", "B4", "B6", "B7"),
                      session_id = "session_id",
                      trial_latency = "trial_latency",
                      trial_error = "trial_error",
                      v_error = 2, v_extreme = 2, v_std = 1) #v_error=2 means recode error latency to m+600
#Sanity check. Does the qiat scores seem fine?
describe_distribution(qiatscoreSE$IAT)

#Save the qiat scores. (recommended to view this file in Excel, to understand what we saved; use ?cleanIAT to learn what each variable in the output means)
write.csv(qiatscoreSE,file = here("data/qiatscoreSE.csv"),na = "")

#IC for qiat ####
qiatRawSC$modulo <- 1:nrow(qiatRawSC) %% 3   ### nth cycle, here every 3
qiatRawSE$modulo <- 1:nrow(qiatRawSE) %% 3   ### nth cycle, here every 3

### make sure every subject has same number of trials with valid
### block_number.
qiatRaw %>%
        group_by(session_id,trait) %>%
        filter(!is.na(block_number)) %>%
        dplyr::count()

### make sure numbers of trials with valid block_number make sense. note:
### B6,B7 are should be twice as long as B3,B4
qiatRaw %>%
        group_by(block_number,trait) %>%
        filter(!is.na(block_number)) %>%
        dplyr::count()
# breakdown the valid trials by blocks, for each subject. this could get
# lengthy for big datasets.
qiatRaw %>%
        group_by(session_id,block_number,trait) %>%
        filter(!is.na(block_number)) %>%
        dplyr::count()


# now same tests, by modulo, to make sure the division for the IC analysis
# worked as expected

qiatmod0SC <- qiatRawSC[qiatRawSC$modulo == 0 , ]
qiatmod1SC <- qiatRawSC[qiatRawSC$modulo == 1 , ]
qiatmod2SC <- qiatRawSC[qiatRawSC$modulo == 2 , ]

qiatDmod0SC <- cleanIAT(qiatmod0SC, block_name = "blockName",
                      trial_blocks = c("B3", "B4", "B6", "B7"),
                      session_id = "session_id",
                      trial_latency = "trial_latency",
                      trial_error = "trial_error",
                      v_error = 2, v_extreme = 2, v_std = 1) #v_error=2 means recode error latency to m+600
#Sanity check. Does the qiat scores seem fine?
describe_distribution(qiatDmod0SC$IAT)
qiatDmod1SC <- cleanIAT(qiatmod1SC, block_name = "blockName",
                      trial_blocks = c("B3", "B4", "B6", "B7"),
                      session_id = "session_id",
                      trial_latency = "trial_latency",
                      trial_error = "trial_error",
                      v_error = 2, v_extreme = 2, v_std = 1) #v_error=2 means recode error latency to m+600
#Sanity check. Does the qiat scores seem fine?
describe_distribution(qiatDmod1SC$IAT)
qiatDmod2SC <- cleanIAT(qiatmod2SC, block_name = "blockName",
                      trial_blocks = c("B3", "B4", "B6", "B7"),
                      session_id = "session_id",
                      trial_latency = "trial_latency",
                      trial_error = "trial_error",
                      v_error = 2, v_extreme = 2, v_std = 1) #v_error=2 means recode error latency to m+600
#Sanity check. Does the qiat scores seem fine?
describe_distribution(qiatDmod2SC$IAT)

rm(qiatmod0SC,qiatmod1SC,qiatmod2SC)

qiatDmod0SC$qiatmod0SC <- qiatDmod0SC$IAT
qiatDmod1SC$qiatmod1SC <- qiatDmod1SC$IAT
qiatDmod2SC$qiatmod2SC <- qiatDmod2SC$IAT

qiatDmod0SC <- dplyr::select(qiatDmod0SC,session_id,qiatmod0SC)
qiatDmod1SC <- dplyr::select(qiatDmod1SC,session_id,qiatmod1SC)
qiatDmod2SC <- dplyr::select(qiatDmod2SC,session_id,qiatmod2SC)

qiatDmodsSC <- Merge(qiatDmod0SC, qiatDmod1SC, qiatDmod2SC, id = ~ session_id , verbose = FALSE)
rm(qiatDmod0SC,qiatDmod1SC,qiatDmod2SC)
qiatICSC <- psych::alpha(qiatDmodsSC[ , -1])
qiatICSC
print(paste0("Raw Cronbach's Alpha for the SC qiat is ", round((qiatICSC$total$raw_alpha),2)))

#Save the qiat modulo scores. (recommended to view this file in Excel, to understand what we saved; use ?cleanIAT to learn what each variable in the output means)
write.csv(qiatDmodsSC,file = here("data/qiatDmodsSC.csv"),na = "")
#

qiatmod0SE <- qiatRawSE[qiatRawSE$modulo == 0 , ]
qiatmod1SE <- qiatRawSE[qiatRawSE$modulo == 1 , ]
qiatmod2SE <- qiatRawSE[qiatRawSE$modulo == 2 , ]

qiatDmod0SE <- cleanIAT(qiatmod0SE, block_name = "blockName",
                        trial_blocks = c("B3", "B4", "B6", "B7"),
                        session_id = "session_id",
                        trial_latency = "trial_latency",
                        trial_error = "trial_error",
                        v_error = 2, v_extreme = 2, v_std = 1) #v_error=2 means recode error latency to m+600
#Sanity check. Does the qiat scores seem fine?
describe_distribution(qiatDmod0SE$IAT)
qiatDmod1SE <- cleanIAT(qiatmod1SE, block_name = "blockName",
                        trial_blocks = c("B3", "B4", "B6", "B7"),
                        session_id = "session_id",
                        trial_latency = "trial_latency",
                        trial_error = "trial_error",
                        v_error = 2, v_extreme = 2, v_std = 1) #v_error=2 means recode error latency to m+600
#Sanity check. Does the qiat scores seem fine?
describe_distribution(qiatDmod1SE$IAT)
qiatDmod2SE <- cleanIAT(qiatmod2SE, block_name = "blockName",
                        trial_blocks = c("B3", "B4", "B6", "B7"),
                        session_id = "session_id",
                        trial_latency = "trial_latency",
                        trial_error = "trial_error",
                        v_error = 2, v_extreme = 2, v_std = 1) #v_error=2 means recode error latency to m+600
#Sanity check. Does the qiat scores seem fine?
describe_distribution(qiatDmod2SE$IAT)

rm(qiatmod0SE,qiatmod1SE,qiatmod2SE)

qiatDmod0SE$qiatmod0SE <- qiatDmod0SE$IAT
qiatDmod1SE$qiatmod1SE <- qiatDmod1SE$IAT
qiatDmod2SE$qiatmod2SE <- qiatDmod2SE$IAT

qiatDmod0SE <- dplyr::select(qiatDmod0SE,session_id,qiatmod0SE)
qiatDmod1SE <- dplyr::select(qiatDmod1SE,session_id,qiatmod1SE)
qiatDmod2SE <- dplyr::select(qiatDmod2SE,session_id,qiatmod2SE)

qiatDmodsSE <- Merge(qiatDmod0SE, qiatDmod1SE, qiatDmod2SE, id = ~ session_id , verbose = FALSE)
rm(qiatDmod0SE,qiatDmod1SE,qiatDmod2SE)
qiatICSE <- psych::alpha(qiatDmodsSE[ , -1])
qiatICSE
print(paste0("Raw Cronbach's Alpha for the SE qiat is ", round((qiatICSE$total$raw_alpha),2)))

#Save the qiat modulo scores. (recommended to view this file in Excel, to understand what we saved; use ?cleanIAT to learn what each variable in the output means)
write.csv(qiatDmodsSE,file = here("data/qiatDmodsSE.csv"),na = "")
#

qiatCond <- qiatRaw[,c('session_id','trait', 'blockOrder')] %>% distinct()

#But make sure there are no sessions with two different trait orders
dups <- qiatCond %>% group_by(session_id,trait) %>% summarise(count = n()) %>% filter(count >1)
nrow(dups) #Make sure it is zero

qiatCondSC <- qiatCond %>% rename(blockOrder.SC = blockOrder) %>% filter(trait == "SC") %>% select(-trait)
qiatCondSE <- qiatCond %>% rename(blockOrder.SE = blockOrder) %>% filter(trait == "SE") %>% select(-trait)

#Save the condition in a file.
write.csv(qiatCondSC,file = here("data/qiatCondSC.csv"),na = "")
write.csv(qiatCondSE,file = here("data/qiatCondSE.csv"),na = "")

#Remove data frames to free memory
rm( dups)


#Get study conditions
forcond <- explicit.long %>% filter(questionnaire_name %in% c('mgr'))
#Remove sessions with more responses than expected.
##**Elad explained to me that if participants refreshed while the study was loading, the conditions were randomly chosen more than once. **
##**So, the last saved variables are probably the correct variables, but we can simply use the actual data to infer the conditions **
dups <- forcond[duplicated(forcond[,c('session_id', 'question_name')]),]
dupsids <- unique(dups$session_id)
stopifnot(length(dupsids) == 0) #Make sure it is zero
dupcond <- forcond %>% filter(session_id %in% dupsids)
#We'll save only those who do not have duplicates. For the duplicates, we will infer the correct conditions from other records later.
forcond <- forcond %>% filter(!session_id %in% dupsids)

#Convert to wide format by subject.
conds <- forcond %>% select(session_id , question_name , question_response) %>% spread(key = question_name , value = question_response)
conds <- conds %>% select(-refresh, -study) %>% rename(part1id = subject_nr)

#Save the conditions to file
write.csv(conds, file = here("data/conds.csv"),na = "")




#Remove data frames to free memory
# rm(explicit.long, forcond, dups, dupsids, dupcond, dupexps, forexp,qiatCond)


allPI <- Hmisc::Merge(sessions , conds,  explicit %>%
                              select(-wave,-female,-part1id) , qiatCondSE  , qiatDmodsSC , qiatDmodsSE ,
                      qiatscoreSC %>%
                              select(session_id, qIATSC = IAT),
                      qiatscoreSE %>%
                              select(session_id, qIATSE = IAT) ,
                      id = ~ session_id) %>%
        filter(!part1id == "testtest") %>%
        mutate(part1id = case_when( #manual fix for wrong URL coming out of Qualtrics for the first few Ps. This was picked up in the sanity checks). linking to the qualtrics data was done by matching the endDate of qualtrics with the start date in PI.
                session_id == "10506783" ~ "R_1dugeoOSikKGDbv",
                session_id == "10508518" ~ "R_30oRSeJD2dRjCAx",
                session_id == "10509120" ~ "R_2TnlmmEqI5yiKxB",
                session_id == "10509125" ~ "R_3sgKjfgaPvisY1X",
                session_id == "10509335" ~ "R_2EjfwFUQgEKED9E",
                session_id == "10510330" ~ "R_2rvCELNnwCZnm2f",
                session_id == "10511921" ~ "R_3L5u3hk4Dpl95Dp",
                session_id == "10551952" ~ "126", # fix for typo by on of the experimenters on t2. 125 instead of 126
                session_id == "10963554" ~ "156", # fix for typo by on of the experimenters on t2.
                session_id == "10963528" ~ "155", # fix for typo by on of the experimenters on t2.
                session_id == "10963535" ~ "153", # fix for typo by on of the experimenters on t2.
                session_id == "10948126" ~ "156", # fix for typo by on of the experimenters on t1.
                session_id == "10948122" ~ "155", # fix for typo by on of the experimenters on t1.
                session_id == "10948075" ~ "153", # fix for typo by on of the experimenters on t1.
                session_id == "10982956" ~ "188", # fix for typo by on of the experimenters on t1.
                session_id == "10556770" ~ "null", # remove second entry of RedactedUser@Email22
                session_id == "10610980" ~ "null", # remove second entry of RedactedUser@Email9
                TRUE ~ part1id
        )) %>%
        filter(!part1id %in% c("999", "null"))

allPIwave1 <- allPI %>% filter(wave == 1) %>%
        rename( bsi09 = bsiQ09 , bsi39 = bsiQ39) %>%
        select(-session_id, -starts_with("ord"), -user_id , -ends_with("rt") , -refresh , -study , -wave ,
               -starts_with("qiatmod") , -starts_with("blockOrder") , -completion_secs , -starts_with("rsesQ") ,
               -starts_with("bsiQ") , -starts_with("fscrsQ") , -starts_with("cesdQ"), -starts_with("t.")
               ) %>%
        filter(total_secs > 15)

allPIwave2 <- allPI %>% filter(wave == 2) %>%
        rename( bsi09 = bsiQ09 , bsi39 = bsiQ39) %>%
        select(-session_id, -starts_with("ord"), -user_id , -ends_with("rt") , -refresh , -study , -wave ,
               -starts_with("qiatmod") , -starts_with("blockOrder") , -completion_secs , -starts_with("rsesQ") ,
               -starts_with("bsiQ") , -starts_with("fscrsQ") , -starts_with("cesdQ") , -female, -starts_with("t.")
               ) %>%
        filter(total_secs > 15)


#fix screw-ups in PI1
cheatedPI1 <- allPIwave1 %>%
        filter(part1id %in% cheatedTBL$part1id) %>%
        left_join(cheatedTBL, by = "part1id") %>%
        select(part1id,email,felony,total_secs , everything())

allPIwave1 <- allPIwave1 %>%
        filter( part1id != "R_38ZiWeFn4TC3KnL" # RedactedUser@Email6
                ,part1id != "R_2R8GZNUSKShVAAo" # RedactedUser@Email7
                ,part1id != "R_3qBXpXADqzYTA0s" # RedactedUser@Email17
        ) %>%
        mutate(part1id = case_when(
                part1id == "R_3rNeQKggTXV2HvF" ~ "R_38ZiWeFn4TC3KnL" #RedactedUser@Email6
                , part1id == "R_2QDUbitFHwNmN3p" ~ "R_1KkhqLSee8SCpvR" #RedactedUser@Email12
                , part1id == "R_2xPMuhAJ76EErDt" ~ "R_12buLyvkF7FZmfk" #RedactedUser@Email16
                , part1id == "R_3rU8mjyanXWshGa" ~ "R_2R8GZNUSKShVAAo" #RedactedUser@Email7
                , part1id == "R_3nBLqcTV6UnS9kI" ~ "R_3qBXpXADqzYTA0s" #RedactedUser@Email17
                , TRUE ~ part1id))

verifybyemail <- allPIwave1 %>%
        left_join(surveyKeepVars_t1 %>% select(part1id,email), by = "part1id") %>%
        select(part1id,email,everything())
# if there are any Ps with NA for email, it means that they cheated on the first session, and I handeled it manually elsewhere (look in the code to find it).
# rm(verifybyemail)

#fix screw-ups in PI2
cheatedPI2 <- allPIwave2 %>%
        filter(part1id %in% cheatedTBL$part1id) %>%
        left_join(cheatedTBL, by = "part1id") %>%
        select(part1id,email,felony,total_secs , everything())

allPIwave2 <- allPIwave2 %>%
        filter( part1id != "R_3rNeQKggTXV2HvF",       #RedactedUser@Email6
                part1id != "R_2xWUPOGZxf2i93u") %>%   #RedactedUser@Email8

        mutate(
                part1id = case_when(
                        part1id == "R_3D0ixXQjQhk6F7C" ~ "R_2qz4xdQeglNHLkf"  # RedactedUser@Email5 finished twice, but returned with the second session_id, that one that I did not keep. overwrite with the correct session_id before merge.
                        , part1id == "R_3rU8mjyanXWshGa" ~ "R_2R8GZNUSKShVAAo"  # RedactedUser@Email7 finished twice, but returned with the second session_id, that one that I did not keep. overwrite with the correct session_id before merge.
                        , part1id == "R_2xPMuhAJ76EErDt" ~ "R_12buLyvkF7FZmfk"  # RedactedUser@Email16 finished three times, but returned with the third session_id, that one that I did not keep. overwrite with the correct session_id before merge.
                        , TRUE ~ part1id)
        )

verifybyemail <- allPIwave2 %>%
        left_join(surveyKeepVars_t1 %>% select(part1id,email), by = "part1id") %>%
        select(part1id,email,everything())
# if there are any Ps with NA for email, it means that they cheated on the first session, and I handeled it manually elsewhere (look in the code to find it).
# rm(verifybyemail)

# check dups before merging PI}
# 101 dupe in T1
allPIwave1 <- allPIwave1 %>% filter(!(part1id == 101 & is.na(rses)),part1id != 999)
allPIwave2 <- allPIwave2 %>% filter(part1id != 999)

dups_T1 <- allPIwave1[duplicated(allPIwave1[,'part1id']),]
dupsids_T1 <- unique(dups_T1$part1id)
dups_T2 <- allPIwave2[duplicated(allPIwave2[,'part1id']),]
dupsids_T2 <- unique(dups_T2$part1id)

stopifnot(length(dupsids_T1) == 0 , length(dupsids_T2) == 0)

# inspect duplicate pairs in T1
for (dupe in dupsids_T1) {
        allPIwave1 %>% filter(part1id == dupe) %>% select(part1id, everything()) %>%  print()
}

# inspect duplicate pairs in T2
for (dupe in dupsids_T2) {
        allPIwave2 %>% filter(part1id == dupe) %>% print()
}

allPIwaves <- left_join(allPIwave1, allPIwave2, by = "part1id" , suffix = c("_t1" , "_t2")) %>% filter(!is.na(part1id))

allds <- left_join(SCB, allPIwaves, by = "part1id") %>%
        filter(!is.na(part1id)) %>%
        mutate(
                total_mins_t1 = (total_secs_t1/60) + duration_t1,
                total_mins_t2 = (total_secs_t2/60) + duration_t2,
                total_time_min = total_mins_t1 + total_mins_t2
        ) %>%
        as_tibble() %>%
        select(part1id, email, age, total_mins_t1,total_mins_t2 , cheated ,everything())

# deidentify and save the row-per-participant data to file, for the analysis
allds %<>% select(-email)

PI_item <- Hmisc::Merge(conds,rsesRaw , cesdRaw , qiatDmodsSC, qiatDmodsSE, bsiRaw, fscrsHSraw, fscrsRSraw, fscrsISraw, id = ~session_id) %>%
        filter(part1id %in% allds$part1id)

# Save output as csv ###########################################################
write.csv(allds,file =  here::here("data/allds.csv"),na = "")
write.csv(PI_item,file =  here::here("data/PI_item.csv"),na = "")

quick.fst <- function(x){
                name <- deparse(substitute(x))
                fst::write_fst(x, paste0("data/",name, ".fst"))
        }
quick.fst(allds)
quick.fst(PI_item)
quick.fst(comparison_DspOrd)

