В `playbook` описывается удаленная устакновка на сервер `Java`, `Elasticserch` и `Kibana`  с исповльзованием модулей `copy`, `file`, `unarchive` и `template`


### Установка `Java`
* set_fact
* copy
* file
* unarchive
* templates

### Установка `Elasticsearch`
* copy
* file
* unarchive
* templates

### Установка `Kibana`
* copy
* file
* unarchive
* templates
  
### Group_vars
* java_jdk_version - версия `Java`
* java_oracle_jdk_package - имя пакета установки 

* elastic_version - версия `Elasticsearch`
* elastic_home - переменная домашнего каталога `Elasticsearch`

* kibana_version - версия `Kibana`  
* kibana_home - переменная домашнего каталога `Kibana`


