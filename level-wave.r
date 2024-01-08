rm(list = ls())

# Variávis de ajuste
a = 0.5   # Dificuldade (inclinação da reta base)
A = 5    # Variação da fase (amplitude da oscilação)
w = 0.5  # frequencia da oscilacao

# Funções auxiliares
wave = function(t, t0) {
  a*(t-t0) + A*cos(w*(t-t0))
}

dwave_xmin = function(n, t0) {
  (-asin(a/(A*w)) + 2*pi*n + t0*w + pi)/w
}

dwave_xmax = function(n, t0) {
  (asin(a/(A*w)) + 2*pi*n + t0*w)/w
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
  dwave_xmin(level-1, -t0)
}

xPowerMax = function(level) {
  t0 = dwave_xmin(0,0)
  dwave_xmax(level, -t0)
}

yPowerMin = function(level) {
  power(xPowerMin(level))
}

yPowerMax = function(level) {
  power(xPowerMax(level))
}

# ---
# Uso
# ---

# Quantos passos de dificuldade fase tem.
# Se a fase dura 3 min (180 segundos), então cada "step" deve ser incrementado a cada 6 segundos (180/300)
levelSteps = 31

# Definindo level
level = 2

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

#paste0("xs =[", paste(xs, collapse=','), ']')
#paste0("powers =[", paste(levelPowerSteps, collapse=','), ']')
cat(levelPowerSteps, sep='\n')
