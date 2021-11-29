

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	УИ_ОбщегоНазначения.ФормаИнструментаПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
КонецПроцедуры


&НаСервере
Функция СтрокуВДату(СтрокаДата)
	Попытка
		СтрокаДата = Прав(СтрокаДата, 10);
		МассивДата = Новый Массив;
		МассивДата =  РазложитьСтрокуВМассивПодстрок(СтрокаДата, ".");
		Возврат Дата(Строка(МассивДата[2]) + Строка(МассивДата[1]) + Строка(МассивДата[0]));
	Исключение
		Возврат Дата(1899, 12, 30);
	КонецПопытки;
КонецФункции

// Разбивает строку на несколько строк по разделителю. Разделитель может иметь любую длину.
//
// Параметры:
//  Строка                 - Строка - текст с разделителями;
//  Разделитель            - Строка - разделитель строк текста, минимум 1 символ;
//  ПропускатьПустыеСтроки - Булево - признак необходимости включения в результат пустых строк.
//    Если параметр не задан, то функция работает в режиме совместимости со своей предыдущей версией:
//     - для разделителя-пробела пустые строки не включаются в результат, для остальных разделителей пустые строки
//       включаются в результат.
//     Е если параметр Строка не содержит значащих символов или не содержит ни одного символа (пустая строка), то в
//       случае разделителя-пробела результатом функции будет массив, содержащий одно значение "" (пустая строка), а
//       при других разделителях результатом функции будет пустой массив.
//  СокращатьНепечатаемыеСимволы - Булево - сокращать непечатаемые символы по краям каждой из найденных подстрок.
//
// Возвращаемое значение:
//  Массив - массив строк.
//
// Примеры:
//  РазложитьСтрокуВМассивПодстрок(",один,,два,", ",") - возвратит массив из 5 элементов, три из которых  - пустые
//  строки;
//  РазложитьСтрокуВМассивПодстрок(",один,,два,", ",", Истина) - возвратит массив из двух элементов;
//  РазложитьСтрокуВМассивПодстрок(" один   два  ", " ") - возвратит массив из двух элементов;
//  РазложитьСтрокуВМассивПодстрок("") - возвратит пустой массив;
//  РазложитьСтрокуВМассивПодстрок("",,Ложь) - возвратит массив с одним элементом "" (пустой строкой);
//  РазложитьСтрокуВМассивПодстрок("", " ") - возвратит массив с одним элементом "" (пустой строкой);
//
&НаСервере
Функция РазложитьСтрокуВМассивПодстрок(Знач Строка, Знач Разделитель = ",", Знач ПропускатьПустыеСтроки = Неопределено,
	СокращатьНепечатаемыеСимволы = Ложь) Экспорт

	Результат = Новый Массив;
	
	// Для обеспечения обратной совместимости.
	Если ПропускатьПустыеСтроки = Неопределено Тогда
		ПропускатьПустыеСтроки = ?(Разделитель = " ", Истина, Ложь);
		Если ПустаяСтрока(Строка) Тогда
			Если Разделитель = " " Тогда
				Результат.Добавить("");
			КонецЕсли;
			Возврат Результат;
		КонецЕсли;
	КонецЕсли;
	//

	Позиция = Найти(Строка, Разделитель);
	Пока Позиция > 0 Цикл
		Подстрока = Лев(Строка, Позиция - 1);
		Если Не ПропускатьПустыеСтроки Или Не ПустаяСтрока(Подстрока) Тогда
			Если СокращатьНепечатаемыеСимволы Тогда
				Результат.Добавить(СокрЛП(Подстрока));
			Иначе
				Результат.Добавить(Подстрока);
			КонецЕсли;
		КонецЕсли;
		Строка = Сред(Строка, Позиция + СтрДлина(Разделитель));
		Позиция = Найти(Строка, Разделитель);
	КонецЦикла;

	Если Не ПропускатьПустыеСтроки Или Не ПустаяСтрока(Строка) Тогда
		Если СокращатьНепечатаемыеСимволы Тогда
			Результат.Добавить(СокрЛП(Строка));
		Иначе
			Результат.Добавить(Строка);
		КонецЕсли;
	КонецЕсли;

	Возврат Результат;

КонецФункции

