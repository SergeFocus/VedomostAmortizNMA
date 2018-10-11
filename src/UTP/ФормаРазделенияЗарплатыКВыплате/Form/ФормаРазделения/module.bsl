﻿
Процедура ОсновныеДействияФормыОК(Кнопка)
	
	Попытка
		ДокОбъект = СсылкаНаОбъект.ПолучитьОбъект();
		ДокОбъект.Комментарий = "ДОКУМЕНТ РАЗДЕЛЕН. Старый комментарий " + ДокОбъект.Комментарий;
		ДокОбъект.УстановитьПометкуУдаления(Истина);
		ДокОбъект.ОбменДанными.Загрузка = Истина;
		ДокОбъект.Записать();
		ДокОбъект.ОбменДанными.Загрузка = Ложь;
	Исключение
		Сообщить("Ошибка установки пометки удаления")
	КонецПопытки;
	
	СписокВыбора = ЭлементыФормы.ТабличноеПоле1.Колонки.Документ.ЭлементУправления.СписокВыбора;
	ПроцентВыплаты = ЭлементыФормы.ПроцентВыплаты.Значение;
	
	Данные = ЭлементыФормы.ТабличноеПоле1.Значение.Скопировать();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПодразделенияПоДокументам.Подразделение,
	|	ПодразделенияПоДокументам.Документ
	|ПОМЕСТИТЬ ПодразделенияПоДокументам
	|ИЗ
	|	&Данные КАК ПодразделенияПоДокументам
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗарплатаКВыплатеОрганизацийРаботникиОрганизации.Сотрудник КАК Сотрудник,
	|	ЗарплатаКВыплатеОрганизацийРаботникиОрганизации.Сумма,
	|	ЗарплатаКВыплатеОрганизацийРаботникиОрганизации.СуммаОкругления,
	|	ЗарплатаКВыплатеОрганизацийРаботникиОрганизации.ВыплаченностьЗарплаты,
	|	ЗарплатаКВыплатеОрганизацийРаботникиОрганизации.СпособВыплаты,
	|	ЗарплатаКВыплатеОрганизацийРаботникиОрганизации.Банк,
	|	ЗарплатаКВыплатеОрганизацийРаботникиОрганизации.НомерКарточки,
	|	ЗарплатаКВыплатеОрганизацийРаботникиОрганизации.СуммаГрязными,
	|	ЗарплатаКВыплатеОрганизацийРаботникиОрганизации.СуммаПромежуточная,
	|	ЗарплатаКВыплатеОрганизацийРаботникиОрганизации.Физлицо,
	|	ЗарплатаКВыплатеОрганизацийРаботникиОрганизации.Подразделение,
	|	ПодразделенияПоДокументам.Документ КАК Документ
	|ИЗ
	|	Документ.ЗарплатаКВыплатеОрганизаций.РаботникиОрганизации КАК ЗарплатаКВыплатеОрганизацийРаботникиОрганизации
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПодразделенияПоДокументам КАК ПодразделенияПоДокументам
	|		ПО ЗарплатаКВыплатеОрганизацийРаботникиОрганизации.Подразделение = ПодразделенияПоДокументам.Подразделение
	|ГДЕ
	|	ЗарплатаКВыплатеОрганизацийРаботникиОрганизации.Ссылка = &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	Документ,
	|	Сотрудник
	|ИТОГИ ПО
	|	Документ";
	
	Запрос.УстановитьПараметр("Ссылка", СсылкаНаОбъект);
	Запрос.УстановитьПараметр("Данные", Данные);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаВсехДокументов = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	НовыйДокументОстатки = Документы.ЗарплатаКВыплатеОрганизаций.СоздатьДокумент();
	НовыйДокументОстатки.Комментарий 		= " Остаток от разделения документа " + СсылкаНаОбъект.Номер + " от " + СсылкаНаОбъект.Дата;
	НовыйДокументОстатки.Организация 		= СсылкаНаОбъект.Организация;
	НовыйДокументОстатки.ПериодРегистрации 	= СсылкаНаОбъект.ПериодРегистрации;
	НовыйДокументОстатки.Дата 				= СсылкаНаОбъект.Дата;
	НовыйДокументОстатки.Ответственный 		= СсылкаНаОбъект.Ответственный;
	НовыйДокументОстатки.ВидВыплаты 		= СсылкаНаОбъект.ВидВыплаты;
	
	
	Пока ВыборкаВсехДокументов.Следующий() Цикл
		
		ВыборкаПоДокументу = ВыборкаВсехДокументов.Выбрать();
		
		Если Не ЗначениеЗаполнено(ВыборкаВсехДокументов.Документ) тогда
			Пока ВыборкаПоДокументу.Следующий() Цикл
				
				//работники организаций
				НоваяСтрока2 = НовыйДокументОстатки.РаботникиОрганизации.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока2,ВыборкаПоДокументу);
								
				//параметры оплаты
				СтрокиПараметрыОплаты = СсылкаНаОбъект.ПараметрыОплаты.НайтиСтроки(Новый Структура("Сотрудник",ВыборкаПоДокументу.Сотрудник));
				
				Для каждого Строка из СтрокиПараметрыОплаты Цикл
						НоваяСтрока2 = НовыйДокументОстатки.ПараметрыОплаты.Добавить();
						ЗаполнитьЗначенияСвойств(НоваяСтрока2,Строка);		
				КонецЦикла;
				
				//НДФЛ
				СтрокиНДФЛ = СсылкаНаОбъект.НДФЛ.НайтиСтроки(Новый Структура("Сотрудник",ВыборкаПоДокументу.Сотрудник));
				Для каждого Строка из СтрокиНДФЛ Цикл
						НоваяСтрока2 = НовыйДокументОстатки.НДФЛ.Добавить();
						ЗаполнитьЗначенияСвойств(НоваяСтрока2,Строка);
				КонецЦикла;
				
				//взносы
				СтрокиВзносы = СсылкаНаОбъект.Взносы.НайтиСтроки(Новый Структура("Сотрудник",ВыборкаПоДокументу.Сотрудник));
				Для каждого Строка из СтрокиВзносы Цикл
						НоваяСтрока2 = НовыйДокументОстатки.Взносы.Добавить();
						ЗаполнитьЗначенияСвойств(НоваяСтрока2,Строка);
				КонецЦикла;
				
				//взносы фот
				СтрокиВзносыФОТ = СсылкаНаОбъект.ВзносыФОТ.НайтиСтроки(Новый Структура("Сотрудник",ВыборкаПоДокументу.Сотрудник));
				Для каждого Строка из СтрокиВзносыФОТ Цикл
						НоваяСтрока2 = НовыйДокументОстатки.ВзносыФОТ.Добавить();
						ЗаполнитьЗначенияСвойств(НоваяСтрока2,Строка);
				КонецЦикла;	
			КонецЦикла;
			Продолжить;
		КонецЕсли;
				
		НовыйДокумент = Документы.ЗарплатаКВыплатеОрганизаций.СоздатьДокумент();
		
		НовыйДокумент.Комментарий 		= "" + ВыборкаВсехДокументов.Документ + " разделение " + ПроцентВыплаты + "%";
		НовыйДокумент.Организация 		= СсылкаНаОбъект.Организация;
		НовыйДокумент.ПериодРегистрации = СсылкаНаОбъект.ПериодРегистрации;
		НовыйДокумент.Дата 				= СсылкаНаОбъект.Дата;
		НовыйДокумент.Ответственный 	= СсылкаНаОбъект.Ответственный;
		НовыйДокумент.ВидВыплаты 		= СсылкаНаОбъект.ВидВыплаты;
		
		Пока ВыборкаПоДокументу.Следующий() Цикл
			
			НоваяСтрока = НовыйДокумент.РаботникиОрганизации.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока,ВыборкаПоДокументу);
						
			Если ПроцентВыплаты <> 100 тогда
				НоваяСтрока.Сумма 				= НоваяСтрока.Сумма * ПроцентВыплаты / 100;
				НоваяСтрока.СуммаГрязными 		= НоваяСтрока.СуммаГрязными * ПроцентВыплаты / 100;
				НоваяСтрока.СуммаОкругления 	= НоваяСтрока.СуммаОкругления * ПроцентВыплаты / 100;
				НоваяСтрока.СуммаПромежуточная 	= НоваяСтрока.СуммаПромежуточная * ПроцентВыплаты / 100;
				
				НоваяСтрока2 = НовыйДокументОстатки.РаботникиОрганизации.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока2,ВыборкаПоДокументу);
				
				НоваяСтрока2.Сумма 				= НоваяСтрока2.Сумма - НоваяСтрока.Сумма;
				НоваяСтрока2.СуммаГрязными 		= НоваяСтрока2.СуммаГрязными - НоваяСтрока.СуммаГрязными;
				НоваяСтрока2.СуммаОкругления 	= НоваяСтрока2.СуммаОкругления - НоваяСтрока.СуммаОкругления;
				НоваяСтрока2.СуммаПромежуточная = НоваяСтрока2.СуммаПромежуточная - НоваяСтрока.СуммаПромежуточная;
			КонецЕсли;
			
			
			СтрокиПараметрыОплаты = СсылкаНаОбъект.ПараметрыОплаты.НайтиСтроки(Новый Структура("Сотрудник",ВыборкаПоДокументу.Сотрудник));
			Для каждого Строка из СтрокиПараметрыОплаты Цикл
				НоваяСтрока = НовыйДокумент.ПараметрыОплаты.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока,Строка);
				
				Если ПроцентВыплаты <> 100 тогда
					НоваяСтрока.Сумма 				= НоваяСтрока.Сумма * ПроцентВыплаты / 100;
					НоваяСтрока.СуммаГрязными 		= НоваяСтрока.СуммаГрязными * ПроцентВыплаты / 100;
					НоваяСтрока.СуммаОкругления 	= НоваяСтрока.СуммаОкругления * ПроцентВыплаты / 100;
					
					НоваяСтрока2 = НовыйДокументОстатки.ПараметрыОплаты.Добавить();
					ЗаполнитьЗначенияСвойств(НоваяСтрока2,Строка);
					
					НоваяСтрока2.Сумма 				= НоваяСтрока2.Сумма - НоваяСтрока.Сумма;
					НоваяСтрока2.СуммаГрязными 		= НоваяСтрока2.СуммаГрязными - НоваяСтрока.СуммаГрязными;
					НоваяСтрока2.СуммаОкругления 	= НоваяСтрока2.СуммаОкругления - НоваяСтрока.СуммаОкругления;
				КонецЕсли;
				
			КонецЦикла;
			
			СтрокиНДФЛ = СсылкаНаОбъект.НДФЛ.НайтиСтроки(Новый Структура("Сотрудник",ВыборкаПоДокументу.Сотрудник));
			Для каждого Строка из СтрокиНДФЛ Цикл
				НоваяСтрока = НовыйДокумент.НДФЛ.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока,Строка);
				Если ПроцентВыплаты <> 100 тогда
					НоваяСтрока.Налог 				= НоваяСтрока.Налог * ПроцентВыплаты / 100;
					НоваяСтрока.Доход 				= НоваяСтрока.Доход * ПроцентВыплаты / 100;
					
					НоваяСтрока2 = НовыйДокументОстатки.НДФЛ.Добавить();
					ЗаполнитьЗначенияСвойств(НоваяСтрока2,Строка);
					
					НоваяСтрока2.Налог 				= НоваяСтрока2.Налог - НоваяСтрока.Налог;
					НоваяСтрока2.Доход 				= НоваяСтрока2.Доход - НоваяСтрока.Доход;
				КонецЕсли;
			КонецЦикла;
			
			СтрокиВзносы = СсылкаНаОбъект.Взносы.НайтиСтроки(Новый Структура("Сотрудник",ВыборкаПоДокументу.Сотрудник));
			Для каждого Строка из СтрокиВзносы Цикл
				НоваяСтрока = НовыйДокумент.Взносы.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока,Строка);
				Если ПроцентВыплаты <> 100 тогда
					НоваяСтрока.Результат 	= НоваяСтрока.Результат * ПроцентВыплаты / 100;
					
					НоваяСтрока2 = НовыйДокументОстатки.Взносы.Добавить();
					ЗаполнитьЗначенияСвойств(НоваяСтрока2,Строка);
					
					НоваяСтрока2.Результат 	= НоваяСтрока2.Результат - НоваяСтрока.Результат;
				КонецЕсли;
			КонецЦикла;
			
			СтрокиВзносыФОТ = СсылкаНаОбъект.ВзносыФОТ.НайтиСтроки(Новый Структура("Сотрудник",ВыборкаПоДокументу.Сотрудник));
			Для каждого Строка из СтрокиВзносыФОТ Цикл
				НоваяСтрока = НовыйДокумент.ВзносыФОТ.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока,Строка);
				Если ПроцентВыплаты <> 100 тогда
					НоваяСтрока.Результат 	= НоваяСтрока.Результат * ПроцентВыплаты / 100;
					
					НоваяСтрока2 = НовыйДокументОстатки.ВзносыФОТ.Добавить();
					ЗаполнитьЗначенияСвойств(НоваяСтрока2,Строка);
					
					НоваяСтрока2.Результат 	= НоваяСтрока2.Результат - НоваяСтрока.Результат;
				КонецЕсли;
			КонецЦикла;
			
		КонецЦикла;
			НовыйДокумент.РаботникиОрганизации.Сортировать("Сотрудник");
			НовыйДокумент.ПолучитьФорму("ФормаДокумента").Открыть();
		
	КонецЦикла;
	
	Если НовыйДокументОстатки.РаботникиОрганизации.Количество() > 0 Тогда
		НовыйДокументОстатки.РаботникиОрганизации.Сортировать("Сотрудник");
		НовыйДокументОстатки.ПолучитьФорму("ФормаДокумента").Открыть();
	КонецЕсли;
	
	Закрыть();
		
