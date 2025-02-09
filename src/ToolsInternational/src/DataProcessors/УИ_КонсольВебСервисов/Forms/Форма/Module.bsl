Перем WSОпределение;



&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	UT_Common.ToolFormOnCreateAtServer(ЭтотОбъект, Отказ, СтандартнаяОбработка);
КонецПроцедуры


&НаСервере
Процедура ПодключитьсяКСерверу(МестоположениеWSDL, ИмяПользователя, Пароль)
	// Подключимся к серверу зная WSDL
	ssl = Новый ЗащищенноеСоединениеOpenSSL;
	WSОпределение = Новый WSОпределения(МестоположениеWSDL, ИмяПользователя, Пароль, , , ssl);
	//обновим список веб сервисов
	СписокСервисов.Очистить();
	СписокТочекПодключения.Очистить();
	СписокОпераций.Очистить();
	СписокПараметров.Очистить();
	// Читаем веб сервисы
	Для Каждого Сервис Из WSОпределение.Сервисы Цикл
		НовыйСервис = СписокСервисов.Добавить();
		НовыйСервис.МестоположениеWSDL = МестоположениеWSDL;
		НовыйСервис.WSСервис = Сервис.Имя;
		НовыйСервис.URIПространстваИмен = Сервис.URIПространстваИмен;
		// Читаем точки подклбючения что бы создать прокси
		Для Каждого ТочкаПодключения Из Сервис.ТочкиПодключения Цикл
			УникальныйИдентификаторТочкиПодключения = Новый УникальныйИдентификатор;
			НоваяТочкаПодключения = СписокТочекПодключения.Добавить();
			НоваяТочкаПодключения.WSСервис = Сервис.Имя;
			НоваяТочкаПодключения.ИмяТочкиПодключения = ТочкаПодключения.Имя;
			НоваяТочкаПодключения.УникальныйИдентификаторТочкиПодключения = УникальныйИдентификаторТочкиПодключения;
			// Читаем операции веб сервисов
			Для Каждого Операция Из ТочкаПодключения.Интерфейс.Операции Цикл
				НоваяОперация = СписокОпераций.Добавить();
				НоваяОперация.ИмяТочкиПодключения = ТочкаПодключения.Имя;
				НоваяОперация.ИмяОперации = Операция.Имя;
				НоваяОперация.ТипВозвращаемогоЗначения = Операция.ВозвращаемоеЗначение.Тип;
				НоваяОперация.УникальныйИдентификаторТочкиПодключения = УникальныйИдентификаторТочкиПодключения;
				// Читаем параметры операций
				Для Каждого Параметр Из Операция.Параметры Цикл
					НовыйПараметр = СписокПараметров.Добавить();
					НовыйПараметр.ИмяОперации = Операция.Имя;
					НовыйПараметр.ИмяТочкиПодключения = ТочкаПодключения.Имя;
					НовыйПараметр.ИмяПараметра = Параметр.Имя;
					НовыйПараметр.ТипПараметра = Параметр.Тип;
				КонецЦикла;
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьWSDL(Команда)
	Если ЗначениеЗаполнено(МестоположениеWSDL) Тогда
		ПодключитьсяКСерверу(МестоположениеWSDL, ИмяПользователя, Пароль);
		ЭтаФорма.Элементы.СписокСервисов.ВыделенныеСтроки.Добавить(0);
		ЭтаФорма.Элементы.СписокСервисов.Обновить();
		ЭтаФорма.Элементы.СписокТочекПодключения.ВыделенныеСтроки.Добавить(0);
		ЭтаФорма.Элементы.СписокТочекПодключения.Обновить();
		ЭтаФорма.Элементы.СписокОпераций.ВыделенныеСтроки.Добавить(0);
		ЭтаФорма.Элементы.СписокОпераций.Обновить();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СписокСервисовПриАктивизацииСтроки(Элемент)
	Если Элементы.СписокСервисов.ТекущиеДанные <> Неопределено Тогда
		ИмяВебСервиса =  Элементы.СписокСервисов.ТекущиеДанные.WSСервис;
		URIПространстваИменВебСервиса = Элементы.СписокСервисов.ТекущиеДанные.URIПространстваИмен;
	Иначе
		ИмяВебСервиса =  "";
		URIПространстваИменВебСервиса = "";
	КонецЕсли;
	Отбор = Новый ФиксированнаяСтруктура("WSСервис", ИмяВебСервиса);
	Элементы.СписокТочекПодключения.ОтборСтрок	= Отбор;
