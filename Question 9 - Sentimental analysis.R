# ============================================================================
# Sentiment Analysis & Topic Extraction for Maternal Health Comments
# Based on B585_FA25_lect11.ipynb approach
# ============================================================================


# Install required packages (run once)
if(!require(reticulate)) install.packages("reticulate")
if(!require(ggplot2)) install.packages("ggplot2")
if(!require(dplyr)) install.packages("dplyr")


library(reticulate)
library(ggplot2)
library(dplyr)


# ============================================================================
# STEP 1: Setup Python Environment
# ============================================================================


cat("=== Setting up Transformers Environment ===\n\n")


# Step 1: Check Python environment
cat("Step 1: Checking Python environment...\n")
py_config()
cat("\n")


# Step 2: Check what's already installed
cat("Step 2: Checking existing packages...\n")


torch_installed <- py_module_available("torch")
transformers_installed <- py_module_available("transformers")


if (torch_installed) {
 cat(" torch is already installed\n")
} else {
 cat(" torch needs to be installed\n")
}


if (transformers_installed) {
 cat(" transformers is already installed\n")
} else {
 cat(" transformers needs to be installed\n")
}


cat("\n")


# Step 3: Install missing packages
cat("Step 3: Installing/upgrading packages...\n\n")


if (!torch_installed) {
 cat("Installing PyTorch...\n")
 py_install("torch", pip = TRUE)
 cat(" PyTorch installed\n\n")
} else {
 cat("PyTorch already available, skipping...\n\n")
}


if (!transformers_installed) {
 cat("Installing transformers...\n")
 py_install("transformers", pip = TRUE)
 cat(" Transformers installed\n\n")
} else {
 cat("Transformers already available, skipping...\n\n")
}


# Install additional helpful packages
cat("Installing additional packages...\n")
py_install(
 c("sentencepiece", "sacremoses", "protobuf"),
 pip = TRUE
)
cat(" Additional packages installed\n\n")


# Step 4: Test the installation
cat("Step 4: Testing installation...\n\n")


test_passed <- FALSE
tryCatch({
 # Import torch
 torch <- import("torch")
 cat(" torch imported successfully\n")
 cat("  Version:", torch$`__version__`, "\n")


 # Import transformers
 transformers <- import("transformers")
 cat(" transformers imported successfully\n")
 cat("  Version:", transformers$`__version__`, "\n")


 # Test pipeline creation
 cat("\nTesting pipeline creation...\n")
 pipeline <- transformers$pipeline("sentiment-analysis")
 cat(" Pipeline created successfully\n")


 # Test with sample text
 cat("\nTesting with sample text...\n")
 result <- pipeline("This is a test")
 cat(" Analysis successful!\n")
 cat("  Result:", result[[1]]$label, "(confidence:", round(result[[1]]$score, 4), ")\n")


 test_passed <- TRUE


}, error = function(e) {
 cat(" Test failed\n")
 cat("Error:", conditionMessage(e), "\n")


 # Try to get more details
 cat("\nTrying to import torch directly...\n")
 tryCatch({
   torch <- import("torch")
   cat("Torch imported! Version:", torch$`__version__`, "\n")
 }, error = function(e2) {
   cat("Failed to import torch:", conditionMessage(e2), "\n")
 })
})


# Final message
cat("\n=== Setup Complete ===\n\n")


if (test_passed) {
 cat("SUCCESS! Everything is working correctly.\n\n")
} else {
 cat("There was an issue with the setup. Please restart R session and try again.\n\n")
 stop("Setup failed. Please restart R session.")
}


# ============================================================================
# STEP 2: Import Python Modules
# ============================================================================


cat("Importing Python modules...\n")
tryCatch({
 torch <- import("torch")
 transformers <- import("transformers")


 cat("Successfully imported 'torch' and 'transformers'.\n")
 cat(sprintf("Using PyTorch version: %s\n", torch$`__version__`))
 cat(sprintf("Using Transformers version: %s\n", transformers$`__version__`))


}, error = function(e) {
 cat("Error importing Python modules.\n")
 print(e)
 stop("Import failed. Please restart R session and run again.")
})


# ============================================================================
# STEP 3: Prepare Comments Data
# ============================================================================


