library(tidyverse)
library(spotifyr)
remotes::install_github('jaburgoyne/compmus')
library(compmus)

bzt <-
  get_tidy_audio_analysis("5ZLkc5RY1NM4FtGWEd6HOE") %>%
  compmus_align(bars, segments) %>%
  select(bars) %>%
  unnest(bars) %>% 
  mutate(
    pitches =
      map(segments,
          compmus_summarise, pitches,
          method = "rms", norm = "euclidean"
      )
  ) %>%
  mutate(
    timbre =
      map(segments,
          compmus_summarise, timbre,
          method = "rms", norm = "euclidean" 
      )
  )

bzt %>%
  compmus_gather_timbre() %>%
  ggplot(
    aes(
      x = start + duration / 2,
      width = duration,
      y = basis,
      fill = value
    )
  ) +
  geom_tile() +
  labs(x = "Time (s)", y = NULL, fill = "Magnitude") +
  scale_fill_viridis_c() +                              
  theme_classic()
