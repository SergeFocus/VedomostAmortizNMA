﻿////////////////////////////////////////////////////////////////////
// Стартовый модуль синхронизатора

#Использовать tempfiles
#Использовать cmdline
#Использовать logos

#Использовать "core"

Перем Лог;

///////////////////////////////////////////////////////////////////
// Прикладные процедуры и функции

Функция РазобратьАргументыКоманднойСтроки()

	Если АргументыКоманднойСтроки.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Парсер = ИнициализироватьПарсерАргументов();
	
	Параметры = Парсер.Разобрать(АргументыКоманднойСтроки);

	Возврат Параметры;
	
КонецФункции

Функция ИнициализироватьПарсерАргументов()
	
	Парсер = Новый ПарсерАргументовКоманднойСтроки();
	
	ДобавитьКомандуClone(Парсер);
	ДобавитьКомандуInit(Парсер);
	ДобавитьКомандуAll(Парсер);
	ДобавитьКомандуSetVersion(Парсер);
	ДобавитьКомандуHelp(Парсер);
	ДобавитьАргументыПоУмолчанию(Парсер);
	
	Возврат Парсер;
	
КонецФункции

Процедура ДобавитьКомандуClone(Знач Парсер)
	
	Команда = Парсер.ОписаниеКоманды("clone", "Клонирует существующий репозиторий и создает служебные файлы");
	
	Парсер.ДобавитьПозиционныйПараметрКоманды(Команда, "ПутьКХранилищу", "Файловый путь к каталогу хранилища конфигурации 1С.");
	Парсер.ДобавитьПозиционныйПараметрКоманды(Команда, "URLРепозитория", "Адрес удаленного репозитория GIT.");
	Парсер.ДобавитьПозиционныйПараметрКоманды(Команда, "ЛокальныйКаталогГит", "Каталог исходников внутри локальной копии git.");
	
	Парсер.ДобавитьИменованныйПараметрКоманды(Команда, "-email", "<домен почты для пользователей git>");
	Парсер.ДобавитьИменованныйПараметрКоманды(Команда, "-debug", "<on|off>");
	Парсер.ДобавитьКоманду(Команда);
	
КонецПроцедуры

Процедура ДобавитьКомандуInit(Знач Парсер)
	
	Команда = Парсер.ОписаниеКоманды("init", "Создает новый репозиторий и создает служебные файлы");
	
	Парсер.ДобавитьПозиционныйПараметрКоманды(Команда, "ПутьКХранилищу", "Файловый путь к каталогу хранилища конфигурации 1С.");
	Парсер.ДобавитьПозиционныйПараметрКоманды(Команда, "ЛокальныйКаталогГит", "Адрес удаленного репозитория GIT.");
	
	Парсер.ДобавитьИменованныйПараметрКоманды(Команда, "-email", "<домен почты для пользователей git>");
	Парсер.ДобавитьИменованныйПараметрКоманды(Команда, "-debug", "<on|off>");
	Парсер.ДобавитьКоманду(Команда);
	
КонецПроцедуры

Процедура ДобавитьКомандуSetVersion(Знач Парсер)
	
	Команда = Парсер.ОписаниеКоманды("set-version", "Устанавлиает необходимую версию в файл VERSION");
	
	Парсер.ДобавитьПозиционныйПараметрКоманды(Команда, "ЛокальныйКаталогГит", "Адрес локального репозитория GIT.");
    Парсер.ДобавитьПозиционныйПараметрКоманды(Команда, "НомерВерсии", "Номер версии для записи в файл");
	
	Парсер.ДобавитьИменованныйПараметрКоманды(Команда, "-debug", "<on|off>");
	Парсер.ДобавитьКоманду(Команда);
	
КонецПроцедуры

