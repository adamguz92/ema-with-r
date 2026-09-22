# eth-usd-ema21 – Exponential Moving Average (EMA) in Excel

Arkusz kalkulacyjny Microsoft Excel służący do obliczania wykładniczej średniej kroczącej (Exponential Moving Average, EMA) na podstawie historycznych danych cenowych. Użyte zostały dane ceny zamknięcia ETH/USD pochodzące z serwisu CoinGeko. 

## Metoda obliczania

Wskaźnik EMA obliczany jest według wzoru:

$$
EMA_t = \alpha P_t + (1-\alpha)EMA_{t-1}
$$

gdzie współczynnik wygładzania wynosi:

$$
\alpha = \frac{2}{N+1}
$$

W arkuszu zastosowano formuły programu Excel umożliwiające obliczanie kolejnych wartości EMA na podstawie bieżącej ceny i poprzedniej wartości wskaźnika.