КонецПроцедуры

&НаКлиенте
Процедура СписокТочекПодключенияПриАктивизацииСтроки(Элемент)
	Если Элементы.СписокТочекПодключения.ТекущиеДанные <> Неопределено Тогда
		ИмяТочкиПодключения = Элементы.СписокТочекПодключения.ТекущиеДанные.ИмяТочкиПодключения;
		УникальныйИдентификаторТочкиПодключения = Элементы.СписокТочекПодключения.ТекущиеДанные.УникальныйИдентификаторТочкиПодключения;
	Иначе
		ИмяТочкиПодключения = "";
		УникальныйИдентификаторТочкиПодключения = "";
	КонецЕсли;
	Отбор = Новый ФиксированнаяСтруктура("УникальныйИдентификаторТочкиПодключения",
		УникальныйИдентификаторТочкиПодключения);
	Элементы.СписокОпераций.ОтборСтрок	= Отбор;
КонецПроцедуры

&НаКлиенте
Процедура СписокОперацийПриАктивизацииСтроки(Элемент)
	Если ИмяТочкиПодключения <> "" И Элементы.СписокОпераций.ТекущиеДанные <> Неопределено Тогда
		ИмяОперации =  Элементы.СписокОпераций.ТекущиеДанные.ИмяОперации;
		ОбновитьПараметрыОперации(ИмяТочкиПодключения, ИмяОперации);
	Иначе
		ИмяОперации = "";
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ОбновитьПараметрыОперации(ИмяТочкиПодключения, ИмяОперации)
	Если ИмяТочкиПодключения = ИмяТочкиПодключенияТекущее И ИмяОперации = ИмяОперацииТекущее Тогда
		Возврат;
	КонецЕсли;
	Отбор = Новый Структура("ИмяТочкиПодключения,ИмяОперации", ИмяТочкиПодключения, ИмяОперации);
	МассивПараметровОперации = СписокПараметров.НайтиСтроки(Отбор);
	// Очистим таблицу параметров операции
	ПараметрыОперации.Очистить();
	
	// Создадим WSОпределния для того что бы получить фабрикуXDTO веб сервиса, что бы можно было попытаться привести типы веб сервиса. к простим типам
	ssl = Новый ЗащищенноеСоединениеOpenSSL;
	WSОпределение = Новый WSОпределения(МестоположениеWSDL, ИмяПользователя, Пароль, , , ssl);
	Сериализатор = Новый СериализаторXDTO(WSОпределение.ФабрикаXDTO);

	Для Каждого Параметр Из МассивПараметровОперации Цикл
		НовыйПараметр = ПараметрыОперации.Добавить();
		НовыйПараметр.ИмяПараметра = Параметр.ИмяПараметра;
		НовыйПараметр.ТипПараметра = Параметр.ТипПараметра;
		ПоложениеВторойСкобки = Найти(Параметр.ТипПараметра, "}");
	КонецЦикла;
	ИмяОперацииТекущее = ИмяОперации;
	ИмяТочкиПодключенияТекущее = ИмяТочкиПодключения;
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОперацию(Команда)
	Если ЗначениеЗаполнено(МестоположениеWSDL) И ЗначениеЗаполнено(ИмяВебСервиса) И ЗначениеЗаполнено(
		URIПространстваИменВебСервиса) И ЗначениеЗаполнено(ИмяТочкиПодключения) И ЗначениеЗаполнено(ИмяОперации) Тогда
		РезультатОперации = ВыполнитьОперациюСервер(МестоположениеWSDL, ИмяПользователя, Пароль, ИмяВебСервиса,
			URIПространстваИменВебСервиса, ИмяТочкиПодключения, ИмяОперации, ПараметрыОперации);
		Если Не ЭтаФорма.Элементы.ДеревоРезультат.ДанныеСтроки(1) = Неопределено Тогда
			ЭтаФорма.Элементы.ДеревоРезультат.Развернуть(1, Истина);
		КонецЕсли;
	Иначе
		Сообщить("Не все параметры выбраны!");
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ВыполнитьОперациюСервер(МестоположениеWSDL, ИмяПользователя, Пароль, ИмяВебСервиса,
	URIПространстваИменВебСервиса, ИмяТочкиПодключения, ИмяОперации, Знач ПараметрыОперации)
	Результат = Неопределено;
	ssl = Новый ЗащищенноеСоединениеOpenSSL;
	WSОпределение = Новый WSОпределения(МестоположениеWSDL, ИмяПользователя, Пароль, , , ssl);
	WSПрокси = Новый WSПрокси(WSОпределение, URIПространстваИменВебСервиса, ИмяВебСервиса, ИмяТочкиПодключения, , , ssl);
	WSПрокси.Пользователь = ИмяПользователя;
	WSПрокси.Пароль = Пароль;
	КодВызоваОперации = "Результат = WSПрокси." + ИмяОперации + "(";
	ДобавитьЗапятую = Ложь;
	НомерПараметра = 0;
	Для Каждого Параметр Из ПараметрыОперации Цикл
		Если ДобавитьЗапятую Тогда
			КодВызоваОперации = КодВызоваОперации + ", ";
		КонецЕсли;
		// Обработаем случай когда установлена галочка Неопределено. В этом случае 1С отсылает null
		Если Параметр.Неопределено Тогда
			КодВызоваОперации = КодВызоваОперации + "Неопределено";
		ИначеЕсли Параметр.ТипПараметра = "{http://v8.1c.ru/8.1/data/core}Structure" Тогда
			Если ТипЗнч(Параметр.Структура) = Тип("Структура") Тогда
				КодВызоваОперации = КодВызоваОперации + "СериализаторXDTO.ЗаписатьXDTO(ПараметрыОперации[" + Строка(
					НомерПараметра) + "].Структура)";
			Иначе
				КодВызоваОперации = КодВызоваОперации + "СериализаторXDTO.ЗаписатьXDTO(Новый Структура)";
			КонецЕсли;
		ИначеЕсли ТипЗнч(Параметр.Значение) = Тип("Строка") Тогда
			КодВызоваОперации = КодВызоваОперации + """" + Параметр.Значение + """";
		ИначеЕсли ТипЗнч(Параметр.Значение) = Тип("Число") Тогда
			КодВызоваОперации = КодВызоваОперации + Параметр.Значение;
		ИначеЕсли ТипЗнч(Параметр.Значение) = Тип("Булево") Тогда
			Если Параметр.Значение = Истина Тогда
				КодВызоваОперации = КодВызоваОперации + "Истина";
			Иначе
				КодВызоваОперации = КодВызоваОперации + "Ложь";
			КонецЕсли;
		ИначеЕсли ТипЗнч(Параметр.Значение) = Тип("Дата") Тогда
			Если ЗначениеЗаполнено(Параметр.Значение) Тогда
				КодВызоваОперации = КодВызоваОперации + "'" + Формат(Параметр.Значение, "ДФ=""ггггММддЧЧммсс""") + "'";
			Иначе
				КодВызоваОперации = КодВызоваОперации + "'00010101000000'";
			КонецЕсли;
		Иначе
			КодВызоваОперации = КодВызоваОперации + """" + Параметр.Значение + """";
		КонецЕсли;
		ДобавитьЗапятую = Истина;
		НомерПараметра = НомерПараметра + 1;
	КонецЦикла;
	КодВызоваОперации = КодВызоваОперации + ");";
	Выполнить (КодВызоваОперации);

	Если ТипЗнч(Результат) = Тип("ОбъектXDTO") Или ТипЗнч(Результат) = Тип("ЗначениеXDTO") Тогда
		ЗаписьXML = Новый ЗаписьXML;
		ЗаписьXML.УстановитьСтроку();
		WSОпределение.ФабрикаXDTO.ЗаписатьXML(ЗаписьXML, Результат);
		ДеревоЗначений = РеквизитФормыВЗначение("ДеревоРезультат");
		ДеревоЗначений.Строки.Очистить();
		ПреобразоватьXDTOВДерево(Результат, ДеревоЗначений);
		ЗначениеВРеквизитФормы(ДеревоЗначений, "ДеревоРезультат");
		СтрXML = ЗаписьXML.Закрыть();
		WSОпределение = Неопределено;
		WSПрокси = Неопределено;
		Возврат СтрXML;

	ИначеЕсли ТипЗнч(Результат) = Тип("Строка") Или ТипЗнч(Результат) = Тип("Число") Или ТипЗнч(Результат) = Тип(
		"Булево") Или ТипЗнч(Результат) = Тип("Дата") Тогда

		ДеревоЗначений = РеквизитФормыВЗначение("ДеревоРезультат");
		ДеревоЗначений.Строки.Очистить();
		НоваяСтрока = ДеревоЗначений.Строки.Добавить();
		НоваяСтрока.Свойство 	= "Результат операции";
		НоваяСтрока.Значение 	= Результат;
		НоваяСтрока.Тип 		= ТипЗнч(Результат);
		ЗначениеВРеквизитФормы(ДеревоЗначений, "ДеревоРезультат");

		Возврат Результат;
	Иначе
		Возврат "Неопределенный тип результата операции"
	КонецЕсли
	;