Процедура ДобавитьКомандуAll(Знач Парсер)
	
	Команда = Парсер.ОписаниеКоманды("all", "Запускает синхронизацию по нескольким репозиториям");
	
	Парсер.ДобавитьПозиционныйПараметрКоманды(Команда, "ПутьКНастройкам", "Путь к файлу настроек синхронизатора");
	
	Парсер.ДобавитьИменованныйПараметрКоманды(Команда, "-log", "Путь к файлу лога");
	Парсер.ДобавитьИменованныйПараметрКоманды(Команда, "-timer", "Интервал срабатывания");
	
	Парсер.ДобавитьИменованныйПараметрКоманды(Команда, "-force", "<on|off> принудительная синхронизация");
	Парсер.ДобавитьИменованныйПараметрКоманды(Команда, "-debug", "<on|off>");
	Парсер.ДобавитьКоманду(Команда);
	
КонецПроцедуры

Процедура ДобавитьКомандуHelp(Знач Парсер)
	
	Команда = Парсер.ОписаниеКоманды("help", "Вывести справку по параметрам команды");
	
	Парсер.ДобавитьПозиционныйПараметрКоманды(Команда, "КомандаДляСправки");
	Парсер.ДобавитьКоманду(Команда);
	
КонецПроцедуры

Процедура ДобавитьАргументыПоУмолчанию(Знач Парсер)
	
	Парсер.ДобавитьПараметр("ПутьКХранилищу", "Файловый путь к каталогу хранилища конфигурации 1С.");
	Парсер.ДобавитьПараметр("URLРепозитория", "Адрес удаленного репозитория GIT.");
	Парсер.ДобавитьПараметр("ЛокальныйКаталогГит", "Каталог исходников внутри локальной копии git.");
	
	Парсер.ДобавитьИменованныйПараметр("-email", "<домен почты для пользователей git>");
	Парсер.ДобавитьИменованныйПараметр("-v8version", "Маска версии платформы (8.3, 8.3.5, 8.3.6.2299 и т.п.)");
	Парсер.ДобавитьИменованныйПараметр("-debug", "<on|off>");
	Парсер.ДобавитьИменованныйПараметр("-branch", "<имя ветки git>");
    	Парсер.ДобавитьИменованныйПараметр("-format", "<hierarchical|plain>");
	
КонецПроцедуры

Процедура ВыполнитьОбработку(Знач Параметры)

	Если ТипЗнч(Параметры) = Тип("Структура") Тогда
		УстановитьРежимОтладкиПриНеобходимости(Параметры.ЗначенияПараметров);
		ВыполнитьКоманду(Параметры);
	Иначе
	
		УстановитьРежимОтладкиПриНеобходимости(Параметры);
		Синхронизировать(
			Параметры["ПутьКХранилищу"], 
			Параметры["URLРепозитория"],
			Параметры["ЛокальныйКаталогГит"], 
			Параметры["-email"],
			Параметры["-v8version"],
			,
			,
			Параметры["-format"],
			Параметры["-branch"]);
			
	КонецЕсли;

КонецПроцедуры

Процедура ВыполнитьКоманду(Знач ОписаниеКоманды)

	Если ОписаниеКоманды.ЗначенияПараметров["-debug"] = "on" Тогда
		Лог.УстановитьУровень(УровниЛога.Отладка);
	КонецЕсли;

	Если ОписаниеКоманды.Команда = "init" Тогда
		ПодготовитьНовыйРепозитарий(ОписаниеКоманды.ЗначенияПараметров, Истина);
	ИначеЕсли ОписаниеКоманды.Команда = "clone" Тогда
		КлонироватьРепозитарий(ОписаниеКоманды.ЗначенияПараметров);
	ИначеЕсли ОписаниеКоманды.Команда = "all" Тогда
		СинхронизироватьПоСпискуРепозитариев(ОписаниеКоманды.ЗначенияПараметров);
	ИначеЕсли ОписаниеКоманды.Команда = "help" Тогда
		ВывестиСправкуПоКомандам(ОписаниеКоманды.ЗначенияПараметров["КомандаДляСправки"]);
	ИначеЕсли ОписаниеКоманды.Команда = "set-version" Тогда
		УстановитьНовуюВерсию(ОписаниеКоманды.ЗначенияПараметров);
	Иначе
		ВызватьИсключение "Неизвестная команда: " + ОписаниеКоманды.Команда;
	КонецЕсли;

