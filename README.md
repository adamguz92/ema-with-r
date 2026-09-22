# ema-with-r – Exponential Moving Average (EMA) in R

Implementacja wykładniczej średniej kroczącej (Exponential Moving Average, EMA) w języku R.

## Opis projektu

Projekt zawiera kod służący do obliczania wskaźnika EMA na podstawie historycznych danych cenowych ETH/USD. EMA przypisuje większą wagę nowszym obserwacjom, dzięki czemu szybciej reaguje na zmiany cen niż prosta średnia krocząca (SMA).

## Metoda obliczania

Wskaźnik EMA obliczany jest rekurencyjnie:

$$
EMA_t = \alpha P_t + (1-\alpha)EMA_{t-1}
$$

gdzie:

$$
\alpha = \frac{2}{N+1}
$$

- `P_t` – cena w okresie t.
- `N` – liczba okresów średniej.
- `α` – współczynnik wygładzania.

## Dane

Dane pochodzą z serwisu CoinGeko i są dokładnie opisane w pliku README.md w folderze data.
