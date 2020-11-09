#PDF Data Extraction Tool
##Version 1.0
##Author - Josh Reini (joshua.reini.ctr@usuhs.edu)

########################################################
##############Install and Load Packages#################
########################################################
# Package names
packages <- c("dplyr","pdftools","stringr","tm","strex")

# Install packages not yet installed
installed_packages <- packages %in% rownames(installed.packages())
if (any(installed_packages == FALSE)) {
  install.packages(packages[!installed_packages])
}

# Packages loading
invisible(lapply(packages, library, character.only = TRUE))

########################################################
##############Build Neccessary Functions################
########################################################

#Function 1 = createshell
##Create an empty dataframe with the fields you are looking to capture
### intput: list of fields, EX: c("field1","field2)
### output: empty dataframe with columns as fieldlist 
createshell <- function(fieldlist) {
  df <- data.frame(matrix(ncol=length(fieldlist),nrow=0))
  colnames(df) <- fieldlist
  df
}

#Function 2 = scrapeR
##input: number of form in form vector you want to scrape
##output: dataframe containing text of interest

scrapeR <- function(num) {
  #take PDF number i
  form <- form_vector[num]
  #extract text using pdftools
  form <- pdftools::pdf_text(form)
  #remove extra whitespace
  form <- paste0(form, collapse = " ")
  # write the text to a raw file 
  write(form,"raw.txt")
  # read the file back in
  raw <- readLines("raw.txt")
  # transform to df
  raw_df <- as.data.frame(raw, stringsAsFactors = FALSE)
  # trim leading white space
  raw_df$raw <- trimws(raw_df$raw, "left")
  raw_df
}
  
#Function 3 = textcapture 
##captures the value of an unknown string using its position near a known string
###inputs: df = input dataframe (dataframe containing text of interest)
###        ref = reference word (a string, in quotes)
###        btwn = number of characters between reference and target (default = -10)
###        lngth = length of target (default = +10)
###output: target number

textcapture <- function(df,ref,btwn=-10,lngth=10) {
  substr(df,
         regexpr(ref,
                 df)+btwn,
         regexpr(ref,
                 df)+lngth)
}

#Function 4 = numbercapture
##captures a string using its position near a known string
###inputs: df = input dataframe (dataframe containing text of interest)
###        ref = reference word (a string, in quotes)
###        btwn = number of characters between reference and target (default = -10)
###        lngth = length of target (default = +10)
###output: target number

numbercapture <- function(df,ref,btwn,lngth) {
  str_first_number(
    textcapture(df,ref,btwn,lngth)
    )
}
########################################################
###############Where the action happens#################
########################################################

#crete a vector of the full file names of all PDFs (collection forms)
form_vector <- list.files(path = "PDFs",full.names = TRUE)

#Set structure for dataframe with the elements you want to extract
##In this example, we're using the Satisfaction with Life Scale (SWLS)
all_form_data  <- createshell(c("SubjectID",
                            "SWLS_1",
                            "SWLS_2",
                            "SWLS_3",
                            "SWLS_4",
                            "SWLS_5")
                            )
#loop through all PDFs
for (i in 1:length(form_vector)){
  print(i)
  
#scrape all of the text off the pdf and set into a dataframe  
raw_df <- scrapeR(i)

#Extract each element from raw_df using regex and substr 
#and write extracted data to a new row in tidy data
form_data <- data.frame("SubjectID"=numbercapture(raw_df,"Subject",0,20),
                       "SWLS_1"=numbercapture(raw_df,"In most ways",-12,-7),
                       "SWLS_2"=numbercapture(raw_df,"The conditions",-12,-7),
                       "SWLS_3"=numbercapture(raw_df,"I am satisfied",-12,-7),
                       "SWLS_4"=numbercapture(raw_df,"So far I",-15,0),
                       "SWLS_5"=numbercapture(raw_df,"If I could",-15,0)
                       )

#append each loop to larger tidy dataframe
all_form_data <- rbind(all_form_data,form_data)
}

#Write tidy data to csv
write.csv(all_form_data,"Collection_forms.csv")