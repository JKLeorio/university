type
  PNode = ^Node;
  Node = record
    data: integer;
    next: PNode;
    previous : PNode
  end;
  List = record
    private
      head : PNode;
      tail : PNode;
      size : Integer;
    public
      constructor Create;
        begin
          self.head := nil;
          self.tail := nil;
          self.size := 0;
        end;
      procedure append(data : Integer);
        var
          node : PNode;
        begin
          new(node);
          node^.data := data;
          node^.next := nil;
          if self.size = 0 then
            begin
              self.head := node;
              self.tail := node;
            end
          else
            if size = 1 then
            begin
              self.tail := node;
              self.head^.next := self.tail;
              self.tail^.previous := self.head;
            end
            else
              if size > 1 then
                 begin
                   self.tail^.next := node;
                   node^.previous := self.tail;
                   self.tail := node;
                 end;
          self.size += 1;
          self.show('',  ' <--- '+ self.head^.data);
        end;
        
      function pop : Integer;
        var
          junk : PNode;
        begin 
          if self.head <> nil then
          begin
            junk := self.tail;
            Result := self.tail^.data;
            if self.size > 1 then
              begin
                self.tail := self.tail^.previous;
                self.tail^.next := nil;
              end
            else
              begin
                self.tail := nil;
                self.head := nil;
              end;
            self.size -= 1;
            self.show('',  ' ---> '+ Result);
            dispose(junk);
          end;
        end;
        
      procedure show(left : String := ''; right : String := '');
        var
          listNode : PNode;
          output : String;
        begin
          writeln;
          listNode := self.head;
          output := 'Structure size is ' + self.size + ' | structure : ' + left + '[ ';
          output := (output.Length * '-') + chr(10)+ output;
          
          Write(output);
          while listNode <> nil do 
            begin
              Write(listNode^.data);
              listNode := ListNode^.next;
              if listNode <> nil then
                Write(' , ');
            end;
            Writeln(' ]' + right);
            Write((output.Length div 2) * '-' + chr(10)*2)
        end;
        
        
      function remove : Integer;
        var
          junk : PNode;
        begin
          if self.head <> nil then 
            begin
              if self.size > 1 then
              begin
                junk := self.head;
                Result := self.head^.data;
                self.head^.next^.previous := nil;
                self.head := self.head^.next;
                self.size -= 1;
              end
              else
                if self.size = 1 then 
                  begin
                    junk := self.head;
                    Result := self.head^.data;
                    self.head := nil;
                    self.tail := nil;
                    self.size := 0;
                  end;
              self.show(junk^.data + ' <--- ');
              dispose(junk);
            end;
        end;
        
      procedure push(data : Integer);
        var
          node : PNode;
        begin
          new(node);
          node^.data := data;
          node^.next := self.head;
          if self.size >= 1 then
            begin
              self.head^.previous := node;
              self.head := node;
            end
          else
            begin
              self.head := node;
              self.tail := node;
            end;
          self.size += 1;
          self.show(self.head^.data + ' ---> ');
        end;
        
     function get_by(n : Integer) : PNode;
      var
        node : PNode;
        i : Integer;
      begin
        if self.size = n then
          Result := self.tail
        else
          if self.size >= n then
            i := 1;
            node := self.head;
            while (i <> n) and (node^.next <> nil) do
              begin
                node := node^.next;
                i += 1
              end;
            Result := node;
      end;
      
     function get_data_by(n: Integer) : Integer;
       begin
         Result := self.get_by(n)^.data;
       end;
       
     procedure add_after(n : Integer; data : Integer);
      var
        node, new_node, buff : PNode;
      begin
        new(new_node);
        new_node^.data := data;
        node := self.get_by(n);
        if node^.next <> nil then
          begin
            buff := node^.next;
            buff^.previous := new_node;
            new_node^.next := buff;
            new_node^.previous := node;
            node^.next := new_node;
          end
        else
          begin
            new_node^.previous := node;
            node^.next := new_node;
            self.tail := new_node;
          end;
        self.size += 1;
        self.show;
      end;
      
     function get_size: Integer;
     begin
       Result := self.size;
     end;
     
     function is_empty: Boolean;
      begin
        Result := self.head = nil;
        if Result then
          Writeln('Структура пуста')
        else
          Writeln('Структура не пуста');
      end;
     
     
     procedure delete;
      begin
        dispose(self.head);
        dispose(self.tail);
        self.show;
      end;
      
     procedure pop_to_file(filename : String);
      var
        _file : text;
        data : Integer;
        output : String;
      begin
        self.CheckFile(filename);
        Assign(_file, filename);
        Rewrite(_file);
        output := _file.Name;
        data := self.pop();
        _file.Write(data);
        _file.Close();
        output := ' --->' + data + ' ---> ' + output;
        self.show('', output);
      end;
      
     procedure remove_to_file(filename : String);
      var
        _file : text;
        data : Integer;
        output : String;
      begin
        self.CheckFile(filename);
        Assign(_file, filename);
        Rewrite(_file);
        data := self.remove();
        output := _file.Name + ' <--- ';
        _file.Write(data);
        _file.Close();
        output += data + ' <--- ';
        self.show(output);
      end;
      
      procedure CheckFile(filename : String);
        begin
          if not FileExists(filename) then
             begin
              writeLn('Файл ',filename,' не найден!');
              writeLn('Работа программы завершена. Нажмите ENTER');
              readln;
              exit;
             end;
        end;
      
      procedure push_from_file(filename : String);
      var
        _file : text;
        data : Integer;
        output : String;
      begin
        CheckFile(filename);
        AssignFile(_file, filename);
        reset(_file);
        output := _file.Name + ' ---> (';
        while not _file.Eof do
        begin
          if not _file.SeekEof() then
            begin
              data := _file.ReadInteger();
              self.push(data);
              output := output + data + '  ';
            end;
        end;
         output += ') ---> ';
        _file.Close();
        self.show(output);
      end;
      
      
      procedure append_from_file(filename : String);
      var
        _file : text;
        data : Integer;
        output : String;
      begin
        CheckFile(filename);
        AssignFile(_file, filename);
        reset(_file);
        output := ') <--- ' + _file.Name;
        while not _file.Eof do
        begin
          if not _file.SeekEof() then
            begin
              data := _file.ReadInteger();
              self.append(data);
              output := ' ' + data + output;
            end;
        end;
        output := ' <--- (' + output;
        _file.Close();
        self.show('',output);
      end;
  end;
  
  PList = ^List;
  
  BaseStructure = class
    private
      _list : PList;
      
    public
      constructor Create;
        begin
          new(_list);
        end;
        
      procedure push(data : Integer);
      begin
        self._list^.push(data);
      end;

      function empty : Boolean;
      begin
        Result := self._list^.is_empty();
      end;
      
      function size : Integer;
      begin
        Result := self._list^.get_size();
      end;
      
      procedure show := self._list^.show();
      
      
      procedure push_from_file(filename : String);
      begin
        self._list^.push_from_file(filename);
      end;
      
      procedure delete;
        begin
          self._list^.delete;
          dispose(self._list);
          new(_list)
        end;
  end;
  
  Queue = class(BaseStructure)
    private
    public
    function pop : Integer;
      begin
        Result := self._list^.pop()
      end;
      
    procedure pop_to_file(filename : String);
      begin
        self._list^.pop_to_file(filename);
      end;
      
    end;
    
  Stack = class(BaseStructure)
    private
    public
    function pop : Integer;
      begin
        Result := self._list^.remove();
      end;
      
    procedure pop_to_file(filename : String);
      begin
        self._list^.remove_to_file(filename);
      end;
      
    end;
    
  function ask_path : String;
    begin
      Write('Введите путь до файла : ');
      Readln(Result);
    end;
  
  procedure menu;
    label 1,2;
    var
      
    _list : List;
    _stack : Stack;
    _queue : Queue;
    
    menu_option1, menu_option2, file_path : String;
    arg1, arg2, arg3, input_data : Integer;
    Structure_label : array of String;
    begin
      _list := new List;
      _stack := new Stack;
      _queue := new Queue;
      menu_option1 := 'Структура для операций:' + chr(10) + 
                      '1.связный список'+
                      chr(10)+'2.стек'+
                      chr(10)+'3.очередь'+
                      chr(10)+ 'Выбор : ';
      1:Writeln;          
      Write(menu_option1);
      Readln(arg1);
      Writeln;
      
      case arg1 of
        1 : Structure_label := Arr('список', 'списка');
        2 : Structure_label := Arr('стек', 'стека');
        3 : Structure_label := Arr('очередь', 'очереди');
      end;
      
      menu_option2 := 'Операции:' + chr(10) +
      '1. Добавление элемента в ' + Structure_label[0] + chr(10) +
      '2. Извлечение элемента из' + Structure_label[1] + chr(10) + 
      '3. Очистка ' + Structure_label[1] + chr(10) + 
      '4. Проверка пустоты ' + Structure_label[1] + chr(10) +
      '5. Извлечение элемента из '+ Structure_label[1]+' и запись в файл'+ chr(10)+
      '6. Чтение элемента из файла и добавление в '+ Structure_label[0] + chr(10)+
      '7. Назад' + chr(10) +
      '8. Выход.'+ chr(10) +
      'Выберите операцию: ';
      
      2:Writeln;
      Write(menu_option2);
      Readln(arg2);
      
      case arg1 of 
        1:begin
          case arg2 of
            1:begin
              Write('Введите значение : ');
              Readln(input_data);
              Writeln;
              Write('1.В начало'+chr(10)+'2.В конец'+chr(10)+'Выбор : ');
              Readln(arg3);
              Writeln;
              case arg3 of
                1: _list.push(input_data);
                2: _list.append(input_data);
              end;
            end;
            
            2:begin
              Write('1.C начала'+chr(10)+'2.С конца'+chr(10)+'Выбор : ');
              Readln(arg3);
              Writeln;
              case arg3 of
                1: _list.remove;
                2: _list.pop;
              end;
            end;
            
            3:_list.delete;
            
            4:_list.is_empty;
            
            5:begin
              file_path := ask_path;
              Write('1.C начала'+chr(10)+'2.С конца'+chr(10)+'Выбор : ');
              Readln(arg3);
              Writeln;
              case arg3 of
                1: _list.remove_to_file(file_path);
                2: _list.pop_to_file(file_path);
              end;
            end;
            
            6:begin
              file_path := ask_path;
              Write('1.В начало'+chr(10)+'2.В конец'+chr(10)+'Выбор : ');
              Readln(arg3);
              Writeln;
              case arg3 of
                1: _list.push_from_file(file_path);
                2: _list.append_from_file(file_path);
              end;
            end;
            
            7:goto 1;
            
            8:exit;
          end;
        end;
        
        2:begin
          case arg2 of
            1:begin
              Write('Введите значение : ');
              Readln(input_data);
              _stack.push(input_data);
            end;
            2:_stack.pop;
            3:_stack.delete;
            4:_stack.empty;
            5:begin
              file_path := ask_path;
              _stack.pop_to_file(file_path);
            end;
            6:begin
              file_path := ask_path;
              _stack.push_from_file(file_path);
            end;
            7:goto 1;
            8:exit;
          end;
        end;
        
        3:begin
          case arg2 of
            1:begin
              Write('Введите значение : ');
              Readln(input_data);
              _queue.push(input_data);
            end;
            2:_queue.pop;
            3:_queue.delete;
            4:_queue.empty;
            
            5:begin
              file_path := ask_path;
              _queue.pop_to_file(file_path);
            end;
            6:begin
              file_path := ask_path;
              _queue.push_from_file(file_path);
            end;
            7:goto 1;
            8:exit
            
          end;
        end;
      end;
      goto 2;
   end;

    
    
var
  _list : List;
  _stack : Stack;
  _queue : queue;

begin
  menu;
end.