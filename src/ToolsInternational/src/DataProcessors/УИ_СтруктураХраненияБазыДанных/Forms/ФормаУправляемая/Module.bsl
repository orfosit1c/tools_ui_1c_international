&НаСервере
Процедура ПолучитьСтруктуру()

	СтруктураБазы = ПолучитьИзВременногоХранилища(АдресСтруктурыБазы);

	Если СтруктураБазы = Неопределено Тогда

		СтруктураБазы = ПолучитьСтруктуруХраненияБазыДанных();
		ПоместитьВоВременноеХранилище(СтруктураБазы, АдресСтруктурыБазы);

	КонецЕсли;

	ЗаполнитьТаблицуРезультата(СтруктураБазы);
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуРезультата(СтруктураБазы, НайденныеСтроки = Неопределено)
	Результат.Очистить();

	Если НайденныеСтроки = Неопределено Тогда
		СтрокиДляРезультата=СтруктураБазы;
	Иначе
		СтрокиДляРезультата=НайденныеСтроки;
	КонецЕсли;

	Для Каждого Строка Из СтрокиДляРезультата Цикл
		НоваяСтрока = Результат.Добавить();
		НоваяСтрока.ИмяТаблицы = Строка.ИмяТаблицы;
		НоваяСтрока.Метаданные = Строка.Метаданные;
		НоваяСтрока.Назначение = Строка.Назначение;
		НоваяСтрока.ИмяТаблицыХранения = Строка.ИмяТаблицыХранения;

		Для Каждого Поле Из Строка.Поля Цикл
			НоваяСтрокаПолей = НоваяСтрока.Поля.Добавить();
			НоваяСтрокаПолей.ИмяПоляХранения = Поле.ИмяПоляХранения;
			НоваяСтрокаПолей.ИмяПоля = Поле.ИмяПоля;
			НоваяСтрокаПолей.Метаданные = Поле.Метаданные;
		КонецЦикла;

		Для Каждого Индекс Из Строка.Индексы Цикл
			НоваяСтрокаИндексов = НоваяСтрока.Индексы.Добавить();
			НоваяСтрокаИндексов.ИмяИндексаХранения = Индекс.ИмяИндексаХранения;

			// Поля индекса
			Для Каждого Поле Из Индекс.Поля Цикл
				НоваяСтрокаПолейИндекса = НоваяСтрокаИндексов.ПоляИндекса.Добавить();
				НоваяСтрокаПолейИндекса.ИмяПоляХранения = Поле.ИмяПоляХранения;
				НоваяСтрокаПолейИндекса.ИмяПоля = Поле.ИмяПоля;
				НоваяСтрокаПолейИндекса.Метаданные = Поле.Метаданные;
			КонецЦикла;

		КонецЦикла;

	КонецЦикла;

	Результат.Сортировать("Метаданные ВОЗР,ИмяТаблицы ВОЗР");
КонецПроцедуры

&НаСервере
Процедура НайтиПоИмениТаблицыХранения()

	СтруктураБазы = ПолучитьИзВременногоХранилища(АдресСтруктурыБазы);

	ИмяДляПоиска = ВРЕГ(СокрЛП(Отбор));
	Если Не ТочноеСоответствие И Лев(ИмяДляПоиска, 1) = "_" Тогда
		ИмяДляПоиска = Сред(ИмяДляПоиска, 2);
	КонецЕсли;
	НайденныеСтроки = Новый Массив;

	Если ПустаяСтрока(ИмяДляПоиска) Тогда
		Возврат;
	КонецЕсли;

	Для Каждого Строка Из СтруктураБазы Цикл

		Если ВключаяПоля Тогда
			Для Каждого СтрокаПоле Из Строка.Поля Цикл
				Если ТочноеСоответствие Тогда
					Если ВРЕГ(СтрокаПоле.ИмяПоляХранения) = ИмяДляПоиска Или ВРЕГ(СтрокаПоле.ИмяПоля) = ИмяДляПоиска Тогда
						НайденныеСтроки.Добавить(Строка);
					КонецЕсли;
				Иначе

					Если Найти(ВРЕГ(СтрокаПоле.ИмяПоляХранения), ИмяДляПоиска) > 0 Или Найти(ВРЕГ(СтрокаПоле.ИмяПоля),
						ИмяДляПоиска) Тогда
						НайденныеСтроки.Добавить(Строка);
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;

		Если ТочноеСоответствие Тогда
			Если ВРЕГ(Строка.ИмяТаблицыХранения) = ИмяДляПоиска Или ВРЕГ(Строка.ИмяТаблицы) = ИмяДляПоиска Или ВРЕГ(
				Строка.Метаданные) = ИмяДляПоиска Или ВРЕГ(Строка.Назначение) = ИмяДляПоиска Тогда
				НайденныеСтроки.Добавить(Строка);
			КонецЕсли;
		Иначе
			Если Найти(ВРЕГ(Строка.ИмяТаблицыХранения), ИмяДляПоиска) > 0 Или Найти(ВРЕГ(Строка.ИмяТаблицы),
				ИмяДляПоиска) Или Найти(ВРЕГ(Строка.Метаданные), ИмяДляПоиска) Или Найти(ВРЕГ(Строка.Назначение),
				ИмяДляПоиска) Тогда
				НайденныеСтроки.Добавить(Строка);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;

	ЗаполнитьТаблицуРезультата(НайденныеСтроки);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтбор(Команда)

	НайтиПоИмениТаблицыХранения();

КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	АдресСтруктурыБазы = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
	ПолучитьСтруктуру();

	УИ_ОбщегоНазначения.ФормаИнструментаПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ОтборОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)

	ДанныеВыбора = Новый СписокЗначений;
	ДанныеВыбора.Добавить(Текст);
	СтандартнаяОбработка = Ложь;
	Отбор = Текст;
	НайтиПоИмениТаблицыХранения();

КонецПроцедуры

&НаКлиенте
Procedure ВключаяПоляOnChange(Item)
	НайтиПоИмениТаблицыХранения();
EndProcedure

&НаКлиенте
Procedure ТочноеСоответствиеOnChange(Item)
	НайтиПоИмениТаблицыХранения();
EndProcedure

&НаКлиенте
Процедура Подключаемый_ВыполнитьОбщуюКомандуИнструментов(Команда) Экспорт
	UT_CommonClient.Подключаемый_ВыполнитьОбщуюКомандуИнструментов(ЭтотОбъект, Команда);
КонецПроцедуры