КонецПроцедуры
	
	Процедура ПолеВвода1ПриИзменении(Элемент)
		СписокВыбора = Новый СписокЗначений;
		
		Если не ЗначениеЗаполнено(ЭлементыФормы.ПолеВвода1.Значение) Тогда
			Возврат;
		КонецЕсли;
		
		Для К = 1 по ЭлементыФормы.ПолеВвода1.Значение Цикл
			СписокВыбора.Добавить("Документ № " + К);
		КонецЦикла;
		
		ЭлементыФормы.ТабличноеПоле1.Колонки.Документ.ЭлементУправления.СписокВыбора = СписокВыбора;
		
	КонецПроцедуры
	
	Процедура ПриОткрытии()
		
		ЭлементыФормы.ПолеВвода1.Значение = 2;
		ЭлементыФормы.ПроцентВыплаты.Значение = 100;
		
		ПолеВвода1ПриИзменении(Неопределено);
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ЗарплатаКВыплатеОрганизацийРаботникиОрганизации.Подразделение КАК Подразделение,
		|	СУММА(1) КАК Количество
		|ИЗ
		|	Документ.ЗарплатаКВыплатеОрганизаций.РаботникиОрганизации КАК ЗарплатаКВыплатеОрганизацийРаботникиОрганизации
		|ГДЕ
		|	ЗарплатаКВыплатеОрганизацийРаботникиОрганизации.Ссылка = &Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	ЗарплатаКВыплатеОрганизацийРаботникиОрганизации.Подразделение
		|
		|УПОРЯДОЧИТЬ ПО
		|	Подразделение";
		
		Запрос.Параметры.Вставить("Ссылка",СсылкаНаОбъект);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			НоваяСтрока = ЭлементыФормы.ТабличноеПоле1.Значение.Добавить();
			НоваяСтрока.Подразделение = ВыборкаДетальныеЗаписи.Подразделение;
			НоваяСтрока.КоличествоСотрудников = ВыборкаДетальныеЗаписи.Количество;
		КонецЦикла;
		
	КонецПроцедуры