# PDF Data Extraction Tool

This is an R-based PDF extraction tool, developed by [Josh Reini](https://github.com/joshreini1) at the [Center for Rehabilitation Sciences Research](http://crsr.org/) at Uniformed Services Univerisity.

It can be used to extract relevant data from PDF versions of patient reported outcome measures or other forms. This script can pull data from many PDF files at once stored in a single folder.

### What you need to do:
Step 1: Create folder named PDFs in working directory that contains all forms to be scraped.

Step 2: Update Lines 94-116 to meet the requirements of your PDF outcome measure.

Note: Make sure to set working directory

### The tool contains the following functions:
#### 1. createshell
Creates an empty dataframe with the fields you are looking to capture.

###### Input: 

fieldlist = list of fields you are looking to capture in a tidy data frame.

###### Output: 
An empty, tidy dataframe with columns as field list.

#### 2. scrapeR
Scrapes text from PDF file, performs some cleaning and outputs text set in a data frame.

###### Input: 

num = the number of the form in form_vector that you are scraping in this loop.

###### Output: 
A data frame full of clenaer text scraped from the PDF

#### 3. textcapture
Captures the value of an unknown string using its position near a known string.

###### Inputs: 

df = input dataframe (dataframe containing text of interest)

ref = reference word (a string, in quotes)

btwn = number of characters between reference and target (default = -10)

lngth = length of target (default = +10)

###### Output:

target string

#### 4. numbercapture
Similar to text capture, constrained to capture the first numeric only.

##### Output:

target number

## Acknowledgements

Thanks to [Will Roddy](https://github.com/wtroddy) for collaborating on earlier iterations of this tool. Thanks to the Henry Jackson Foundation and the Center for Rehabilitation Sciences Research at Uniformed Services University of the Health Sciences.