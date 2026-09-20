# 1. Instalacja bibliotek ----
install.packages(c('readr', 'dplyr', 'plotly'))
library(readr)
library(dplyr)
library(plotly)

# 2. Wczytanie danych ----
eth <- read_csv(file.choose(),show_col_types = FALSE)
# file.choose() otworzy okno wyboru pliku.

head(eth)
tail(eth)

str(eth) # struktura danych
# Daty w kolumnie event_date są przechowywane jako chr, czyli tekst zawierający datę. Trzeba je przekształcić na dane typu Date.

# Ostatnia obserwacja z 20.09.2026 nie zawiera ceny zamknięcia (ten dzień się jeszcze nie skończył). Trzeba się pozbyć tej obserwacji.

# 3. Zmiana typu danych z chr na Date ----
eth1 <- eth |> 
  mutate(event_date = as.Date(event_date)) |> # Zmiana typu danych.
  filter(!is.na(close_price_usd)) |> # Zachowaj obserwacje, które nie są puste.
  arrange(event_date) # Sortowanie po dacie.

head(eth1)
tail(eth1)
nrow(eth1)
str(eth1)

# 4. Obliczenie EMA ----
n <- 21
alpha <- 2/(n + 1)

# Utworzenie kolumny z wartościami EMA
eth1$ema21 <- NA
View(eth1)

# Obliczenie EMA21
eth1$ema21[n] <- mean(eth1$close_price_usd[1:n]) 
# Tutaj wyliczyłem średnią wartość dla 21 pierwszych obserwacji, jest to SMA21, która służy inicjalizacji EMA21. Szerszy opis znajduje sie w pliku eth-usd-ema21.xlsx. Wyliczona średnia trafia do 21 obserwacji w kolumnie ema21.

eth1$ema21[n] # 21 wiersz kolumny ema21.

for (i in (n+1):nrow(eth1)) {
  eth1$ema21[i] <- alpha * eth1$close_price_usd[i] + (1 - alpha) * eth1$ema21[i - 1]
}
# W każdej iteracji pobrana zostaje bieżąca cena ETH oraz poprzednia wartość EMA, zostaje obliczona nowa średnia i zapisana w odpowiednim wierszu.

View(eth1)

tail(eth1)

# 5. Interaktywny wykres w Plotly ----
## 5.1 Interaktywny wykres dla 90 okresów ----

# 90 ostatnich okresów do wizualizacji
eth_plot <- tail(eth1, 90)
View(eth_plot)

# Wykres interaktywny

fig <- plot_ly(
  data = eth_plot,
  x = ~event_date,
  y = ~close_price_usd,
  type = 'scatter',
  mode = 'lines',
  name = 'ETH/USD'
) |> 
  add_trace(
    y = ~ema21,
    name = 'EMA(21)'
  )

fig
# add_trace() dodaje kolejną serie danych do istniejącego wykresu.

# Cena ETH i EMA(21) pojawią się jednocześnie po najechaniu kursorem na wykres
fig1 <- fig |> 
  layout(
    title = 'ETH/USD - EMA(21)',
    xaxis = list(title = 'Data'),
    yaxis = list(title = 'Cena (USD)'),
    hovermode = 'x unified'
  )

fig1
# hovermode = 'x unified' powoduje,m że po wskazaniu określonej daty Plotly wyświetla wartości obu serii danych we wspólnym okienku.

## 5.2 Interaktywny wykres dla całego setu danych ----
# Tutaj zaczynam się już gubić w layoutcie, zostawiam ten kod bez opisu.
eth_plot1 <- eth1

fig2 <- plot_ly(
  data = eth_plot1,
  x = ~event_date,
  y = ~close_price_usd,
  type = "scatter",
  mode = "lines",
  name = "ETH/USD"
) |> 
  add_trace(
    y = ~ema21,
    name = "EMA(21)"
  ) |> 
  layout(
    title = "ETH/USD – EMA(21)",
    xaxis = list(
      title = "Data",
      rangeselector = list(
        buttons = list(
          list(
            count = 1,
            label = "1M",
            step = "month",
            stepmode = "backward"
          ),
          list(
            count = 3,
            label = "3M",
            step = "month",
            stepmode = "backward"
          ),
          list(
            count = 1,
            label = "1Y",
            step = "year",
            stepmode = "backward"
          ),
          list(
            step = "all",
            label = "ALL"
          )
        )
      ),
      rangeslider = list(
        visible = TRUE
      )
    ),
    yaxis = list(
      title = "Cena (USD)"
    ),
    hovermode = "x unified"
  )

fig2
