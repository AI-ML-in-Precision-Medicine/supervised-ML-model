# Install required packages
install.packages(c("tidyverse", "here", "janitor"))

# Load libraries
library(tidyverse)
library(here)
library(janitor)

# Import the data
clinical_data_full <- read.csv(here("data/clinical-variables.csv"))
normalised_reads_full <- read.csv(here("data/normalised-reads.csv"))

# Change column names
clinical_data <- clinical_data_full %>%
  select(SAMPLE_ID, MOTIF_INC, TABAC_PDT_GROSS, AUT_DROG, DIABET_GESTA, HTA_PRE_ECLAM, RCIU, INF_URI_REPETE, CERCLAGE, BIL_INC_AB_PDT_GROS) %>%
  clean_names() %>%
  rename(pregnancy_group = motif_inc) %>%
  rename(smoking = tabac_pdt_gross) %>%
  rename(drugs = aut_drog) %>%
  rename(hypertension_preeclam = hta_pre_eclam) %>%
  rename(intrauterine_growth_restriction = rciu) %>%
  rename(recurring_UTIs = inf_uri_repete) %>%
  rename(antibiotics = bil_inc_ab_pdt_gros)

# Convert the data to numerical values
clinical_data_num <- clinical_data %>%
  mutate(pregnancy_group = recode(pregnancy_group, "A-Control" = 1, "B-RPM-at-term" = 2, "C-Premature" = 3, "D-Premature-with-RPM" = 4)) %>%
  mutate(smoking = recode(smoking, "no" = 0, "yes" = 1)) %>%
  mutate(drugs = recode(drugs, "no" = 0, "yes" = 1)) %>%
  mutate(diabet_gesta = recode(diabet_gesta, "no" = 0, "yes" = 1)) %>%
  mutate(hypertension_preeclam = recode(hypertension_preeclam, "no" = 0, "yes" = 1)) %>%
  mutate(intrauterine_growth_restriction = recode(intrauterine_growth_restriction, "no" = 0, "yes" = 1)) %>%
  mutate(recurring_UTIs = recode(recurring_UTIs, "no" = 0, "yes" = 1)) %>%
  mutate(cerclage = recode(cerclage, "no" = 0, "yes" = 1)) %>%
  mutate(antibiotics = recode(antibiotics, "no" = 0, "yes" = 1)) %>%
  drop_na()

# Restructure the data frame
normalised_reads <- normalised_reads_full %>%
  select(species:last_col()) %>%
  pivot_longer(starts_with("A"), names_to = "sample_id", values_to = "norm_reads") %>%
  pivot_wider(names_from = species, values_from = norm_reads)

# Output the restructured data
write.csv(clinical_data_num, here("data/processed/num_clinical_data.csv"), row.names = FALSE)
write.csv(normalised_reads, here("data/processed/norm_reads_restructured.csv"), row.names = FALSE)