КонецФункции

&НаСервере
Функция ПреобразоватьXDTOВДерево(ОбъектXDTO, ДеревоЗначений, ИмяСвойства = "")

	Если 1 = 0 Тогда
		ОбъектXDTO = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип("http://v8.1c.ru/8.1/xdto", "Model"));
	КонецЕсли;

	Если ТипЗнч(ОбъектXDTO) = Тип("ОбъектXDTO") Тогда
		НоваяСтрока = ДеревоЗначений.Строки.Добавить();
		НоваяСтрока.Свойство 	= ?(ЗначениеЗаполнено(ИмяСвойства), ИмяСвойства, ОбъектXDTO.Тип().Имя);
		НоваяСтрока.Тип 		= ОбъектXDTO.Тип();
		Для Каждого СвойствоXDTO Из ОбъектXDTO.Свойства() Цикл
			ЗначениеСвойства = ОбъектXDTO[СвойствоXDTO.Имя];
			Если ТипЗнч(ЗначениеСвойства) = Тип("Строка") Или ТипЗнч(ЗначениеСвойства) = Тип("Число") Или ТипЗнч(
				ЗначениеСвойства) = Тип("Булево") Или ТипЗнч(ЗначениеСвойства) = Тип("Дата") Тогда
				НоваяСтрока2 = НоваяСтрока.Строки.Добавить();
				НоваяСтрока2.Свойство 	= СвойствоXDTO.Имя;
				НоваяСтрока2.Значение 	= ЗначениеСвойства;
				НоваяСтрока2.Тип 		= СвойствоXDTO.Тип;
			Иначе
				ПреобразоватьXDTOВДерево(ЗначениеСвойства, НоваяСтрока, СвойствоXDTO.Имя);
			КонецЕсли;
		КонецЦикла;
	ИначеЕсли ТипЗнч(ОбъектXDTO) = Тип("СписокXDTO") Тогда
		НоваяСтрока = ДеревоЗначений.Строки.Добавить();
		НоваяСтрока.Свойство = ИмяСвойства;
		Для Каждого СтрокаСпискаXDTO Из ОбъектXDTO Цикл
			ПреобразоватьXDTOВДерево(СтрокаСпискаXDTO, НоваяСтрока);
		КонецЦикла;
	ИначеЕсли ТипЗнч(ОбъектXDTO) = Тип("ЗначениеXDTO") Тогда
		НоваяСтрока = ДеревоЗначений.Строки.Добавить();
		НоваяСтрока.Свойство = "ЗначениеXDTO";
	КонецЕсли;

	Возврат ДеревоЗначений;