comments <- data.frame(
 comment_id = 1:16,
 text = c(
   "There are major data completeness issues, with two facilities missing ANC data entirely. Among facilities with complete data, Delken MCHP and Tissana CHC show better ANC service continuity, while St. Joseph’s Clinic lags behind.",


   "Missing data may reflect reporting gaps or operational challenges.",


   "The chart shows clear differences in ANC performance across Sherbro Island facilities. Delken MCHP performs strongest with high ANC1 and PHU delivery rates, while Tissana CHC shows moderate ANC3 performance. St. Joseph’s Clinic reports lower ANC3 and PHU values.",


   "Tissana, which is a standard community health care facility, does not see a strong link between an initial antenatal care visit and live birth deliveries, suggesting that expecting patients tend to deliver elsewhere.",


   "Delken, which is a maternal care facility, does largely deliver the patients that attend their first antenatal care visit, but does not see a high level of continued antenatal care compared to Tissana CHC.",


   "The chart also shows that Delken performs well in ANC1 and delivery, while Tissana CHC has stronger ANC3 continuity, suggesting differences in follow-up care across the two facilities.",


   "Delken MCHP demonstrates the strongest facility-based delivery rates but shows inconsistent ANC3 coverage, suggesting these maternal health posts excel at PHU delivery but may need to strengthen antenatal care engagement.",


   "The interesting thing to observe is that the highest PHU delivery rate does not guarantee high ANC coverage. Delken has a 64.58% PHU delivery rate but only 24.72% ANC3 coverage, while Tissana has lower PHU delivery (35.9%) but higher ANC3 coverage.",


   "From the visualization, it is evident that Delken MCHP performs the best in both ANC3 coverage and PHU delivery rate, whereas Govt Hospital, St. Joseph’s Clinic, and Mbokie show almost no ANC3 or delivery activity.",


   "Good catch — only Tissana and Delken report ANC1, ANC3, and PHU delivery metrics, even though it is likely that Govt Hospital Bonthe, St. Joseph's Clinic, and Mbokie CHP provide antenatal care and deliveries.",


   "The other facilities may simply not have reported their data, so performance cannot be accurately judged.",


   "The grouped bar chart shows that each facility faces different barriers. Delken attracts more women for delivery but struggles to keep them engaged in ANC visits, while Tissana CHC has better ANC engagement but loses clients at the delivery stage.",


   "Higher PHU delivery rate doesn't mean higher ANC3 coverage, as shown in the comparison between Delken and Tissana.",


   "The chart clearly shows that the two facilities differ in their strengths.",


   "Delken MCHP excels in encouraging facility deliveries but struggles with ANC follow-up. Tissana CHC performs better in ANC visits but faces challenges converting ANC clients into facility deliveries.",


   "The chart highlights each facility’s strengths and gaps, making it easier to identify where improvements are needed for each PHU."
 ),
 stringsAsFactors = FALSE
)


cat("✓ Loaded", nrow(comments), "comments\n\n")


# ============================================================================
# STEP 4: Sentiment Analysis
# ============================================================================


cat("=== SENTIMENT ANALYSIS ===\n")


# Create sentiment analyzer function (like in your notebook)
create_sentiment_analyzer <- function(model_name = "distilbert-base-uncased-finetuned-sst-2-english") {
 cat("Loading model:", model_name, "\n")
 cat("(First time will download the model - may take a moment)\n\n")


 analyzer <- transformers$pipeline(
   task = "sentiment-analysis",
   model = model_name
 )


 cat("✓ Model loaded successfully!\n\n")
 return(analyzer)
}


cat("--- Loading Default DistilBERT Model ---\n")
analyzer1 <- create_sentiment_analyzer("distilbert-base-uncased-finetuned-sst-2-english")


cat("Analyzing comments...\n\n")
results1 <- analyzer1(comments$text)


# Display results
cat("SENTIMENT ANALYSIS RESULTS:\n")
cat(rep("-", 70), "\n")
for (i in seq_along(comments$text)) {
 cat("Comment", i, "\n")
 cat("Text:", substr(comments$text[i], 1, 80), "...\n")
 cat("Sentiment:", results1[[i]]$label, "\n")
 cat("Confidence:", round(results1[[i]]$score, 4), "\n")
 cat(rep("-", 70), "\n")
}


