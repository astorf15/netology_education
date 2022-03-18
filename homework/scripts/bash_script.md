### Bash скрипты

#### Вложеные условия `if`+ `case`
```bash
#!/bin/bash
echo "Введите марку телефона"
read brand
if [[ $brand == "samsung" ]] || [[ $brand == "nokia" ]] || [[ $brand == "apple" ]] || [[ $brand == "oppo" ]] ; then
        case  $brand in
                samsung)
                        echo "Скидака на телефоны $brand - 30%";;
                nokia)
                        echo "Скидка на телефоны $brand - 10%";;
                apple)
                        echo "Скидка на телефоны $brand - 20%";;
                *)
                        echo "На этот товар скидок нет"
        esac
        else
                        echo "$brand - это не марка телефона"
fi
```
#### Вложеные условия `if`+ `if`
```bash
#!/bin/bash
echo "Введите марку телефона"
read brand
if [[ $brand == "samsung" ]] || [[ $brand == "nokia" ]] || [[ $brand == "apple" ]] || [[ $brand == "oppo" ]] ; then
  if [[ $brand == "samsung" ]] ; then
    echo "Скидака на телефоны $brand - 30%"
  elif [[ $brand == "nokia" ]] ; then 
    echo "Скидка на телефоны $brand - 10%"
  elif [[ $brand == "nokia" ]] ; then 
    echo "Скидка на телефоны $brand - 20%"
  else   
    echo "На этот товар скидок нет"
  fi
else
   echo "$brand - это не марка телефона"
fi      
```
#### Массивы
```bash
#!/bin/bash
array=(20 30 40 50)
array2=(20 30 40 fifty)

# Вывод всех элементов массива
echo ${array[@]}

# Вывод элемента массива по присвоенному индексу (в данном случае это 40)
echo ${array2[2]} 

# Для просмотра индексов массива необходимо добавить восклицательный знак перед переменной

array2=(20 30 40 fifty)
echo ${!array2[@]} 

# Для просмотра общего колличества индексов добавляем знак решетки
array2=(20 30 40 fifty)
echo ${#array2[@]}

# Для просмотра колличества символом в элементе массива 
array2=(20 30 40 fifty)
echo ${#array2[3]}

# Задать значение элемента массива
array[1]=thirty
array2[2]=fourty
echo ${array[@]}
echo ${array2[@]}
```
#### Цикл `for`
```bash
# Конструкция for
for 'переменная' in 'список';
    do
      'команды';
done      

# Перебор элементов массива
array=(20 30 40 fifty)
for i in ${!array[@]} ; do
  echo "${array[$i]}"
done  

# Примеры
for (( i=0; i<10; i++ )); do
    echo $i;
done 
```
#### Цикл `while`
```bash
# Конструкция
while 'условие'
  do
    'комнады'
done

# Примеры
n=1
while [ $n -lt 4 ]
  do 
    echo "$n"
    n=$(( $n+1 )); 
done    
```

#### Функции

```bash
# Конструкция
имя_функции() {
  список_команд;
}
вызов функции (имя_функции)
# Примеры

list_files() {
  echo "Выводим содержимое каталога"
  cd ~/scripts
  ls;
}
 list_files
 ```

 #### Рекурсия
 ```bash
 Example() {
      echo "Сколько будет 2+2"
  read answer
  if [[ $answer == 4 ]]; then
      echo "Ответ верный"
  else
      echo "Ответ невреный. Поробуйте еще раз"
      echo
      Example
  fi        
 }
 echo "Пример рекурсивной функции:"
 Example
 ```

 #### Перенаправление ввода/вывода
 ```bash
while read text; do
  array[$i]=$text
  i=$(($i+1))
  echo $text
done < ~/scripts/ip.txt  
#
ls /dev/ | grep sd[a-z][1-9]
