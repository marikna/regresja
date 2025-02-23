#CZESC 1 
#1)
dane = read.csv2('weather.csv', header = TRUE)
dane = dane[,-1]
head(dane)

#2)
sapply(dane, class)
summary(dane)

#3)
dane = subset(dane, select = -c(DWD_ID, STATION.NAME, FEDERAL.STATE, MEAN.MONTHLY.MAX.TEMP, MEAN.MONTHLY.MIN.TEMP, MEAN.ANNUAL.WIND.SPEED, MAX.MONTHLY.WIND.SPEED, MAX.WIND.SPEED, PERIOD))

#4)
przed = nrow(dane)
dane = na.omit(dane)
po = nrow(dane)
przed - po

#5)
dim(dane)

#6)
split = sample.split(dane, SplitRatio = 0.7)
treningowe = subset(dane, split == TRUE)
testowe = subset(dane, split == FALSE)

head(testowe)  

#7)
zmienna_train = treningowe$MEAN.ANNUAL.RAINFALL
zmienna_test = testowe$MEAN.ANNUAL.RAINFALL

macierz_train = subset(treningowe, select = -MEAN.ANNUAL.RAINFALL)
macierz_test = subset(testowe, select = -MEAN.ANNUAL.RAINFALL)

#8)
ggpairs(dane)

#9)
korelacja = cor(dane)

#10)
corrplot(korelacja, method = "number")

#11)
filtr = korelacja[,which(abs(korelacja[, "MEAN.ANNUAL.RAINFALL"]) >= 0.5)]
filtr

#12)
ggpairs(filtr)





#CZESC 2
#1)
model_bazowy = lm(MEAN.ANNUAL.RAINFALL ~ 1, data = treningowe)
srednia = mean(treningowe$MEAN.ANNUAL.RAINFALL)
srednia

#2)
rmse = sqrt(mean((treningowe$MEAN.ANNUAL.RAINFALL - srednia)^2))
rmse

#3)
przewidywania = predict(model_bazowy, newdata = testowe)
rmse2 = sqrt(mean((testowe$MEAN.ANNUAL.RAINFALL - przewidywania)^2))
rmse2

#4)
kor_treningowe = cor(treningowe)
kor_rainfall = kor_treningowe['MEAN.ANNUAL.RAINFALL',]
pearson76 = names(which.min(abs(kor_rainfall - 0.76)))
pearson76
model = lm(MEAN.ANNUAL.RAINFALL ~ ALTITUDE, data = treningowe)
coef = coef(model)
pred = coef[1] + coef[2] * treningowe$ALTITUDE
rmse3 = sqrt(mean((treningowe$MEAN.ANNUAL.RAINFALL - pred)^2))
rmse3


#5)
przewidywania2 = predict(model, newdata = testowe)
rmse4 = sqrt(mean((testowe$MEAN.ANNUAL.RAINFALL - przewidywania2)^2))
rmse4

#6)
model_liniowy = lm(MEAN.ANNUAL.RAINFALL ~ MAX.RAINFALL, data = treningowe)
coef = coef(model_liniowy)
pred = coef[1] + coef[2] * treningowe$MAX.RAINFALL
rmse5 = sqrt(mean((treningowe$MEAN.ANNUAL.RAINFALL - pred)^2))
rmse5


#7)
przewidywania3 = predict(model_liniowy, newdata = testowe)
rmse6 = sqrt(mean((testowe$MEAN.ANNUAL.RAINFALL - przewidywania3)^2))
rmse6

#8)
model_wielokrotny = lm(MEAN.ANNUAL.RAINFALL ~ ALTITUDE + MEAN.ANNUAL.AIR.TEMP + MAX.RAINFALL, data=treningowe)
r2 = summary(model_wielokrotny)$r.squared
r2
#wartosc r squared to ~0.74, to oznacza ze 74% zmiennej zaleznej jest objasniane przez zmienne objasniajace, im blizej do wartosci = 1, tym wieksza czesc jest wyjasniona
przewidywania4 = predict(model_wielokrotny, newdata = treningowe)
rmse7 = sqrt(mean((treningowe$MEAN.ANNUAL.RAINFALL - przewidywania4)^2))
rmse7

#9)
przewidywania5 = predict(model_wielokrotny, newdata = testowe)
rmse8 = sqrt(mean((testowe$MEAN.ANNUAL.RAINFALL - przewidywania5)^2))
rmse8

#10)
wykres = data.frame(
  models = rep(c("Model 1", "Model 2", "Model 3", "Model 4"), each = 2),
  RMSE = c(rmse, rmse2, rmse3, rmse4, rmse5, rmse6, rmse7, rmse8),
  name = rep(c("Treningowe", "Testowe"), times = 4)
)

ggplot(wykres, aes(x = models, y = RMSE, fill = name)) + geom_bar(stat = "identity", position = "dodge")










#CZESC 3
#1)
treningowe$LOG.ALTITUDE = log(treningowe$ALTITUDE)
treningowe$SQUARE.ALTITUDE = treningowe$ALTITUDE^2

model = lm(data = treningowe, MEAN.ANNUAL.RAINFALL ~ ALTITUDE + LOG.ALTITUDE + SQUARE.ALTITUDE)
summary(model)

rmse9 = sqrt(mean((model$fitted.values - treningowe$MEAN.ANNUAL.RAINFALL)^2))
rmse9

#2)
testowe$LOG.ALTITUDE = log(testowe$ALTITUDE)
testowe$SQUARE.ALTITUDE = testowe$ALTITUDE^2

przewidywania6 = predict(model, newdata = testowe)
rmse10 = sqrt(mean((testowe$MEAN.ANNUAL.RAINFALL - przewidywania6)^2))
rmse10

#3)
model = lm(data=treningowe, MEAN.ANNUAL.RAINFALL ~ MAX.RAINFALL + log(MAX.RAINFALL) + (MAX.RAINFALL)^2)
summary(model)














