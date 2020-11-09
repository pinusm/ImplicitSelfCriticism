########################################################################################################################
#Create the dataframe for iat D scores analysis
########################################################################################################################
#iat:               data frame containing the long format iat.txt data
#
#block.name:        Name of variable containing the block information. Defaults to "block_number"
#
#parsels:           List of vectors associating pairs of blocks with specific parsels. If names are specified
#                   (e.g., c(B3 = "3", B6 = "6")), the output will display the associated name for each block (e.g., "MB3").
#                   If unspecified (e.g., c("3", "6")), the output will display the value of the block (e.g., "M3").
#
#subject:           Name of variable containing the subject ids. Defaults to "session_id"
#
#trial.latency:     Name of variable containing reaction time data. Defaults to "trail_latency"
#
#trial.error:       Name of variable containing the error flag data. Defaults to "trial_error"
#
#verror:            Boolean. Specifies usage of error trials latency. If TRUE, latencies of error
#                   trials will be replaced by the mean latency of the correct trials + 600ms
#                   If FALSE, latencies of error trials will be used unmodified. Defaults to FALSE
#
#vextreme:          Boolean. Specifies usage of fast latency trials. If true, trials with faster than
#                   minRT or slower than maxRT will be excluded. If false, all trials will be included.
#                   Defaults to TRUE.
#
#vstd:              Boolean. Speficies the method for calculating block standard deviations. If TRUE,
#                   The block standard deviations are calculated on correct trial only. If FALSE,
#                   the block standard deviations are cacluclated on all trials. Defaults to FALSE.
#
#fastRT:            Numeric. Responses faster than fastRT will be flagged as fast responses. Defaults to 300
#
#maxFastTrialRate:  Numeric. Participants with more than maxFastTrialRate fast trials will be 
#                   flagged for exclusion. Defaults to 0.1
#
#minRT:             Numeric. Trials with reaction time faster than minRT will be excluded. Defaults to 400
#
#maxRt:             Numeric. Trials with reaction time longer than maxRT will be excluded. Defaults to 10000
########################################################################################################################