КонецФункции

&НаКлиенте
Процедура СписокWSОпределенийПриАктивизацииСтроки(Элемент)
	Если Элементы.СписокWSОпределений.ТекущиеДанные <> Неопределено Тогда
		МестоположениеWSDL = Элементы.СписокWSОпределений.ТекущиеДанные.МестоположениеWSDL;
		ИмяПользователя = Элементы.СписокWSОпределений.ТекущиеДанные.ИмяПользователя;
		Пароль = Элементы.СписокWSОпределений.ТекущиеДанные.Пароль;
	Иначе
		МестоположениеWSDL = "";
		ИмяПользователя = "";
		Пароль = "";
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)

	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
	ДиалогОткрытияФайла.Заголовок = "Выберите файл";
	ДиалогОткрытияФайла.Показать(Новый ОписаниеОповещения("СохранитьЗавершение", ЭтаФорма,
		Новый Структура("ДиалогОткрытияФайла", ДиалогОткрытияФайла)));

КонецПроцедуры

&НаКлиенте
Процедура СохранитьЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт

	ДиалогОткрытияФайла = ДополнительныеПараметры.ДиалогОткрытияФайла;
	Если (ВыбранныеФайлы <> Неопределено) Тогда
		ПолноеИмяФайла = ДиалогОткрытияФайла.ПолноеИмяФайла;
		ТекстXML = СохранитьСервер();
		ТекстДок = Новый ТекстовыйДокумент;
		ТекстДок.УстановитьТекст(ТекстXML);
		ТекстДок.НачатьЗапись( , ПолноеИмяФайла);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция СохранитьСервер()
	Сериализатор = Новый СериализаторXDTO(ФабрикаXDTO);
	Запись = Новый ЗаписьXML;
	Запись.УстановитьСтроку();