КонецПроцедуры

Процедура ПодготовитьНовыйРепозитарий(Знач Параметры, Знач РежимИнициализации)
	
	Распаковщик = ПолучитьИНастроитьРаспаковщик(Параметры);
	КаталогРабочейКопии = ПодготовитьКаталогНовойРабочейКопии(Параметры);
	
	// инициализировать с нуля
	СоздатьКаталог(КаталогРабочейКопии);
	Результат = Распаковщик.ИнициализироватьРепозитарий(КаталогРабочейКопии);
	Если Результат <> 0 Тогда
		ВызватьИсключение "git init вернул код <"+Результат+">";
	КонецЕсли;
	
	НаполнитьКаталогРабочейКопииСлужебнымиДанными(КаталогРабочейКопии, Распаковщик, Параметры["ПутьКХранилищу"]);
	
КонецПроцедуры

Процедура УстановитьНовуюВерсию(Знач Параметры)
	
	Распаковщик = ПолучитьИНастроитьРаспаковщик(Параметры);
	ФайлВерсий = Новый Файл(ОбъединитьПути(Параметры["ЛокальныйКаталогГит"], "VERSION"));
	Распаковщик.ЗаписатьФайлВерсийГит(ФайлВерсий.Путь, Параметры["НомерВерсии"]);
	
КонецПроцедуры


Процедура КлонироватьРепозитарий(Знач Параметры)

	Распаковщик = ПолучитьИНастроитьРаспаковщик(Параметры);
	КаталогРабочейКопии = ПодготовитьКаталогНовойРабочейКопии(Параметры);
	
	URL = Параметры["URLРепозитория"];
	Если ПустаяСтрока(URL) Тогда
		ВызватьИсключение "Не указан URL репозитария";
	КонецЕсли;
	
	СоздатьКаталог(КаталогРабочейКопии);
	Результат = Распаковщик.КлонироватьРепозитарий(КаталогРабочейКопии, URL);
	Если Результат <> 0 Тогда
		ВызватьИсключение "git clone вернул код <"+Результат+">";
	КонецЕсли;
	
	НаполнитьКаталогРабочейКопииСлужебнымиДанными(КаталогРабочейКопии, Распаковщик, Параметры["ПутьКХранилищу"]);
	
КонецПроцедуры

Функция ПолучитьИНастроитьРаспаковщик(Знач Параметры)
	Распаковщик = ПолучитьРаспаковщик();
	Распаковщик.ДоменПочтыДляGitПоУмолчанию = Параметры["-email"];
	УстановитьРежимОтладкиПриНеобходимости(Параметры);
	Возврат Распаковщик;
КонецФункции

Функция ПодготовитьКаталогНовойРабочейКопии(Знач Параметры)
	
	КаталогРабочейКопии = Параметры["ЛокальныйКаталогГит"];
	Если КаталогРабочейКопии = Неопределено Тогда
		КаталогРабочейКопии = ТекущийКаталог();
	Иначе
		ФайлРК = Новый Файл(КаталогРабочейКопии);
		КаталогРабочейКопии = ФайлРК.ПолноеИмя;
	КонецЕсли;
	
	Возврат КаталогРабочейКопии;
	
КонецФункции

Процедура НаполнитьКаталогРабочейКопииСлужебнымиДанными(Знач КаталогРабочейКопии, Знач Распаковщик, Знач ПутьКХранилищу)
	
	КаталогИсходников = Новый Файл(КаталогРабочейКопии);
	Если Не КаталогИсходников.Существует() Тогда
		СоздатьКаталог(КаталогИсходников.ПолноеИмя);
	ИначеЕсли Не КаталогИсходников.ЭтоКаталог() Тогда
		ВызватьИсключение "Невозможно создать каталог " + КаталогИсходников.ПолноеИмя;
	КонецЕсли;
	
	СгенерироватьФайлAUTHORS(ПолучитьПутьКБазеДанныхХранилища(ПутьКХранилищу), КаталогИсходников.ПолноеИмя, Распаковщик);
	СгенерироватьФайлVERSION(КаталогИсходников.ПолноеИмя, Распаковщик);
	
