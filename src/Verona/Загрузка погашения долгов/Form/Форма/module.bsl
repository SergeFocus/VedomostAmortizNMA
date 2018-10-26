﻿// Структура колонок загружаемых реквизитов, с описанием их свойств
Перем Колонки;
Перем ОперацияНачислениеПені;
Перем ОперацияНачислениеПроцентов;
Перем РегХозрасчетныйНачислениеПені;
Перем РегХозрасчетныйНачислениеПроцентов;
Перем ДокОперация;
Перем РегХозрасчетныйСписаниеЗадолженности;

// Процедура - обаботчик события, при нажатии на кнопку "Загрузить" Командной панели "ОсновныеДействияФормы"
//
Процедура ОсновныеДействияФормыЗагрузить(Кнопка)
	
	ЗагрузитьДанные(ЭлементыФормы.ТабличныйДокумент, ЭлементыФормы.Индикатор);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////

// Функция выполняет загрузку данных из табличного документа в справочник или табличную часть документа
//
// Параметры:
//  ТабличныйДокумент - ТабличныйДокумент, у которого необходимо сформировать шапку
//  Индикатор         - Элемент управления индикатор, в котором необходимо отображать процент выполнения загрузки
//
// Возвращаемое значение:
//  Истина, если загрузка прошла без ошибок, Ложь - иначе
//
Функция ЗагрузитьДанные(ТабличныйДокумент, Индикатор) Экспорт
	
	ОперацияНачислениеПені = Неопределено;
	ОперацияНачислениеПроцентов = Неопределено;
	РегХозрасчетныйНачислениеПені = Неопределено;
	РегХозрасчетныйНачислениеПроцентов = Неопределено;
	
	ЗаписыватьОбъект = истина;
	ПерваяСтрокаДанныхТабличногоДокумента =2;
	
	КоличествоЭлементов = ТабличныйДокумент.ВысотаТаблицы - ПерваяСтрокаДанныхТабличногоДокумента + 1;
	Если КоличествоЭлементов <= 0 Тогда
		Предупреждение("Нет данных для загрузки");
		Возврат Ложь;
	КонецЕсли;
	ТекстВопросаИсточника = " строк в Списание задолженности по договору факторинга";
	
	Если Вопрос("Загрузить "+КоличествоЭлементов  + ТекстВопросаИсточника, РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да Тогда
		
		ОчиститьСообщения();
		Сообщить("Выполняется загрузка"+ ТекстВопросаИсточника, СтатусСообщения.Информация);
		Сообщить("Всего: " + КоличествоЭлементов, СтатусСообщения.Информация);
		Сообщить("---------------------------------------------", СтатусСообщения.БезСтатуса);
		Индикатор.Значение = 0;
		Индикатор.МаксимальноеЗначение = КоличествоЭлементов;
		Загружено = 0;
		
		
		//Загрузка строк
		Для НомерСтроки = ПерваяСтрокаДанныхТабличногоДокумента По ТабличныйДокумент.ВысотаТаблицы Цикл
			НомерТекущейСтроки = Индикатор.Значение + 1;
			ТекстыЯчеек = Неопределено;
			Отказ = Ложь;
			ТекущаяСтрока = КонтрольЗаполненияСтроки(ТабличныйДокумент, НомерСтроки, ТекстыЯчеек);
			
			если НЕ СоздатьИЗаписатьНаборЗаписейПоСтроке(ТабличныйДокумент, ТекущаяСтрока)Тогда
				
				Отказ = Истина;
				Сообщить("Строка "+ Строка(Загружено+ 2)+ " НЕ ЗАГРУЖЕНА!");   //
				ТабличныйДокумент.Область((Загружено + 2),1).ЦветФона = Новый Цвет(255, 0, 0);  ;
			КонецЕсли;
			
			Если Не Отказ Тогда
				//Сообщить("Добавлена строка: " + (Загружено + 2));
				
			Иначе
				//Сообщить("При добавлении строки " + (Загружено + 2) + " возникли ошибки. ");
				ЗаписыватьОбъект = Ложь;
			КонецЕсли;
			
			Загружено = Загружено + 1;
			
			Индикатор.Значение = Индикатор.Значение + 1;
			ОбработкаПрерыванияПользователя();
			
		КонецЦикла;
		Сообщить("Создана Операция Списание задолженности по договору факторинга на сумму "+ ДокОперация.СуммаОперации + "грн. от "+ ДокОперация.Дата);
		
		Сообщить("---------------------------------------------", СтатусСообщения.БезСтатуса);
		
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

Функция СоздатьДокОперация()
	
	Перем ДокОперация, НовыйДокППВх, ТекПользователь;
	ДокОперация = Документы.ОперацияБух.СоздатьДокумент();
	ДокОперация.Дата =  Дата;  
	ДокОперация.Организация = Организация;
	ДокОперация.Ответственный = ПараметрыСеанса.ТекущийПользователь;
	ДокОперация.Содержание = "Гасіння заборгованості згідно договору факторингу";
	ДокОперация.Комментарий = "Гасіння заборгованості згідно договору факторингу";
	ДокОперация.СпособЗаполнения = "Вручную";
	ДокОперация.Записать();
	
	Возврат ДокОперация;
КонецФункции

Функция СоздатьИЗаписатьНаборЗаписейПоСтроке(ТабличныйДокумент, ТекущаяСтрока)	
	Перем ПараметрОбъектКопирования;
	Источник = новый массив;
	
	НомерДоговора	= формат(ТекущаяСтрока.НомерДоговора,"ЧЦ=9; ЧГ=0"); 
	ДатаОперации = НачалоДня( ПреобразоватьВДату(ТекущаяСтрока.ДатаОперации))+9*60*60;
	ТипПогашения = ТекущаяСтрока.ТипПогашения;
	Сумма =	формат(ТекущаяСтрока.Сумма,"ЧЦ=7; ЧГ=2");
	
	если ДатаОперации <> Дата Тогда
		Дата = ДатаОперации;
		//Создаем документ Операция БУ
		ДокОперация = СоздатьДокОперация();
		СуммаДокумента = 0;
		РегХозрасчетныйСписаниеЗадолженности = РегистрыБухгалтерии.Хозрасчетный.СоздатьНаборЗаписей();
		РегХозрасчетныйСписаниеЗадолженности.Отбор.Регистратор.Значение = ДокОперация.Ссылка;
		
	КонецЕсли;
	
	ДоговорКонтрагента = Справочники.ДоговорыКонтрагентов.НайтиПоНаименованию(НомерДоговора);
	если ДоговорКонтрагента =  Справочники.ДоговорыКонтрагентов.ПустаяСсылка() Тогда
		Сообщить("Не найден Договор " + НомерДоговора, СтатусСообщения.Важное);
		Возврат Ложь;
	КонецЕсли;
	
	
	Контрагент = КонтрагентИзСвойствДоговора(ДоговорКонтрагента);
	
	если ДоговорКонтрагента.Владелец =  Справочники.Контрагенты.ПустаяСсылка() Тогда
		Сообщить("Договор " +НомерДоговора+" не имеет контрагента", СтатусСообщения.Важное);
		Возврат Ложь;
	КонецЕсли;
	
	СуммаСтроки = 0;
	СуммаОстаток = СуммаОстаток(ДоговорКонтрагента);
	
	Доход = 0;
	Оплата = 0;
	
	Доход = Сумма-СуммаОстаток;
	
	
	Если ТипПогашения = "CASH" Тогда
		
		РегЗапись = РегХозрасчетныйСписаниеЗадолженности.Добавить();
		РегЗапись.Период = Дата;
		РегЗапись.Регистратор = ДокОперация.Ссылка;
		РегЗапись.Организация = Организация;
		РегЗапись.Содержание  = "Погашение задолженности";
		РегЗапись.СчетДт = ПланыСчетов.Хозрасчетный.НайтиПоКоду("301");
		РегЗапись.СчетКт = ПланыСчетов.Хозрасчетный.НайтиПоКоду("352");
		БухгалтерскийУчет.УстановитьСубконто(РегЗапись.СчетДт, РегЗапись.СубконтоДт, "СтатьиДвиженияДенежныхСредств", Справочники.СтатьиДвиженияДенежныхСредств.НайтиПоКоду("000000001"));  
		БухгалтерскийУчет.УстановитьСубконто(РегЗапись.СчетКт, РегЗапись.СубконтоКт, "ФинансовыеИнвестиции", Справочники.ФинансовыеИнвестиции.НайтиПоКоду("000000001"));
		БухгалтерскийУчет.УстановитьСубконто(РегЗапись.СчетКт, РегЗапись.СубконтоКт, "Контрагенты", Контрагент);
		БухгалтерскийУчет.УстановитьСубконто(РегЗапись.СчетКт, РегЗапись.СубконтоКт, "Договоры", ДоговорКонтрагента);
		РегЗапись.Сумма = Сумма;
		РегХозрасчетныйСписаниеЗадолженности.Записать();
		ДокОперация.СуммаОперации = ДокОперация.СуммаОперации + Оплата;
		ДокОперация.Записать();
		
	ИначеЕсли ТипПогашения = "MANUAL"Тогда
		
		РегЗапись = РегХозрасчетныйСписаниеЗадолженности.Добавить();
		РегЗапись.Период = Дата;
		РегЗапись.Регистратор = ДокОперация.Ссылка;
		РегЗапись.Организация = Организация;
		РегЗапись.Содержание  = "Погашение задолженности";
		РегЗапись.СчетДт = ПланыСчетов.Хозрасчетный.НайтиПоКоду(БУСчет);
		РегЗапись.СчетКт = ПланыСчетов.Хозрасчетный.НайтиПоКоду("352");
		БухгалтерскийУчет.УстановитьСубконто(РегЗапись.СчетДт, РегЗапись.СубконтоДт, "БанковскиеСчета", Счет); 
		БухгалтерскийУчет.УстановитьСубконто(РегЗапись.СчетДт, РегЗапись.СубконтоДт, "СтатьиДвиженияДенежныхСредств", Справочники.СтатьиДвиженияДенежныхСредств.НайтиПоКоду("000000001"));  
		БухгалтерскийУчет.УстановитьСубконто(РегЗапись.СчетКт, РегЗапись.СубконтоКт, "ФинансовыеИнвестиции", Справочники.ФинансовыеИнвестиции.НайтиПоКоду("000000001"));
		БухгалтерскийУчет.УстановитьСубконто(РегЗапись.СчетКт, РегЗапись.СубконтоКт, "Контрагенты", Контрагент);
		БухгалтерскийУчет.УстановитьСубконто(РегЗапись.СчетКт, РегЗапись.СубконтоКт, "Договоры", ДоговорКонтрагента);
		РегЗапись.Сумма = Сумма;
		РегХозрасчетныйСписаниеЗадолженности.Записать();
		ДокОперация.СуммаОперации = ДокОперация.СуммаОперации + Оплата;
		ДокОперация.Записать();
		
	ИначеЕсли ТипПогашения = "PLATON" Тогда
		
		РегЗапись = РегХозрасчетныйСписаниеЗадолженности.Добавить();
		РегЗапись.Период = Дата;
		РегЗапись.Регистратор = ДокОперация.Ссылка;
		РегЗапись.Организация = Организация;
		РегЗапись.Содержание  = "Погашение задолженности";
		РегЗапись.СчетДт = ПланыСчетов.Хозрасчетный.НайтиПоКоду(БУСчет);
		РегЗапись.СчетКт = ПланыСчетов.Хозрасчетный.НайтиПоКоду("352");
		БухгалтерскийУчет.УстановитьСубконто(РегЗапись.СчетДт, РегЗапись.СубконтоДт, "БанковскиеСчета", Счет);
		БухгалтерскийУчет.УстановитьСубконто(РегЗапись.СчетДт, РегЗапись.СубконтоДт, "СтатьиДвиженияДенежныхСредств", Справочники.СтатьиДвиженияДенежныхСредств.НайтиПоКоду("000000001"));  
		БухгалтерскийУчет.УстановитьСубконто(РегЗапись.СчетКт, РегЗапись.СубконтоКт, "ФинансовыеИнвестиции", Справочники.ФинансовыеИнвестиции.НайтиПоКоду("000000001"));
		БухгалтерскийУчет.УстановитьСубконто(РегЗапись.СчетКт, РегЗапись.СубконтоКт, "Контрагенты", Контрагент);
		БухгалтерскийУчет.УстановитьСубконто(РегЗапись.СчетКт, РегЗапись.СубконтоКт, "Договоры", ДоговорКонтрагента);
		РегЗапись.Сумма = Сумма;
		РегХозрасчетныйСписаниеЗадолженности.Записать();
		ДокОперация.СуммаОперации = ДокОперация.СуммаОперации + Оплата;
		ДокОперация.Записать();
		
	Иначе
		Сообщить("Не определено движение для типв погашения задолженности " +ТипПогашения, СтатусСообщения.Важное);
		Возврат Ложь;
	КонецЕсли;	
	
	
	
	Если Доход>0 Тогда
		
		РегЗапись = РегХозрасчетныйСписаниеЗадолженности.Добавить();
		РегЗапись.Период = Дата;
		РегЗапись.Регистратор = ДокОперация.Ссылка;
		РегЗапись.Организация = Организация;
		РегЗапись.Содержание  = "Доход";
		РегЗапись.СчетДт = ПланыСчетов.Хозрасчетный.НайтиПоКоду("352");               
		РегЗапись.СчетКт = ПланыСчетов.Хозрасчетный.НайтиПоКоду("719");
		БухгалтерскийУчет.УстановитьСубконто(РегЗапись.СчетДт, РегЗапись.СубконтоДт, "ФинансовыеИнвестиции", Справочники.ФинансовыеИнвестиции.НайтиПоКоду("000000001"));
		БухгалтерскийУчет.УстановитьСубконто(РегЗапись.СчетДт, РегЗапись.СубконтоДт, "Контрагенты", Контрагент);
		БухгалтерскийУчет.УстановитьСубконто(РегЗапись.СчетДт, РегЗапись.СубконтоДт, "Договоры", ДоговорКонтрагента);
		БухгалтерскийУчет.УстановитьСубконто(РегЗапись.СчетКт, РегЗапись.СубконтоКт, "СтатьиДоходов", Справочники.СтатьиДоходов.НайтиПоКоду("000001001"));  
		РегЗапись.Сумма = Доход;                                                                                           
		РегХозрасчетныйСписаниеЗадолженности.Записать();
		ДокОперация.СуммаОперации = ДокОперация.СуммаОперации + Доход;
		ДокОперация.Записать();
	КонецЕсли;
	Возврат Истина;
КонецФункции

Функция СуммаОстаток(Знач ДоговорКонтрагента)
	
	Перем Запрос, РЗ, СуммаОстаток, ТекстЗапроса;
	
	Запрос = Новый Запрос;
	
	ТекстЗапроса = "
	|		
	|		ВЫБРАТЬ ПЕРВЫЕ 1
	|	ХозрасчетныйОстатки.СуммаОстатокДт	 Как СуммаОстаток
	|	ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.Остатки(&Период, Счет В ИЕРАРХИИ (&Счет), , Организация = &Организация И Субконто3 В (&ДоговорКонтрагента)) КАК ХозрасчетныйОстатки
	|";
	
	
	Запрос.УстановитьПараметр("ДоговорКонтрагента", ДоговорКонтрагента);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Период", Дата+1);
	Запрос.УстановитьПараметр("Счет", ПланыСчетов.Хозрасчетный.НайтиПоКоду("352"));
	
	Запрос.Текст = ТекстЗапроса;
	
	РЗ = Запрос.Выполнить().Выбрать();
	Пока РЗ.Следующий() Цикл
		СуммаОстаток = РЗ.СуммаОстаток;
	КонецЦикла;
	Возврат СуммаОстаток;
	
КонецФункции

Функция КонтрагентИзСвойствДоговора(Знач ДоговорКонтрагента )
	
	Перем РЗ, ТекстЗапроса;
	
	Запрос = Новый Запрос;
	
	ТекстЗапроса = "
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	ЗначенияСвойствОбъектов.Значение Как Контрагент
	|ИЗ
	|	РегистрСведений.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектов
	|ГДЕ
	|	ЗначенияСвойствОбъектов.Свойство = &Свойство
	|	И ЗначенияСвойствОбъектов.Объект = &ДоговорКонтрагента
	|";
	
	
	Запрос.УстановитьПараметр("Свойство", ПланыВидовХарактеристик.СвойстваОбъектов.НайтиПоНаименованию( "Поставщик"));
	Запрос.УстановитьПараметр("ДоговорКонтрагента", ДоговорКонтрагента);
	
	Запрос.Текст = ТекстЗапроса;
	РЗ = Запрос.Выполнить().Выбрать();
	Пока РЗ.Следующий() Цикл
		Контрагент = РЗ.Контрагент;
	КонецЦикла;
	Возврат Контрагент;
КонецФункции

// "01.12.2011" преобразует в '01.12.2011 0:00:00'
Функция ДатаИзСтроки10(стрДата) экспорт  
	Попытка 
		возврат Дата(Сред(стрДата,7,4)+Сред(стрДата,4,2)+Лев(стрДата,2)) 
	Исключение 
		возврат '00010101' 
	КонецПопытки; 
КонецФункции // ДатаИзСтроки10()

Функция ПреобразоватьВДату(ИсхСтр)
	Стр = СокрЛП(ИсхСтр);
	ЭтоДата = Найти(Стр,".") или Найти(Стр,"-") или Найти(Стр,"/");
	ЭтоВремя = Найти(Стр,":");
	Если Не ЭтоДата и Не ЭтоВремя Тогда
		Возврат Дата(1,1,1,1,1,1);
	КонецЕсли;
	МассивДат = Новый Массив;
	МассивВремени = Новый Массив;
	врСтр = "";
	Для а = 1 По СтрДлина(Стр) Цикл
		Если (Сред(Стр,а,1) = "." или Сред(Стр,а,1) = "-" или Сред(Стр,а,1) = "/") и ЭтоДата Тогда
			МассивДат.Добавить(Число(врСтр));
			врСтр = "";
		ИначеЕсли Сред(Стр,а,1) = ":" и Не ЭтоДата Тогда
			МассивВремени.Добавить(Число(врСтр));
			врСтр = "";
		ИначеЕсли Сред(Стр,а,1) = " " или КодСимвола(Сред(Стр,а,1))<48 или КодСимвола(Сред(Стр,а,1))>57 Тогда
			Если МассивДат.Количество()>0 и МассивДат.Количество()<3 и врСтр <> "" Тогда
				МассивДат.Добавить(Число(врСтр));
			КонецЕсли;
			ЭтоДата = Ложь;
			врСтр = "";
		Иначе
			врСтр = врСтр + Сред(Стр,а,1);
		КонецЕсли;
	КонецЦикла;
	Если МассивВремени.Количество()>0 и МассивВремени.Количество()<3 и врСтр <> "" Тогда
		МассивВремени.Добавить(Число(врСтр));
	ИначеЕсли МассивДат.Количество()>0 и МассивДат.Количество()<3 и врСтр <> "" Тогда
		МассивДат.Добавить(Число(врСтр));
	КонецЕсли;
	врДень = 0;
	врМесяц = 0;
	врГод = 0;
	Для Каждого дСтр из МассивДат Цикл
		Если врДень <> 0 и врМесяц <> 0 Тогда
			врГод = дСтр;
		ИначеЕсли врГод <> 0 и врМесяц <> 0 Тогда
			врДень = дСтр;
		ИначеЕсли врГод <> 0 или врДень <> 0 Тогда
			врМесяц = дСтр;
		КонецЕсли;
		Если дСтр/100>1 Тогда
			врГод = дСтр;
		КонецЕсли;
		Если врГод = 0 и врДень = 0 Тогда
			врДень = дСтр;
		КонецЕсли;
	КонецЦикла;
	врЧас = 0;
	врМин = 0;
	врСек = 0;
	Для Каждого вСтр из МассивВремени Цикл
		Если врЧас = 0 Тогда
			врЧас = вСтр;
		ИначеЕсли врМин = 0 Тогда
			врМин = вСтр;
		ИначеЕсли врСек = 0 Тогда
			врСек = вСтр;
		КонецЕсли;
	КонецЦикла;
	Если врГод = 0 или врГод > 9999 Тогда
		врГод = 1;
	ИначеЕсли врГод/100<1 Тогда
		врГод = врГод + 2000;
	КонецЕсли;
	
	Если врМесяц = 0 или врМесяц>12 Тогда
		врМесяц = 1;
	КонецЕсли;
	Если врДень = 0 или врДень>31 Тогда
		врДень = 1;
	КонецЕсли;
	Если врЧас>23 Тогда
		врЧас = 0;
	КонецЕсли;
	Если врМин>59 Тогда
		врМин = 0;
	КонецЕсли;
	Если врСек>59 Тогда
		врСек = 0;
	КонецЕсли;
	Возврат Дата(врГод,врМесяц,врДень,врЧас,врМин,врСек);
КонецФункции

// Функция возвращает части представления даты
//
// Параметры:
//  Представление - Представление даты
//
// Возвращаемое значение:
//  массив частей даты
//
Функция ПолучитьЧастиПредставленияДаты(ЗНАЧ Представление)
	
	МассивЧастей = Новый Массив;
	НачалоЦифры = 0;
	Для к = 1 По СтрДлина(Представление) Цикл
		
		Символ = Сред(Представление, к ,1);
		ЭтоЦифра = Символ >= "0" и Символ <= "9";
		
		Если ЭтоЦифра Тогда
			
			Если НачалоЦифры = 0 Тогда
				НачалоЦифры = к;
			КонецЕсли;
			
		Иначе
			
			Если Не НачалоЦифры = 0 Тогда
				МассивЧастей.Добавить(Число(Сред(Представление,НачалоЦифры, к - НачалоЦифры)));
			КонецЕсли;
			
			НачалоЦифры = 0;
		КонецЕсли;
		
	КонецЦикла;
	
	Если Не НачалоЦифры = 0 Тогда
		МассивЧастей.Добавить(Число(Сред(Представление,НачалоЦифры)));
	КонецЕсли;
	
	Возврат МассивЧастей;
КонецФункции // ()

// Процедура формирует структуру колонок загружаемых реквизитов из табличной части "ТаблицаЗагружаемыхРеквизитов"
//
// Параметры:
//  нет
//
Процедура СформироватьСтруктуруКолонок() Экспорт
	
	НомерКолонки = 1;
	Колонки = Новый Структура;
	
	Колонка = Новый Структура;
	Колонка.Вставить("НомерКолонки",НомерКолонки);
	Колонка.Вставить("ИмяРеквизита","ДатаОперации");
	Колонка.Вставить("ОписаниеТипов",  ОбщегоНазначения.ПолучитьОписаниеТиповДаты(ЧастиДаты.ДатаВремя));
	//Колонка.Вставить("ШиринаКолонки",  10);
	Колонки.Вставить(Колонка.ИмяРеквизита,Колонка);
	НомерКолонки = НомерКолонки + 1;
	
	Колонка = Новый Структура;
	Колонка.Вставить("НомерКолонки",НомерКолонки);
	Колонка.Вставить("ИмяРеквизита","НомерДоговора");
	Колонка.Вставить("ОписаниеТипов",  ОбщегоНазначения.ПолучитьОписаниеТиповЧисла(9,0));
	Колонка.Вставить("ШиринаКолонки",  10);
	Колонки.Вставить(Колонка.ИмяРеквизита,Колонка);
	НомерКолонки = НомерКолонки + 1;
	
	Колонка = Новый Структура;
	Колонка.Вставить("НомерКолонки",НомерКолонки);
	Колонка.Вставить("ИмяРеквизита","ТипПогашения");
	Колонка.Вставить("ОписаниеТипов",  ОбщегоНазначения.ПолучитьОписаниеТиповСтроки(0));
	//Колонка.Вставить("ШиринаКолонки",  10);
	Колонки.Вставить(Колонка.ИмяРеквизита,Колонка);
	НомерКолонки = НомерКолонки + 1;
	
	Колонка = Новый Структура;
	Колонка.Вставить("НомерКолонки",НомерКолонки);
	Колонка.Вставить("ИмяРеквизита","Сумма");
	Колонка.Вставить("ОписаниеТипов",  ОбщегоНазначения.ПолучитьОписаниеТиповЧисла(7,2));
	//Колонка.Вставить("ШиринаКолонки",  10);
	Колонки.Вставить(Колонка.ИмяРеквизита,Колонка);
	НомерКолонки = НомерКолонки + 1;
КонецПроцедуры // ()

// Функция выполняет контроль заполнения строки данных табличного документа
// сообщает об ошибках и устанавливает коментарии к ошибочным ячейкам
//
// Параметры:
//  ТабличныйДокумент - ТабличныйДокумент, у которого необходимо сформировать шапку
//  НомерСтроки       - Число, номер строки табличного документа
//  ТекстыЯчеек    - возвращает массив текстов ячеек строки,
//
// Возвращаемое значение:
//  структура, ключ - Имя загружаемого реквизита, Значение - Значение загружаемого реквизита
//
Функция КонтрольЗаполненияСтроки(ТабличныйДокумент, НомерСтроки, ТекстыЯчеек = Неопределено, КоличествоОшибок = 0)
	
	ТекстыЯчеек = Новый Массив;
	ТекстыЯчеек.Добавить(Неопределено);
	Для к = 1 По ТабличныйДокумент.ШиринаТаблицы Цикл
		ТекстыЯчеек.Добавить(СокрЛП(ТабличныйДокумент.Область("R"+Формат(НомерСтроки,"ЧГ=")+"C"+Формат(К,"ЧГ=")).Текст));
	КонецЦикла;
	
	ТекущаяСтрока     = Новый Структура;
	Для каждого КлючИЗначение Из Колонки Цикл
		
		Колонка = КлючИЗначение.Значение;
		Если Не ОбработатьОбласть(ТабличныйДокумент.Область("R"+Формат(НомерСтроки,"ЧГ=")+"C"+Формат(Колонка.НомерКолонки,"ЧГ=")), Колонка, ТекущаяСтрока, ТекстыЯчеек) Тогда
			КоличествоОшибок = КоличествоОшибок + 1;
		КонецЕсли;
	КонецЦикла;
	Возврат ТекущаяСтрока;
	
КонецФункции

// Процедура выполняет обработку области табличного документа:
// заполняет расшифровку по представлению ячейки в соответствии со структурой загружаемых реквизитов
// сообщает об ошибке и устанавливает коментарий, если ячейка содержит ошибку
//
// Параметры:
//  Область - область табличного документа
//  Колонка - Структура, свойства, в соответствии с которыми необходимо выполнить обработку области
//  ТекущиеДанные  - структура загруженных значений
//  ТекстыЯчеек    - массив текстов ячеек строки
//
Функция ОбработатьОбласть(Область, Колонка, ТекущиеДанные, ТекстыЯчеек)
	
	Представление = Область.Текст;
	Примечание = "";
	
	Результат = СокрЛП(Представление);
	ОписаниеОшибки = "";
	
	ТекущиеДанные.Вставить(Колонка.ИмяРеквизита,Результат);
	
	Область.Расшифровка = Результат;
	Область.Примечание.Текст = Примечание;
	
	Если Не ПустаяСтрока(Примечание) Тогда
		Сообщить("Ячейка["+Область.Имя+"]("+Колонка.ПредставлениеРеквизита+"): " + Примечание);
	КонецЕсли;
	
	Возврат ПустаяСтрока(Примечание);
	
КонецФункции

// Процедура формирует шапку табличного документа, в соответствии с таблицей загружаемых реквизитов
//
// Параметры:
//  ТабличныйДокумент - ТабличныйДокумент, у которого необходимо сформировать шапку
//
Процедура СформироватьШапкуТабличногоДокумента(ТабличныйДокумент) Экспорт
	
	Линия = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная,1);
	
	//Таблица = ТаблицаЗагружаемыхРеквизитов.Скопировать();
	//Таблица.Сортировать("НомерКолонки");
	Для каждого КлючИЗначение Из Колонки Цикл
		ЗагружаемыйРеквизит = КлючИЗначение.Значение;
		НомерКолонки = ЗагружаемыйРеквизит.НомерКолонки;
		//ШиринаКолонки = ЗагружаемыйРеквизит.ШиринаКолонки;
		
		
		Область = ТабличныйДокумент.Область("R1C"+НомерКолонки);
		БылТекст = Не ПустаяСтрока(Область.Текст);
		Область.Текст       = ?(БылТекст,Область.Текст + Символы.ПС,"") + ЗагружаемыйРеквизит.ИмяРеквизита;
		Область.Расшифровка = ЗагружаемыйРеквизит.ИмяРеквизита;
		Область.ЦветФона = ЦветаСтиля.ЦветФонаФормы;
		Область.Обвести(Линия, Линия, Линия, Линия);
		
		//ОбластьКолонки = ТабличныйДокумент.Область("C"+НомерКолонки);
		//ОбластьКолонки.ШиринаКолонки = ?(БылТекст,Макс(ОбластьКолонки.ШиринаКолонки,ШиринаКолонки),ШиринаКолонки);
		
	КонецЦикла;
	
КонецПроцедуры // СформироватьШапкуТабличногоДокумента()

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	Дата = НачалоДня(ТекущаяДата())+9*60*60;
	СформироватьСтруктуруКолонок();
	СформироватьШапкуТабличногоДокумента(ЭлементыФормы.ТабличныйДокумент);
	Организация =  ОбщегоНазначения.ГоловнаяОрганизация(глЗначениеПеременной("ОсновнаяОрганизация"));
	Счет = Справочники.БанковскиеСчета.НайтиПоНаименованию("26506056101627");      // Справочники.БанковскиеСчета.НайтиПоРеквизиту("НомерСчета", "11111111111111111111")
	БУСчет = ПланыСчетов.Хозрасчетный.ТекущиеСчетаВНациональнойВалюте;
КонецПроцедуры