IATD = function(iat,
                block.name = "block_number",
                parsels = list(c(B3 = "3", B6 = "6"), c(B4 = "4", B7 = "7")),
                subject = "session_id",
                trial.latency = "trial_latency",
                trial.error = "trial_error",
                verror = FALSE,
                vextreme = TRUE,
                vstd = FALSE,
                fastRT = 300,
                maxFastTrialRate = 0.1,
                minRT = 400,
                maxRT = 10000) {
    ########################################################################################################################
    #Load dependencies
    ########################################################################################################################
    if (!require(reshape2)) {
        stop("Library reshape2 is required to run IATD")
    }
    
    ########################################################################################################################
    #Prepare data and working variables
    ########################################################################################################################    
    data = iat
    
    #Prepare a vector representation of the block parsel definitions
    parsels.values = c()
    
    for (parsel in parsels) {
        parsels.values = c(parsels.values, as.character(parsel))
    }
    
    #Prepare naming of the blocks
    if (is.null(names(parsels.values))) {
        parsels.names = parsels.values
    } else {
        parsels.names = names(parsels.values)
    }
    
    #Mark trials' parsel id
    #We should first remove leading and trailing white space
    data[,block.name] = format(data[,block.name], trim = TRUE)
       
    for (i in 1:length(parsels)){
        data[data[,block.name] %in% parsels[[i]], "parsel"] = i
    }
    
    ########################################################################################################################
    #Clean data from coding errors
    ########################################################################################################################    
    data = data[!is.na(data[,trial.latency]) & data[,trial.latency] > 0 & !is.na(data[,trial.error]) & data[,trial.error] > -1 & data[,trial.error] < 2,]
    
    ########################################################################################################################
    #STEP 1 HAS BEEN REMOVED, NOW ALL DATA IS AT LEAST PARTIALLY ANALYZED;
    #STEP 1: Include data from B3, B4, B6, B7;
    ########################################################################################################################
    #data = data[data[,block.name] %in% parsels,]
    
    ########################################################################################################################
    #STEP 2a: remove trial latencies > 10000ms
    ########################################################################################################################
    data = data[data[,trial.latency] < 10000,]
    
    ########################################################################################################################
    #STEP 2b: Eliminate subjects for whom more than 10% of trials have latencies < fastRT
    #CHANGE: Calculate fast trial rate for each subject in each block
    ########################################################################################################################
    data$fastRT = as.numeric(data[,trial.latency] < fastRT)
    
    #Save the data for ouput
    fast.data = aggregate(data$fastRT, by = list(data[,subject], data[,block.name]), FUN = mean)
    fast.data = dcast(fast.data, fast.data[,1]~fast.data[,2], value.var = "x")
    
    #Subset critical blocks
    fast.data = cbind(fast.data[,1], fast.data[, parsels.values])
    
    #Compute unweighted mean fastRT rate
    ##Comment: Is it theoretically correct to calculate the unweighted mean?
    fast.data$FASTM = rowMeans(fast.data[,parsels.values], na.rm = TRUE)
    
    #Rename columns to meaningful values
    colnames(fast.data) = c(subject, paste("F", parsels.names, sep = ""), "FASTM")
    
    ########################################################################################################################
    #STEP 3 HAS BEEN REMOVED, NOW ALL TRIALS ARE BEING ANLYZED
    ########################################################################################################################
    
    ########################################################################################################################
    #STEP 4: Delete trials with extreme latencies if vextreme is set to TRUE
    ########################################################################################################################
    if (vextreme) {
        data[data[,trial.latency] < minRT | data[,trial.latency] > maxRT,] = NA
    }
    
    ########################################################################################################################
    #STEP 5: Compute mean latencies and Ns for each block.
    #        Select only correct trials if verror is set to TRUE
    ########################################################################################################################
    #Select the correct trials
    correct = data[!is.na(data[,trial.error]) & data[,trial.error] == 0,]
    
    #Calculate means for each block - correct trials only
    meansC = aggregate(correct[, trial.latency], by = list(correct[,subject], correct[,block.name]), FUN = function(x) mean(x, na.rm = TRUE))
    
    #Calculate counts for each block - correct trials only
    countsC = aggregate(correct[, trial.latency], by = list(correct[,subject], correct[,block.name]), FUN = function(x) sum(as.numeric(!is.na(x))))
    
    #Convert to wide format
    out.meansC = dcast(meansC, meansC[,1]~meansC[,2], value.var = "x")
    out.countsC = dcast(countsC, countsC[,1]~countsC[,2], value.var = "x")
    
    #Add all error trials the block means + 600ms if verror is set to TRUE    
    if (verror) {
        names(meansC) = c(subject, block.name, "MEANC")
        data = merge(data, meansC, by = c(subject, block.name))
        
        errors = !is.na(data[,trial.error]) & data[,trial.error] == 1
        
        data[errors, trial.latency] = data[errors ,"MEANC"] + 600
        
        rm(errors)
    }
    
    #Calculate means for each block - all trials
    meansA = aggregate(data[, trial.latency], by = list(data[,subject], data[,block.name]), FUN = function(x) mean(x, na.rm = TRUE))
    
    #Calculate counts for each block - all trials
    countsA = aggregate(data[, trial.latency], by = list(data[,subject], data[,block.name]), FUN = function(x) sum(as.numeric(!is.na(x))))    
    
    #Convert to wide format
    out.meansA = dcast(meansA, meansA[,1]~meansA[,2], value.var = "x")    
    out.countsA = dcast(countsA, countsA[,1]~countsA[,2], value.var = "x")
    
    #Remove dataframes to free memory
    rm (meansC, countsC, meansA, countsA)    
    
    #Subset critical blocks
    out.meansC = cbind(out.meansC[,1], out.meansC[, parsels.values])
    out.countsC = cbind(out.countsC[,1], out.countsC[, parsels.values])
    out.meansA = cbind(out.meansA[,1], out.meansA[, parsels.values])    
    out.countsA = cbind(out.countsA[,1], out.countsA[, parsels.values])
    
    #Calculate mean errors per block.
    #Moved here to remove redundant compuations.
    errors = aggregate(data[, trial.error], by = list(data[,subject], data[,block.name]), FUN = mean)
    errors = dcast(errors, errors[,1]~errors[,2], value.var = "x")
    
    #Subset critical blocks
    errors = cbind(errors[,1], errors[, parsels.values])
    
    #Rename columns to meaningful values
    colnames(errors) = c(subject, paste("E", parsels.names, sep = ""))
    ########################################################################################################################
    #STEP 6: Compute combined SDs for each block
    ########################################################################################################################
    #Calculate combinded SD for seperately for iat1 and iat2 blocks - all trials
    SDA = dcast(data, data[,subject]~data$parsel, value.var = trial.latency, fun = sd)
    
    #Calculate combinded SD for seperately for iat1 and iat2 blocks - correct trials
    subs = correct[,subject] 
    pars = correct$parsel
    SDC = dcast(correct, subs~pars, value.var = trial.latency, fun = sd)
    
    #Remove data frame to free memory
    rm(correct)
    
    out.SD = merge(cbind(SDA[,1], SDA[,as.character(1:length(parsels))]), cbind(SDC[,1], SDC[,as.character(1:length(parsels))]), by = c(1,1))
    
    rm(SDA, SDC)
    
    #Rename columns to menaingul values
    colnames(out.SD) = c(subject, paste("AS", 1:length(parsels), sep = ""), paste("CS", 1:length(parsels), sep = ""))
    
    #Output means and counts for correct trials only if specified    
    out.means = out.meansA
    
    if (verror) {        
        out.counts = out.countsC        
    } else {
        out.counts = out.countsA
    }
    
    #Delete dataframes to free memory
    rm(out.meansC, out.countsC, out.meansA, out.countsA)
    
    #Rename columns to meaningful values
    colnames(out.means) = c(subject, paste("M", parsels.names, sep = ""))
    colnames(out.counts) = c(subject, paste("N", parsels.names, sep = ""))
    
    #Merge tables
    out = merge(out.means, out.counts, by = c(1, 1))
    out = merge(out, out.SD, by = c(1, 1))
    
    #Delete dataframes to free memory
    rm(out.means, out.counts, out.SD)
    
    ########################################################################################################################
    #STEP 7: Replace error latencies with block mean + 600ms if verror is TRUE
    #This step was already accomplished in step 5
    ########################################################################################################################
    
    ########################################################################################################################
    #STEP 8 HAS BEEN REMOVED: NO TRANSFORMATION OF LATENCIES
    ########################################################################################################################
    
    ########################################################################################################################
    #STEP 9: Average latencies for each of the four blocks
    #This was already accomplished in step 5
    ########################################################################################################################
    
    ########################################################################################################################
    #STEP 9.5: Output error and fastRT rates for each block
    ########################################################################################################################    
    out = merge(out, errors, by = c(1, 1))
    
    #Delete dataframe to free memory
    rm(errors)
    
    out = merge(out, fast.data, by = c(1, 1))
    
    #Delete dataframe to free memory
    rm(fast.data)
    
    #Mark participans for exclusion
    nMissing = rowSums(is.na(out[,paste("M", parsels.names, sep = "")]))
    out$SUBEXCL = 0
    out[nMissing > 0, "SUBEXCL"] = 2
    out[!is.na(out$FASTM) & out$FASTM > maxFastTrialRate, "SUBEXCL"] = 1    
    
    ########################################################################################################################
    #STEP 10: Compute differences in each parsel
    ########################################################################################################################
    diffs = list()
    for (i in 1:length(parsels)) {        
        diffs[[i]] = paste("M", c(parsels.names[(i - 1) * 2 + 1], parsels.names[(i - 1) * 2 + 2]), sep = "")
    }
    
    for (i in 1:length(parsels)) {
        diff = diffs[[i]]
        out[, paste("DIFF", i, sep = "")] = out[,diff[2]] - out[,diff[1]]
    }
    
    ########################################################################################################################
    #STEP 11: Divide each difference by associated combined SD
    ########################################################################################################################
    for (i in 1:length(parsels)) {
        if (vstd) {
            out[, paste("IAT", i, sep = "")] = out[, paste("DIFF", i, sep = "")] / out[, paste("CS", i, sep = "")]
        } else {
            out[, paste("IAT", i, sep = "")] = out[, paste("DIFF", i, sep = "")] / out[, paste("AS", i, sep = "")]
        }
    }
    
    ########################################################################################################################
    #STEP 12: Average quotients from STEP 11
    ########################################################################################################################
    out$IAT = rowMeans(out[, paste("IAT", 1:length(parsels), sep = "")], na.rm = TRUE)
    
    return(out)
}
