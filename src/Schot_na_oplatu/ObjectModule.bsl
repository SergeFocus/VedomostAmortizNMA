﻿Перем мВалютаРегламентированногоУчета Экспорт;

Перем ТаблицаВзаиморасчетов;

//#Если Клиент Тогда
Функция Печать() Экспорт
	
Тип = "Счет" ;

	ДопКолонка = Константы.ДополнительнаяКолонкаПечатныхФормДокументов.Получить();
	Если ДопКолонка = Перечисления.ДополнительнаяКолонкаПечатныхФормДокументов.Артикул Тогда
		ВыводитьКоды    = Истина;
		Колонка         = "Артикул";
		ТекстКодАртикул = "Артикул";
	ИначеЕсли ДопКолонка = Перечисления.ДополнительнаяКолонкаПечатныхФормДокументов.Код Тогда
		ВыводитьКоды    = Истина;
		Колонка         = "Код";
		ТекстКодАртикул = "Код";
	Иначе
		ВыводитьКоды    = Ложь;
		Колонка         = "";
		ТекстКодАртикул = "Код";
	КонецЕсли;

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТекущийДокумент", СсылкаНаОбъект);
	Запрос.Текст ="
	|ВЫБРАТЬ
	|	Номер,
	|	Дата,
	|	ДоговорКонтрагента,
	|	ДоговорКонтрагента.ВидДоговора КАК ВидДоговораКонтрагента,
	|	ДоговорКонтрагента.НаименованиеДляПечати КАК ДоговорНаименованиеДляПечати,	
	|	Организация,
	|	Контрагент КАК Покупатель,
	|	Организация КАК Поставщик,
	|	Ответственный.ФизЛицо.Наименование КАК Выписал,
	|	Ответственный.ФизЛицо.Наименование КАК ФИОИсполнителя,
	|	КонтактноеЛицоКонтрагента.Наименование КАК ФИОЗаказчика,	
	|	СуммаДокумента,
	|	ВалютаДокумента,
	|	УчитыватьНДС,
	|	СуммаВключаетНДС
	|ИЗ
	|	Документ.ЗаказПокупателя КАК ЗаказПокупателя
	|
	|ГДЕ
	|	ЗаказПокупателя.Ссылка = &ТекущийДокумент";

	Шапка = Запрос.Выполнить().Выбрать();
	Шапка.Следующий();
	
	СтрокаВыборкиПоляСодержания = ОбработкаТабличныхЧастей.ПолучитьЧастьЗапросаДляВыбораСодержания("");
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТекущийДокумент", СсылкаНаОбъект);
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	НомерТЧ,
	|	НомерСтрокиТЧ,
	|	Номенклатура,
	|	ВЫРАЗИТЬ(Номенклатура.НаименованиеПолное КАК СТРОКА(1000)) КАК Товар,
	|	Номенклатура.Код                КАК Код,
	|	Номенклатура."+ ТекстКодАртикул + " КАК КодАртикул,
	|	Количество,
	|	КоличествоМест,
	|	ЕдиницаЦены.Представление КАК ЕдиницаЦены,
	|	ЕдиницаМест.Представление КАК ЕдиницаМест,
	|	ПроцентСкидкиНаценки КАК Скидка,
	|	ПроцентАвтоматическихСкидок КАК АвтоматическаяСкидка,
	|	Цена,
	|	Сумма,
	|	СуммаНДС,
	|	Характеристика,
	|	NULL 							КАК Серия
	|ИЗ
	|	(
	|	ВЫБРАТЬ
	|		1 КАК НомерТЧ,
	|		МИНИМУМ(НомерСтроки) 		КАК НомерСтрокиТЧ,
	|		Номенклатура,
	|		ЕдиницаИзмерения 	 		КАК ЕдиницаЦены,
	|		ЕдиницаИзмеренияМест 		КАК ЕдиницаМест,
	|		ПроцентСкидкиНаценки        КАК ПроцентСкидкиНаценки,
	|		ПроцентАвтоматическихСкидок КАК ПроцентАвтоматическихСкидок,
	|		Цена                        КАК Цена,
	|		СУММА(Количество)           КАК Количество,
	|		СУММА(КоличествоМест)       КАК КоличествоМест,
	|		СУММА(Сумма     )           КАК Сумма,
	|		СУММА(СуммаНДС  )           КАК СуммаНДС,
	|		ХарактеристикаНоменклатуры  КАК Характеристика
	|	ИЗ
	|		Документ.ЗаказПокупателя.Товары КАК ЗаказПокупателя
	|
	|	ГДЕ
	|		ЗаказПокупателя.Ссылка = &ТекущийДокумент
	|
	|	СГРУППИРОВАТЬ ПО
	|		Номенклатура,
	|		ЕдиницаИзмерения,
	|		ЕдиницаИзмеренияМест,
	|		ПроцентСкидкиНаценки,
	|		ПроцентАвтоматическихСкидок,
	|		Цена,
	|		ХарактеристикаНоменклатуры
	|	) КАК ВложенныйЗапрос
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|   2,
	|   НомерСтроки,
	|	Номенклатура,
	|	" + СтрокаВыборкиПоляСодержания + " КАК Товар,
	|	Номенклатура.Код     КАК Код,
	|	Номенклатура."+ ТекстКодАртикул + " КАК КодАртикул,
	|	Количество,
	|	NULL,
	|	Номенклатура.ЕдиницаХраненияОстатков,
	|	NULL,
	|	ПроцентСкидкиНаценки,
	|	ПроцентАвтоматическихСкидок,
	|	Цена,
	|	Сумма,
	|	СуммаНДС,
	|	NULL,
	|	NULL
	|	
	|ИЗ
	|	Документ.ЗаказПокупателя.Услуги КАК ЗаказПокупателя
	|
	|ГДЕ
	|	ЗаказПокупателя.Ссылка = &ТекущийДокумент
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерТЧ, НомерСтрокиТЧ
	|";

	ЗапросТовары = Запрос.Выполнить().Выгрузить();

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТекущийДокумент", СсылкаНаОбъект);
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	НомерСтроки						КАК НомерСтрокиТЧ,
	|	Номенклатура,
	|	ВЫРАЗИТЬ(Номенклатура.НаименованиеПолное КАК СТРОКА(1000)) КАК Товар,
	|	Номенклатура.Код                КАК Код,
	|	Номенклатура."+ ТекстКодАртикул + " КАК КодАртикул,
	|	Количество,
	|	Номенклатура.ЕдиницаХраненияОстатков.Представление КАК ЕдиницаЦены,
	|	Цена,
	|	Сумма
	|ИЗ
	|	Документ.ЗаказПокупателя.ВозвратнаяТара КАК ЗаказПокупателя
	|
	|ГДЕ
	|	ЗаказПокупателя.Ссылка = &ТекущийДокумент
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтрокиТЧ
	|";
	
	ЗапросТара = Запрос.Выполнить().Выгрузить();
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ЗаказПокупателя_СчетЗаказ";
	
	Макет = ПолучитьМакет("СчетЗаказ");
	
	// печать производится на языке, указанном в настройках пользователя
	КодЯзыкаПечать = Локализация.ПолучитьЯзыкФормированияПечатныхФорм(УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "РежимФормированияПечатныхФорм"));
	Макет.КодЯзыкаМакета = КодЯзыкаПечать;

	// Выводим шапку накладной
	СведенияОПоставщике = УправлениеКонтактнойИнформацией.СведенияОЮрФизЛице(Шапка.Поставщик, Шапка.Дата,,,КодЯзыкаПечать);
	СведенияОПокупателе = УправлениеКонтактнойИнформацией.СведенияОЮрФизЛице(Шапка.Покупатель, Шапка.Дата,,,КодЯзыкаПечать);
	
	Если  ТипЗнч(СсылкаНаОбъект.СтруктурнаяЕдиница) = Тип("СправочникСсылка.БанковскиеСчета")
		И ЗначениеЗаполнено(СсылкаНаОбъект.СтруктурнаяЕдиница) Тогда
		Банк		= СсылкаНаОбъект.СтруктурнаяЕдиница.Банк;
		МФО	 		= Банк.Код;
		НомерСчета 	= СсылкаНаОбъект.СтруктурнаяЕдиница.НомерСчета;
	Иначе
		// покажем банковские реквизиты основного счета организации
		Банк		= СведенияОПоставщике.Банк;
		МФО	 		= СведенияОПоставщике.МФО;
		НомерСчета 	= СведенияОПоставщике.НомерСчета;
	КонецЕсли;
	
	Если Тип = "Счет" Тогда		
		ОбластьМакета       						= Макет.ПолучитьОбласть("ЗаголовокСчета");
		ОбластьМакета.Параметры.НазваниеОрганизации = СведенияОПоставщике.ПолноеНаименование;
		ОбластьМакета.Параметры.ЕДРПОУОрганизации	= ?(ЗначениеЗаполнено(СведенияОПоставщике.КодПоЕДРПОУ), СведенияОПоставщике.КодПоЕДРПОУ, СведенияОПоставщике.КодПоДРФО);
		Если ТипЗнч(СсылкаНаОбъект.СтруктурнаяЕдиница) = Тип("СправочникСсылка.БанковскиеСчета")
			И НЕ Шапка.ВидДоговораКонтрагента = Перечисления.ВидыДоговоровКонтрагентов.СКомиссионером  
			И НЕ Шапка.ВалютаДокумента <> мВалютаРегламентированногоУчета Тогда
			ОбластьМакета.Параметры.БанкОрганизации					= Банк;
			ОбластьМакета.Параметры.МФОБанкаОрганизации	            = МФО;
			ОбластьМакета.Параметры.НомерРасчетногоСчетаОрганизации = НомерСчета;
			ТабДокумент.Вывести(ОбластьМакета);
		КонецЕсли;
	КонецЕсли; 

	ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
	Если Тип = "Счет" Тогда
		Если Шапка.ВидДоговораКонтрагента = Перечисления.ВидыДоговоровКонтрагентов.СКомиссионером  Тогда
			ОбластьМакета.Параметры.ТекстЗаголовка = ОбщегоНазначения.СформироватьЗаголовокДокумента(Шапка, НСтр("ru='Список товаров на комиссию по заказу';uk='Список товарів на комісію по замовленню'",КодЯзыкаПечать),КодЯзыкаПечать);
		Иначе	
			ОбластьМакета.Параметры.ТекстЗаголовка = ОбщегоНазначения.СформироватьЗаголовокДокумента(Шапка, НСтр("ru='Счет на оплату';uk='Рахунок на оплату'",КодЯзыкаПечать),КодЯзыкаПечать);
		КонецЕсли; 
	Иначе
		ОбластьМакета.Параметры.ТекстЗаголовка = ОбщегоНазначения.СформироватьЗаголовокДокумента(Шапка, НСтр("ru='Заказ покупателя';uk='Замовлення покупця'",КодЯзыкаПечать),КодЯзыкаПечать);
	КонецЕсли;
	ТабДокумент.Вывести(ОбластьМакета);

	ОбластьМакета = Макет.ПолучитьОбласть("Поставщик");
	ОбластьМакета.Параметры.Заполнить(Шапка);
	ОбластьМакета.Параметры.ПредставлениеПоставщика = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОПоставщике, "ПолноеНаименование,",,КодЯзыкаПечать);	
	
	ОбластьМакета.Параметры.РеквизитыПоставщика =  НСтр("ru='Т/с ';uk='П/р '",КодЯзыкаПечать) + НомерСчета + ", Банк " + Банк + ", МФО " + МФО + Символы.ПС 
												 + ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОПоставщике, "ЮридическийАдрес,Телефоны,/,КодПоЕДРПОУ,КодПоДРФО,ИНН,НомерСвидетельства,/,ИнформацияОСтатусеПлательщикаНалогов,",,КодЯзыкаПечать);
	ТабДокумент.Вывести(ОбластьМакета);

	ОбластьМакета = Макет.ПолучитьОбласть("Покупатель");
	ОбластьМакета.Параметры.Заполнить(Шапка);
 	ОбластьМакета.Параметры.ПредставлениеПокупателя = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОПокупателе, "ПолноеНаименование,",,КодЯзыкаПечать);
	ОбластьМакета.Параметры.РеквизитыПокупателя		= ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОПокупателе,"Телефоны,",,КодЯзыкаПечать);
	ТабДокумент.Вывести(ОбластьМакета);

	Если Тип = "Счет" Тогда
		

	// Выводим дополнительные реквизиты № Заказа  	
	ОбластьМакета = Макет.ПолучитьОбласть("НомерЗаказа");
		Запрос = Новый Запрос();
	
	Запрос.УстановитьПараметр("НазначениеСвойств", ОбщегоНазначения.ПолучитьСписокНазначенийСвойствКатегорийОбъектовПоСсылке(СсылкаНаОбъект));
	Запрос.УстановитьПараметр("ОбъектОтбораЗначений", СсылкаНаОбъект);
	
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	СвойстваОбъектов.Наименование КАК СвойстваОбъектовНаименование,
	|	ЗначенияСвойствОбъектов.Значение КАК Значение 
	|	ИЗ
	|	(ВЫБРАТЬ
	|		СвойстваОбъектов.Ссылка КАК Ссылка,
	|		СвойстваОбъектов.Наименование КАК Наименование,
	|		СвойстваОбъектов.ПометкаУдаления КАК ПометкаУдаления
	|	ИЗ
	|		ПланВидовХарактеристик.СвойстваОбъектов КАК СвойстваОбъектов
	|	ГДЕ
	|		СвойстваОбъектов.НазначениеСвойства В(&НазначениеСвойств)) КАК СвойстваОбъектов
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектов
	|		ПО (ЗначенияСвойствОбъектов.Свойство = СвойстваОбъектов.Ссылка)
	|			И (ЗначенияСвойствОбъектов.Объект = &ОбъектОтбораЗначений)

	|";

	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл 
		Если Выборка.СвойстваОбъектовНаименование = "№ Заказа" Тогда 
				ОбластьМакета.Параметры.Заказ = Выборка.Значение;
		КонецЕсли;
	КонецЦикла;
	ТабДокумент.Вывести(ОбластьМакета);
		
		
		
		
		// Выводим дополнительно информацию о договоре
		СписокДополнительныхПараметров = "ДоговорНаименованиеДляПечати,";
		МассивСтруктурСтрок = ФормированиеПечатныхФорм.ДополнительнаяИнформация(Шапка,СписокДополнительныхПараметров,КодЯзыкаПечать);
		
		ОбластьМакета = Макет.ПолучитьОбласть("ДопИнформация");		
		Для каждого СтруктураСтроки Из МассивСтруктурСтрок Цикл
			ОбластьМакета.Параметры.Заполнить(СтруктураСтроки);
			ТабДокумент.Вывести(ОбластьМакета);
		КонецЦикла;		
	КонецЕсли;
	
	ЕстьСкидки = ЗапросТовары.Итог("Скидка") + ЗапросТовары.Итог("АвтоматическаяСкидка") <> 0;

	Если ВыводитьКоды Тогда
		ОбластьШапки  = "ШапкаСКодом";
		ОбластьСтроки = "СтрокаСКодом";
	Иначе
		ОбластьШапки  = "ШапкаТаблицы";
		ОбластьСтроки = "Строка";
	Конецесли;

	Если СсылкаНаОбъект.Товары.Итог("КоличествоМест") > 0 Тогда
		ОбластьШапки  = ОбластьШапки  + "Мест";
		ОбластьСтроки = ОбластьСтроки + "Мест";
	Конецесли;
	
	Если ЕстьСкидки Тогда
		ОбластьШапки  = ОбластьШапки  + "Скидка";
		ОбластьСтроки = ОбластьСтроки + "Скидка";
	КонецЕсли; 
	
	// Вывести табличную часть (товары и услуги)
	ОбластьМакета = Макет.ПолучитьОбласть(ОбластьШапки);
	Если ВыводитьКоды Тогда
		ОбластьМакета.Параметры.Колонка = Колонка;
	КонецЕсли;
	
	Суффикс = "";
	Если Шапка.УчитыватьНДС Тогда
		Если Шапка.СуммаВключаетНДС Тогда
			Суффикс  = Суффикс  + НСтр("ru=' с ';uk=' з '",КодЯзыкаПечать);
		Иначе	
			Суффикс  = Суффикс  + НСтр("ru=' без ';uk=' без '",КодЯзыкаПечать);
		КонецЕсли;
		Суффикс = Суффикс  + НСтр("ru='НДС';uk='ПДВ'",КодЯзыкаПечать);
	КонецЕсли;
	ОбластьМакета.Параметры.Цена  = НСтр("ru='Цена';uk='Ціна'",КодЯзыкаПечать) + Суффикс;
	ОбластьМакета.Параметры.Сумма = НСтр("ru='Сумма';uk='Сума'",КодЯзыкаПечать)+ Суффикс;
	
	ТабДокумент.Вывести(ОбластьМакета);

	ОбластьМакета = Макет.ПолучитьОбласть(ОбластьСтроки);
	
	Сумма    = 0;
	СуммаНДС = 0;
	ВсегоСкидок    = 0;
	ВсегоБезСкидок = 0;

	Для каждого ВыборкаСтрокТовары из ЗапросТовары Цикл 

		Если НЕ ЗначениеЗаполнено(ВыборкаСтрокТовары.Номенклатура) Тогда
			Сообщить("В одной из строк не заполнено значение номенклатуры - строка при печати пропущена.", СтатусСообщения.Важное);
			Продолжить;
		КонецЕсли;

		ОбластьМакета.Параметры.Заполнить(ВыборкаСтрокТовары);
		ОбластьМакета.Параметры.НомерСтроки = ЗапросТовары.Индекс(ВыборкаСтрокТовары) + 1;
		ОбластьМакета.Параметры.Товар       = СокрЛП(ВыборкаСтрокТовары.Товар) + ФормированиеПечатныхФорм.ПредставлениеСерий(ВыборкаСтрокТовары);

		Если ВыводитьКоды Тогда
			ОбластьМакета.Параметры.КодАртикул = ВыборкаСтрокТовары.КодАртикул;
		КонецЕсли;

		// Скидка может быть NULL
		ПроцентСкидки = ?(НЕ ЗначениеЗаполнено(ВыборкаСтрокТовары.Скидка),0,ВыборкаСтрокТовары.Скидка) 
		              + ?(НЕ ЗначениеЗаполнено(ВыборкаСтрокТовары.АвтоматическаяСкидка),0,ВыборкаСтрокТовары.АвтоматическаяСкидка);

		Скидка = ?(ПроцентСкидки < 100, ВыборкаСтрокТовары.Сумма  / (100 - ПроцентСкидки)* ПроцентСкидки, ВыборкаСтрокТовары.Цена * ВыборкаСтрокТовары.Количество);

		Если ЕстьСкидки Тогда
			ОбластьМакета.Параметры.Скидка         = Скидка;
			ОбластьМакета.Параметры.СуммаБезСкидки = ВыборкаСтрокТовары.Сумма + Скидка;
		КонецЕсли;
		
		ТабДокумент.Вывести(ОбластьМакета);

		Сумма    = Сумма    + ВыборкаСтрокТовары.Сумма;
		СуммаНДС = СуммаНДС + ВыборкаСтрокТовары.СуммаНДС;
		ВсегоСкидок    = ВсегоСкидок 	+ Скидка;
		ВсегоБезСкидок = Сумма + ВсегоСкидок;

	КонецЦикла;

	ОбластьИтого = "Итого";
	СтруктураПараметровОбластиИтого = Новый Структура();
	СтруктураПараметровОбластиИтого.Вставить("Всего", ОбщегоНазначения.ФорматСумм(Сумма));
	Если ЕстьСкидки Тогда
		ОбластьИтого  = ОбластьИтого + "Скидка";
		СтруктураПараметровОбластиИтого.Вставить("ВсегоБезСкидок", 	ОбщегоНазначения.ФорматСумм(ВсегоБезСкидок));
		СтруктураПараметровОбластиИтого.Вставить("ВсегоСкидок", 	ОбщегоНазначения.ФорматСумм(ВсегоСкидок));
	КонецЕсли; 
	
	// Вывести Итого
	ОбластьМакета = Макет.ПолучитьОбласть(ОбластьИтого);
	ОбластьМакета.Параметры.Заполнить(СтруктураПараметровОбластиИтого);
	ТабДокумент.Вывести(ОбластьМакета);

	// Вывести ИтогоНДС
	Если Шапка.УчитыватьНДС Тогда
		// НДС
		ОбластьМакета = Макет.ПолучитьОбласть("ИтогоНДС");
		ОбластьМакета.Параметры.ВсегоНДС = ОбщегоНазначения.ФорматСумм(СуммаНДС,,"''");
		ОбластьМакета.Параметры.НДС      = ?(Шапка.СуммаВключаетНДС, НСтр("ru='В том числе НДС:';uk='У тому числі ПДВ:'",КодЯзыкаПечать), НСтр("ru='Сумма НДС:';uk='Сума ПДВ:'",КодЯзыкаПечать));
		ТабДокумент.Вывести(ОбластьМакета);

		// всего с НДС (если сумма не включает НДС)
		Если НЕ Шапка.СуммаВключаетНДС Тогда
			ОбластьМакета = Макет.ПолучитьОбласть("ИтогоНДС");
			ОбластьМакета.Параметры.ВсегоНДС = ОбщегоНазначения.ФорматСумм(Сумма + СуммаНДС);
			ОбластьМакета.Параметры.НДС      = НСтр("ru='Всего с НДС:';uk='Усього з ПДВ:'",КодЯзыкаПечать);
			ТабДокумент.Вывести(ОбластьМакета);
		КонецЕсли;
	КонецЕсли;
	
	// Вывести таблицу с возвратной тарой
	ОбластьШапки  = СтрЗаменить(ОбластьШапки,"Мест","");
	ОбластьСтроки = СтрЗаменить(ОбластьСтроки,"Мест","");
	ОбластьШапки  = СтрЗаменить(ОбластьШапки,"Скидка","")+"Тара";
	ОбластьСтроки = СтрЗаменить(ОбластьСтроки,"Скидка","")+"Тара";
	
	Если ЗапросТара.Количество() > 0 Тогда
		
		// сделаем отступ от основной таблицы
		ОбластьПробел = Макет.ПолучитьОбласть("Пробел");
		ТабДокумент.Вывести(ОбластьПробел);
		
		ОбластьМакета = Макет.ПолучитьОбласть(ОбластьШапки);
		Если ВыводитьКоды Тогда
			ОбластьМакета.Параметры.Колонка = Колонка;
		КонецЕсли;

		ТабДокумент.Вывести(ОбластьМакета);

		ОбластьМакета = Макет.ПолучитьОбласть(ОбластьСтроки);
		
		СуммаТара    = 0;
		
		Для каждого ВыборкаСтрокТара Из ЗапросТара Цикл 
		
			ОбластьМакета.Параметры.Заполнить(ВыборкаСтрокТара);
			ОбластьМакета.Параметры.НомерСтроки = ЗапросТара.Индекс(ВыборкаСтрокТара) + 1;
			ОбластьМакета.Параметры.Товар       = СокрЛП(ВыборкаСтрокТара.Номенклатура);

			Если ВыводитьКоды Тогда
				ОбластьМакета.Параметры.КодАртикул = ВыборкаСтрокТара.КодАртикул;
			КонецЕсли;

			ТабДокумент.Вывести(ОбластьМакета);

			СуммаТара = СуммаТара + ВыборкаСтрокТара.Сумма;
		
		КонецЦикла; 
		
		ОбластьИтого = "ИтогоТара";
		
		// Вывести Итого
		ОбластьМакета                 = Макет.ПолучитьОбласть(ОбластьИтого);
		ОбластьМакета.Параметры.Всего = ОбщегоНазначения.ФорматСумм(СуммаТара);
		ТабДокумент.Вывести(ОбластьМакета);
		
		// сделаем отступ
		ТабДокумент.Вывести(ОбластьПробел);
	
	КонецЕсли;

	// Вывести Сумму прописью
	ОбластьМакета = Макет.ПолучитьОбласть("СуммаПрописью");
	СуммаКПрописи = Сумма + ?(Шапка.СуммаВключаетНДС, 0, СуммаНДС);
	ОбластьМакета.Параметры.ИтоговаяСтрока = НСтр("ru='Всего наименований ';uk='Всього найменувань '",КодЯзыкаПечать) + ЗапросТовары.Количество() + "," +
											 НСтр("ru=' на сумму ';uk=' на суму '",КодЯзыкаПечать)  + ОбщегоНазначения.ФорматСумм(СуммаКПрописи, Шапка.ВалютаДокумента)
											 + ?(ЗапросТара.Количество() = 0, "",  НСтр("ru='; возвратная тара ';uk='; зворотна тара '",КодЯзыкаПечать) + ЗапросТара.Количество() + НСтр("ru=', на сумму ';uk=', на суму '",КодЯзыкаПечать) + ОбщегоНазначения.ФорматСумм(СуммаТара, Шапка.ВалютаДокумента)) + ".";
											 
	ОбластьМакета.Параметры.СуммаПрописью  = ОбщегоНазначения.СформироватьСуммуПрописью(СуммаКПрописи, Шапка.ВалютаДокумента,КодЯзыкаПечать)
	 										 + ?(НЕ Шапка.УчитыватьНДС, "", Символы.ПС + НСтр("ru='В т.ч. НДС: ';uk='У т.ч. ПДВ: '",КодЯзыкаПечать) + ОбщегоНазначения.СформироватьСуммуПрописью(СуммаНДС, Шапка.ВалютаДокумента, КодЯзыкаПечать));
	ТабДокумент.Вывести(ОбластьМакета);

	// Вывести подписи
	Если Тип = "Счет" Тогда
		ОбластьМакета = Макет.ПолучитьОбласть("ПодвалСчета");
		ОбластьМакета.Параметры.Заполнить(Шапка);
	Иначе
		ОбластьМакета = Макет.ПолучитьОбласть("ПодвалЗаказа");
	КонецЕсли; 
	ОбластьМакета.Параметры.Заполнить(Шапка);
	ТабДокумент.Вывести(ОбластьМакета);

	Возврат ТабДокумент;
КонецФункции

//#КонецЕсли