КонецПроцедуры

Процедура Синхронизировать(Знач ПутьКХранилищу, 
			Знач URLРепозитория,
			Знач ЛокальныйКаталогГит = Неопределено,
			Знач ДоменПочты = Неопределено,
			Знач ВерсияПлатформы = Неопределено,
			Знач НачальнаяВерсия = 0,
			Знач КонечнаяВерсия = 0,
			Знач Формат = Неопределено,
			Знач ИмяВетки = Неопределено) Экспорт
	
	Лог.Информация("Начинаю синхронизацию хранилища 1С и репозитария GIT");
	
	Если ЛокальныйКаталогГит = Неопределено Тогда
		ЛокальныйКаталогГит = ТекущийКаталог();
	КонецЕсли;
	
	Если Формат = Неопределено Тогда 
		Формат = РежимВыгрузкиФайлов.Авто;
	КонецЕсли;
	
	Если ИмяВетки = Неопределено Тогда 
		ИмяВетки = "master";
	КонецЕсли;
	
	Лог.Отладка("ПутьКХранилищу = " + ПутьКХранилищу);
	Лог.Отладка("URLРепозитория = " + URLРепозитория);
	Лог.Отладка("ЛокальныйКаталогГит = " + ЛокальныйКаталогГит);
	Лог.Отладка("ДоменПочты = " + ДоменПочты);
	Лог.Отладка("ВерсияПлатформы = " + ВерсияПлатформы);
	Лог.Отладка("Формат = " + Формат);
	Лог.Отладка("ИмяВетки = " + ИмяВетки);
	
	ФайлБазыДанныхХранилища = ПолучитьПутьКБазеДанныхХранилища(ПутьКХранилищу);
	
	Распаковщик = ПолучитьРаспаковщик();
	Распаковщик.ВерсияПлатформы = ВерсияПлатформы;
	Распаковщик.ДоменПочтыДляGitПоУмолчанию = ДоменПочты;
	
	Лог.Информация("Получение изменений с удаленного узла (pull)");
	КодВозврата = Распаковщик.ВыполнитьGitPull(ЛокальныйКаталогГит, URLРепозитория, ИмяВетки);
	Если КодВозврата <> 0 Тогда
		ВызватьИсключение "Не удалось получить изменения с удаленного узла (код: " + КодВозврата + ")";
	КонецЕсли;
	
	Лог.Информация("Синхронизация изменений с хранилищем");
	Распаковщик.СинхронизироватьХранилищеКонфигурацийСГит(ЛокальныйКаталогГит, ФайлБазыДанныхХранилища, НачальнаяВерсия, КонечнаяВерсия, Формат);
	
	Лог.Информация("Отправка изменений на удаленный узел");
	КодВозврата = Распаковщик.ВыполнитьGitPush(ЛокальныйКаталогГит, URLРепозитория, ИмяВетки);
	Если КодВозврата <> 0 Тогда
		ВызватьИсключение "Не удалось отправить изменения на удаленный узел (код: " + КодВозврата + ")";
	КонецЕсли;
	
	Лог.Информация("Синхронизация завершена");
	
КонецПроцедуры

Функция ТребуетсяСинхронизироватьХранилище(Знач ФайлХранилища, Знач ЛокальныйКаталогГит) Экспорт
	
	Распаковщик = ПолучитьРаспаковщик();
	Возврат Распаковщик.ТребуетсяСинхронизироватьХранилищеСГит(ФайлХранилища, ЛокальныйКаталогГит);
	
КонецФункции

Процедура УстановитьРежимОтладкиПриНеобходимости(Знач Параметры)
	Если Параметры["-debug"] = "on" Тогда
		Лог.УстановитьУровень(УровниЛога.Отладка);
	КонецЕсли;