# Store results in dataframe
comments$sentiment <- sapply(results1, function(x) x$label)
comments$confidence <- sapply(results1, function(x) x$score)


# Summary
cat("\nSENTIMENT SUMMARY:\n")
print(table(comments$sentiment))
cat("Average Confidence:", round(mean(comments$confidence), 3), "\n\n")


# Visualization
p1 <- ggplot(comments, aes(x = factor(comment_id), y = confidence, fill = sentiment)) +
 geom_bar(stat = "identity") +
 scale_fill_manual(values = c("NEGATIVE" = "#e57373", "POSITIVE" = "#81c784")) +
 labs(title = "Sentiment Analysis of Maternal Health Comments",
      subtitle = "Using DistilBERT Pre-trained Model",
      x = "Comment ID", y = "Confidence Score", fill = "Sentiment") +
 theme_minimal() +
 ylim(0, 1)


print(p1)


# ============================================================================
# STEP 5: Topic Extraction using NER 
# ============================================================================


cat("\n=== TOPIC EXTRACTION (Named Entity Recognition) ===\n")


cat("Loading BioClinical NER model...\n")


# Use biomedical NER model (like in your notebook)
ner <- transformers$pipeline(
 "ner",
 model = "dslim/bert-base-NER",
 aggregation_strategy = "simple"
)


cat(" Model loaded!\n\n")


# Extract entities from all comments
cat("Extracting entities from comments...\n\n")


all_entities <- list()


for (i in 1:nrow(comments)) {
 cat("Processing comment", i, "...\n")
 entities <- ner(comments$text[i])


 if (length(entities) > 0) {
   for (entity in entities) {
     cat("  ", entity$word, "-", entity$entity_group, "\n")
     all_entities[[length(all_entities) + 1]] <- data.frame(
       comment_id = i,
       entity = entity$word,
       type = entity$entity_group,
       score = entity$score,
       stringsAsFactors = FALSE
     )
   }
 }
}


# Combine all entities
if (length(all_entities) > 0) {
 entities_df <- do.call(rbind, all_entities)


 cat("\n--- EXTRACTED ENTITIES SUMMARY ---\n")
 print(table(entities_df$type))


 cat("\n--- MOST FREQUENT ENTITIES ---\n")
 entity_freq <- as.data.frame(table(entities_df$entity))
 entity_freq <- entity_freq[order(-entity_freq$Freq), ]
 colnames(entity_freq) <- c("Entity", "Frequency")
 print(head(entity_freq, 10))


} else {
 cat("No entities extracted.\n")
}


# ============================================================================
# STEP 7: Save Results
# ============================================================================


cat("\n=== SAVING RESULTS ===\n")


# Prepare export dataframe
comments_export <- comments[, c("comment_id", "text", "sentiment", "confidence")]
comments_export$topics <- sapply(comments$topics_list, function(x) paste(x, collapse = "; "))


# Save to CSV
write.csv(comments_export, "maternal_health_sentiment_analysis.csv", row.names = FALSE)
cat(" Sentiment results saved to: maternal_health_sentiment_analysis.csv\n")


if (exists("entities_df")) {
 write.csv(entities_df, "extracted_entities.csv", row.names = FALSE)
 cat(" Entities saved to: extracted_entities.csv\n")
}


write.csv(topic_freq, "topic_frequency.csv", row.names = FALSE)
cat(" Topic frequency saved to: topic_frequency.csv\n")


# ============================================================================
# FINAL SUMMARY
# ============================================================================


cat("\n")
cat(rep("=", 70), "\n")
cat("                    FINAL ANALYSIS SUMMARY\n")
cat(rep("=", 70), "\n\n")


cat("Total Comments Analyzed:", nrow(comments), "\n\n")


cat("Sentiment Distribution:\n")
print(table(comments$sentiment))
cat("\nAverage Confidence:", round(mean(comments$confidence), 3), "\n\n")


cat("Top 5 Topics:\n")
print(head(topic_freq, 5))


cat("\n")
cat(rep("=", 70), "\n")
cat(" Analysis complete!\n")
cat(rep("=", 70), "\n")
