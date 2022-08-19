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
flights %>% 
  filter(!is.na(tailnum)) %>% 
  select('tailnum',ends_with('delay')) %>% 
  mutate(delay = arr_delay + dep_delay) %>% 
  arrange(delay)

diamonds <- diamonds
diamonds %>% ggplot(mapping = aes(x = carat)) + 
  geom_histogram(binwidth = 0.01) +
  theme_bw()
diamonds %>% 
  filter(carat == 0.99 | carat == 1) %>% 
  group_by(carat) %>% 
  count()
diamonds2 <- diamonds %>% 
  filter(between(y, 3, 20))
diamonds2 %>% 
  count(cut,color) %>% 
  ggplot(mapping = aes(x = cut,y = color))+
  geom_tile(mapping = aes(fill = n))
diamonds2 %>% 
  ggplot(mapping = aes(x = price, y = carat)) + 
  geom_bin2d(mapping = aes())
df <- data.frame(abc = 1, xyz = "a")
df$x
df[, "xyz"]
df[, c("abc", "xyz")]

# response ----------------------------------------------------------------

models <- tibble(
  a1 = runif(250, -20, 40),
  a2 = runif(250, -5, 5))
data_sim <- sim1 %>% 
  select(-pre)


# predict -----------------------------------------------------------------

model1 <- function(model,data){
  model[1] + model[2] * data[['x']]
}
mesure_distance <- function(mod,data){
  diff <- data[['y']] - model1(model = mod,data = data)
  sqrt(mean(diff^2))
}
sim1_distance <- function(a1,a2,data){
  mesure_distance(mod = c(a1,a2),data = sim1)
}

(models <- models %>% 
  mutate(dist = map2_dbl(.x = a1,.y = a2,.f = sim1_distance)))
ggplot(data = sim1,mapping = aes(x,y))+
  geom_point()+
  geom_abline(data = filter(.data = models,min_rank(dist)<10),
              mapping = aes(intercept = a1,slope = a2,color = -dist))+
  scale_x_continuous(limits = c(0,15))

ggplot(data = models,mapping = aes(a1,a2))+
  geom_point(data = filter(models,min_rank(dist)<=10),size = 4,color = 'red')+
  geom_point(aes(color = -dist))

(sim1 <- sim1 %>% 
  add_residuals(model = lm(y~x,data = sim1)) %>% 
  add_predictions(model = lm(y~x,data = sim1)) %>% 
    select('x','y','pred',everything()))

sim1 %>% 
  ggplot(mapping = aes(x = x, y = resid)) + 
  geom_point(data = filter(sim1,min_rank(abs(resid))<= 10),size = 2,shape = 2)+ 
  geom_point(alpha = 0.5) +
  coord_cartesian(xlim = c(1,10))+
  geom_hline(yintercept = 0, color = 'red') + 
  geom_refline(h = 0)


# loess -------------------------------------------------------------------

model_loe <- loess(formula = y~x,data = sim1)
sim1 <- sim1 %>% 
  add_predictions(model = model_loe) %>% 
  add_residuals(model = model_loe)
ggplot(data = sim1,mapping = aes(x = x,y = pred)) + 
  geom_point() + 
  geom_smooth() 

geom_refline <- function(h,v,color = 'white'){
  if(!missing(h)){
    geom_hline(yintercept = h,size = 2, color = color)
  }else if(!missing(v)){
    geom_vline(xintercept = v, size = 2 ,color = color)
  }else {
    stop('stop')
  }
}


# two predictor(cc) -------------------------------------------------------

mod1 <- lm(y~x1 + x2,data = sim3)
mod2 <- lm(y~x1 * x2, data = sim3)
sim3 %>% 
  gather_predictions(mod1,mod2) %>% 
  ggplot(mapping = aes(x1,y,color = x2)) + 
  geom_point() + 
  geom_line(aes(y = pred)) + 
  facet_wrap(~model)


sim3 %>% 
  gather_predictions(mod1,mod2) %>% 
  gather_residuals(mod1,mod2) %>% 
  ggplot(mapping = aes(x1,resid,color = x2)) + 
  geom_point() + 
  facet_grid(model~x2)

sim5 <- tibble(
  x = seq(0, 3.5 * pi, length = 50),
  y = 4 * sin(x) + rnorm(length(x))
)
summary(lm(y~x^2+x,data = sim5))
summary(lm(y~I(x^3)+I(x^2)+x,data = sim5))
summary(lm(y~x,sim5))
summary(lm(y~poly(x,3),sim5))
sim5 %>% 
  add_predictions(model = lm(y~poly(x,3),sim5))
sim5 %>% 
  add_predictions(model = lm(y~I(x^3)+I(x^2)+x,data = sim5))


# splines 样条-----------------------------------------------------------------

ggplot(sim5,mapping = aes(x,y)) + 
  geom_point()
for (i in 1:5) {
 assign(paste0('mod',i), lm(formula = y~ns(x,i),data = sim5))
}
grid <- sim5 %>% 
  data_grid(x = (seq_range(x = x,n = 50,expand = 0.1))) %>% 
  gather_predictions(mod1,mod2,mod3,mod4,mod5) 
 
ggplot(data = sim5,mapping = aes(x = x,y = y)) + 
  geom_point() + 
  geom_line(data = grid,mapping = aes(y = pred),color = 'red',alpha = 0.5) + 
  facet_wrap(~model,nrow = 3)

summary(lm(y~x1 * x2,sim3))
model.matrix(lm(y~x1 + x2 ,sim3))
sim3 %>% 
  add_predictions(model = lm(y~x1 + x2,sim3))