//	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	Сериализатор.ЗаписатьXML(Запись, СписокWSОпределений.Выгрузить());
	Возврат Запись.Закрыть();
КонецФункции

&НаКлиенте
Процедура Прочитать(Команда)

	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
	ДиалогОткрытияФайла.Заголовок = "Выберите файл";
	ДиалогОткрытияФайла.Показать(Новый ОписаниеОповещения("ПрочитатьЗавершение", ЭтаФорма,
		Новый Структура("ДиалогОткрытияФайла", ДиалогОткрытияФайла)));

КонецПроцедуры

&НаКлиенте
Процедура ПрочитатьЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт

	ДиалогОткрытияФайла = ДополнительныеПараметры.ДиалогОткрытияФайла;
	Если (ВыбранныеФайлы <> Неопределено) Тогда
		ПолноеИмяФайла = ДиалогОткрытияФайла.ПолноеИмяФайла;
		ТекстДок = Новый ТекстовыйДокумент;
		ТекстДок.НачатьЧтение(Новый ОписаниеОповещения("ПрочитатьЗавершениеЗавершение", ЭтаФорма,
			Новый Структура("ТекстДок", ТекстДок)), ПолноеИмяФайла);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПрочитатьЗавершениеЗавершение(ДополнительныеПараметры1) Экспорт

	ТекстДок = ДополнительныеПараметры1.ТекстДок;
	ТекстXML = ТекстДок.ПолучитьТекст();
	ПрочитатьСервер(ТекстXML);

КонецПроцедуры
&НаСервере
Процедура ПрочитатьСервер(ТекстXML)
	Сериализатор = Новый СериализаторXDTO(ФабрикаXDTO);
	Чтение = Новый ЧтениеXML;
	Чтение.УстановитьСтроку(ТекстXML);
//	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	СписокWSОпределений.Загрузить(Сериализатор.ПрочитатьXML(Чтение));
//	ЗначениеВРеквизитФормы(ОбработкаОбъект, "Объект");
	Чтение.Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыОперацийЗначениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	// Если тип параметра структура то откром отдельную форму для ее заполнения
	Если Элементы.ПараметрыОпераций.ТекущиеДанные.ТипПараметра = "{http://v8.1c.ru/8.1/data/core}Structure" Тогда
		СтандартнаяОбработка = Ложь;
		ОписаниеОповещения = Новый ОписаниеОповещения("СохранениеСтруктуры", ЭтотОбъект);
		ПрошлоеЗначение = Новый Структура;
		ПрошлоеЗначение.Вставить("ПрошлоеЗначение", Элементы.ПараметрыОпераций.ТекущиеДанные.Структура);
		ОткрытьФорму("Обработка.УИ_КонсольВебСервисов.Форма.ФормаВводаСтруктуры", ПрошлоеЗначение, ЭтотОбъект, , , ,
			ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СохранениеСтруктуры(ВыбранноеЗначение, ИсточникВыбора) Экспорт
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		Элементы.ПараметрыОпераций.ТекущиеДанные.Значение = "Структура";
		Элементы.ПараметрыОпераций.ТекущиеДанные.Структура = ВыбранноеЗначение;
	КонецЕсли;
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Attachable_ExecuteToolsCommonCommand(Команда) 
	UT_CommonClient.Attachable_ExecuteToolsCommonCommand(ЭтотОбъект, Команда);
КонецПроцедуры