КонецПроцедуры

Функция ПолучитьРаспаковщик()
	Возврат Новый МенеджерСинхронизации();
КонецФункции

Функция ПолучитьПутьКБазеДанныхХранилища(Знач ПутьКХранилищу)
	ФайлПутиКХранилищу = Новый Файл(ПутьКХранилищу);
	Если ФайлПутиКХранилищу.Существует() и ФайлПутиКХранилищу.ЭтоКаталог() Тогда
		ФайлБазыДанныхХранилища = ОбъединитьПути(ФайлПутиКХранилищу.ПолноеИмя, "1cv8ddb.1CD");
	ИначеЕсли ФайлПутиКХранилищу.Существует() Тогда
		ФайлБазыДанныхХранилища = ФайлПутиКХранилищу.ПолноеИмя;
	Иначе
		ВызватьИсключение "Некорректный путь к хранилищу: " + ФайлПутиКХранилищу.ПолноеИмя;
	КонецЕсли;
	
	Возврат ФайлБазыДанныхХранилища;
КонецФункции

Процедура СгенерироватьФайлAUTHORS(Знач ФайлХранилища, Знач КаталогИсходников, Знач Распаковщик)
	
	ОбъектФайлХранилища = Новый Файл(ПолучитьПутьКБазеДанныхХранилища(ФайлХранилища));
	Если Не ОбъектФайлХранилища.Существует() Тогда
		ВызватьИсключение "Файл хранилища <" + ОбъектФайлХранилища.ПолноеИмя + "> не существует.";
	КонецЕсли;
	
	ФайлАвторов = Новый Файл(ОбъединитьПути(КаталогИсходников, "AUTHORS"));
	Если ФайлАвторов.Существует() Тогда
		Лог.Отладка("Файл " + ФайлАвторов.ПолноеИмя + " уже существует. Пропускаем генерацию файла AUTHORS");
		Возврат;
	КонецЕсли;
	
	Попытка
		
		Лог.Отладка("Формирую файл AUTHORS в каталоге " + КаталогИсходников);
		Распаковщик.СформироватьПервичныйФайлПользователейДляGit(ОбъектФайлХранилища.ПолноеИмя, ФайлАвторов.ПолноеИмя);
		Лог.Отладка("Файл сгенерирован");
		
	Исключение
		Лог.Ошибка("Не удалось сформировать файл авторов");
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

Процедура СгенерироватьФайлVERSION(Знач КаталогИсходников, Знач Распаковщик)
	
	ФайлВерсий = Новый Файл(ОбъединитьПути(КаталогИсходников, "VERSION"));
	Если ФайлВерсий.Существует() Тогда
		Лог.Информация("Файл " + ФайлВерсий.ПолноеИмя + " уже существует. Пропускаем генерацию файла VERSION");
		Возврат;
	КонецЕсли;
	
	Распаковщик.ЗаписатьФайлВерсийГит(ФайлВерсий.Путь);
	
КонецПроцедуры

