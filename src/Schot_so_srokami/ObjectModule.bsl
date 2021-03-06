﻿Перем мВалютаРегламентированногоУчета Экспорт;

Перем ТаблицаВзаиморасчетов;

//#Если Клиент Тогда

Функция Печать() Экспорт
	
Тип = "Счет" ;
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТекущийДокумент", СсылкаНаОбъект);
	Запрос.Текст ="
	|ВЫБРАТЬ
	|	Номер,
	|	Дата,
	|	ДоговорКонтрагента,
	|	ДоговорКонтрагента.Дата  		КАК ДоговорДата,
	|	ДоговорКонтрагента.Номер 		КАК ДоговорНомер,
	|	ДоговорКонтрагента.НаименованиеДляПечати КАК ДоговорНаименованиеДляПечати,
	|	ДоговорКонтрагента.ВидДоговора  КАК ВидДоговораКонтрагента,
	|	Ответственный.ФизЛицо.Наименование КАК Отпустил,
	|	Организация,
	|	Контрагент КАК Покупатель,
	|	Организация КАК Поставщик,
	|	СуммаДокумента,
	|	ВалютаДокумента,
	|	УчитыватьНДС,
	|	СуммаВключаетНДС
	|ИЗ
	|	Документ.СчетНаОплатуПокупателю КАК ЗаказПокупателя
	|
	|ГДЕ
	|	ЗаказПокупателя.Ссылка = &ТекущийДокумент";

	Шапка = Запрос.Выполнить().Выбрать();
	Шапка.Следующий();

	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ЗаказПокупателя_СчетЗаказ";

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТекущийДокумент", СсылкаНаОбъект);
	
	ЧастьЗапросаДляВыбораСодержанияУслуг = ФормированиеПечатныхФорм.ПолучитьЧастьЗапросаДляВыбораСодержанияУслуг("ЗаказПокупателя");
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ВложенныйЗапрос.Номенклатура,
				   |	ВЫРАЗИТЬ(ВложенныйЗапрос.Номенклатура.НаименованиеПолное КАК Строка(1000)) КАК Товар,
				   |	ВложенныйЗапрос.Номенклатура.Артикул КАК Артикул,
				   |	ВложенныйЗапрос.Номенклатура.Код КАК Код,
				   |	ВложенныйЗапрос.Количество,
				   |	ВложенныйЗапрос.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	               |	ВложенныйЗапрос.Цена,
	               |	ВложенныйЗапрос.СуммаБезСкидки,
	               |	ВложенныйЗапрос.СуммаСкидки,
	               |	ВложенныйЗапрос.Сумма,
	               |	ВложенныйЗапрос.СуммаНДС,
	               |	ВложенныйЗапрос.НомерСтроки КАК НомерСтроки,
				   |    1 КАК ID
	               |ИЗ
	               |	(ВЫБРАТЬ
	               |		ЗаказПокупателя.Номенклатура КАК Номенклатура,
	               |		ЗаказПокупателя.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
				   |		ЗаказПокупателя.Цена КАК Цена,
	               |		СУММА(ЗаказПокупателя.Количество) 		КАК Количество,
	               |		СУММА(ЗаказПокупателя.СуммаБезСкидки) 	КАК СуммаБезСкидки,
	               |		СУММА(ЗаказПокупателя.СуммаСкидки) 		КАК СуммаСкидки,
	               |		СУММА(ЗаказПокупателя.Сумма) 			КАК Сумма,
	               |		СУММА(ЗаказПокупателя.СуммаНДС) 		КАК СуммаНДС,
	               |		МИНИМУМ(ЗаказПокупателя.НомерСтроки) 	КАК НомерСтроки
	               |	ИЗ
	               |		Документ.СчетНаОплатуПокупателю.Товары КАК ЗаказПокупателя
	               |	
	               |	ГДЕ
	               |		ЗаказПокупателя.Ссылка = &ТекущийДокумент
	               |	
	               |	СГРУППИРОВАТЬ ПО
	               |		ЗаказПокупателя.Номенклатура,
				   |		ЗаказПокупателя.ЕдиницаИзмерения,
	               |		ЗаказПокупателя.Цена,
				   |		ЗаказПокупателя.СтавкаНДС) КАК ВложенныйЗапрос
	               |
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ
	               |	" + ЧастьЗапросаДляВыбораСодержанияУслуг + ",
				   |	" + ЧастьЗапросаДляВыбораСодержанияУслуг + ",
				   |	ЗаказПокупателя.Номенклатура.Артикул КАК Артикул,
				   |	ЗаказПокупателя.Номенклатура.Код КАК Код,
				   |	ЗаказПокупателя.Количество,
	               |	ЗаказПокупателя.Номенклатура.БазоваяЕдиницаИзмерения.Наименование,
	               |	ЗаказПокупателя.Цена,
	               |	ЗаказПокупателя.СуммаБезСкидки,
	               |	ЗаказПокупателя.СуммаСкидки,
	               |	ЗаказПокупателя.Сумма,
	               |	ЗаказПокупателя.СуммаНДС,
	               |	ЗаказПокупателя.НомерСтроки,
				   |    2
	               |ИЗ
	               |	Документ.СчетНаОплатуПокупателю.Услуги КАК ЗаказПокупателя
	               |
	               |ГДЕ
	               |	ЗаказПокупателя.Ссылка = &ТекущийДокумент
	               |
	               |УПОРЯДОЧИТЬ ПО
				   |    ID,
	               |	НомерСтроки";
    
	ЗапросТовары = Запрос.Выполнить().Выгрузить();

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТекущийДокумент", СсылкаНаОбъект);
	Запрос.Текст = "ВЫБРАТЬ
	               |	ВложенныйЗапрос.Номенклатура,
	               |	ВЫРАЗИТЬ(ВложенныйЗапрос.Номенклатура.НаименованиеПолное КАК Строка(1000)) КАК Товар,
				   |	ВложенныйЗапрос.Номенклатура.Артикул КАК Артикул,
				   |	ВложенныйЗапрос.Номенклатура.Код КАК Код,
				   |	ВложенныйЗапрос.Количество,
	               |	ВложенныйЗапрос.ЕдиницаИзмерения,
	               |	ВложенныйЗапрос.Цена,
	               |	ВложенныйЗапрос.Сумма,
	               |	ВложенныйЗапрос.НомерСтроки КАК НомерСтроки
	               |ИЗ
	               |	(ВЫБРАТЬ
	               |		ЗаказПокупателя.Номенклатура КАК Номенклатура,
	               |		ЗаказПокупателя.Номенклатура.БазоваяЕдиницаИзмерения.Наименование КАК ЕдиницаИзмерения,
	               |		ЗаказПокупателя.Цена КАК Цена,
	               |		СУММА(ЗаказПокупателя.Количество) КАК Количество,
	               |		СУММА(ЗаказПокупателя.Сумма) КАК Сумма,
	               |		МИНИМУМ(ЗаказПокупателя.НомерСтроки) КАК НомерСтроки
	               |	ИЗ
	               |		Документ.СчетНаОплатуПокупателю.ВозвратнаяТара КАК ЗаказПокупателя
	               |	
	               |	ГДЕ
	               |		ЗаказПокупателя.Ссылка = &ТекущийДокумент
	               |	
	               |	СГРУППИРОВАТЬ ПО
	               |		ЗаказПокупателя.Номенклатура,
	               |		ЗаказПокупателя.Цена) КАК ВложенныйЗапрос
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	НомерСтроки";
	ЗапросТара = Запрос.Выполнить().Выгрузить();	
	
	Макет = ПолучитьМакет("СчетЗаказ");

	// печать производится на языке, указанном в настройках пользователя
	КодЯзыкаПечать = Локализация.ПолучитьЯзыкФормированияПечатныхФорм(УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "РежимФормированияПечатныхФорм"));
	Макет.КодЯзыкаМакета = КодЯзыкаПечать;
	
	// Выводим шапку накладной
	СведенияОПокупателе = УправлениеКонтактнойИнформацией.СведенияОЮрФизЛице(Шапка.Покупатель, Шапка.Дата,,,КодЯзыкаПечать);
	СведенияОПоставщике = УправлениеКонтактнойИнформацией.СведенияОЮрФизЛице(Шапка.Поставщик, Шапка.Дата,,,КодЯзыкаПечать);
	
	Если Тип = "Счет" Тогда
		ОбластьМакета       						= Макет.ПолучитьОбласть("ЗаголовокСчета");
		ОбластьМакета.Параметры.НазваниеОрганизации = СведенияОПоставщике.ПолноеНаименование;
		ОбластьМакета.Параметры.ЕДРПОУОрганизации	= УправлениеКонтактнойИнформацией.ПолучитьКодОрганизации(СведенияОПоставщике);
		Если ТипЗнч(СсылкаНаОбъект.СтруктурнаяЕдиница) = Тип("СправочникСсылка.БанковскиеСчета") Тогда
			Банк		= СсылкаНаОбъект.СтруктурнаяЕдиница.Банк;
			МФО	 		= Банк.Код;
			НомерСчета 	= СсылкаНаОбъект.СтруктурнаяЕдиница.НомерСчета;
		Иначе
			// покажем банковские реквизиты основного счета организации
			Банк		= СведенияОПоставщике.Банк;
			МФО	 		= СведенияОПоставщике.МФО;
			НомерСчета 	= СведенияОПоставщике.НомерСчета;
		КонецЕсли;
		
		ОбластьМакета.Параметры.БанкОрганизации					= Банк;
		ОбластьМакета.Параметры.МФОБанкаОрганизации	            = МФО;
		ОбластьМакета.Параметры.НомерРасчетногоСчетаОрганизации = НомерСчета;
			
		Если  НЕ Шапка.ВидДоговораКонтрагента = Перечисления.ВидыДоговоровКонтрагентов.СКомиссионером  
			И НЕ Шапка.ВалютаДокумента <> мВалютаРегламентированногоУчета Тогда
			ТабДокумент.Вывести(ОбластьМакета);
		КонецЕсли;
	КонецЕсли; 

	ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
	Если Шапка.ВидДоговораКонтрагента = Перечисления.ВидыДоговоровКонтрагентов.СКомиссионером  Тогда
		ОбластьМакета.Параметры.ТекстЗаголовка = ОбщегоНазначения.СформироватьЗаголовокДокумента(Шапка, НСтр("ru='Список товаров на комиссию';uk='Список товарів на комісію'",КодЯзыкаПечать),КодЯзыкаПечать);
	Иначе	
		ОбластьМакета.Параметры.ТекстЗаголовка = ОбщегоНазначения.СформироватьЗаголовокДокумента(Шапка, НСтр("ru='Счет на оплату';uk='Рахунок на оплату'",КодЯзыкаПечать),КодЯзыкаПечать);
	КонецЕсли; 

	ТабДокумент.Вывести(ОбластьМакета);

	ОбластьМакета = Макет.ПолучитьОбласть("Поставщик");
	ОбластьМакета.Параметры.Заполнить(Шапка);
	ОбластьМакета.Параметры.ПредставлениеПоставщика = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОПоставщике, "ПолноеНаименование,",,КодЯзыкаПечать);	
	Если Тип = "Счет" Тогда
		ОбластьМакета.Параметры.РеквизитыПоставщика =  НСтр("ru='Т/с ';uk='П/р '",КодЯзыкаПечать) + НомерСчета + НСтр("ru=', Банк ';uk=', Банк '",КодЯзыкаПечать) + Банк + НСтр("ru=', МФО ';uk=', МФО '",КодЯзыкаПечать) + МФО + Символы.ПС + 
													ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОПоставщике, "ЮридическийАдрес,Телефоны,/,КодПоЕДРПОУ,КодПоДРФО,ИНН,НомерСвидетельства,/,ИнформацияОСтатусеПлательщикаНалогов,",,КодЯзыкаПечать);
	КонецЕсли;
    ТабДокумент.Вывести(ОбластьМакета);
	
	ОбластьМакета = Макет.ПолучитьОбласть("Покупатель");
	ОбластьМакета.Параметры.Заполнить(Шапка);
 	ОбластьМакета.Параметры.ПредставлениеПокупателя = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОПокупателе, "ПолноеНаименование,",,КодЯзыкаПечать);
	ОбластьМакета.Параметры.РеквизитыПокупателя		= ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОПокупателе,"Телефоны,",,КодЯзыкаПечать);
	ТабДокумент.Вывести(ОбластьМакета);

	// Выводим дополнительно информацию о договоре и сделке
	СписокДополнительныхПараметров = "ДоговорНаименованиеДляПечати,";
	МассивСтруктурСтрок = ФормированиеПечатныхФорм.ДополнительнаяИнформация(Шапка,СписокДополнительныхПараметров,КодЯзыкаПечать);
	ОбластьМакета = Макет.ПолучитьОбласть("ДопИнформация");
    Для каждого СтруктураСтроки Из МассивСтруктурСтрок Цикл
		ОбластьМакета.Параметры.Заполнить(СтруктураСтроки);
		ТабДокумент.Вывести(ОбластьМакета);
	КонецЦикла;
	
	// Выводим дополнительные реквизиты ПериодАкта (ДатаНачала-ДатаОкончания)  	
	ОбластьМакета = Макет.ПолучитьОбласть("Период");
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
		Если Выборка.СвойстваОбъектовНаименование = "Дата Початку" Тогда 
				ОбластьМакета.Параметры.ДатаНачала = Выборка.Значение;
		ИначеЕсли Выборка.СвойстваОбъектовНаименование = "Дата Закінчення" Тогда 
			ОбластьМакета.Параметры.ДатаОкончания = Выборка.Значение;
		ИначеЕсли Выборка.СвойстваОбъектовНаименование = "Выписал" Тогда 
			Выписал = Выборка.Значение;
		КонецЕсли;
	КонецЦикла;
	ТабДокумент.Вывести(ОбластьМакета);

	
	// Вывести табличную часть
	ОбластьИтого = "Итого";
	
	ЕстьСкидки = (ЗапросТовары.Итог("СуммаСкидки") <> 0);
	
	ДопКолонка = Константы.ДополнительнаяКолонкаПечатныхФормДокументов.Получить();
	Если ДопКолонка = Перечисления.ДополнительнаяКолонкаПечатныхФормДокументов.Артикул Тогда
		ВыводитьКоды = Истина;
		Колонка = "Артикул";
	ИначеЕсли ДопКолонка = Перечисления.ДополнительнаяКолонкаПечатныхФормДокументов.Код Тогда
		ВыводитьКоды = Истина;
		Колонка = "Код";
	Иначе
		ВыводитьКоды = Ложь;
	КонецЕсли;
	
	ОбластьНомера = Макет.ПолучитьОбласть("ШапкаТаблицы|НомерСтроки");
	ОбластьКодов  = Макет.ПолучитьОбласть("ШапкаТаблицы|КолонкаКодов");
	ОбластьДанных = Макет.ПолучитьОбласть("ШапкаТаблицы|Данные");
    ОбластьСкидка = Макет.ПолучитьОбласть("ШапкаТаблицы|Скидка");
	ОбластьСуммы  = Макет.ПолучитьОбласть("ШапкаТаблицы|Сумма");
    
	ТабДокумент.Вывести(ОбластьНомера);
	Если ВыводитьКоды Тогда
		ОбластьКодов.Параметры.ИмяКолонкиКодов = Колонка;
		ТабДокумент.Присоединить(ОбластьКодов);
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
	ОбластьДанных.Параметры.Цена  = НСтр("ru='Цена';uk='Ціна'",КодЯзыкаПечать) + Суффикс;
	ТабДокумент.Присоединить(ОбластьДанных);
	Если ЕстьСкидки Тогда
		ТабДокумент.Присоединить(ОбластьСкидка);
	КонецЕсли;
	
	ОбластьСуммы.Параметры.Сумма = НСтр("ru='Сумма';uk='Сума'",КодЯзыкаПечать)+ Суффикс;
	ТабДокумент.Присоединить(ОбластьСуммы);
	//ТабДокумент.Вывести(ОбластьМакета);
	
	ОбластьКолонкаТовар = Макет.Область("Товар");
	Если Не ВыводитьКоды Тогда
		ОбластьКолонкаТовар.ШиринаКолонки = ОбластьКолонкаТовар.ШиринаКолонки + 
											Макет.Область("КолонкаКодов").ШиринаКолонки;
	КонецЕсли;
	Если НЕ ЕстьСкидки Тогда
		ОбластьКолонкаТовар.ШиринаКолонки = ОбластьКолонкаТовар.ШиринаКолонки + 
											Макет.Область("СуммаБезСкидки").ШиринаКолонки +
											Макет.Область("СуммаСкидки").ШиринаКолонки;
	КонецЕсли;
	
	СуммаБезСкидки	= 0;
	СуммаСкидки 	= 0;
	Сумма    		= 0;
	СуммаНДС 		= 0;
	
	ОбластьНомера = Макет.ПолучитьОбласть("Строка|НомерСтроки");
	ОбластьКодов  = Макет.ПолучитьОбласть("Строка|КолонкаКодов");
	ОбластьДанных = Макет.ПолучитьОбласть("Строка|Данные");
	ОбластьСкидки = Макет.ПолучитьОбласть("Строка|Скидка");
	ОбластьСуммы  = Макет.ПолучитьОбласть("Строка|Сумма");

	Для каждого ВыборкаСтрокТовары Из ЗапросТовары Цикл 

		Если НЕ ЗначениеЗаполнено(ВыборкаСтрокТовары.Номенклатура) Тогда
			Сообщить(НСтр("ru='В одной из строк не заполнено значение номенклатуры - строка при печати пропущена.';uk='В одному з рядків не заповнене значення номенклатури - рядок під час друку буде пропущений.'"), СтатусСообщения.Важное);
			Продолжить;
		КонецЕсли;


		ОбластьНомера.Параметры.НомерСтроки = ЗапросТовары.Индекс(ВыборкаСтрокТовары) + 1;
		ТабДокумент.Вывести(ОбластьНомера);
		
		Если ВыводитьКоды Тогда
			Если Колонка = "Артикул" Тогда
				ОбластьКодов.Параметры.Артикул = ВыборкаСтрокТовары.Артикул;
			Иначе
				ОбластьКодов.Параметры.Артикул = ВыборкаСтрокТовары.Код;
			КонецЕсли;
			ТабДокумент.Присоединить(ОбластьКодов);
		КонецЕсли;

		ОбластьДанных.Параметры.Заполнить(ВыборкаСтрокТовары);
		ОбластьДанных.Параметры.Товар = СокрЛП(ВыборкаСтрокТовары.Товар);
		ТабДокумент.Присоединить(ОбластьДанных);

		Если ЕстьСкидки Тогда
			ОбластьСкидки.Параметры.Заполнить(ВыборкаСтрокТовары);
			ТабДокумент.Присоединить(ОбластьСкидки);
		КонецЕсли;

		ОбластьСуммы.Параметры.Заполнить(ВыборкаСтрокТовары);
		ТабДокумент.Присоединить(ОбластьСуммы);
		
		СуммаБезСкидки = СуммаБезСкидки + ВыборкаСтрокТовары.СуммаБезСкидки;
		СуммаСкидки    = СуммаСкидки    + ВыборкаСтрокТовары.СуммаСкидки;
		Сумма          = Сумма       	+ ВыборкаСтрокТовары.Сумма;
		СуммаНДС       = СуммаНДС    	+ ВыборкаСтрокТовары.СуммаНДС;

	КонецЦикла;

	// Вывести Итого
	ОбластьНомера = Макет.ПолучитьОбласть("Итого|НомерСтроки");
	ОбластьКодов  = Макет.ПолучитьОбласть("Итого|КолонкаКодов");
	ОбластьДанных = Макет.ПолучитьОбласть("Итого|Данные");
	ОбластьСкидки = Макет.ПолучитьОбласть("Итого|Скидка");
	ОбластьСуммы  = Макет.ПолучитьОбласть("Итого|Сумма");
	
	ТабДокумент.Вывести(ОбластьНомера);
	Если ВыводитьКоды Тогда
		ТабДокумент.Присоединить(ОбластьКодов);
	КонецЕсли;
	ТабДокумент.Присоединить(ОбластьДанных);
	
	Если ЕстьСкидки Тогда
		ОбластьСкидки.Параметры.ВсегоСуммаБезСкидки = ОбщегоНазначения.ФорматСумм(СуммаБезСкидки);		
		ОбластьСкидки.Параметры.ВсегоСуммаСкидки    = ОбщегоНазначения.ФорматСумм(СуммаСкидки);
		ТабДокумент.Присоединить(ОбластьСкидки);
	КонецЕсли;
	
	ОбластьСуммы.Параметры.Всего = ОбщегоНазначения.ФорматСумм(Сумма);
	ТабДокумент.Присоединить(ОбластьСуммы);

	// Вывести ИтогоНДС
	Если Шапка.УчитыватьНДС Тогда
		// НДС
		ОбластьМакета = Макет.ПолучитьОбласть("ИтогоНДС");
		ОбластьМакета.Параметры.ВсегоНДС = ОбщегоНазначения.ФорматСумм(СуммаНДС,,"""");
		ОбластьМакета.Параметры.НДС      = ?(Шапка.СуммаВключаетНДС, НСтр("ru='В том числе НДС:';uk='У тому числі ПДВ:'",КодЯзыкаПечать), НСтр("ru='Сумма НДС:';uk='Сума ПДВ:'",КодЯзыкаПечать));
		ТабДокумент.Вывести(ОбластьМакета);
		
		// всего с НДС (если сумма не включает НДС)
		Если НЕ Шапка.СуммаВключаетНДС Тогда
			ОбластьМакета = Макет.ПолучитьОбласть("ИтогоНДС");
			ОбластьМакета.Параметры.ВсегоНДС = ОбщегоНазначения.ФорматСумм(Сумма + СуммаНДС);
			ОбластьМакета.Параметры.НДС      = НСтр("ru='Всего с НДС:';uk='Всього із ПДВ:'",КодЯзыкаПечать);
			ТабДокумент.Вывести(ОбластьМакета);
		КонецЕсли;
	КонецЕсли;

	// выведем таблицу с возвратной тарой
	Если ЗапросТара.Количество() > 0 Тогда
		// сделаем отступ от основной таблицы
		ОбластьПробел = Макет.ПолучитьОбласть("Пробел");
		ТабДокумент.Вывести(ОбластьПробел);
		
		ОбластьНомера = Макет.ПолучитьОбласть("ШапкаТаблицыТара|НомерСтрокиТара");
		ОбластьКодов  = Макет.ПолучитьОбласть("ШапкаТаблицыТара|КолонкаКодовТара");
		ОбластьДанных = Макет.ПолучитьОбласть("ШапкаТаблицыТара|ДанныеТара");
		
		ТабДокумент.Вывести(ОбластьНомера);
		Если ВыводитьКоды Тогда
			ОбластьКодов.Параметры.ИмяКолонкиКодов = Колонка;
			ТабДокумент.Присоединить(ОбластьКодов);
		КонецЕсли;
		ТабДокумент.Присоединить(ОбластьДанных);
		
		ОбластьКолонкаТара = Макет.Область("Тара");
		Если Не ВыводитьКоды Тогда
			ОбластьКолонкаТара.ШиринаКолонки = ОбластьКолонкаТара.ШиринаКолонки + 
			Макет.Область("КолонкаКодовТара").ШиринаКолонки;
		КонецЕсли;
		
        ОбластьНомера = Макет.ПолучитьОбласть("СтрокаТара|НомерСтрокиТара");
		ОбластьКодов  = Макет.ПолучитьОбласть("СтрокаТара|КолонкаКодовТара");
		ОбластьДанных = Макет.ПолучитьОбласть("СтрокаТара|ДанныеТара");
		
		СуммаТара    = 0;
		
		Для каждого ВыборкаСтрокТара Из ЗапросТара Цикл 
			
			Если НЕ ЗначениеЗаполнено(ВыборкаСтрокТара.Номенклатура) Тогда
				Сообщить(НСтр("ru='В одной из строк не заполнено значение тары - строка при печати пропущена.';uk='В одному з рядків не заповнене значення тари - рядок під час друку буде пропущений.'"), СтатусСообщения.Важное);
				Продолжить;
			КонецЕсли;
			
			ОбластьНомера.Параметры.НомерСтроки = ЗапросТара.Индекс(ВыборкаСтрокТара) + 1;
			ТабДокумент.Вывести(ОбластьНомера);
			
			Если ВыводитьКоды Тогда
				Если Колонка = "Артикул" Тогда
					ОбластьКодов.Параметры.Артикул = ВыборкаСтрокТара.Артикул;
				Иначе
					ОбластьКодов.Параметры.Артикул = ВыборкаСтрокТара.Код;
				КонецЕсли;
				ТабДокумент.Присоединить(ОбластьКодов);
			КонецЕсли;
			
			ОбластьДанных.Параметры.Заполнить(ВыборкаСтрокТара);
			ОбластьДанных.Параметры.Товар = СокрЛП(ВыборкаСтрокТара.Товар);
			ТабДокумент.Присоединить(ОбластьДанных);
		
			СуммаТара = СуммаТара + ВыборкаСтрокТара.Сумма;
			
			
		КонецЦикла;
		
		// Вывести Итого
		ОбластьМакета = Макет.ПолучитьОбласть("ИтогоТара");
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
	ОбластьМакета = Макет.ПолучитьОбласть("Подписи");
	ОбластьМакета.Параметры.Заполнить(Шапка);
	ОбластьМакета.Параметры.Выписал = Выписал;
	ТабДокумент.Вывести(ОбластьМакета);
	Возврат ТабДокумент;
КонецФункции

//#КонецЕсли
