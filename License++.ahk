/*
License++
Made by CurtishDev
Version: v0.1
2023
*/

#NoEnv

Windows_Disk := A_WinDir

if Windows_Disk contains Windows
{
    RegExMatch(Windows_Disk, "(.*)windows", Disk_7)
    if Disk_71 contains Q,W,E,R,T,Y,U,I,O,P,A,S,D,F,G,H,J,K,L,Z,X,C,V,B,N,M
    {
        DriveGet, HWID, Serial, %Disk_71%
    }
      
    RegExMatch(Windows_Disk, "(.*)Windows", Disk_8)
    if Disk_81 contains Q,W,E,R,T,Y,U,I,O,P,A,S,D,F,G,H,J,K,L,Z,X,C,V,B,N,M
    {
        DriveGet, HWID, Serial, %Disk_81%
    }
      
    RegExMatch(Windows_Disk, "(.*)WINDOWS", Disk_10)
    if Disk_101 contains Q,W,E,R,T,Y,U,I,O,P,A,S,D,F,G,H,J,K,L,Z,X,C,V,B,N,M
    {
        DriveGet, HWID, Serial, %Disk_101%
    }
}
else
{
    MsgBox, У тебя операционная система не Windows!
    ExitApp
}

global hwid_url := ""
global cHwid := ""

UrlGetContents(sUrl) {
    ComObjError(False) ; Не выводим ошибки пользователю
    http := ComObjCreate("WinHttp.WinHttpRequest.5.1") ; Подключаем библиотеку WinHttpRequest

    http.Open("GET", sUrl, false) ; Открываем html страницу
    http.Send() ; Получаем данные

    ;Эта библиотека нужна для кириллицы
    ADODBStream := ComObjCreate("ADODB.Stream")
    ADODBStream.Type := 1
    ADODBStream.Mode  := 3
    ADODBStream.Open()
    ADODBStream.Write(http.ResponseBody)
    ADODBStream.Position := 0
    ADODBStream.Type := 2
    ADODBStream.Charset := "UTF-8"

    text := ADODBStream.ReadText()
    ADODBStream.Close()
    return text ; Возращаем полученный текст
}

CheckHwid() {
    Active := FALSE
    DriveGet, cHwid, Serial, C:\ ; Получаем серийник C:)
    Loop, Parse, % UrlGetContents(hwid_url), `n ; В цикле парсим данные из html страницы через строку
    {
        sHwid := strsplit(A_LoopField, " / ") ; делим полученные данные через символ "-"
        if (cHwid == sHwid[1]) { ; Задаём нужный нам массив с данными
            Active := TRUE ; Если hwid совпал, то Active = true
            name := sHwid[2] ; Получаем имя на хостинге
            regdate := sHwid[3] ; Дата Внесения в Базу
            forum := sHwid[4] ; Lolz Клиента
        }
    }
    return Active ; Возращаем значение
}

SetWorkingDir %A_ScriptDir%

;Парамертры
global name := name
global regdate := regdate
global forum := forum



if (!CheckHwid()) { ; Здесь происходит проверка на hwid, если функция вернула false, то он выводит сообщение что нет hwid на хостинге, если true пропускается
    MsgBox, Добро пожаловать в поле регистрации!`nСкопированные данные отправьте @ (TG).
    Gui, Font, S16 CBlack Bold, Arial
    Gui, Add, Text, x53 y0 w500 h30 , Твой ключ:
    Gui, Font, ,
    Gui, Add, Edit, x1 y31 w219 h21 +Center ReadOnly vEdit,
    Gui, Add, Button, x35 y52 w153 h24 gClip , Копировать и Закрыть
    Gui, Show, w221 h76, Доступ к Приватному ПО
    GuiControl, , Edit, % HWID
    return
    Clip:
    Gui, Submit, NoHide
    Clipboard := Edit
    ExitApp
    GuiClose:
    ExitApp
}

msgbox, 0x40, Информация, % "Добро Пожаловать, " name "!`nСофт Активирован!`nАвтор: @ (TG)`nВы Присоединились к Нам " regdate "!`nМы Всегда Свяжимся с Вами В Случае Проблем По Этим Данным: " forum "!"
