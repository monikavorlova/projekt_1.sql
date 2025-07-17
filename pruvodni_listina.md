# Průvodní listina

## Data

Při analýze jsou využita data z dostupných datových sad, z nichž jsou vytvořeny dvě zdrojové tabulky (t_monika_vorlova_sql_primary_final pro zodpovězení výzkumných otázek 1-4 a t_monika_vorlova_sql_secondary_final pro zodpovězení výzkumné otázky 5). Data jsou omezena na srovnatelné období, kterým jsou v tomto případě roky 2006 až 2018.

### NULL hodnoty
- Hodnoty industry_branch_code IS NULL, které ukazují na souhrnné informace o všech odvětvích, nebyly zahrnuty, jelikož dále pracujeme zejména s hodnotami pro jednotlivá odvětví. V případě potřeby získání souhrnných informací využíváme agregačních funkcí.
- Hodnoty region_code IS NULL byly zahrnuty. Jedná se o celorepubliková data, se kterými budeme dále uvažovat, naopak nevyužíváme dat o jednotlivých regionech (region_code IS NOT NULL). Byla provedena kontrola a průměr hodnot region_code IS NULL odpovídá průměru hodnot region_code IS NOT NULL. 

### Nekonzistence v datech
- V datové sadě 'czechia_payroll' je nekonzistentně veden údaj 'unit_code'. Dle dokumentace by měl 'unit_code = 80403' značit Kč. Jelikož je však veden spolu s údajem o průměrných počtech zaměstnaných osob, dále s ním pracujeme jako s údajem pro tisíce osob a s údajem 'unit_code = 200' jako s ukazatelem pro Kč.

---

## Výsledky

### VO1: Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

[SQL skript zde](https://github.com/monikavorlova/projekt_1.sql/blob/main/projekt_sql_vo1.sql)

Analýza dat ukazuje, že pouze ve třech z devatenácti sledovaných odvětví dochází ke konzistentnímu meziročnímu růstu mezd (zpracovatelský průmysl, zdravotní a sociální péče, ostatní činnosti). Ve zbývajících odvětvích se objevují roky s dočasným poklesem, a to zejména v období doznívající ekonomické krize, započaté v roce 2008. Celkem 20 z 23 zaznamenaných poklesů nastalo v letech 2009 až 2013, přičemž rok 2013 sám o sobě tvoří téměř 60 % všech těchto poklesů. V tomto roce došlo k poklesu mezd v 11 z 19 sledovaných odvětví. 
Navzdory těmto výkyvům lze mzdy ve všech odvětvích považovat za dlouhodobě rostoucí. Celkem 214 z 247 měření ukazuje nárůst, což činí téměř 87 % všech případů. 

### VO2: Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

[SQL skript zde](https://github.com/monikavorlova/projekt_1.sql/blob/main/projekt_sql_vo2.sql)

Za průměrnou mzdu jsme v prvním srovnatelném období mohli koupit 1287 kg chleba a 1437 l mléka, v porovnání s posledním obdobím, kdy nám průměrná mzda umožnila koupit 1342 kg chleba a 1641 l mléka.
I když ceny obou komodit v rámci prvního a posledního srovnatelného období vzrostly, mzda vzrostla relativně více než ceny. To znamená, že jsme si v roce 2018 mohli za průměrnou mzdu koupit více kilogramů chleba a litrů mléka než v roce 2006 — stoupla tedy kupní síla peněz. Tento trend, kdy je růst mezd rychlejší než růst cen základních potravin, může být ukazatelem zlepšující se životní úrovně v dané zemi.

### VO3: Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?

[SQL skript zde](https://github.com/monikavorlova/projekt_1.sql/blob/main/projekt_sql_vo3.sql)

V rámci sledovaného období došlo k nejnižšímu procentuálnímu nárůstu u cukru krystalového, jehož cena se snížila o 1,92 %. 

### VO4: Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

[SQL skript zde](https://github.com/monikavorlova/projekt_1.sql/blob/main/projekt_sql_vo4.sql)

Porovnáváme souhrny průměrných cen ve všech kategoriích a souhrny průměrných platů ve všech odvětvích za daný rok. V tomto případě není žádný rok, ve kterém bychom evidovali rozdíl meziročních nárůstů u cen a mezd vyšší než deset procentních bodů. 

### VO5: Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?

[SQL skript zde](https://github.com/monikavorlova/projekt_1.sql/blob/main/projekt_sql_vo5.sql)

Byly porovnávány úhrny průměrných cen a mezd za daný rok a jejich korelace s HDP daného, resp. předcházejícího roku. Pro posouzení míry vzájemné korelace využíváme Pearsonův korelační deficit (CORR()) - statistický ukazatel síly lineárního vztahu mezi párovými daty. Výsledky verbálně interpretujeme dle Evansovy příručky. 

Výsledky ukazují, že vliv HDP předcházejícího roku na průměrné ceny je zanedbatelný. Průměrné ceny i průměrné mzdy s HDP v daném roce mají střední korelaci (0,48, resp. 0,43 na škále 0-1). Nejsilnější vazba byla nalezena mezi průměrnými platy a HDP předcházejícího roku - zde můžeme hovořit o silné korelaci (0,67).