Процедура СинхронизироватьПоСпискуРепозитариев(Знач Параметры)
	
	ИмяФайлаНастроек = Параметры["ПутьКНастройкам"];
	Если ИмяФайлаНастроек = Неопределено Тогда
		ВывестиСправкуПоКомандам("all");
		ЗавершитьРаботу(1);
	КонецЕсли;
	
	Если Параметры["-log"] <> Неопределено Тогда
		Аппендер = Новый ВыводЛогаВФайл();
		Аппендер.ОткрытьФайл(Параметры["-log"]);
		Лог.ДобавитьСпособВывода(Аппендер);
		Раскладка = ЗагрузитьСценарий(ОбъединитьПути(ТекущийСценарий().Каталог, "log-layout.os"));
		Лог.УстановитьРаскладку(Раскладка);
	КонецЕсли;
	
	Интервал = 0;
	Если Параметры["-timer"] <> Неопределено Тогда
		Интервал = Число(Параметры["-timer"]);
	КонецЕсли;
	
	Контроллер = ЗагрузитьСценарий(ОбъединитьПути(ТекущийСценарий().Каталог, "multi-controller.os"));
	
	Пока Истина Цикл
		Контроллер.ВыполнитьСинхронизациюПоФайлуНастроек(ЭтотОбъект, ИмяФайлаНастроек, Параметры["-force"] = Истина);
		
		Если Интервал <= 0 Тогда
			Прервать;
		Иначе
			Лог.Информация("Ожидаем " + Интервал + " секунд перед новым циклом");
			Приостановить(Интервал * 1000);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПоказатьИнформациюОПараметрахКоманднойСтроки() 
	
	Парсер = ИнициализироватьПарсерАргументов();
	
	ВозможныеКоманды = Парсер.СправкаВозможныеКоманды();
	
	Сообщить("Синхронизация хранилища конфигураций 1С с репозитарием GIT.");
	Сообщить("Использование: ");
	Сообщить("	gitsync <storage-path> <git-url> [local-dir] [ключи]");
	Сообщить("	gitsync <команда> <параметры команды> [ключи]");
	ВывестиПараметры(Парсер.СправкаПоПараметрам());
	
	Сообщить(Символы.ПС + "Возможные команды:");
	
	МаксШирина = 0;
	Поле = "               ";
	Для Каждого Команда Из ВозможныеКоманды Цикл
		ТекШирина = СтрДлина(Команда.Команда);
		Если ТекШирина > МаксШирина Тогда
			МаксШирина = ТекШирина;
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого Команда Из ВозможныеКоманды Цикл
		Сообщить(" " + Лев(Команда.Команда + Поле, МаксШирина + 2) + "- " + Команда.Пояснение);
	КонецЦикла;
			
	Сообщить("Для подсказки по конкретной команде наберите gitsync help <команда>");
	
КонецПроцедуры

Процедура ВывестиСправкуПоКомандам(Знач Команда) Экспорт
	
	Парсер = ИнициализироватьПарсерАргументов();
	
	ВозможныеКоманды = Парсер.СправкаВозможныеКоманды();
	ОписаниеКоманды = ВозможныеКоманды.Найти(Команда, "Команда");
	Если ОписаниеКоманды = Неопределено Тогда
		Сообщить("Команда отсуствует: " + Команда);
		Возврат;
	КонецЕсли;
	
	Сообщить("" + ОписаниеКоманды.Команда + " - " + ОписаниеКоманды.Пояснение);
	ВывестиПараметры(ОписаниеКоманды.Параметры);
	
КонецПроцедуры

Процедура ВывестиПараметры(Знач ОписаниеПараметров)
	
	Сообщить("Параметры:");
	Для Каждого СтрПараметр Из ОписаниеПараметров Цикл
		Если Не СтрПараметр.ЭтоИменованныйПараметр Тогда
			Сообщить(СтрШаблон(" <%1> - %2", СтрПараметр.Имя, СтрПараметр.Пояснение));
		Иначе
			Сообщить(СтрШаблон(" %1 - %2", СтрПараметр.Имя, СтрПараметр.Пояснение));
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////
// Точка входа в приложение

Лог = Логирование.ПолучитьЛог("oscript.app.gitsync");

Попытка
	Параметры = РазобратьАргументыКоманднойСтроки();
	Если Параметры <> Неопределено Тогда
		ВыполнитьОбработку(Параметры);
	Иначе
		ПоказатьИнформациюОПараметрахКоманднойСтроки();
		Лог.Ошибка("Указаны некорректные аргументы командной строки");
		ВременныеФайлы.Удалить();
		ЗавершитьРаботу(1);
	КонецЕсли;
	ВременныеФайлы.Удалить();
	Лог.Закрыть();
Исключение
	Лог.Ошибка(ОписаниеОшибки());
	ВременныеФайлы.Удалить();
	Лог.Закрыть();
	ЗавершитьРаботу(1);
КонецПопытки;