&НаСервере
Процедура ПолучитьСписокЛицензийНаСервере()
	Объект.СписокЛицензий.Очистить();
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла("txt");
	Если УИ_ОбщегоНазначенияКлиентСервер.ЭтоWindows() Тогда
		ИмяВременногоФайлаCMD = ПолучитьИмяВременногоФайла("cmd");
	Иначе
		ИмяВременногоФайлаCMD=ПолучитьИмяВременногоФайла("sh");
	КонецЕсли;
	ТекстCMD = Новый ЗаписьТекста;
	ТекстCMD.Открыть(ИмяВременногоФайлаCMD, КодировкаТекста.ANSI);
	ТекстCMD.ЗаписатьСтроку("ring license list > " + ИмяВременногоФайла);
	ТекстCMD.Закрыть();
	ЗапуститьПриложение(ИмяВременногоФайлаCMD, КаталогВременныхФайлов(), Истина);
	
//	КомандаСистемы("ring license list > " + ИмяВременногоФайла, КаталогВременныхФайлов());
	Текст = Новый ЧтениеТекста;
	Текст.Открыть(ИмяВременногоФайла);
	стр = "";
	Пока стр <> Неопределено Цикл
		стр = Текст.ПрочитатьСтроку();
		ПозицияИмениФайла = СтрНайти(стр, "(file name:");
		Если ПозицияИмениФайла > 0 Тогда
			ПинЛицензия = Лев(стр, ПозицияИмениФайла - 1);
		Иначе
			ПинЛицензия = стр;
		КонецЕсли;

		мПинЛицензия = РазложитьСтрокуВМассивПодстрок(ПинЛицензия, "-");
		Если мПинЛицензия.Количество() < 2 Тогда
			Продолжить;
		КонецЕсли;
		ИмяФайлаЛицензии = Сред(стр, ПозицияИмениФайла + 13, 99);
		ИмяФайлаЛицензии = СтрЗаменить(ИмяФайлаЛицензии, """)", "");
		нСтр = Объект.СписокЛицензий.Добавить();
		нСтр.ПинКод = мПинЛицензия[0];
		нСтр.НомерЛицензии = мПинЛицензия[1];
		нСтр.ИмяФайлаЛицензии = ИмяФайлаЛицензии;
		нСтр.РучнойВвод = Ложь;
		
				//Сообщить(стр);
	КонецЦикла;
	Текст.Закрыть();
	УдалитьФайлы(ИмяВременногоФайла);
	УдалитьФайлы(ИмяВременногоФайлаCMD);

КонецПроцедуры

&НаКлиенте
Процедура ПолучитьСписокЛицензий()
	ПолучитьСписокЛицензийНаСервере();
КонецПроцедуры

&НаСервере
Функция ЗапросИнформацииОЛицезнии(ИмяЛицензии)
	СтруктураОтвета = Новый Структура("Описание, Фамилия, Имя, Отчество, EMail, Компания, Страна, Индекс, Город, Регион, Район, Улица, Дом, Строение, Квартира, ДатаАктивации, РегистрационныйНомер, КодПродукта, ТекстоваяИнформация, КоличествоЛицензий");
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла("txt");
	ИмяВременногоФайлаCMD = ПолучитьИмяВременногоФайла("cmd");

	ТекстCMD = Новый ЗаписьТекста;
	ТекстCMD.Открыть(ИмяВременногоФайлаCMD, КодировкаТекста.ANSI);
	ТекстCMD.ЗаписатьСтроку("call ring > " + ИмяВременногоФайла + " license info --name " + ИмяЛицензии);
	ТекстCMD.Закрыть();
	ЗапуститьПриложение(ИмяВременногоФайлаCMD, КаталогВременныхФайлов(), Истина);
	Текст = Новый ЧтениеТекста;
	Текст.Открыть(ИмяВременногоФайла);
	стр = "";
	Пока стр <> Неопределено Цикл
		стр = Текст.ПрочитатьСтроку();
		Если СтрНайти(стр, "First name:") > 0 Тогда
			СтруктураОтвета.Имя = Прав(стр, СтрДлина(стр) - СтрНайти(стр, "First name:") - СтрДлина("First name:"));
		ИначеЕсли СтрНайти(стр, "Middle name:") > 0 Тогда
			СтруктураОтвета.Отчество = Прав(стр, СтрДлина(стр) - СтрНайти(стр, "Middle name:") - СтрДлина(
				"Middle name:"));
		ИначеЕсли СтрНайти(стр, "Last name:") > 0 Тогда
			СтруктураОтвета.Фамилия = Прав(стр, СтрДлина(стр) - СтрНайти(стр, "Last name:") - СтрДлина("Last name:"));
		ИначеЕсли СтрНайти(стр, "Email:") > 0 Тогда
			СтруктураОтвета.Email = Прав(стр, СтрДлина(стр) - СтрНайти(стр, "Email:") - СтрДлина("Email:"));
		ИначеЕсли СтрНайти(стр, "Company:") > 0 Тогда
			СтруктураОтвета.Компания = Прав(стр, СтрДлина(стр) - СтрНайти(стр, "Company:") - СтрДлина("Company:"));
		ИначеЕсли СтрНайти(стр, "Country:") > 0 Тогда
			СтруктураОтвета.Страна = Прав(стр, СтрДлина(стр) - СтрНайти(стр, "Country:") - СтрДлина("Country:"));
		ИначеЕсли СтрНайти(стр, "ZIP code:") > 0 Тогда
			СтруктураОтвета.Индекс = Прав(стр, СтрДлина(стр) - СтрНайти(стр, "ZIP code:") - СтрДлина("ZIP code:"));
		ИначеЕсли СтрНайти(стр, "Town:") > 0 Тогда
			СтруктураОтвета.Город = Прав(стр, СтрДлина(стр) - СтрНайти(стр, "Town:") - СтрДлина("Town:"));
		ИначеЕсли СтрНайти(стр, "Region:") > 0 Тогда
			СтруктураОтвета.Регион = Прав(стр, СтрДлина(стр) - СтрНайти(стр, "Region:") - СтрДлина("Region:"));
		ИначеЕсли СтрНайти(стр, "District:") > 0 Тогда
			СтруктураОтвета.Район = Прав(стр, СтрДлина(стр) - СтрНайти(стр, "District:") - СтрДлина("District:"));
		ИначеЕсли СтрНайти(стр, "Building:") > 0 Тогда
			СтруктураОтвета.Строение = Прав(стр, СтрДлина(стр) - СтрНайти(стр, "Building:") - СтрДлина("Building:"));
		ИначеЕсли СтрНайти(стр, "Apartment:") > 0 Тогда
			СтруктураОтвета.Квартира = Прав(стр, СтрДлина(стр) - СтрНайти(стр, "Apartment:") - СтрДлина("Apartment:"));
		ИначеЕсли СтрНайти(стр, "Street:") > 0 Тогда
			СтруктураОтвета.Улица = Прав(стр, СтрДлина(стр) - СтрНайти(стр, "Street:") - СтрДлина("Street:"));
		ИначеЕсли СтрНайти(стр, "House:") > 0 Тогда
			СтруктураОтвета.Дом = Прав(стр, СтрДлина(стр) - СтрНайти(стр, "House:") - СтрДлина("House:"));
		ИначеЕсли СтрНайти(стр, "Description:") > 0 Тогда
			СтруктураОтвета.Описание = Прав(стр, СтрДлина(стр) - СтрНайти(стр, "Description:") - СтрДлина(
				"Description:"));
			Если СтрНайти(стр, " рабочих мест") Тогда
				тСтр = Лев(стр, СтрНайти(стр, " рабочих мест"));
				мСтр = РазложитьСтрокуВМассивПодстрок(тСтр, " ");
				СтруктураОтвета.КоличествоЛицензий = Число(мСтр[мСтр.Количество() - 1]);
			КонецЕсли;
		ИначеЕсли СтрНайти(стр, "License generation date:") > 0 Тогда
			СтруктураОтвета.ДатаАктивации = СтрокуВДату(Прав(стр, СтрДлина(стр) - СтрНайти(стр,
				"License generation date:") - СтрДлина("License generation date:")));
		ИначеЕсли СтрНайти(стр, "Distribution kit registration number:") > 0 Тогда
			СтруктураОтвета.РегистрационныйНомер = Прав(стр, СтрДлина(стр) - СтрНайти(стр,
				"Distribution kit registration number:") - СтрДлина("Distribution kit registration number:"));
		ИначеЕсли СтрНайти(стр, "Product code:") > 0 Тогда
			СтруктураОтвета.КодПродукта = Прав(стр, СтрДлина(стр) - СтрНайти(стр, "Product code:") - СтрДлина(
				"Product code:"));
		КонецЕсли;
	КонецЦикла;
	Текст.Закрыть();
	УдалитьФайлы(ИмяВременногоФайла);
	УдалитьФайлы(ИмяВременногоФайлаCMD);
	Возврат СтруктураОтвета;

КонецФункции

&НаСервере
Функция ЗапросВалидностиЛицезнии(ИмяЛицензии)
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла("txt");
	ИмяВременногоФайлаCMD = ПолучитьИмяВременногоФайла("cmd");

	ТекстCMD = Новый ЗаписьТекста;
	ТекстCMD.Открыть(ИмяВременногоФайлаCMD, КодировкаТекста.ANSI);
	ТекстCMD.ЗаписатьСтроку("call ring > " + ИмяВременногоФайла + " license validate --name " + ИмяЛицензии);
	ТекстCMD.Закрыть();
	ЗапуститьПриложение(ИмяВременногоФайлаCMD, КаталогВременныхФайлов(), Истина);
	Текст = Новый ЧтениеТекста;
	Текст.Открыть(ИмяВременногоФайла);
	стр = Текст.Прочитать();
	СтруктураОтвета = Новый Структура("Активна, ТекстоваяИнформация");
	Если СтрНайти(стр, "License check passed for the following license:") Тогда
		СтруктураОтвета.Активна = Истина;
	Иначе
		СтруктураОтвета.Активна = Ложь;
	КонецЕсли;
	СтруктураОтвета.ТекстоваяИнформация = стр;
	Текст.Закрыть();
	УдалитьФайлы(ИмяВременногоФайла);
	УдалитьФайлы(ИмяВременногоФайлаCMD);
	Возврат СтруктураОтвета;

КонецФункции
&НаКлиенте
Процедура ПолучитьПолнуюИнформациюОЛицензии()
	КоличествоЛицензий = Объект.СписокЛицензий.Количество();
	значениеИндикатора = 0;
	Счетчик = 1;
	Для Каждого стр Из Объект.СписокЛицензий Цикл
		ТекстСообщения = "Получение информации о лицензиях (" + Строка(КоличествоЛицензий) + " шт.)";
		Пояснение = "Запрос информации о лицензии " + стр.НомерЛицензии + ". Всего: " + КоличествоЛицензий;
		Картинка = БиблиотекаКартинок.Провести;
		значениеИндикатора = 100 / (КоличествоЛицензий / Счетчик);
		Состояние(ТекстСообщения, значениеИндикатора, Пояснение, Картинка);
		СтруктураЗн = ЗапросИнформацииОЛицезнии(стр.ПинКод + "-" + стр.НомерЛицензии);
		ЗаполнитьЗначенияСвойств(стр, СтруктураЗн);
		Счетчик = Счетчик + 1;

	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура ПроверкаВалидностиЛицензий()
	КоличествоЛицензий = Объект.СписокЛицензий.Количество();
	значениеИндикатора = 0;
	Счетчик = 1;
	Для Каждого стр Из Объект.СписокЛицензий Цикл
		ТекстСообщения = "Получение информации о лицензиях (" + Строка(КоличествоЛицензий) + " шт.)";
		Пояснение = "Запрос информации о лицензии " + стр.НомерЛицензии + ". Всего: " + КоличествоЛицензий;
		Картинка = БиблиотекаКартинок.Провести;
		значениеИндикатора = 100 / (КоличествоЛицензий / Счетчик);
		Состояние(ТекстСообщения, значениеИндикатора, Пояснение, Картинка);
		СтруктураЗн = ЗапросВалидностиЛицезнии(стр.ПинКод + "-" + стр.НомерЛицензии);
		ЗаполнитьЗначенияСвойств(стр, СтруктураЗн);
		Счетчик = Счетчик + 1;
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ПовторнаяАктивацияЛицензииНаСервере(ПереданныеПараметры)
	СтруктураПараметров = Новый Структура(" НовыйПинКод,ПинКод, Описание, Фамилия, Имя, Отчество, EMail, Компания, Страна, Индекс, Город, Улица, Дом, ДатаАктивации, РегистрационныйНомер, КодПродукта, ТекстоваяИнформация, КоличествоЛицензий");

	ИмяВременногоФайла = ПолучитьИмяВременногоФайла("txt");
	ИмяВременногоФайлаCMD = ПолучитьИмяВременногоФайла("cmd");

	ТекстCMD = Новый ЗаписьТекста;
	ТекстCMD.Открыть(ИмяВременногоФайлаCMD, КодировкаТекста.ANSI);
	ТекстCMD.ЗаписатьСтроку("call ring > " + ИмяВременногоФайла + " license activate" + ?(ЗначениеЗаполнено(
		ПереданныеПараметры.Имя), " --first-name " + ПереданныеПараметры.Имя, "") + ?(ЗначениеЗаполнено(
		ПереданныеПараметры.Отчество), " --middle-name " + ПереданныеПараметры.Отчество, "") + ?(ЗначениеЗаполнено(
		ПереданныеПараметры.Фамилия), " --last-name " + ПереданныеПараметры.Фамилия, "") + ?(ЗначениеЗаполнено(
		ПереданныеПараметры.EMail), " --email " + ПереданныеПараметры.EMail, "") + ?(ЗначениеЗаполнено(
		ПереданныеПараметры.Компания), " --company " + Символ(34) + СтрЗаменить(ПереданныеПараметры.Компания, Символ(
		34), "") + Символ(34), "") + ?(ЗначениеЗаполнено(ПереданныеПараметры.Страна), " --country " + Символ(34)
		+ ПереданныеПараметры.Страна + Символ(34), "") + ?(ЗначениеЗаполнено(ПереданныеПараметры.Индекс),
		" --zip-code " + ПереданныеПараметры.Индекс, "") + ?(ЗначениеЗаполнено(ПереданныеПараметры.Город), " --town "
		+ Символ(34) + ПереданныеПараметры.Город + Символ(34), "") + ?(ЗначениеЗаполнено(ПереданныеПараметры.Регион),
		" --region " + Символ(34) + ПереданныеПараметры.Регион + Символ(34), "") + ?(ЗначениеЗаполнено(
		ПереданныеПараметры.Район), " --district " + Символ(34) + ПереданныеПараметры.Район + Символ(34), "") + ?(
		ЗначениеЗаполнено(ПереданныеПараметры.Улица), " --street " + Символ(34) + ПереданныеПараметры.Улица + Символ(
		34), "") + ?(ЗначениеЗаполнено(ПереданныеПараметры.Дом), " --house " + Символ(34) + ПереданныеПараметры.Дом
		+ Символ(34), "") + ?(ЗначениеЗаполнено(ПереданныеПараметры.Строение), " --building " + Символ(34)
		+ ПереданныеПараметры.Строение + Символ(34), "") + ?(ЗначениеЗаполнено(ПереданныеПараметры.Квартира),
		" --apartment " + Символ(34) + ПереданныеПараметры.Квартира + Символ(34), "") + " --serial "
		+ ПереданныеПараметры.НомерЛицензии + " --pin " + ПереданныеПараметры.НовыйПинКод + " --previous-pin "
		+ ПереданныеПараметры.ПинКод + " --validate");
	ТекстCMD.Закрыть();
	ЗапуститьПриложение(ИмяВременногоФайлаCMD, КаталогВременныхФайлов(), Истина);
	Текст = Новый ЧтениеТекста;
	Текст.Открыть(ИмяВременногоФайла);
	стр = Текст.Прочитать();
	Сообщить(стр);
	Текст.Закрыть();
	УдалитьФайлы(ИмяВременногоФайла);
	УдалитьФайлы(ИмяВременногоФайлаCMD);
КонецПроцедуры

&НаСервере
Процедура ПослеВводаСтрокиПинкода(ПолученноеЗначение, ПереданныеПараметры) Экспорт
	ВведенныйКод = ПолученноеЗначение;
	Если ПустаяСтрока(ВведенныйКод) Тогда
		Отказ = Истина;
	Иначе
		ПереданныеПараметры.НовыйПинКод = ВведенныйКод;
		ПовторнаяАктивацияЛицензииНаСервере(ПереданныеПараметры);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПовторнаяАктивацияЛицензии(Команда)
	ТекущаяСтрока = Элементы.СписокЛицензий.ТекущиеДанные;
	СтруктураПараметров = Новый Структура(" НомерЛицензии,НовыйПинКод,ПинКод, Описание, Фамилия, Имя, Отчество, EMail, Компания, Страна, Индекс, Регион, Район,Город, Улица, Дом, Корпус, Квартира, Строение, ДатаАктивации, РегистрационныйНомер, КодПродукта, ТекстоваяИнформация, КоличествоЛицензий");
	ЗаполнитьЗначенияСвойств(СтруктураПараметров, ТекущаяСтрока);
	Оповещение = Новый ОписаниеОповещения("ПослеВводаСтрокиПинкода", ЭтотОбъект, СтруктураПараметров);

	ПоказатьВводСтроки(
        Оповещение, , // пропускаем начальное значение

		"Введите пин-код для лицензии " + ТекущаяСтрока["НомерЛицензии"], 0, // (необ.) длина

		Ложь // (необ.) многострочность
	);
КонецПроцедуры

&НаСервере
Процедура УдалитьЛицензиюНаСервере(ИмяЛицензии)
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла("txt");
	ИмяВременногоФайлаCMD = ПолучитьИмяВременногоФайла("cmd");

	ТекстCMD = Новый ЗаписьТекста;
	ТекстCMD.Открыть(ИмяВременногоФайлаCMD, КодировкаТекста.ANSI);
	ТекстCMD.ЗаписатьСтроку("call ring > " + ИмяВременногоФайла + " license remove --name " + ИмяЛицензии);
	ТекстCMD.Закрыть();
	ЗапуститьПриложение(ИмяВременногоФайлаCMD, КаталогВременныхФайлов(), Истина);
	Текст = Новый ЧтениеТекста;
	Текст.Открыть(ИмяВременногоФайла);
	стр = Текст.Прочитать();
	Сообщить(стр);
	Текст.Закрыть();
	УдалитьФайлы(ИмяВременногоФайла);
	УдалитьФайлы(ИмяВременногоФайлаCMD);

КонецПроцедуры

&НаКлиенте
Процедура УдалитьЛицензию(Команда)
	ТекущаяСтрока = Элементы.СписокЛицензий.ТекущиеДанные;
	УдалитьЛицензиюНаСервере(ТекущаяСтрока["ПинКод"] + "-" + ТекущаяСтрока["НомерЛицензии"]);
	Объект.СписокЛицензий.Удалить(Элементы.СписокЛицензий.ТекущаяСтрока);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПодключитьОбработчикОжидания("ЗагрузитьДанные", 1, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьДанные()
	ПолучитьСписокЛицензий();
	ПолучитьПолнуюИнформациюОЛицензии();
	ПроверкаВалидностиЛицензий();
КонецПроцедуры

&НаКлиенте
Процедура СписокЛицензийПриАктивизацииСтроки(Элемент)
	Попытка
		Элементы.ГруппаДанныеАктивации.ТолькоПросмотр = Элементы.СписокЛицензий.ТекущиеДанные["Активна"];
		Элементы.СписокЛицензийАктивироватьЛицензию.Доступность = Не Элементы.СписокЛицензий.ТекущиеДанные["Активна"];
	Исключение
	КонецПопытки;
КонецПроцедуры

&НаКлиенте
Процедура СписокЛицензийПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	// Вставить содержимое обработчика.
КонецПроцедуры

&НаКлиенте
Процедура АктивироватьЛицензию(Команда)
	ПараметрыОткрытия = Новый Структура("Фамилия, Имя, Отчество, EMail, Компания, Страна, Индекс, Регион, Район,Город, Улица, Дом, Корпус, Квартира, Строение");
	ТекущаяСтрока = Элементы.СписокЛицензий.ТекущиеДанные;
	ЗаполнитьЗначенияСвойств(ПараметрыОткрытия, ТекущаяСтрока);
	ОткрытьФорму("Обработка.УИ_ИнформацияОЛицензиях1С.Форма.ФормаАктивацииЛицензии", ПараметрыОткрытия);
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ВыполнитьОбщуюКомандуИнструментов(Команда) 
	UT_CommonClient.Подключаемый_ВыполнитьОбщуюКомандуИнструментов(ЭтотОбъект, Команда);
КонецПроцедуры

