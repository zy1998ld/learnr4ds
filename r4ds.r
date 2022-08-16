library(tidyverse)
library(ggplot2)


# ggplot ------------------------------------------------------------------

ggplot(data = mpg, mapping = aes(x = displ,y = hwy,color = drv)) + 
  geom_point(mapping = aes()) +
  geom_smooth(mapping = aes(),se = FALSE) 
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_smooth()



ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))

# transform ---------------------------------------------------------------

filter(mpg, cyl == 8)
filter(diamonds, carat > 3)
data("flights")
flights %>% 
  filter(arr_delay >= 2 & dest %in% c('HOU', 'IAH'))
delays <- not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(
    delay = mean(arr_delay, na.rm = TRUE),
    n = n()
)
not_cancelled <- flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay))
delays %>% 
  filter(n > 20) %>% 
  ggplot(mapping = aes(x = n, y = delay)) + 
  geom_point(alpha = 0.1)

