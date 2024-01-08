rm(list = ls())
par(mfrow=c(1,1))

a = 0.5  # Dificuldade (inclinação da reta base)
A = 2    # Variação da fase (amplitude da oscilação)
w = 0.5  # frequencia da oscilacao

# Funções auxiliares
wave = function(t, t0) {
  a*(t-t0) + A*cos(w*(t-t0))
}

dwave_xmin = function(n, t0) {
  (-asin(a/(A*w)) + 2*pi*n - t0*w + pi)/w
}

dwave_xmax = function(n, t0) {
  (asin(a/(A*w)) + 2*pi*n - t0*w)/w
}

# Cálculo de potência
power = function(t) {
  t0 = -dwave_xmin(0,0)
  A2 = wave(0, t0)
  wave(t, t0) - A2 + 1
}

# Cálculo dos mínimos e máximos
xPowerMin = function(level) {
  t0 = dwave_xmin(0,0)
  dwave_xmin(level-1, t0)
}

xPowerMax = function(level) {
  t0 = dwave_xmin(0,0)
  dwave_xmax(level, t0)
}

yPowerMin = function(level) {
  power(xPowerMin(level))
}

yPowerMax = function(level) {
  power(xPowerMax(level))
}

evolutionArrow = function(L) {
  x0 = xPowerMin(L)
  x1 = xPowerMin(L+1)
  y0 = power(x0)
  y1 = power(x1)
  xm = xPowerMax(L)
  ym = power(xm)

  points(x0, y0, col='red', pch=21)
  points(xm, ym, col='red', pch=16)

  arrows(x0+1, y0-1, x1-1, y1-1, length=.1)
  text((x0+x1)/2 + 1, (y0+y1)/2 - 2, paste0("L", L))
  text(xm, ym + 2, paste0("L", L, " max"))
}

# Levels evolution
evolution = function() {
  n = 7
  levels = 1:n
  levelSpace = xPowerMin(2) - xPowerMin(1)

  steps = seq(0, n*levelSpace, by=.1)
  powers = sapply(steps, power)
  plot(steps, powers, cex=.1, main=paste('Power X Steps', '\n', 'Levels segments'))

  startsX = sapply(levels, xPowerMin)
  startsY = sapply(startsX, power)
  endsX = sapply(levels, xPowerMax)
  endsY = sapply(endsX, power)

  sapply(levels, evolutionArrow)
}

# Level evolution
level_evolution = function() {
  levelSteps = 30

  levelPlot = function(level) {
    x0 = xPowerMin(level)
    x1 = xPowerMin(level+1)
    xm = xPowerMax(level)
    y0 = power(x0)
    ym = power(xm)

    steps = seq(xPowerMin(level), xPowerMin(level+1), length.out=levelSteps)
    powers = sapply(steps, power)

    plot(steps, powers, xlim=c(x0, x1), ylim=c(y0-3, ym+3), main=paste('Power X Steps', '\n', 'Inside level', level), xaxt='n')
    axis(1, at = steps, labels = 1:levelSteps)

    evolutionArrow(level)
  }

  par(mfrow=c(2,2))
  levelPlot(1)
  levelPlot(2)
  levelPlot(3)
  levelPlot(4)
}

evolution()
level_evolution()

# --------
# Uso

# Quantos passos de dificuldade fase tem.
# Se a fase dura 3 min (180 segundos), então cada "step" deve ser incrementado a cada 6 segundos (180/300)
levelSteps = 30

# Definindo level
level = 1

# Intervalo de power do level
xstart = xPowerMin(level)
xend = xPowerMin(level+1)

# Monta um array entr xtart e xend, com levelSteps pontos
xs = seq(xstart, xend, length.out=levelSteps)

# Cmonta um array calculando, para cada ponto de xs, o power.
levelPowerSteps = sapply(xs, power)

# Um step arbitário da fase, escolhido entre 0 e 30 do levelStep
# no início da fase começa como 1*
# no R o array começa com 1. Então no C/Ruby/Python seria 0 e 29
step = 10

# O power que deve ser usado agora
powerNow = levelPowerSteps[step]
