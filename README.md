## Внешние отчеты, обработки и печатные формы для 1С Бухгалтерия для Украины



L
# Внешние отчет отчет Ведомость Амортизации НМА Бухгалтерский Учет для Украины
VedomostAmortizNMA.erf
Добавлен в отчет вывод документов  Ввод в эксплуатацию

# Печатная форма акта списания ТМЦ на затраты для 1С Бухгалтерия для Украины
AktSpisaniya.epf
для
Документы.ТребованиеНакладная		
Документы.ПередачаМатериаловВЭксплуатацию		

# Печатная форма акта Акт с реквизитами период выполнения услуг 
Schot_so_srokami.epf
для
Документы.РеализацияТоваровУслуг

# Печатная форма Счет с реквизитами период выполнения услуг
Akt_rabot_so_srokami.epf
для
Документы.СчетНаОплатуПокупателю


S
# Обробка:  Загрузка Платежных Поручений Входящих из таблицы для 1С Бухгалтерия для Украины
ЗагрузкаПлатежныхПорученийВходящих.epf

# Обробка:  Загрузка платежных поручений Исходящих  из таблицы для 1С Бухгалтерия для Украины
ЗагрузкаПлатежныхПорученийИсходящих.epf
# Обробка:  ЗаменаСчета в проводках на 703  для 1С Бухгалтерия для Украины
ЗаменаСчета 703.epf

# Обробка:  Загрузка процентов (начисление процентов ПОМЕСЯЧНО).
ЗагрузкаЗакрытияПроцентов.epf

V
# Печатная форма Заказы покупателя - Счет с номером заказа 
Schot_so_srokami.epf

S2
# Обработка: Загрузка Платежных Поручений Входящих из таблицы для 1С УТП

1. Создает контрагентов в корне справочника.
Контрагенты- физлица. ИНН и ФИО заемщика - обязательны
2. Создает новый договор контрагента, # кредита / заявки - название договора, используется для поиска при закрытии договора; дата - Дата выдачи кредита
3. Создается документ - платежное поручение исходящее

ЗагрузкаПлатежныхПорученийИсходящих ТопКредит.epf

# Обробка:  Загрузка Платежных Поручений Входящих из таблицы для 1С УТП

ЗагрузкаПлатежныхПорученийВходящих ТопКредит.epf
